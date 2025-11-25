from flask import Flask, render_template, jsonify, send_from_directory, request, redirect, session, abort
import os
from datetime import datetime, timedelta
import requests
import re
import json
from werkzeug.utils import secure_filename
from functools import wraps # Importar wraps para el decorador

app = Flask(__name__)

# Configuration
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'dev-secret-key-change-in-production')
app.config['DEBUG'] = os.environ.get('DEBUG', 'False') == 'True'

# Simple in-memory storage for online users (use Redis in production)
online_users = {}

# --- Directorios clave ---
# Base directory donde están las subcarpetas de criaturas
BASE_DIR_ROOT = os.path.dirname(__file__)
ASSETS_DIR = os.path.join(BASE_DIR_ROOT, 'Welcome Card Wars Kingdom_files')
BASE_DIR = os.path.join(ASSETS_DIR, 'Creature Book') # Directorio de las criaturas

# ensure secret key for sessions (override in env for production)
app.secret_key = os.environ.get('FLASK_SECRET_KEY', 'dev-secret-key')

# Admin password (as requested)
ADMIN_PASSWORD = os.environ.get('ADMIN_PASSWORD', 'admin')

# Directory to store editable texts
DATA_DIR = os.path.join(BASE_DIR_ROOT, 'data')
TEXTS_FILE = os.path.join(DATA_DIR, 'editable_texts.json')
os.makedirs(DATA_DIR, exist_ok=True)

# ----------------------------------------------------
# --- Decorador de Admin y Funciones de Utilidad ---
# ----------------------------------------------------

def is_image(filename):
    return filename.lower().endswith(('.png', '.jpg', '.jpeg', '.webp', '.gif', '.bmp', '.svg'))

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

def build_creature_list():
    creatures = []
    if not os.path.exists(BASE_DIR):
        # Crear la carpeta si no existe para evitar errores
        os.makedirs(BASE_DIR, exist_ok=True)
        return creatures
        
    for entry in sorted(os.listdir(BASE_DIR), key=lambda n: n.lower()):
        full = os.path.join(BASE_DIR, entry)
        if os.path.isdir(full):
            # Es una carpeta de criatura (ej: 001_Giant)
            images = sorted([f for f in os.listdir(full) if os.path.isfile(os.path.join(full, f)) and is_image(f)])
            m = re.match(r'^\s*0*([0-9]+)', entry)
            num = int(m.group(1)) if m else None
            # Limpiar nombre, remover prefijo numérico
            name = re.sub(r'^\s*\d+[_\-\s]*', '', entry).replace('_', ' ').replace('-', ' ').strip() or entry
            creatures.append({'folder': entry, 'name': name, 'number': num, 'images': images})
        else:
            # Es un archivo de imagen suelto en BASE_DIR
            if is_image(entry):
                name = os.path.splitext(entry)[0].replace('_', ' ').replace('-', ' ').strip()
                creatures.append({'folder': '', 'name': name or entry, 'number': None, 'images': [entry]})
                
    def sort_key(c):
        return (c['number'] if isinstance(c.get('number'), int) else float('inf'), (c.get('name') or '').lower())
    creatures.sort(key=sort_key)
    return creatures

# --- Funciones de administración ---
def require_admin(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not session.get('is_admin'):
            # El JS espera un 403 o 401 y un JSON de error
            return jsonify({'error': 'No admin session or forbidden'}), 403 
        return f(*args, **kwargs)
    return decorated_function

# ----------------------------------------------------
# --- RUTAS PRINCIPALES ---
# ----------------------------------------------------

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/cards')
def cards_page():
    """Creature Book page - Professional creature gallery"""
    creatures = build_creature_list()
    # Importante: is_admin se inyecta desde la sesión
    return render_template('cards.html', creatures=creatures, is_admin=bool(session.get('is_admin')))

# ... (Otras rutas como /status, /heroes, /download, etc., se mantienen igual) ...

@app.route('/status')
def status():
    return redirect('/heroes')

@app.route('/heroes')
def heroes():
    return render_template('heroes.html')

@app.route('/creatures')
def creatures():
    return render_template('creatures.html')

@app.route('/cartas-update')
def cartas_update():
    return redirect('/card-museum')

@app.route('/card-museum')
def card_museum():
    return render_template('cartas-update.html')

@app.route('/download')
def download():
    return render_template('download.html')

# ----------------------------------------------------
# --- RUTAS ESTÁTICAS MODIFICADAS ---
# ----------------------------------------------------

# --- Servir archivos de la carpeta principal de assets ---
# Esta ruta debe capturar:
# /Welcome Card Wars Kingdom_files/a53f14ee4cfcc268.css
# /Welcome Card Wars Kingdom_files/card-wars-kingdom-icon.png
@app.route('/Welcome Card Wars Kingdom_files/<path:filename>')
def serve_files(filename):
    """Serve files from the main assets folder (except Creature Book)"""
    # Usamos ASSETS_DIR que apunta a 'Welcome Card Wars Kingdom_files'
    return send_from_directory(ASSETS_DIR, filename)

# --- Servir imágenes de criaturas ---
# Esta ruta debe capturar:
# /Welcome Card Wars Kingdom_files/Creature Book/001_Giant/image.png
@app.route('/Welcome Card Wars Kingdom_files/Creature Book/<path:filepath>')
def serve_creature_file(filepath):
    """Serve files from the Creature Book folder"""
    # Protege que la ruta exista dentro de BASE_DIR
    target = os.path.normpath(os.path.join(BASE_DIR, filepath))
    
    # Simple check to prevent path traversal
    if not target.startswith(os.path.normpath(BASE_DIR) + os.sep) and os.path.normpath(BASE_DIR) != os.path.normpath(target):
         abort(404)
         
    if not os.path.isfile(target):
        abort(404)
        
    directory, filename = os.path.split(target)
    return send_from_directory(directory, filename)


# ----------------------------------------------------
# --- ENDPOINTS API Y ADMIN ---
# ----------------------------------------------------

@app.route('/creature-book-list')
def creature_book_list():
    return jsonify(build_creature_list())

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

# --- PROTECTED ENDPOINTS ---

@app.route('/creature-book-rename', methods=['POST'])
@require_admin # Usamos el decorador
def creature_book_rename():
    data = request.get_json(silent=True) or {}
    folder = data.get('folder')
    new_name = data.get('newName') or data.get('new_name')
    if not folder or not new_name:
        return jsonify({'error': 'folder and newName required'}), 400

    src = os.path.join(BASE_DIR, folder)
    if not os.path.exists(src):
        return jsonify({'error': 'source folder not found'}), 404

    # 1. Limpieza y preparación del nuevo nombre
    # Extraer prefijo numérico si existe
    m = re.match(r'^(\d+)', folder)
    prefix = m.group(1) if m else None
    
    # Sanitizar el nuevo nombre: solo letras, números, espacios, guiones
    sanitized = re.sub(r'[^A-Za-z0-9 _-]', '', new_name).strip().replace(' ', '_')

    # Reconstruir el nombre final de la carpeta
    if sanitized:
        dst_folder = f"{prefix}_{sanitized}" if prefix else sanitized
    elif prefix:
        dst_folder = prefix # Si solo hay prefijo numérico
    else:
        dst_folder = folder # No se puede renombrar a vacío

    dst = os.path.join(BASE_DIR, dst_folder)
    
    if dst_folder == folder: # No hay cambio real
        return jsonify({'ok': True, 'folder': folder})

    if os.path.exists(dst):
        return jsonify({'error': 'destination folder already exists'}), 409

    try:
        os.rename(src, dst)
        return jsonify({'ok': True, 'folder': dst_folder})
    except Exception as e:
        return jsonify({'error': f'Renaming failed: {str(e)}'}), 500

@app.route('/creature-book-upload', methods=['POST'])
@require_admin # Usamos el decorador
def creature_book_upload():
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
    
    # 1. Verificar que el folder de destino existe y es una subcarpeta segura
    target_dir_norm = os.path.normpath(target_dir)
    if not target_dir_norm.startswith(os.path.normpath(BASE_DIR) + os.sep) and os.path.normpath(BASE_DIR) != os.path.normpath(target_dir):
        # Evitar subir fuera del directorio de criaturas
        return jsonify({'error': 'target folder is not safe'}), 400

    try:
        os.makedirs(target_dir, exist_ok=True)
    except Exception as e:
        return jsonify({'error': f'cannot create folder: {e}'}), 500

    save_path = os.path.join(target_dir, filename)
    try:
        # 2. Prevenir sobrescritura silenciosa (opcional)
        if os.path.exists(save_path):
            return jsonify({'error': 'file already exists'}), 409
            
        file.save(save_path)
        return jsonify({'ok': True, 'filename': filename})
    except Exception as e:
        return jsonify({'error': str(e)}), 500

# ... (El resto de las APIs se mantienen igual, solo se eliminó la definición redundante de require_admin) ...

@app.route('/api/latest-release')
def latest_release():
    # ... (código existente) ...
    # ... (mantener código existente) ...
    pass # Mantener código de latest_release

@app.route('/api/health')
def health():
    # ... (código existente) ...
    pass # Mantener código de health

@app.route('/api/users/online')
def users_online():
    # ... (código existente) ...
    pass # Mantener código de users_online

@app.route('/api/users/heartbeat')
def user_heartbeat():
    # ... (código existente) ...
    pass # Mantener código de user_heartbeat

@app.route('/api/creatures/list')
def list_creatures():
    # ... (código existente) ...
    pass # Mantener código de list_creatures

@app.route('/api/cards/database')
def cards_database():
    # ... (código existente) ...
    pass # Mantener código de cards_database

@app.route('/api/texts', methods=['GET'])
def api_get_texts():
    texts = load_texts()
    return jsonify(texts)

@app.route('/api/texts/update', methods=['POST'])
@require_admin
def api_update_text():
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

@app.errorhandler(404)
def not_found(error):
    return "<h1>404 - Page Not Found</h1>", 404

@app.errorhandler(500)
def internal_error(error):
    return "<h1>500 - Internal Server Error</h1>", 500

@app.route('/admin-login')
def admin_login_page():
    return render_template('adminlogin.html', is_admin=bool(session.get('is_admin')))

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8000))
    print(f"\nCard Wars Kingdom Server Starting...")
    print(f"Open your browser at: http://localhost:{port}")
    print(f"Admin Password: {ADMIN_PASSWORD}")
    print(f"\nPress CTRL+C to stop the server\n")
    # Nota: Si tu carpeta de templates/archivos está en la raíz del proyecto,
    # el argumento 'static_url_path' no es necesario por defecto.
    # Pero si 'Welcome Card Wars Kingdom_files' está en la raíz, podría ser necesario.
    # Para la estructura de carpetas típica de Flask, la configuración actual debería funcionar.
    app.run(host='0.0.0.0', port=port, debug=True)