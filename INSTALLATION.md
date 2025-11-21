# 🚀 Guía de Instalación Completa - Card Wars Kingdom

Esta guía te llevará desde cero hasta tener el servidor funcionando en tu VPS con Cloudflare.

## 📋 Requisitos Previos

- VPS con Ubuntu 20.04 o superior (DigitalOcean, AWS, etc.)
- Acceso SSH a tu VPS
- Dominio registrado: `cardwars-kingdom.net`
- Cuenta de Cloudflare (gratuita)

## 🔑 Paso 1: Acceder a tu VPS

```bash
# Conectar por SSH
ssh root@159.89.157.63

# O si tienes usuario no-root
ssh tu-usuario@159.89.157.63
```

## 📦 Paso 2: Actualizar el Sistema

```bash
# Actualizar paquetes
sudo apt update
sudo apt upgrade -y

# Instalar dependencias básicas
sudo apt install -y git python3 python3-pip python3-venv nginx curl
```

## 📂 Paso 3: Clonar el Repositorio

```bash
# Crear directorio para aplicaciones web
sudo mkdir -p /var/www

# Navegar al directorio
cd /var/www

# Clonar el repositorio
sudo git clone https://github.com/Lu2312/Welcome-Card-Wars-Kingdom.git cardwars-kingdom

# Cambiar permisos
sudo chown -R www-data:www-data /var/www/cardwars-kingdom
sudo chmod -R 755 /var/www/cardwars-kingdom

# Entrar al directorio
cd cardwars-kingdom
```

## 🐍 Paso 4: Configurar Python y Entorno Virtual

```bash
# Crear entorno virtual
sudo -u www-data python3 -m venv venv

# Activar entorno virtual
source venv/bin/activate

# Actualizar pip
pip install --upgrade pip

# Instalar dependencias
pip install -r requirements.txt

# Instalar Gunicorn
pip install gunicorn

# Desactivar entorno (por ahora)
deactivate
```

## 📝 Paso 5: Crear Directorios para Logs

```bash
# Crear directorios
sudo mkdir -p /var/log/gunicorn
sudo mkdir -p /var/run/gunicorn

# Asignar permisos
sudo chown -R www-data:www-data /var/log/gunicorn
sudo chown -R www-data:www-data /var/run/gunicorn
sudo chmod -R 755 /var/log/gunicorn
sudo chmod -R 755 /var/run/gunicorn
```

## ⚙️ Paso 6: Configurar Servicios Systemd

```bash
# Copiar archivos de servicio
sudo cp /var/www/cardwars-kingdom/systemd/cardwars-kingdom.service /etc/systemd/system/
sudo cp /var/www/cardwars-kingdom/systemd/cardwars-kingdom-backup.service /etc/systemd/system/

# Recargar systemd
sudo systemctl daemon-reload

# Habilitar servicios para inicio automático
sudo systemctl enable cardwars-kingdom.service
sudo systemctl enable cardwars-kingdom-backup.service

# Iniciar servicios
sudo systemctl start cardwars-kingdom.service
sudo systemctl start cardwars-kingdom-backup.service

# Verificar estado
sudo systemctl status cardwars-kingdom.service
sudo systemctl status cardwars-kingdom-backup.service
```

**Verificar que Gunicorn está corriendo:**
```bash
# Debe responder con JSON
curl http://localhost:8000/api/health
curl http://localhost:8001/api/health
```

## 🌐 Paso 7: Configurar Cloudflare DNS

### 7.1. Agregar el Dominio a Cloudflare

1. Ir a [Cloudflare Dashboard](https://dash.cloudflare.com)
2. Click en **"Add a Site"**
3. Introducir: `cardwars-kingdom.net`
4. Seleccionar plan **Free**
5. Click **"Add Site"**

### 7.2. Cambiar Nameservers en tu Registrador de Dominio

Cloudflare te dará 2 nameservers, ejemplo:
