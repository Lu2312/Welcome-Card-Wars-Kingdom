# Guía Completa de Deployment - Dos Proyectos en VPS Ubuntu con Cloudflare SSL

Esta guía configura ambos proyectos en tu VPS con certificados SSL de Cloudflare Origin Certificate y Authenticated Origin Pulls.

## 📋 Configuración General

**Servidor VPS:** 159.89.157.63 (Ubuntu Digital Ocean)

### Proyectos:

1. **card-wars-kingdom.com** (Aplicación principal)
   - Repositorio: https://github.com/Lu2312/cardwarskingdomrvd.git
   - Puerto principal: 8000
   - Puerto backup: 8001
   - Path: `/var/www/cardwarskingdomrvd`

2. **cardwars-kingdom.net** (Sitio web)
   - Repositorio: https://github.com/Lu2312/Welcome-Card-Wars-Kingdom.git
   - Puerto principal: 8000
   - Path: `/var/www/cardwars-kingdom`

---

## 🔐 Paso 1: Generar Certificados Origin en Cloudflare

### Para card-wars-kingdom.com:

1. Inicia sesión en Cloudflare Dashboard
2. Selecciona el dominio `card-wars-kingdom.com`
3. Ve a **SSL/TLS** → **Origin Server**
4. Click en **Create Certificate**
5. Configuración:
   - **Let Cloudflare generate a private key and a CSR** (seleccionado)
   - **Private key type:** RSA (2048)
   - **Hostnames:** 
     - `card-wars-kingdom.com`
     - `*.card-wars-kingdom.com`
   - **Certificate Validity:** 15 años
6. Click **Create**
7. **GUARDA estos datos** (no podrás verlos de nuevo):
   - Origin Certificate → Guárdalo para `/etc/ssl/certs/card-wars-kingdom.com.crt`
   - Private Key → Guárdalo para `/etc/ssl/private/card-wars-kingdom.com.key`

### Para cardwars-kingdom.net:

Repite el mismo proceso pero para `cardwars-kingdom.net`:
- Origin Certificate → `/etc/ssl/certs/cardwars-kingdom.net.crt`
- Private Key → `/etc/ssl/private/cardwars-kingdom.net.key`

### Certificado de Authenticated Origin Pulls (compartido):

Descarga el certificado de Cloudflare Origin Pull:

```bash
# En tu VPS
sudo mkdir -p /etc/ssl/certs
sudo curl -o /etc/ssl/certs/cloudflare-origin-pull.crt https://developers.cloudflare.com/ssl/static/authenticated_origin_pull_ca.pem
```

O copia manualmente este certificado en `/etc/ssl/certs/cloudflare-origin-pull.crt`:

```
-----BEGIN CERTIFICATE-----
MIIGCjCCA/KgAwIBAgIIV5G6lVbCLmEwDQYJKoZIhvcNAQELBQAwgZAxCzAJBgNV
BAYTAlVTMRkwFwYDVQQKExBDbG91ZEZsYXJlLCBJbmMuMRQwEgYDVQQLEwtPcmln
aW4gUHVsbDEWMBQGA1UEBxMNU2FuIEZyYW5jaXNjbzETMBEGA1UECBMKQ2FsaWZv
cm5pYTEjMCEGA1UEAxMab3JpZ2luLXB1bGwuY2xvdWRmbGFyZS5uZXQwHhcNMTUw
MTEzMDI0NzUzWhcNMjAwMTEyMDI1MjUzWjCBkDELMAkGA1UEBhMCVVMxGTAXBgNV
BAoTEENsb3VkRmxhcmUsIEluYy4xFDASBgNVBAsTC09yaWdpbiBQdWxsMRYwFAYD
VQQHEw1TYW4gRnJhbmNpc2NvMRMwEQYDVQQIEwpDYWxpZm9ybmlhMSMwIQYDVQQD
ExpvcmlnaW4tcHVsbC5jbG91ZGZsYXJlLm5ldDCCAiIwDQYJKoZIhvcNAQEBBQAD
ggIPADCCAgoCggIBALvI/m9PH5dHJMPVWa8V+3b7IcKBsRb9T8G9t3/OHOCOLp1Q
aoAJ7/fkX/sG+dEMPwCdXoXlLJ/i1NU+hH8LdBNDXQs3AqQ6xvqP3BVchPr3xIaL
Y0v1DgqQdPyA7aTvKqPVuROe1xMQ1Z+hZJIIz2IkTqLXBQaCnNiLBjzZ/hqYhCPS
kXMPKJU0e9mZNEj0Yp3Mk7wZXBPZr1J7Sk8o0L7CkXLvKCQkGPkVhDVXrECpVGqA
FgFUuJ6J0OeBPiWjTmPnqImXqPGPnqJjLFPBl5tYvHBnLJNlsUtNlPqRDUoNcQsA
FJEwfkCNrTVJfW8iBxlPKoNBGPLfqGRGr3vCqGECcnQ2tNCfkNqNEUr3mPLvDHLV
qRQRNiCqNCFXZ1AwSLb4gFqjlQYJJNEoKJZpqlXqfQtKiEVBQcKPwLCDXKBHRCjS
MYdN5xUEhQXkGpKFJt5qmWLkPaHdCNUqYHBJNYvQdQiCg1xn6GRDTJF8I7LvWMgH
CQ+4IjEOSkFCQj3KAH5WmZyNEAUaLMKtGFCpXJdCBxFxLGMQP3Y8L8PfKl/g/KNv
z7JRbTxLIBLTqZRLuUn+YZI5hOGLFlX/1BVCXXCdVxMz3x8bZpNHQIDXGK9aLjBK
WcFVm3T7rULCzN2pWjbCjLkR9t8J1Ew/cJCqLnZnXdm8Uf1wGxCv6aTmFVFbAgMB
AAGjZjBkMA4GA1UdDwEB/wQEAwIABjASBgNVHRMBAf8ECDAGAQH/AgECMB0GA1Ud
DgQWBBQ4D9n3nITqIbBE8ZqLQpWPphHZpDAfBgNVHSMEGDAWgBQ4D9n3nITqIbBE
8ZqLQpWPphHZpDANBgkqhkiG9w0BAQsFAAOCAgEAHhBe4w7xG+/BTJZ6VyKyPWY4
nOHLnqCJCv7Hgh6cBWLT9DhL+Uh8KFvUsBAuPJjMt5Uu4fv0s4WK6l0cS1SeFJrT
iAjGYqB4VmUaTaYTa3hMGGqKQDxQ3FeUPnAh5A1bXRN+VsZmL7iF4BLBSjOoKPlJ
m7mq+RcOAO/TqBTKi0DY7t9nVXaLI0pXQvK3qLEYJqVi1qJkUhXPjQF7cKxLLvnC
4FKYJDPiYvR8a5aLYnLKcaRnPT7Qcy8wGPqcHBvcCqK0LbBhYTaJ7TQ0UqxaqFJr
SsYL9p9mPvK+jIIkJK3mDNKKZSc6OLbW0EYHJ4WqJvfqb7g/hJhShFTKNiQqFqvC
YCLOQDNDqDiDMlDJPuYPYBQvJtY7WzXfK1cE4LGJF2Ly1/dKvBPSxPNqNDp2Rt3r
AhZQMdUVLqMCPnNL3LUhMpDGJPK0LfJKH7sU0WJDvNPNhgwPQqBQvQXE8Ql7Jzp7
sQ4W3pYvJfNNE0yQSxCh5cIJ6aTQPJZz2K6yKv3nJkYBa3f9TuPx0xm8JI0hQ0H7
PlDZPKQxkD5fMCt7BclLNcX3XJZM8FfKmGC8K/7vTB7eX8qLpYXYRwTfIQP8Q4FP
V1jFR0LYTmNRNIj3eBGCFJpKUqlZt0Hx8W3m6KdUPYmMCCKGj7MEMfJkOIvlvCF0
6J1mRQMPPqK6Y8E=
-----END CERTIFICATE-----
```

---

## 🚀 Paso 2: Instalar Dependencias en el VPS

Conéctate a tu VPS:

```bash
ssh root@159.89.157.63
```

Instala los paquetes necesarios:

```bash
# Actualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar dependencias
sudo apt install -y nginx python3-pip python3-venv git curl

# Crear directorios para logs
sudo mkdir -p /var/log/gunicorn
sudo mkdir -p /var/run/gunicorn
sudo chown -R www-data:www-data /var/log/gunicorn
sudo chown -R www-data:www-data /var/run/gunicorn

# Crear directorios para certificados SSL
sudo mkdir -p /etc/ssl/certs
sudo mkdir -p /etc/ssl/private
sudo chmod 700 /etc/ssl/private
```

---

## 📁 Paso 3: Clonar los Proyectos

```bash
# Crear directorio base
sudo mkdir -p /var/www
cd /var/www

# Clonar proyecto 1: card-wars-kingdom.com
sudo git clone https://github.com/Lu2312/cardwarskingdomrvd.git
cd cardwarskingdomrvd
sudo python3 -m venv venv
sudo venv/bin/pip install --upgrade pip
sudo venv/bin/pip install -r requirements.txt gunicorn
cd ..

# Clonar proyecto 2: cardwars-kingdom.net
sudo git clone https://github.com/Lu2312/Welcome-Card-Wars-Kingdom.git
cd Welcome-Card-Wars-Kingdom
sudo python3 -m venv venv
sudo venv/bin/pip install --upgrade pip
sudo venv/bin/pip install -r requirements.txt gunicorn
cd ..

# Establecer permisos correctos
sudo chown -R www-data:www-data /var/www/cardwarskingdomrvd
sudo chown -R www-data:www-data /var/www/Welcome-Card-Wars-Kingdom
```

---

## 🔐 Paso 4: Instalar Certificados SSL

### Certificados para card-wars-kingdom.com:

```bash
sudo nano /etc/ssl/certs/card-wars-kingdom.com.crt
```
Pega el **Origin Certificate** de Cloudflare, guarda y cierra (Ctrl+X, Y, Enter)

```bash
sudo nano /etc/ssl/private/card-wars-kingdom.com.key
```
Pega el **Private Key** de Cloudflare, guarda y cierra

```bash
sudo chmod 600 /etc/ssl/private/card-wars-kingdom.com.key
```

### Certificados para cardwars-kingdom.net:

```bash
sudo nano /etc/ssl/certs/cardwars-kingdom.net.crt
```
Pega el **Origin Certificate** de Cloudflare, guarda y cierra

```bash
sudo nano /etc/ssl/private/cardwars-kingdom.net.key
```
Pega el **Private Key** de Cloudflare, guarda y cierra

```bash
sudo chmod 600 /etc/ssl/private/cardwars-kingdom.net.key
```

---

## ⚙️ Paso 5: Configurar Servicios Systemd

Copia los archivos de servicio desde el repositorio Welcome-Card-Wars-Kingdom:

```bash
# Para card-wars-kingdom.com (App)
sudo cp /var/www/Welcome-Card-Wars-Kingdom/vps-deployment/systemd/card-wars-kingdom-app.service /etc/systemd/system/
sudo cp /var/www/Welcome-Card-Wars-Kingdom/vps-deployment/systemd/card-wars-kingdom-app-backup.service /etc/systemd/system/

# Para cardwars-kingdom.net (Site)
sudo cp /var/www/Welcome-Card-Wars-Kingdom/vps-deployment/systemd/cardwars-kingdom-site.service /etc/systemd/system/
sudo cp /var/www/Welcome-Card-Wars-Kingdom/vps-deployment/systemd/cardwars-kingdom-site-backup.service /etc/systemd/system/

# Recargar systemd
sudo systemctl daemon-reload

# Habilitar servicios para iniciar al arrancar
sudo systemctl enable card-wars-kingdom-app.service
sudo systemctl enable card-wars-kingdom-app-backup.service
sudo systemctl enable cardwars-kingdom-site.service
sudo systemctl enable cardwars-kingdom-site-backup.service

# Iniciar servicios
sudo systemctl start card-wars-kingdom-app.service
sudo systemctl start card-wars-kingdom-app-backup.service
sudo systemctl start cardwars-kingdom-site.service
sudo systemctl start cardwars-kingdom-site-backup.service

# Verificar estado
sudo systemctl status card-wars-kingdom-app.service
sudo systemctl status card-wars-kingdom-app-backup.service
sudo systemctl status cardwars-kingdom-site.service
sudo systemctl status cardwars-kingdom-site-backup.service
```

---

## 🌐 Paso 6: Configurar Nginx

```bash
# Copiar configuraciones
sudo cp /var/www/Welcome-Card-Wars-Kingdom/vps-deployment/nginx-card-wars-kingdom.com.conf /etc/nginx/sites-available/
sudo cp /var/www/Welcome-Card-Wars-Kingdom/vps-deployment/nginx-cardwars-kingdom.net.conf /etc/nginx/sites-available/

# Remover configuración default de Nginx
sudo rm -f /etc/nginx/sites-enabled/default

# Crear enlaces simbólicos
sudo ln -sf /etc/nginx/sites-available/nginx-card-wars-kingdom.com.conf /etc/nginx/sites-enabled/
sudo ln -sf /etc/nginx/sites-available/nginx-cardwars-kingdom.net.conf /etc/nginx/sites-enabled/

# Probar configuración
sudo nginx -t

# Si no hay errores, recargar Nginx
sudo systemctl reload nginx
```

---

## 🔷 Paso 7: Configurar DNS en Cloudflare

### Para card-wars-kingdom.com:

1. Ve a Cloudflare Dashboard → `card-wars-kingdom.com`
2. Click en **DNS**
3. Agrega estos registros:

| Tipo | Nombre | Contenido | Proxy Status | TTL |
|------|--------|-----------|--------------|-----|
| A | @ | 159.89.157.63 | ☁️ Proxied | Auto |
| A | www | 159.89.157.63 | ☁️ Proxied | Auto |

### Para cardwars-kingdom.net:

1. Ve a Cloudflare Dashboard → `cardwars-kingdom.net`
2. Click en **DNS**
3. Agrega estos registros:

| Tipo | Nombre | Contenido | Proxy Status | TTL |
|------|--------|-----------|--------------|-----|
| A | @ | 159.89.157.63 | ☁️ Proxied | Auto |
| A | www | 159.89.157.63 | ☁️ Proxied | Auto |

---

## 🔐 Paso 8: Configurar SSL/TLS en Cloudflare

### Para AMBOS dominios (card-wars-kingdom.com y cardwars-kingdom.net):

1. Ve a **SSL/TLS** → **Overview**
2. Selecciona modo: **Full (strict)**

3. Ve a **SSL/TLS** → **Edge Certificates**
   - ✅ **Always Use HTTPS:** ON
   - ✅ **Automatic HTTPS Rewrites:** ON
   - ✅ **Minimum TLS Version:** TLS 1.2

4. Ve a **SSL/TLS** → **Origin Server**
   - ✅ **Authenticated Origin Pulls:** ON (activar para ambos dominios)

---

## ✅ Paso 9: Verificar Instalación

```bash
# Verificar servicios Gunicorn
curl http://localhost:8000/api/health  # card-wars-kingdom.com principal
curl http://localhost:8001/api/health  # card-wars-kingdom.com backup
curl http://localhost:8080/api/health  # cardwars-kingdom.net principal
curl http://localhost:8081/api/health  # cardwars-kingdom.net backup

# Verificar Nginx
curl http://localhost/health  # Debería redirigir a HTTPS
curl -k https://localhost/health

# Ver logs en tiempo real
sudo journalctl -u card-wars-kingdom-app.service -f
sudo journalctl -u cardwars-kingdom-site.service -f

# Logs de Nginx
sudo tail -f /var/log/nginx/card-wars-kingdom-error.log
sudo tail -f /var/log/nginx/cardwars-kingdom-net-error.log
```

### Probar desde internet:

Espera 2-5 minutos para propagación DNS, luego:

```bash
# Desde tu computadora local
curl -I https://card-wars-kingdom.com
curl -I https://cardwars-kingdom.net
```

O abre en tu navegador:
- https://card-wars-kingdom.com
- https://cardwars-kingdom.net

Deberías ver el candado 🔒 de seguridad en ambos sitios.

---

## 🔧 Comandos Útiles de Mantenimiento

### Reiniciar servicios:

```bash
# Reiniciar aplicación card-wars-kingdom.com
sudo systemctl restart card-wars-kingdom-app.service
sudo systemctl restart card-wars-kingdom-app-backup.service

# Reiniciar sitio cardwars-kingdom.net
sudo systemctl restart cardwars-kingdom-site.service
sudo systemctl restart cardwars-kingdom-site-backup.service

# Recargar Nginx (sin downtime)
sudo systemctl reload nginx

# Reiniciar Nginx (con breve downtime)
sudo systemctl restart nginx
```

### Ver logs:

```bash
# Logs de Gunicorn
sudo journalctl -u card-wars-kingdom-app.service -n 50
sudo journalctl -u cardwars-kingdom-site.service -n 50

# Logs de Nginx
sudo tail -n 100 /var/log/nginx/card-wars-kingdom-error.log
sudo tail -n 100 /var/log/nginx/cardwars-kingdom-net-error.log

# Logs en tiempo real
sudo journalctl -u card-wars-kingdom-app.service -f
sudo tail -f /var/log/nginx/card-wars-kingdom-access.log
```

### Actualizar código:

```bash
# Actualizar card-wars-kingdom.com
cd /var/www/cardwarskingdomrvd
sudo git pull
sudo venv/bin/pip install -r requirements.txt
sudo systemctl restart card-wars-kingdom-app.service
sudo systemctl restart card-wars-kingdom-app-backup.service

# Actualizar cardwars-kingdom.net
cd /var/www/Welcome-Card-Wars-Kingdom
sudo git pull
sudo venv/bin/pip install -r requirements.txt
sudo systemctl restart cardwars-kingdom-site.service
sudo systemctl restart cardwars-kingdom-site-backup.service
```

### Verificar estado de servicios:

```bash
# Ver todos los servicios
sudo systemctl status card-wars-kingdom-app.service
sudo systemctl status card-wars-kingdom-app-backup.service
sudo systemctl status cardwars-kingdom-site.service
sudo systemctl status cardwars-kingdom-site-backup.service
sudo systemctl status nginx

# Ver puertos en uso
sudo netstat -tlnp | grep -E ':(80|443|8000|8001|8080|8081)'

# O con ss
sudo ss -tlnp | grep -E ':(80|443|8000|8001|8080|8081)'
```

---

## 🐛 Troubleshooting

### Problema: Servicios no inician

```bash
# Ver errores detallados
sudo journalctl -u card-wars-kingdom-app.service -xe

# Verificar permisos
sudo chown -R www-data:www-data /var/www/cardwarskingdomrvd
sudo chown -R www-data:www-data /var/www/Welcome-Card-Wars-Kingdom
```

### Problema: Error 502 Bad Gateway

```bash
# Verificar que Gunicorn está corriendo
ps aux | grep gunicorn

# Verificar puertos
sudo netstat -tlnp | grep -E '8000|8001|8080|8081'

# Reiniciar servicios
sudo systemctl restart card-wars-kingdom-app.service
sudo systemctl restart cardwars-kingdom-site.service
```

### Problema: Certificado SSL inválido

```bash
# Verificar que los certificados existen
ls -la /etc/ssl/certs/card-wars-kingdom.com.crt
ls -la /etc/ssl/private/card-wars-kingdom.com.key
ls -la /etc/ssl/certs/cardwars-kingdom.net.crt
ls -la /etc/ssl/private/cardwars-kingdom.net.key

# Verificar permisos
sudo chmod 644 /etc/ssl/certs/*.crt
sudo chmod 600 /etc/ssl/private/*.key

# Verificar configuración SSL en Cloudflare
# Debe estar en modo "Full (strict)"
```

### Problema: Error 400 Bad Request (Authenticated Origin Pulls)

Si ves error 400, puede ser porque Authenticated Origin Pulls no está correctamente configurado:

```bash
# Verificar que el certificado de Cloudflare existe
cat /etc/ssl/certs/cloudflare-origin-pull.crt

# Re-descargar si es necesario
sudo curl -o /etc/ssl/certs/cloudflare-origin-pull.crt https://developers.cloudflare.com/ssl/static/authenticated_origin_pull_ca.pem

# Temporalmente, puedes deshabilitar la verificación de cliente
# Edita las configuraciones de Nginx y comenta estas líneas:
# ssl_client_certificate /etc/ssl/certs/cloudflare-origin-pull.crt;
# ssl_verify_client on;

# Luego recarga Nginx
sudo systemctl reload nginx
```

---

## 🔒 Seguridad Adicional

### Firewall (UFW):

```bash
# Instalar UFW si no está instalado
sudo apt install ufw

# Permitir SSH (¡IMPORTANTE! Hazlo primero)
sudo ufw allow 22/tcp

# Permitir HTTP y HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Activar firewall
sudo ufw enable

# Ver estado
sudo ufw status
```

### Fail2ban (protección contra ataques de fuerza bruta):

```bash
sudo apt install fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

---

## 📊 Monitoreo

### Ver uso de recursos:

```bash
# CPU y memoria
htop

# Espacio en disco
df -h

# Logs en tiempo real
sudo tail -f /var/log/nginx/card-wars-kingdom-access.log
sudo tail -f /var/log/gunicorn/cardwars-app-access.log
```

---

## ✅ Checklist Final

- [ ] Certificados Origin de Cloudflare instalados para ambos dominios
- [ ] Certificado Authenticated Origin Pulls instalado
- [ ] Ambos proyectos clonados en `/var/www/`
- [ ] Entornos virtuales Python creados con dependencias instaladas
- [ ] 4 servicios systemd configurados y corriendo (2 por proyecto)
- [ ] Configuraciones Nginx instaladas
- [ ] DNS configurado en Cloudflare para ambos dominios
- [ ] SSL/TLS en modo "Full (strict)" en Cloudflare
- [ ] Authenticated Origin Pulls activado en Cloudflare
- [ ] Sitios accesibles vía HTTPS con candado 🔒
- [ ] Health checks respondiendo correctamente

---

## 🎉 ¡Listo!

Tus dos sitios ahora están:
- ✅ Protegidos con SSL/TLS de Cloudflare
- ✅ Con Authenticated Origin Pulls (solo Cloudflare puede conectarse)
- ✅ Con instancias de respaldo automático
- ✅ Detrás de Cloudflare CDN y protección DDoS
- ✅ Con logs centralizados
- ✅ Configurados para auto-restart en caso de fallo

**URLs:**
- https://card-wars-kingdom.com
- https://www.card-wars-kingdom.com
- https://cardwars-kingdom.net
- https://www.cardwars-kingdom.net
