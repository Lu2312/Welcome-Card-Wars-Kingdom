# 🎴 Card Wars Kingdom - Fan Remake

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python Version](https://img.shields.io/badge/python-3.8%2B-blue)](https://www.python.org/downloads/)
[![Deploy](https://img.shields.io/badge/Deploy-Ready-success)](./DEPLOY.md)
[![Docker](https://img.shields.io/badge/Docker-Enabled-blue?logo=docker)](./Dockerfile)
[![Vercel](https://img.shields.io/badge/Deploy%20to-Vercel-black?logo=vercel)](https://vercel.com/new/clone?repository-url=https://github.com/Lu2312/Welcome-Card-Wars-Kingdom_files)
[![Railway](https://img.shields.io/badge/Deploy%20to-Railway-purple?logo=railway)](https://railway.app/new/template)

A fan-made remake of the Card Wars Kingdom game from Adventure Time, built with Flask.

> 📘 **[Ver Guía de Despliegue en Español](./DEPLOY.md)** - Complete deployment guide in Spanish

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
- **Deployment:** Vercel, Render, Railway, Heroku, Docker, VPS (Multi-platform ready)

## 📋 Prerequisites

- Python 3.8 or higher
- pip (Python package manager)
- Virtual environment (recommended)

## ⚡ Quick Start

### Local Development

```bash
# Clone the repository
git clone https://github.com/Lu2312/Welcome-Card-Wars-Kingdom_files.git
cd Welcome-Card-Wars-Kingdom_files

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run the application
python app.py
```

Open your browser at `http://localhost:3000` 🎮

### One-Click Deploy

Click on any platform badge above to deploy instantly:
- **Vercel**: Best for quick prototypes
- **Railway**: $5 free credit monthly
- **Render**: Generous free tier with SSL
- **Heroku**: Classic platform with add-ons

📖 **[Full Deployment Guide (Spanish)](./DEPLOY.md)** | **[English Docs](#deployment-options)**

## ⚙️ Installation

1. **Clone the repository**
```bash
git clone https://github.com/Lu2312/Welcome-Card-Wars-Kingdom_files.git
cd Welcome-Card-Wars-Kingdom_files
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

## 📚 Documentation

- **[🚀 Quick Start Guide](./QUICKSTART.md)** - Get started in 5 minutes
- **[📖 Complete Deployment Guide (Spanish)](./DEPLOY.md)** - All deployment methods
- **[✅ Deployment Checklist](./DEPLOYMENT_CHECKLIST.md)** - Pre/post deployment verification

## 📂 Project Structure

```
Welcome-Card-Wars-Kingdom_files/
├── app.py                      # Main Flask application
├── wsgi.py                     # WSGI entry point
├── requirements.txt            # Python dependencies
├── templates/                  # HTML templates
│   ├── index.html
│   ├── cards.html
│   ├── status.html
│   └── download.html
├── static/                     # Static assets
│   ├── css/
│   └── js/
├── Dockerfile                  # Docker configuration
├── docker-compose.yml          # Docker Compose setup
├── Procfile                    # Heroku configuration
├── vercel.json                 # Vercel configuration
├── render.yaml                 # Render configuration
├── railway.json                # Railway configuration
├── nginx.conf                  # Nginx configuration template
├── cardwars.service           # Systemd service file
└── deploy.sh                   # Quick deployment script
```


## 🌐 Deployment Options

### 🐳 Docker (Recommended)

```bash
# Using Docker Compose (easiest)
docker-compose up -d

# Or using Docker directly
docker build -t card-wars-kingdom .
docker run -p 3000:3000 -e SECRET_KEY=your-secret-key card-wars-kingdom
```

### ☁️ Cloud Platforms

#### Vercel (Instant)
```bash
npm i -g vercel
vercel
```

#### Railway (Simple)
1. Connect your GitHub repository
2. Click "Deploy"
3. Done! 🚀

#### Render (Free SSL)
1. Create account on [render.com](https://render.com)
2. Connect GitHub repository
3. Automatic deployment with `render.yaml`

#### Heroku (Classic)
```bash
heroku create your-app-name
git push heroku main
```

📖 **[Complete Deployment Guide (Spanish)](./DEPLOY.md)**

## 🖥️ VPS Deployment

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


## 🔒 Security

- Never commit `.env` file
- Always use HTTPS in production
- Keep `SECRET_KEY` secure and unique
- Regularly update dependencies
- Use strong passwords for services

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Adventure Time and Card Wars Kingdom are properties of Cartoon Network
- This is a fan-made project, not affiliated with or endorsed by Cartoon Network
- Thanks to all contributors and the Adventure Time community

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/Lu2312/Welcome-Card-Wars-Kingdom_files/issues)
- **Discussions**: [GitHub Discussions](https://github.com/Lu2312/Welcome-Card-Wars-Kingdom_files/discussions)
- **Documentation**: See [DEPLOY.md](./DEPLOY.md) for deployment help

## 🌟 Show Your Support

Give a ⭐️ if this project helped you!

---

Made with ❤️ for Adventure Time fans | [View Documentation](./DEPLOY.md) | [Quick Start](./QUICKSTART.md)
