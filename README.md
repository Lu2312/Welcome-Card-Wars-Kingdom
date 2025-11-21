# 🎮 Card Wars Kingdom - Web Server

Servidor web oficial para Card Wars Kingdom Revived, con información del juego, descarga de releases y estado del servidor.

## 🌐 Sitio Web

**Dominio:** [cardwars-kingdom.net](https://cardwars-kingdom.net)  
**Repositorio:** [https://github.com/Lu2312/Welcome-Card-Wars-Kingdom](https://github.com/Lu2312/Welcome-Card-Wars-Kingdom)  
**Servidor:** VPS 159.89.157.63

## ⚙️ Arquitectura en Producción

- **Puerto 8080**: Gunicorn (interno)
- **Puerto 80**: Nginx (público)
- **Servicio**: cardwars-kingdom-net.service
- **CDN**: Cloudflare

## ✨ Características

- 🏠 **Página Principal** - Información sobre el juego
- 🃏 **Galería de Cartas** - Colección completa de cartas
- 📊 **Estado del Servidor** - Monitoreo en tiempo real
- 📥 **Descargas** - Últimas versiones del juego desde GitHub
- 👥 **Usuarios Online** - Contador de jugadores activos
- 🔄 **API REST** - Endpoints para integraciones

## 🚀 Inicio Rápido

### Requisitos Previos

- Python 3.8 o superior
- pip (gestor de paquetes de Python)

### Instalación Local

1. **Clonar el repositorio**
```bash
git clone https://github.com/Lu2312/Welcome-Card-Wars-Kingdom.git
cd Welcome-Card-Wars-Kingdom
```

2. **Crear entorno virtual**
```bash
python -m venv venv

# Windows
venv\Scripts\activate

# Linux/Mac
source venv/bin/activate
```

3. **Instalar dependencias**
```bash
pip install -r requirements.txt
```

4. **Ejecutar el servidor**
```bash
python app.py
```

5. **Abrir en navegador**
`````
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

