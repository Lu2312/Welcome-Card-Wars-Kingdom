from flask import Flask, render_template, jsonify, send_from_directory, request, redirect, session, abort
import os
from datetime import datetime, timedelta
import requests
import re
import json
from werkzeug.utils import secure_filename

app = Flask(__name__)

# Configuration
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'dev-secret-key-change-in-production')
app.config['DEBUG'] = os.environ.get('DEBUG', 'False') == 'True'

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

def save_texts(texts):
    try:
        with open(TEXTS_FILE, 'w', encoding='utf-8') as f:
            json.dump(texts, f, indent=2, ensure_ascii=False)
        return True
    except:
        return False

def is_image(filename):
    return filename.lower().endswith(('.png', '.jpg', '.jpeg', '.webp', '.gif', '.bmp', '.svg'))

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
    return render_template('creatures.html')

# 3. Spells
@app.route('/spells')
def spells():
    """Muestra la página de Hechizos."""
    return render_template('spells.html')

# 4. Multiplayer (PvP)
@app.route('/multiplayer-pvp')
def multiplayer_pvp():
    """Muestra la página de Multijugador (PvP)."""
    # Usamos 'multiplayer_pvp' como nombre de la función y del archivo HTML
    # La URL utiliza un guion para ser más amigable: /multiplayer-pvp
    return render_template('multiplayer_pvp.html')

# 5. Dungeons
@app.route('/dungeons')
def dungeons():
    """Muestra la página de Mazmorras."""
    return render_template('dungeons.html')

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
