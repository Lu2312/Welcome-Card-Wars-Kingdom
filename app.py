from flask import Flask, render_template, jsonify, send_from_directory, request, redirect, session, abort, send_file
import os
from datetime import datetime, timedelta
import functools
import requests
import re
import json
from werkzeug.utils import secure_filename

app = Flask(__name__)

# Configuration
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'dev-secret-key-change-in-production')
app.config['DEBUG'] = os.environ.get('DEBUG', 'False') == 'True'

# Remote creatures JSON used in several places
CREATURES_JSON_URL = os.environ.get('CREATURES_JSON_URL', 'https://cardwarskingdom.pythonanywhere.com/persist/static/Blueprints/db_Creatures.json')
# Action / Spell cards JSON (Action cards / Spells)
ACTIONS_JSON_URL = os.environ.get('ACTIONS_JSON_URL', 'https://cardwarskingdom.pythonanywhere.com/persist/static/Blueprints/db_ActionCards.json')

# Categories to detect in spells (order matters: first match wins)
CATEGORIES = [
    ('CORN', ['corn']),
    ('DUNGEON', ['dungeon']),
    ('Leader', ['leader']),
    ('NICE', ['nice']),
    ('PLAINS', ['plains']),
    ('sand', ['sand']),
    ('SWAMP', ['swamp']),
    ('TUT', ['tut', 'tutorial']),
]

# Simple in-memory storage for online users (use Redis in production)
online_users = {}

# Base directory donde están las subcarpetas de criaturas
BASE_DIR = os.path.join(os.path.dirname(__file__), 'resources', 'Creature Book')

# ensure secret key for sessions (override in env for production)
app.secret_key = os.environ.get('FLASK_SECRET_KEY', 'dev-secret-key')

# Admin password (as requested)
ADMIN_PASSWORD = os.environ.get('ADMIN_PASSWORD', 'admin')

# Directory to store editable texts
DATA_DIR = os.path.join(os.path.dirname(__file__), 'data')
TEXTS_FILE = os.path.join(DATA_DIR, 'editable_texts.json')
os.makedirs(DATA_DIR, exist_ok=True)

def load_texts():
    if os.path.exists(TEXTS_FILE):
        try:
            with open(TEXTS_FILE, 'r', encoding='utf-8') as f:
                return json.load(f)
        except:
            pass
    return {}


def load_local_spell_texts(xml_path=None):
    """Parse the XML localization file (EN_Sheet1.xml) and return a dict of key->text.

    Keys in the file include entries like '!!CORN_0001_NAME' or '!!CORN_0001_DESC'.
    We store both the raw key and the key without leading '!!' for convenience.
    """
    if xml_path is None:
        xml_path = os.path.join(os.path.dirname(__file__), 'resources', 'spells', 'EN_Sheet1.xml')
    texts = {}
    try:
        import xml.etree.ElementTree as ET
        tree = ET.parse(xml_path)
        root = tree.getroot()
        for entry in root.findall('entry'):
            name = entry.get('name')
            if not name:
                continue
            text = (entry.text or '').strip()
            texts[name] = text
            # also store without leading !! if present
            if name.startswith('!!'):
                texts[name[2:]] = text
    except Exception:
        # fail silently, return what we have
        pass
    return texts


# Load spell localization texts at import time (used to replace placeholders)
SPELL_LOCAL_TEXTS = load_local_spell_texts()

def save_texts(texts):
    try:
        with open(TEXTS_FILE, 'w', encoding='utf-8') as f:
            json.dump(texts, f, indent=2, ensure_ascii=False)
        return True
    except:
        return False

def is_image(filename):
    return filename.lower().endswith(('.png', '.jpg', '.jpeg', '.webp', '.gif', '.bmp', '.svg'))


@functools.lru_cache(maxsize=4096)
def find_local_asset(kind, key):
    """Find a local asset file for spells by searching in resources/spells/<kind> for a filename containing key string.

    kind: either 'cardframes' or 'cardicons'
    key: text found in the JSON (e.g. 'UI_ActionCard_Frame_Corn_Spell' or 'UI_ActionCard_Icon_0' or 'Spell_HuskerAmulet')
    Returns a relative URL '/resources/spells/<kind>/<file>' or None if not found.
    """
    if not key:
        return None
    # Normalize arguments for cache key stability
    kind = str(kind or '')
    key = str(key or '')
    base = os.path.join(os.path.dirname(__file__), 'resources', 'spells', kind)
    if not os.path.exists(base):
        return None
    # Try to match exact name first (with common extensions)
    possible_names = [key, key + '.png', key + '.jpg', key + '.jpeg', key + '.webp', key + '.svg']
    for pname in possible_names:
        for root, _, files in os.walk(base):
            for f in files:
                if f.lower() == pname.lower():
                    return f"/resources/spells/{kind}/{f}"
    # If exact not found, try substring match
    lower_key = key.lower()
    for root, _, files in os.walk(base):
        for f in files:
            if lower_key in f.lower() or f.lower() in lower_key:
                return f"/resources/spells/{kind}/{f}"
    # last resort: return None
    return None

def build_creature_list():
    creatures = []
    if not os.path.exists(BASE_DIR):
        return creatures
    for entry in sorted(os.listdir(BASE_DIR), key=lambda n: n.lower()):
        full = os.path.join(BASE_DIR, entry)
        if os.path.isdir(full):
            images = sorted([f for f in os.listdir(full) if os.path.isfile(os.path.join(full, f)) and is_image(f)])
            m = re.match(r'^\s*0*([0-9]+)', entry)
            num = int(m.group(1)) if m else None
            name = re.sub(r'^\s*\d+[_\-\s]*', '', entry).replace('_', ' ').replace('-', ' ').strip() or entry
            creatures.append({'folder': entry, 'name': name, 'number': num, 'images': images})
        else:
            if is_image(entry):
                name = os.path.splitext(entry)[0].replace('_', ' ').replace('-', ' ').strip()
                creatures.append({'folder': '', 'name': name or entry, 'number': None, 'images': [entry]})
    def sort_key(c):
        return (c['number'] if isinstance(c.get('number'), int) else float('inf'), (c.get('name') or '').lower())
    creatures.sort(key=sort_key)
    return creatures


def fetch_creatures_json(url, timeout=5):
    """Fetch and return list of creatures from remote JSON.

    Returns a list of objects (or [] on error). This mirrors items.py's logic
    but keeps minimal server-side handling.
    """
    try:
        resp = requests.get(url, timeout=timeout)
        resp.raise_for_status()
        data = resp.json()
        if isinstance(data, list):
            return data
        # sometimes API returns an object with keys; try common key
        if isinstance(data, dict):
            # guess the main list field
            for key in ('creatures', 'data', 'items', 'cards'):
                if key in data and isinstance(data[key], list):
                    return data[key]
        return []
    except requests.RequestException:
        # fail silently, caller will handle empty list
        return []

@app.route('/')
def index():
    """Home page"""
    return render_template('index.html')

@app.route('/cards')
def cards_page():
    """Creature Book page - Professional creature gallery"""
    creatures = build_creature_list()
    return render_template('cards.html', creatures=creatures, is_admin=bool(session.get('is_admin')))



@app.route('/cartas-update')
def cartas_update():
    """Card Museum page - redirect to maintain compatibility"""
    return redirect('/card-museum')

@app.route('/card-museum')
def card_museum():
    """Card Museum page - Complete database of cards"""
    return render_template('cartas-update.html')

@app.route('/creature-book/<path:filename>')
def serve_creature_book(filename):
    """Serve files from Creature Book folder"""
    creature_book_dir = os.path.join(os.path.dirname(__file__), 'resources', 'Creature Book')
    return send_from_directory(creature_book_dir, filename)

@app.route('/download')
def download():
    """Download page"""
    return render_template('download.html')

@app.route('/api/latest-release')
def latest_release():
    """Get latest release information from GitHub"""
    try:
        # GitHub API endpoint for latest release
        github_api = 'https://api.github.com/repos/Sgsysysgsgsg/Card-Wars-Kingdom-Revived/releases/latest'
        response = requests.get(github_api, timeout=10)

        if response.status_code == 200:
            release_data = response.json()

            # Extract relevant information
            release_info = {
                'version': release_data.get('tag_name', 'N/A'),
                'name': release_data.get('name', 'N/A'),
                'published_at': release_data.get('published_at', 'N/A'),
                'body': release_data.get('body', ''),
                'html_url': release_data.get('html_url', ''),
                'assets': []
            }

            # Extract download links for assets
            for asset in release_data.get('assets', []):
                release_info['assets'].append({
                    'name': asset.get('name', ''),
                    'size': asset.get('size', 0),
                    'download_url': asset.get('browser_download_url', ''),
                    'download_count': asset.get('download_count', 0)
                })

            return jsonify(release_info)
        else:
            return jsonify({'error': 'Failed to fetch release data'}), 500

    except requests.RequestException as e:
        return jsonify({'error': str(e)}), 500


@app.route('/api/spells/database')
def spells_database():
    """Get action / spell cards database from external API"""
    try:
        external_api = ACTIONS_JSON_URL
        response = requests.get(external_api, timeout=10)

        if response.status_code == 200:
            cards_data = response.json()
            return jsonify(cards_data)
        else:
            return jsonify({'error': 'Failed to fetch spells database'}), 500

    except requests.RequestException as e:
        return jsonify({'error': str(e)}), 500


@app.route('/spells')
def spells_page():
    """Render a book of spells (action cards) by fetching external JSON"""
    spells = []
    local_cache = os.path.join(DATA_DIR, 'db_ActionCards.json')
    try:
        resp = requests.get(ACTIONS_JSON_URL, timeout=8)
        resp.raise_for_status()
        data = resp.json()
        if isinstance(data, list):
            spells = data
            # update local cache
            try:
                with open(local_cache, 'w', encoding='utf-8') as f:
                    json.dump(spells, f, ensure_ascii=False, indent=2)
            except Exception:
                pass
    except requests.RequestException:
        # If we have a local cache, use it as fallback
        try:
            if os.path.exists(local_cache):
                with open(local_cache, 'r', encoding='utf-8') as f:
                    cached = json.load(f)
                    if isinstance(cached, list):
                        spells = cached
        except Exception:
            spells = []

    # annotate spells with category
    def detect_category(item):
        check_fields = []
        for k in ('CardFrame', 'Name', 'TypeText', 'UITexture', 'SpriteName', 'Faction', 'Description'):
            v = item.get(k)
            if v and isinstance(v, str):
                check_fields.append(v.lower())
        combined = ' '.join(check_fields)
        for name, patterns in CATEGORIES:
            for p in patterns:
                if p.lower() in combined:
                    return name
        return 'Other'

    category_counts = {}
    for s in spells:
        try:
            c = detect_category(s)
            s['category'] = c
            category_counts[c] = category_counts.get(c, 0) + 1
        except Exception:
            s['category'] = 'Other'
            category_counts['Other'] = category_counts.get('Other', 0) + 1

        # Resolve display name and description using local XML texts when available
        try:
            # Name resolution
            raw_name = s.get('Name') or ''
            display_name = raw_name
            if raw_name and raw_name.startswith('!!') and raw_name in SPELL_LOCAL_TEXTS:
                display_name = SPELL_LOCAL_TEXTS.get(raw_name)
            elif raw_name and raw_name.lstrip('!') in SPELL_LOCAL_TEXTS:
                display_name = SPELL_LOCAL_TEXTS.get(raw_name.lstrip('!'))
            else:
                # Try by ID
                sid = s.get('ID') or ''
                if sid:
                    for cand in (f'!!{sid}_NAME', f'{sid}_NAME'):
                        if cand in SPELL_LOCAL_TEXTS:
                            display_name = SPELL_LOCAL_TEXTS.get(cand)
                            break
            s['display_name'] = display_name or s.get('Name') or s.get('ID')

            # Description resolution
            raw_desc = (s.get('Description') or '').strip()
            display_desc = raw_desc
            if raw_desc.startswith('!!') and raw_desc in SPELL_LOCAL_TEXTS:
                display_desc = SPELL_LOCAL_TEXTS.get(raw_desc)
            elif raw_desc and raw_desc.lstrip('!') in SPELL_LOCAL_TEXTS:
                display_desc = SPELL_LOCAL_TEXTS.get(raw_desc.lstrip('!'))
            else:
                sid = s.get('ID') or ''
                if sid:
                    for cand in (f'!!{sid}_DESC', f'{sid}_DESC'):
                        if cand in SPELL_LOCAL_TEXTS:
                            display_desc = SPELL_LOCAL_TEXTS.get(cand)
                            break

            # fallback: if description is a placeholder like '!!...' hide it
            if isinstance(display_desc, str) and display_desc.startswith('!!'):
                display_desc = ''

            s['display_description'] = display_desc or ''
            # short preview
            s['display_description_clean'] = (s['display_description'].splitlines()[0] if s['display_description'] else '')
        except Exception:
            s.setdefault('display_name', s.get('Name') or s.get('ID'))
            s.setdefault('display_description', '')
            s.setdefault('display_description_clean', '')

    # Ensure counts for all known categories exist (including Other)
    for cat, _ in CATEGORIES:
        category_counts.setdefault(cat, 0)
    category_counts.setdefault('Other', 0)

    # category list in order
    category_list = [name for name, _ in CATEGORIES] + ['Other']
    return render_template('spells.html', spells=spells, category_counts=category_counts, category_list=category_list)

@app.route('/api/health')
def health():
    """Health check endpoint"""
    return jsonify({
        'status': 'healthy',
        'service': 'Card Wars Kingdom',
        'version': '1.0.0'
    })

@app.route('/api/users/online')
def users_online():
    """Get number of users currently online"""
    # Clean up inactive users (inactive for more than 5 minutes)
    current_time = datetime.now()
    active_users = {
        user_id: last_seen
        for user_id, last_seen in online_users.items()
        if current_time - last_seen < timedelta(minutes=5)
    }
    online_users.clear()
    online_users.update(active_users)

    return jsonify({
        'count': len(online_users),
        'timestamp': current_time.isoformat()
    })

@app.route('/api/users/heartbeat')
def user_heartbeat():
    """Update user's last seen timestamp"""
    # In production, use session ID or user token
    user_id = request.remote_addr
    online_users[user_id] = datetime.now()
    return jsonify({'status': 'ok'})

@app.route('/api/creatures/list')
def list_creatures():
    """Get list of all creatures from Creature Book folder"""
    try:
        creature_book_dir = os.path.join(os.path.dirname(__file__), 'resources', 'Creature Book')

        if not os.path.exists(creature_book_dir):
            return jsonify({'creatures': [], 'error': 'Creature Book folder not found'})

        creatures = []
        for filename in os.listdir(creature_book_dir):
            if filename.lower().endswith(('.png', '.jpg', '.jpeg', '.gif', '.webp')):
                creature_name = os.path.splitext(filename)[0].replace('_', ' ').title()
                creatures.append({
                    'name': creature_name,
                    'image': filename
                })

        # Ordenar alfabéticamente
        creatures.sort(key=lambda x: x['name'])

        return jsonify({
            'creatures': creatures,
            'count': len(creatures)
        })
    except Exception as e:
        return jsonify({'error': str(e), 'creatures': []}), 500

@app.route('/api/cards/database')
def cards_database():
    """Get cards database from external API"""
    try:
        # Fetch data from external API
        external_api = 'https://cardwarskingdom.pythonanywhere.com/persist/static/Blueprints/db_Creatures.json'
        response = requests.get(external_api, timeout=10)

        if response.status_code == 200:
            cards_data = response.json()
            return jsonify(cards_data)
        else:
            return jsonify({'error': 'Failed to fetch cards database'}), 500

    except requests.RequestException as e:
        return jsonify({'error': str(e)}), 500

@app.route('/creature-book-list')
def creature_book_list():
    return jsonify(build_creature_list())

# ---------- new: login / logout endpoints ----------
@app.route('/login', methods=['POST'])
def login():
    data = request.get_json(silent=True) or request.form or {}
    password = data.get('password') or data.get('pwd')
    if not password:
        return jsonify({'error': 'password required'}), 400
    if password == ADMIN_PASSWORD:
        session['is_admin'] = True
        return jsonify({'ok': True})
    return jsonify({'error': 'invalid credentials'}), 401

@app.route('/logout', methods=['POST', 'GET'])
def logout():
    session.pop('is_admin', None)
    return jsonify({'ok': True})

def require_admin():
    return bool(session.get('is_admin'))


@app.context_processor
def inject_helpers():
    return {
        'spell_asset': find_local_asset
    }

# ---------- protect rename endpoint ----------
@app.route('/creature-book-rename', methods=['POST'])
def creature_book_rename():
    if not require_admin():
        return jsonify({'error': 'forbidden'}), 403
    data = request.get_json(silent=True) or {}
    folder = data.get('folder')
    new_name = data.get('newName') or data.get('new_name')
    if not folder or not new_name:
        return jsonify({'error': 'folder and newName required'}), 400

    src = os.path.join(BASE_DIR, folder)
    if not os.path.exists(src):
        return jsonify({'error': 'source folder not found'}), 404

    m = re.match(r'^(\d+)', folder)
    if m:
        prefix = m.group(1)
        sanitized = re.sub(r'[^A-Za-z0-9 _-]', '', new_name).strip().replace(' ', '_')
        dst_folder = f"{prefix}_{sanitized}" if sanitized else prefix
    else:
        sanitized = re.sub(r'[^A-Za-z0-9 _-]', '', new_name).strip().replace(' ', '_')
        dst_folder = sanitized or folder

    dst = os.path.join(BASE_DIR, dst_folder)
    if os.path.exists(dst):
        return jsonify({'error': 'destination folder already exists'}), 409

    try:
        os.rename(src, dst)
        return jsonify({'ok': True, 'folder': dst_folder})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# ---------- protect upload endpoint ----------
@app.route('/creature-book-upload', methods=['POST'])
def creature_book_upload():
    if not require_admin():
        return jsonify({'error': 'forbidden'}), 403

    folder = request.form.get('folder')
    file = request.files.get('file')
    if not folder or not file:
        return jsonify({'error': 'folder and file required'}), 400

    if not file.filename:
        return jsonify({'error': 'no filename'}), 400
    filename = secure_filename(file.filename)
    if not filename:
        return jsonify({'error': 'invalid filename'}), 400

    target_dir = os.path.join(BASE_DIR, folder)
    try:
        os.makedirs(target_dir, exist_ok=True)
    except Exception as e:
        return jsonify({'error': f'cannot create folder: {e}'}), 500

    save_path = os.path.join(target_dir, filename)
    try:
        file.save(save_path)
        return jsonify({'ok': True, 'filename': filename})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# API to get editable texts
@app.route('/api/texts', methods=['GET'])
def api_get_texts():
    texts = load_texts()
    return jsonify(texts)

# API to update a text entry (admin only)
@app.route('/api/texts/update', methods=['POST'])
def api_update_text():
    if not require_admin():
        return jsonify({'error': 'forbidden'}), 403
    data = request.get_json(silent=True) or {}
    key = data.get('key')
    value = data.get('value')
    if not key:
        return jsonify({'error': 'key required'}), 400
    texts = load_texts()
    texts[key] = value
    ok = save_texts(texts)
    if not ok:
        return jsonify({'error': 'failed saving'}), 500
    return jsonify({'ok': True, 'key': key, 'value': value})

# Servir archivos desde la carpeta "Creature Book" para que las rutas en cards.html funcionen.
# La URL exacta coincide con la que usa la plantilla: /resources/Creature Book/...
@app.route('/resources/Creature Book/<path:filepath>')
def serve_creature_file(filepath):
    # Protege que la ruta exista dentro de BASE_DIR
    target = os.path.normpath(os.path.join(BASE_DIR, filepath))
    if not target.startswith(os.path.normpath(BASE_DIR) + os.sep) and os.path.normpath(BASE_DIR) != os.path.normpath(target):
        abort(404)
    if not os.path.isfile(target):
        abort(404)
    directory, filename = os.path.split(target)
    return send_from_directory(directory, filename)

# Serve static files from resources folder
@app.route('/resources/<path:filename>')
def serve_files(filename):
    files_dir = os.path.join(os.path.dirname(__file__), 'resources')
    return send_from_directory(files_dir, filename)


@app.after_request
def add_cache_headers(response):
    try:
        p = request.path or ''
        if p.startswith('/resources') or p.startswith('/creature-book'):
            # cache static resources for a week by default
            response.headers['Cache-Control'] = 'public, max-age=604800'
    except Exception:
        pass
    return response

# Serve dungeon images
@app.route('/dungeon_archivos/<path:filename>')
def serve_dungeon_files(filename):
    return send_from_directory('dungeon_archivos', filename)

@app.errorhandler(404)
def not_found(error):
    """404 error handler"""
    return "<h1>404 - Page Not Found</h1>", 404

@app.errorhandler(500)
def internal_error(error):
    """500 error handler"""
    return "<h1>500 - Internal Server Error</h1>", 500

@app.route('/admin-login')
def admin_login_page():
    """Admin login page (separate template)"""
    return render_template('adminlogin.html', is_admin=bool(session.get('is_admin')))



# 1. Heroes
@app.route('/heroes')
def heroes():
    """Muestra la página de Héroes."""
    return render_template('heroes.html')

# 2. Creatures
@app.route('/creatures')
def creatures():
    """Creature Book page."""
    # Scan resources/Creature-Book for files matching NN_CREATURE.png
    creature_dir = os.path.join(os.path.dirname(__file__), 'resources', 'Creature-Book')
    creature_numbers = set()
    if os.path.exists(creature_dir):
        for fname in os.listdir(creature_dir):
            # match any leading zeros and any number of digits (e.g. 001, 099, 100, 270)
            m = re.match(r'^0*([0-9]+)_CREATURE\.png$', fname)
            if m:
                creature_numbers.add(int(m.group(1)))
    creature_numbers = sorted(creature_numbers)

    # Prepare a quick lookup for which files exist per creature number to avoid
    # rendering <img> tags for files that are not present (prevent 404s).
    images_map = {}
    for n in creature_numbers:
        key = f"{n:02d}"
        images_map[n] = {
            'CREATURE': os.path.isfile(os.path.join(creature_dir, f"{key}_CREATURE.png")),
            'ICON': os.path.isfile(os.path.join(creature_dir, f"{key}_ICON.png")),
            'PASSIVE': os.path.isfile(os.path.join(creature_dir, f"{key}_PASSIVE.png")),
            'SPELL': os.path.isfile(os.path.join(creature_dir, f"{key}_SPELL.png")),
        }

    # Try to fetch remote creatures JSON server-side and build a mapping by Number.
    creatures_by_number = {}
    creatures_remote = fetch_creatures_json(CREATURES_JSON_URL)
    for c in creatures_remote:
        try:
            num_val = c.get('Number')
            if num_val is None:
                continue
            num_int = int(num_val)
        except Exception:
            # Number may not be an integer — skip
            continue

        # Try to parse MinHP/MaxHP and compute the requested PV formula:
        # PV = MinHP - 0.5 * (MaxHP - MinHP)
        pv_val = None
        try:
            minhp_raw = c.get('MinHP')
            maxhp_raw = c.get('MaxHP')
            if minhp_raw is not None and maxhp_raw is not None:
                minhp = float(minhp_raw)
                maxhp = float(maxhp_raw)
                # new requested formula: MinHP + 0.5 * (MaxHP - MinHP)
                pv_calc = minhp + 0.5 * (maxhp - minhp)
                # store as integer for display (round to nearest)
                pv_val = int(round(pv_calc))
        except Exception:
            pv_val = None

        # store the object and attach parsed numeric fields for template convenience
        c_parsed = dict(c)
        if pv_val is not None:
            c_parsed['PV_calc'] = pv_val
        # also attach numeric copies of MinHP/MaxHP when parseable
        try:
            if 'MinHP' in c and c.get('MinHP') is not None:
                c_parsed['MinHP_num'] = float(c.get('MinHP'))
        except Exception:
            pass
        try:
            if 'MaxHP' in c and c.get('MaxHP') is not None:
                c_parsed['MaxHP_num'] = float(c.get('MaxHP'))
        except Exception:
            pass

        # Parse MinSTR/MaxSTR and compute ATQ using: MinSTR + 0.5 * (MaxSTR - MinSTR)
        atq_val = None
        try:
            minstr_raw = c.get('MinSTR')
            maxstr_raw = c.get('MaxSTR')
            if minstr_raw is not None and maxstr_raw is not None:
                minstr = float(minstr_raw)
                maxstr = float(maxstr_raw)
                atq_calc = minstr + 0.5 * (maxstr - minstr)
                atq_val = int(round(atq_calc))
        except Exception:
            atq_val = None

        if atq_val is not None:
            c_parsed['ATQ_calc'] = atq_val
        try:
            if 'MinSTR' in c and c.get('MinSTR') is not None:
                c_parsed['MinSTR_num'] = float(c.get('MinSTR'))
        except Exception:
            pass
        try:
            if 'MaxSTR' in c and c.get('MaxSTR') is not None:
                c_parsed['MaxSTR_num'] = float(c.get('MaxSTR'))
        except Exception:
            pass

        # Parse MinDEX/MaxDEX and compute CRT using: MinDEX + 0.5 * (MaxDEX - MinDEX)
        crt_val = None
        try:
            mindex_raw = c.get('MinDEX')
            maxdex_raw = c.get('MaxDEX')
            if mindex_raw is not None and maxdex_raw is not None:
                mindex = float(mindex_raw)
                maxdex = float(maxdex_raw)
                crt_calc = mindex + 0.5 * (maxdex - mindex)
                crt_val = int(round(crt_calc))
        except Exception:
            crt_val = None

        if crt_val is not None:
            # CRT is shown as a percent in UI; store integer percentage
            c_parsed['CRT_calc'] = crt_val
        try:
            if 'MinDEX' in c and c.get('MinDEX') is not None:
                c_parsed['MinDEX_num'] = float(c.get('MinDEX'))
        except Exception:
            pass
        try:
            if 'MaxDEX' in c and c.get('MaxDEX') is not None:
                c_parsed['MaxDEX_num'] = float(c.get('MaxDEX'))
        except Exception:
            pass

        # Parse MinINT/MaxINT and compute MAG using: MinINT + 0.5 * (MaxINT - MinINT)
        mag_val = None
        try:
            minint_raw = c.get('MinINT')
            maxint_raw = c.get('MaxINT')
            if minint_raw is not None and maxint_raw is not None:
                minint = float(minint_raw)
                maxint = float(maxint_raw)
                mag_calc = minint + 0.5 * (maxint - minint)
                mag_val = int(round(mag_calc))
        except Exception:
            mag_val = None

        if mag_val is not None:
            c_parsed['MAG_calc'] = mag_val
        try:
            if 'MinINT' in c and c.get('MinINT') is not None:
                c_parsed['MinINT_num'] = float(c.get('MinINT'))
        except Exception:
            pass
        try:
            if 'MaxINT' in c and c.get('MaxINT') is not None:
                c_parsed['MaxINT_num'] = float(c.get('MaxINT'))
        except Exception:
            pass

        creatures_by_number[num_int] = c_parsed

    return render_template(
        'creatures.html', 
        creature_numbers=creature_numbers, 
        creatures_by_number=creatures_by_number,
        images_map=images_map
    )

# 3. Spells
@app.route('/spells')
def spells():
    """Muestra la página de Hechizos."""
    return render_template('spells.html')

# 4. PvP Seasons
@app.route('/pvpseason')
def pvp_seasons():
    """Muestra la página de Temporadas PvP."""
    return render_template('pvpseason.html')


# 5. Dungeons
@app.route('/dungeons')
def dungeons():
    """Muestra la página de Mazmorras."""
    # The dungeon page is a template stored in templates/dungeon.html.
    # Previously the code used send_file('dungeon.html') which looks for a
    # file in the project root and caused FileNotFoundError after we moved
    # the page into templates/. Use render_template so Flask renders the
    # template from the templates/ directory.
    return render_template('dungeon.html')

# 6. Treasure Chest Cave
@app.route('/treasure-chest-cave')
def treasure_chest_cave():
    """Muestra la página de la Cueva del Cofre del Tesoro."""
    # Usamos guiones bajos en el nombre de la función para seguir las convenciones de Python (PEP 8)
    return render_template('treasure_chest_cave.html')

# 7. Store
@app.route('/store')
def store():
    """Muestra la página de la Tienda."""
    return render_template('store.html')

# 8. Status Effects
@app.route('/status-effects')
def status_effects():
    """Muestra la página de Efectos de Estado."""
    return render_template('status_effects.html')

# 9. Lab's
@app.route('/labs')
def labs():
    """Muestra la página de Laboratorios."""
    return render_template('labs.html')

# 10. Specials
@app.route('/specials')
def specials():
    """Muestra la página de Especiales."""
    return render_template('specials.html')





if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8000))
    print(f"\nCard Wars Kingdom Server Starting...")
    print(f"Open your browser at: http://localhost:{port}")
    print(f"Make sure your files are in the correct folders!")
    print(f"\nPress CTRL+C to stop the server\n")
    app.run(host='0.0.0.0', port=port, debug=True)
