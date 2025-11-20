# 🎴 Card Wars Kingdom - Fan Remake

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python Version](https://img.shields.io/badge/python-3.8%2B-blue)](https://www.python.org/downloads/)

A fan-made remake of the Card Wars Kingdom game from Adventure Time, built with Flask.

## 🚀 Features

- 🎮 Full web-based gameplay
- 🃏 Card collection system
- 🗺️ Multiple Adventure Time maps
- 👥 Online multiplayer support
- 📱 Responsive design

## 🛠️ Tech Stack

- **Backend:** Flask (Python)
- **Frontend:** HTML5, CSS3 (Tailwind), JavaScript
- **Server:** Gunicorn
- **Deployment:** VPS Ready

## 📋 Prerequisites

- Python 3.8 or higher
- pip (Python package manager)
- Virtual environment (recommended)

## ⚙️ Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/card-wars-kingdom.git
cd card-wars-kingdom
```

2. **Create virtual environment**
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

3. **Install dependencies**
```bash
pip install -r requirements.txt
```

4. **Run the application**
```bash
# Development
python app.py

# Production with Gunicorn
gunicorn --bind 0.0.0.0:3000 --workers 4 wsgi:app
```

## 🐳 Docker Deployment

```bash
docker build -t card-wars-kingdom .
docker run -p 3000:3000 card-wars-kingdom
```

## 🌐 VPS Deployment

### Using systemd

Create `/etc/systemd/system/cardwars.service`:

```ini
[Unit]
Description=Card Wars Kingdom
After=network.target

[Service]
User=www-data
WorkingDirectory=/var/www/card-wars-kingdom
Environment="PATH=/var/www/card-wars-kingdom/venv/bin"
ExecStart=/var/www/card-wars-kingdom/venv/bin/gunicorn --bind 0.0.0.0:3000 --workers 4 wsgi:app
Restart=always

[Install]
WantedBy=multi-user.target
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable cardwars
sudo systemctl start cardwars
```

## 📂 Project Structure

