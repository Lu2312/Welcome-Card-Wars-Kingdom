# 🚀 Guía de Despliegue - Card Wars Kingdom

Esta guía te ayudará a desplegar tu aplicación Card Wars Kingdom en diferentes plataformas web.

## 📑 Tabla de Contenidos

1. [Despliegue Local](#despliegue-local)
2. [Despliegue en Vercel](#despliegue-en-vercel)
3. [Despliegue en Render](#despliegue-en-render)
4. [Despliegue en Railway](#despliegue-en-railway)
5. [Despliegue en Heroku](#despliegue-en-heroku)
6. [Despliegue con Docker](#despliegue-con-docker)
7. [Despliegue en VPS](#despliegue-en-vps)
8. [Despliegue en PythonAnywhere](#despliegue-en-pythonanywhere)

---

## 🏠 Despliegue Local

### Requisitos Previos
- Python 3.8 o superior
- pip (gestor de paquetes de Python)

### Pasos

1. **Clonar el repositorio**
```bash
git clone https://github.com/Lu2312/Welcome-Card-Wars-Kingdom_files.git
cd Welcome-Card-Wars-Kingdom_files
```

2. **Crear entorno virtual (recomendado)**
```bash
python -m venv venv

# En Windows:
venv\Scripts\activate

# En Linux/Mac:
source venv/bin/activate
```

3. **Instalar dependencias**
```bash
pip install -r requirements.txt
```

4. **Configurar variables de entorno**
```bash
# Copiar el archivo de ejemplo
cp .env.example .env

# Editar .env con tu editor favorito
nano .env
```

5. **Ejecutar la aplicación**
```bash
# Modo desarrollo
python app.py

# Modo producción con Gunicorn
gunicorn --bind 0.0.0.0:3000 --workers 4 wsgi:app
```

6. **Abrir en el navegador**
```
http://localhost:3000
```

---

## ☁️ Despliegue en Vercel

Vercel es perfecto para aplicaciones Python con Flask y ofrece despliegue automático.

### Método 1: Usando la Web de Vercel (Más Fácil)

1. Ve a [vercel.com](https://vercel.com) y crea una cuenta
2. Haz clic en "Add New" → "Project"
3. Importa tu repositorio de GitHub
4. Vercel detectará automáticamente el archivo `vercel.json`
5. Haz clic en "Deploy"

### Método 2: Usando Vercel CLI

```bash
# Instalar Vercel CLI
npm i -g vercel

# Login
vercel login

# Desplegar
vercel

# Desplegar a producción
vercel --prod
```

### Variables de Entorno en Vercel

1. Ve a tu proyecto en Vercel
2. Settings → Environment Variables
3. Agrega:
   - `SECRET_KEY`: tu-clave-secreta-aqui
   - `FLASK_ENV`: production

---

## 🎨 Despliegue en Render

Render ofrece hosting gratuito para aplicaciones web con certificados SSL automáticos.

### Pasos:

1. Ve a [render.com](https://render.com) y crea una cuenta
2. Haz clic en "New +" → "Web Service"
3. Conecta tu repositorio de GitHub
4. Render detectará automáticamente el archivo `render.yaml`
5. Configura las variables de entorno:
   - `SECRET_KEY`: genera una clave segura
   - `FLASK_ENV`: production
6. Haz clic en "Create Web Service"

### Configuración Manual (si no detecta render.yaml):

- **Build Command**: `pip install -r requirements.txt`
- **Start Command**: `gunicorn --bind 0.0.0.0:$PORT --workers 4 wsgi:app`
- **Environment**: Python 3

---

## 🚂 Despliegue en Railway

Railway ofrece $5 de crédito gratis mensualmente y es muy fácil de usar.

### Pasos:

1. Ve a [railway.app](https://railway.app) y crea una cuenta
2. Haz clic en "New Project"
3. Selecciona "Deploy from GitHub repo"
4. Conecta tu repositorio
5. Railway detectará automáticamente Python y usará `railway.json`
6. Agrega variables de entorno en el dashboard:
   - `SECRET_KEY`: tu-clave-secreta
   - `FLASK_ENV`: production
7. El despliegue comenzará automáticamente

### Obtener la URL:

Una vez desplegado, Railway te dará una URL como:
`https://tu-app.up.railway.app`

---

## 🟣 Despliegue en Heroku

Heroku es una plataforma clásica para despliegues web.

### Requisitos Previos:
```bash
# Instalar Heroku CLI
# Windows: Descarga de https://devcenter.heroku.com/articles/heroku-cli
# Mac: brew install heroku/brew/heroku
# Ubuntu: curl https://cli-assets.heroku.com/install.sh | sh
```

### Pasos:

1. **Crear archivo Procfile**
```bash
echo "web: gunicorn --bind 0.0.0.0:\$PORT --workers 4 wsgi:app" > Procfile
```

2. **Crear archivo runtime.txt**
```bash
echo "python-3.11.0" > runtime.txt
```

3. **Login en Heroku**
```bash
heroku login
```

4. **Crear aplicación**
```bash
heroku create nombre-de-tu-app
```

5. **Configurar variables de entorno**
```bash
heroku config:set SECRET_KEY=tu-clave-secreta-aqui
heroku config:set FLASK_ENV=production
```

6. **Desplegar**
```bash
git push heroku main
```

7. **Abrir la aplicación**
```bash
heroku open
```

---

## 🐳 Despliegue con Docker

Docker te permite desplegar en cualquier servidor que soporte contenedores.

### Usando Docker Compose (Recomendado)

1. **Crear docker-compose.yml**
```yaml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "3000:3000"
    environment:
      - SECRET_KEY=${SECRET_KEY:-change-me-in-production}
      - FLASK_ENV=production
    restart: unless-stopped
```

2. **Construir y ejecutar**
```bash
docker-compose up -d
```

3. **Ver logs**
```bash
docker-compose logs -f
```

### Usando solo Docker

```bash
# Construir imagen
docker build -t card-wars-kingdom .

# Ejecutar contenedor
docker run -d \
  -p 3000:3000 \
  -e SECRET_KEY=tu-clave-secreta \
  -e FLASK_ENV=production \
  --name card-wars \
  card-wars-kingdom

# Ver logs
docker logs -f card-wars
```

---

## 🖥️ Despliegue en VPS (DigitalOcean, AWS, Linode, etc.)

Para un servidor privado virtual, tendrás control total.

### Requisitos:
- Un VPS con Ubuntu 20.04 o superior
- Acceso SSH al servidor
- Dominio (opcional)

### Paso 1: Preparar el Servidor

```bash
# Conectar por SSH
ssh usuario@tu-servidor-ip

# Actualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar Python y dependencias
sudo apt install python3 python3-pip python3-venv nginx -y

# Instalar Node.js (para npm, si es necesario)
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
```

### Paso 2: Configurar la Aplicación

```bash
# Crear directorio para la aplicación
sudo mkdir -p /var/www/card-wars-kingdom
cd /var/www/card-wars-kingdom

# Clonar repositorio
sudo git clone https://github.com/Lu2312/Welcome-Card-Wars-Kingdom_files.git .

# Crear entorno virtual
sudo python3 -m venv venv
sudo chown -R $USER:$USER venv

# Activar entorno virtual
source venv/bin/activate

# Instalar dependencias
pip install -r requirements.txt

# Configurar variables de entorno
sudo nano .env
```

### Paso 3: Configurar Systemd

```bash
# Crear archivo de servicio
sudo nano /etc/systemd/system/cardwars.service
```

Contenido del archivo:
```ini
[Unit]
Description=Card Wars Kingdom Web Application
After=network.target

[Service]
User=www-data
WorkingDirectory=/var/www/card-wars-kingdom
Environment="PATH=/var/www/card-wars-kingdom/venv/bin"
ExecStart=/var/www/card-wars-kingdom/venv/bin/gunicorn --bind 0.0.0.0:3000 --workers 4 wsgi:app
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

```bash
# Ajustar permisos
sudo chown -R www-data:www-data /var/www/card-wars-kingdom

# Iniciar servicio
sudo systemctl daemon-reload
sudo systemctl enable cardwars
sudo systemctl start cardwars

# Verificar estado
sudo systemctl status cardwars
```

### Paso 4: Configurar Nginx como Proxy Inverso

```bash
# Crear configuración de Nginx
sudo nano /etc/nginx/sites-available/cardwars
```

Contenido del archivo:
```nginx
server {
    listen 80;
    server_name tu-dominio.com;  # Cambia esto por tu dominio

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /static {
        alias /var/www/card-wars-kingdom/static;
        expires 30d;
    }
}
```

```bash
# Habilitar sitio
sudo ln -s /etc/nginx/sites-available/cardwars /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### Paso 5: Configurar SSL con Let's Encrypt (Opcional pero Recomendado)

```bash
# Instalar Certbot
sudo apt install certbot python3-certbot-nginx -y

# Obtener certificado SSL
sudo certbot --nginx -d tu-dominio.com

# El certificado se renovará automáticamente
```

---

## 🐍 Despliegue en PythonAnywhere

PythonAnywhere ofrece hosting gratuito para aplicaciones Flask.

### Pasos:

1. **Crear cuenta en [pythonanywhere.com](https://www.pythonanywhere.com)**

2. **Abrir una consola Bash**

3. **Clonar el repositorio**
```bash
git clone https://github.com/Lu2312/Welcome-Card-Wars-Kingdom_files.git
cd Welcome-Card-Wars-Kingdom_files
```

4. **Crear entorno virtual**
```bash
mkvirtualenv --python=/usr/bin/python3.9 cardwars
pip install -r requirements.txt
```

5. **Configurar Web App**
   - Ve a la pestaña "Web"
   - Haz clic en "Add a new web app"
   - Selecciona "Manual configuration"
   - Selecciona Python 3.9

6. **Configurar WSGI**
   - Edita el archivo WSGI configuration file
   - Reemplaza el contenido con:
```python
import sys
path = '/home/tuusuario/Welcome-Card-Wars-Kingdom_files'
if path not in sys.path:
    sys.path.append(path)

from app import app as application
```

7. **Configurar virtual environment**
   - En la sección "Virtualenv"
   - Ingresa: `/home/tuusuario/.virtualenvs/cardwars`

8. **Reload**
   - Haz clic en el botón "Reload"
   - Tu app estará disponible en `tuusuario.pythonanywhere.com`

---

## 🔧 Configuración de Variables de Entorno

Independientemente de la plataforma, necesitarás configurar estas variables:

| Variable | Descripción | Ejemplo |
|----------|-------------|---------|
| `SECRET_KEY` | Clave secreta para Flask | `tu-clave-super-secreta-123` |
| `FLASK_ENV` | Entorno de Flask | `production` |
| `PORT` | Puerto de la aplicación | `3000` (automático en la mayoría de plataformas) |

### Generar una SECRET_KEY segura:

```python
python -c "import secrets; print(secrets.token_hex(32))"
```

---

## 🔍 Verificación del Despliegue

Una vez desplegada, verifica que todo funcione:

1. **Página principal**: `https://tu-dominio.com/`
2. **Health check**: `https://tu-dominio.com/api/health`
3. **Usuarios online**: `https://tu-dominio.com/api/users/online`

---

## 🆘 Solución de Problemas

### Error: "Application failed to start"
- Verifica que todas las dependencias estén en `requirements.txt`
- Asegúrate de que el comando de inicio sea correcto
- Revisa los logs de la plataforma

### Error: "502 Bad Gateway"
- Verifica que el puerto esté configurado correctamente
- Asegúrate de que Gunicorn esté usando `$PORT` o el puerto correcto
- Revisa que el firewall permita el tráfico

### Error: "Module not found"
- Ejecuta `pip install -r requirements.txt` nuevamente
- Verifica que el entorno virtual esté activado
- Asegúrate de usar la versión correcta de Python

### La aplicación es lenta
- Aumenta el número de workers de Gunicorn
- Considera usar un CDN para archivos estáticos
- Optimiza las imágenes y recursos

---

## 📊 Monitoreo y Mantenimiento

### Logs
```bash
# Ver logs en tiempo real (VPS)
sudo journalctl -u cardwars -f

# Ver logs de Docker
docker logs -f card-wars

# Ver logs de Heroku
heroku logs --tail
```

### Actualizaciones
```bash
# VPS
cd /var/www/card-wars-kingdom
sudo git pull
sudo systemctl restart cardwars

# Heroku
git push heroku main

# Docker
docker-compose down
docker-compose up -d --build
```

---

## 🎯 Recomendaciones por Caso de Uso

| Caso de Uso | Plataforma Recomendada | Por qué |
|-------------|------------------------|---------|
| Pruebas rápidas | Vercel o Railway | Despliegue instantáneo, gratis |
| Aplicación pequeña | Render o PythonAnywhere | Capa gratuita generosa |
| Aplicación mediana | Railway o Heroku | Escalabilidad automática |
| Control total | VPS (DigitalOcean) | Máximo control y rendimiento |
| Alto tráfico | VPS + CDN | Mejor rendimiento |

---

## 📚 Recursos Adicionales

- [Documentación de Flask](https://flask.palletsprojects.com/)
- [Gunicorn Documentation](https://docs.gunicorn.org/)
- [Docker Documentation](https://docs.docker.com/)
- [Nginx Documentation](https://nginx.org/en/docs/)

---

## 🤝 Soporte

Si tienes problemas con el despliegue:
1. Revisa los logs de la plataforma
2. Verifica que todas las variables de entorno estén configuradas
3. Asegúrate de que los archivos de configuración estén en el repositorio
4. Consulta la documentación específica de la plataforma

---

## 📝 Notas Importantes

- **Nunca** subas tu archivo `.env` al repositorio
- Usa siempre HTTPS en producción
- Configura backups regulares de tu base de datos (si la usas)
- Monitorea el uso de recursos regularmente
- Mantén las dependencias actualizadas

---

¡Listo! Tu aplicación Card Wars Kingdom debería estar desplegada y funcionando. 🎮✨
