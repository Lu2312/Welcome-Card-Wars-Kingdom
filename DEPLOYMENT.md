# Deployment Guide - Card Wars Kingdom

## Configuración del Servidor

Este servidor ejecuta **cardwars-kingdom.net**

### Arquitectura

- **Servidor**: 159.89.157.63
- **Puerto 8000**: Gunicorn WSGI Server
- **Puerto 80/443**: Nginx como reverse proxy
- **Cloudflare**: CDN, protección DDoS y proxy (oculta tu IP real)
- **Directorio de Producción**: /var/www/cardwars-kingdom

### 1. Instalar Dependencias

```bash
sudo apt update
sudo apt install nginx python3-pip python3-venv git
```

### 2. Configurar el Proyecto

```bash
# Clonar el repositorio directamente en producción
cd /var/www
sudo git clone https://github.com/Lu2312/Welcome-Card-Wars-Kingdom.git cardwars-kingdom
cd cardwars-kingdom

# Crear entorno virtual
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt gunicorn

# Crear directorios para logs
sudo mkdir -p /var/log/gunicorn
sudo mkdir -p /var/run/gunicorn
sudo chown -R www-data:www-data /var/log/gunicorn
sudo chown -R www-data:www-data /var/run/gunicorn

# Configurar permisos
sudo chown -R www-data:www-data /var/www/cardwars-kingdom
```

### 3. Configurar Servicio Systemd

```bash
# Copiar archivo de servicio
sudo cp systemd/cardwars-kingdom.service /etc/systemd/system/cardwars-kingdom-net.service

# Recargar systemd
sudo systemctl daemon-reload

# Habilitar servicio
sudo systemctl enable cardwars-kingdom-net.service

# Iniciar servicio
sudo systemctl start cardwars-kingdom-net.service

# Verificar estado
sudo systemctl status cardwars-kingdom-net.service
```

### 4. Configurar Nginx

```bash
# Crear configuración de Nginx
sudo nano /etc/nginx/sites-available/cardwars-kingdom-net

# Pegar la siguiente configuración:
```

```nginx
server {
    listen 80;
    server_name cardwars-kingdom.net www.cardwars-kingdom.net;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;

    # Client body size
    client_max_body_size 50M;

    # Static files
    location /static {
        alias /var/www/cardwars-kingdom/static;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    # Resources (images, icons, etc)
    location /resources {
        alias /var/www/cardwars-kingdom/resources;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    # Proxy to Gunicorn
    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_redirect off;
        proxy_buffering off;
    }

    # Logs
    access_log /var/log/nginx/cardwars-kingdom-net-access.log;
    error_log /var/log/nginx/cardwars-kingdom-net-error.log;
}
```

```bash
# Crear enlace simbólico
sudo ln -s /etc/nginx/sites-available/cardwars-kingdom-net /etc/nginx/sites-enabled/

# Probar configuración
sudo nginx -t

# Recargar Nginx
sudo systemctl reload nginx
```

### 5. Configuración SSL (Opcional - Cloudflare Origin Certificate)

**Nota:** Con Cloudflare en modo "Flexible", no es necesario configurar SSL en el servidor.

Si deseas SSL end-to-end:

1. En Cloudflare Dashboard, ve a SSL/TLS > Origin Server
2. Crea un certificado de origen
3. Guarda el certificado y la clave privada:

```bash
sudo mkdir -p /etc/ssl/certs /etc/ssl/private
sudo nano /etc/ssl/certs/cardwars-kingdom.crt  # Pegar certificado
sudo nano /etc/ssl/private/cardwars-kingdom.key  # Pegar clave privada
sudo chmod 600 /etc/ssl/private/cardwars-kingdom.key
```

### 6. Configuración DNS en Cloudflare

Para cardwars-kingdom.net con tu servidor en **159.89.157.63**:

#### Registros DNS (A Records):

| Tipo | Nombre | Contenido | Proxy Status | TTL |
|------|--------|-----------|--------------|-----|
| A | @ | 159.89.157.63 | ☁️ Proxied | Auto |
| A | www | 159.89.157.63 | ☁️ Proxied | Auto |

**Pasos en Cloudflare:**

1. Ve a tu dominio `cardwars-kingdom.net` en Cloudflare
2. Click en "DNS" en el menú lateral
3. Agrega los siguientes registros:

**Registro Root (@):**
- Type: `A`
- Name: `@`
- IPv4 address: `159.89.157.63`
- Proxy status: `Proxied` (nube naranja activa ☁️)
- TTL: `Auto`

**Registro WWW:**
- Type: `A`
- Name: `www`
- IPv4 address: `159.89.157.63`
- Proxy status: `Proxied` (nube naranja activa ☁️)
- TTL: `Auto`

#### Configuración SSL/TLS en Cloudflare:

1. Ve a SSL/TLS > Overview
2. Selecciona modo: **Full (strict)**
3. Activa las siguientes opciones:
   - ✅ Always Use HTTPS: ON
   - ✅ Automatic HTTPS Rewrites: ON
   - ✅ Minimum TLS Version: TLS 1.2

#### Verificación:

Después de configurar, espera unos minutos para la propagación DNS y verifica:

```bash
# Desde tu servidor
ping cardwars-kingdom.net
ping www.cardwars-kingdom.net

# Desde cualquier computadora
nslookup cardwars-kingdom.net
curl -I https://cardwars-kingdom.net
```

**Nota Importante:** Con Cloudflare Proxy activado (☁️), los visitantes verán las IPs de Cloudflare, no tu IP real (159.89.157.63), lo cual proporciona protección DDoS y caché.

### 7. Verificar Instalación

```bash
# Verificar servicio Gunicorn
curl http://localhost:8000/api/health

# Verificar Nginx
curl http://localhost/api/health

# Ver logs
sudo journalctl -u cardwars-kingdom-net.service -f
sudo tail -f /var/log/nginx/cardwars-kingdom-net-error.log
```

## Actualización del Servidor

### Método Rápido (Recomendado)

```bash
# SSH al servidor
ssh root@159.89.157.63

# Actualizar código
cd /var/www/cardwars-kingdom
git pull origin main

# Activar entorno virtual e instalar dependencias (si cambió requirements.txt)
source venv/bin/activate
pip install -r requirements.txt

# Reiniciar servicio
sudo systemctl restart cardwars-kingdom-net.service

# Verificar estado
sudo systemctl status cardwars-kingdom-net.service
```

## Comandos Útiles

```bash
# Reiniciar servicio
sudo systemctl restart cardwars-kingdom-net.service

# Ver logs en tiempo real
sudo journalctl -u cardwars-kingdom-net.service -f

# Ver logs recientes
sudo journalctl -u cardwars-kingdom-net.service -n 50

# Verificar estado del servicio
sudo systemctl status cardwars-kingdom-net.service

# Recargar Nginx
sudo systemctl reload nginx

# Ver logs de Nginx
sudo tail -f /var/log/nginx/cardwars-kingdom-net-access.log
sudo tail -f /var/log/nginx/cardwars-kingdom-net-error.log
```
