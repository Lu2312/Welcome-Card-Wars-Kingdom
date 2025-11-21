# Deployment Guide - Card Wars Kingdom

## Configuración del Servidor (Un Solo Proyecto)

Este servidor solo ejecuta **cardwars-kingdom.net**

### Arquitectura

- **Servidor**: 159.89.157.63
- **Puerto 8000**: Instancia principal de Gunicorn (peso 2)
- **Puerto 8001**: Instancia de respaldo de Gunicorn (peso 1, backup)
- **Puerto 80/443**: Nginx como reverse proxy
- **Cloudflare**: CDN, protección DDoS y proxy (oculta tu IP real)

La instancia de respaldo (8001) solo recibe tráfico si la principal (8000) falla.

### 1. Instalar Dependencias

```bash
sudo apt update
sudo apt install nginx python3-pip python3-venv
```

### 2. Configurar el Proyecto

```bash
# Clonar el repositorio
cd /var/www
sudo git clone <repository-url> cardwars-kingdom
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
```

### 3. Configurar Servicios Systemd

```bash
# Copiar archivos de servicio
sudo cp systemd/cardwars-kingdom.service /etc/systemd/system/
sudo cp systemd/cardwars-kingdom-backup.service /etc/systemd/system/

# Recargar systemd
sudo systemctl daemon-reload

# Habilitar servicios
sudo systemctl enable cardwars-kingdom.service
sudo systemctl enable cardwars-kingdom-backup.service

# Iniciar servicios
sudo systemctl start cardwars-kingdom.service
sudo systemctl start cardwars-kingdom-backup.service

# Verificar estado
sudo systemctl status cardwars-kingdom.service
sudo systemctl status cardwars-kingdom-backup.service
```

### 4. Configurar Nginx

```bash
# Copiar configuración
sudo cp nginx/cardwars-kingdom.conf /etc/nginx/sites-available/

# Crear enlace simbólico
sudo ln -s /etc/nginx/sites-available/cardwars-kingdom.conf /etc/nginx/sites-enabled/

# Probar configuración
sudo nginx -t

# Recargar Nginx
sudo systemctl reload nginx
```

### 5. Configuración SSL (Cloudflare Origin Certificate)

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
# Verificar servicios Gunicorn
curl http://localhost:8000/api/health
curl http://localhost:8001/api/health

# Verificar Nginx
curl http://localhost/api/health

# Ver logs
sudo journalctl -u cardwars-kingdom.service -f
sudo journalctl -u cardwars-kingdom-backup.service -f
sudo tail -f /var/log/nginx/cardwars-kingdom-error.log
```

## Comandos Útiles

```bash
# Reiniciar servicios
sudo systemctl restart cardwars-kingdom.service
sudo systemctl restart cardwars-kingdom-backup.service
sudo systemctl reload nginx

# Ver logs
sudo journalctl -u cardwars-kingdom.service -n 50
sudo journalctl -u cardwars-kingdom-backup.service -n 50

# Actualizar código
cd /var/www/cardwars-kingdom
sudo git pull
source venv/bin/activate
pip install -r requirements.txt
sudo systemctl restart cardwars-kingdom.service
sudo systemctl restart cardwars-kingdom-backup.service
```
