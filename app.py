from flask import Flask, render_template, jsonify, send_from_directory, request
import os
from datetime import datetime, timedelta
import requests

app = Flask(__name__)

# Configuration
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'dev-secret-key-change-in-production')
app.config['DEBUG'] = os.environ.get('DEBUG', 'False') == 'True'

# Simple in-memory storage for online users (use Redis in production)
online_users = {}

@app.route('/')
def index():
    """Home page"""
    return render_template('index.html')

@app.route('/cards')
def cards():
    """Cards collection page"""
    return render_template('cards.html')

@app.route('/status')
def status():
    """Server status page"""
    return render_template('status.html')

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

# Serve static files from Welcome Card Wars Kingdom_files folder
@app.route('/Welcome Card Wars Kingdom_files/<path:filename>')
def serve_files(filename):
    files_dir = os.path.join(os.path.dirname(__file__), 'Welcome Card Wars Kingdom_files')
    return send_from_directory(files_dir, filename)

@app.errorhandler(404)
def not_found(error):
    """404 error handler"""
    return "<h1>404 - Page Not Found</h1>", 404

@app.errorhandler(500)
def internal_error(error):
    """500 error handler"""
    return "<h1>500 - Internal Server Error</h1>", 500

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 8080))
    print(f"\n🎮 Card Wars Kingdom Server Starting...")
    print(f"🌐 Open your browser at: http://localhost:{port}")
    print(f"📁 Make sure your files are in the correct folders!")
    print(f"\n✨ Press CTRL+C to stop the server\n")
    app.run(host='0.0.0.0', port=port, debug=True)
