# VPS Deployment - Card Wars Kingdom

Configuración completa para desplegar ambos proyectos en VPS Ubuntu con Cloudflare SSL.

## 📁 Estructura de Archivos

```
vps-deployment/
├── COMPLETE-DEPLOYMENT-GUIDE.md          # Guía detallada paso a paso
├── nginx-card-wars-kingdom.com.conf      # Config Nginx para card-wars-kingdom.com
├── nginx-cardwars-kingdom.net.conf       # Config Nginx para cardwars-kingdom.net
├── systemd/
│   ├── card-wars-kingdom-app.service          # Servicio principal app (puerto 8000)
│   ├── card-wars-kingdom-app-backup.service   # Servicio backup app (puerto 8001)
│   ├── cardwars-kingdom-site.service          # Servicio principal site (puerto 8080)
│   └── cardwars-kingdom-site-backup.service   # Servicio backup site (puerto 8081)
└── scripts/
    ├── setup-vps.sh           # Instalación inicial automática
    ├── start-services.sh      # Iniciar todos los servicios
    ├── stop-services.sh       # Detener todos los servicios
    ├── restart-services.sh    # Reiniciar todos los servicios
    ├── update-projects.sh     # Actualizar código desde GitHub
    └── status.sh              # Ver estado de todos los servicios
```

## 🚀 Inicio Rápido

### 1. Instalación Inicial en VPS

```bash
# Conectar a VPS
ssh root@159.89.157.63

# Descargar el script de instalación
cd /tmp
git clone https://github.com/Lu2312/Welcome-Card-Wars-Kingdom.git
cd Welcome-Card-Wars-Kingdom/vps-deployment

# Ejecutar instalación automática
sudo bash scripts/setup-vps.sh
```

### 2. Generar Certificados en Cloudflare

1. Ve a Cloudflare Dashboard
2. Para cada dominio (card-wars-kingdom.com y cardwars-kingdom.net):
   - SSL/TLS → Origin Server → Create Certificate
   - Guarda el certificado y la clave privada

### 3. Instalar Certificados en VPS

```bash
# Para card-wars-kingdom.com
sudo nano /etc/ssl/certs/card-wars-kingdom.com.crt     # Pegar certificado
sudo nano /etc/ssl/private/card-wars-kingdom.com.key   # Pegar clave
sudo chmod 600 /etc/ssl/private/card-wars-kingdom.com.key

# Para cardwars-kingdom.net
sudo nano /etc/ssl/certs/cardwars-kingdom.net.crt      # Pegar certificado
sudo nano /etc/ssl/private/cardwars-kingdom.net.key    # Pegar clave
sudo chmod 600 /etc/ssl/private/cardwars-kingdom.net.key
```

### 4. Iniciar Servicios

```bash
sudo bash /var/www/Welcome-Card-Wars-Kingdom/vps-deployment/scripts/start-services.sh
```

### 5. Configurar DNS en Cloudflare

Para ambos dominios, agrega registros A:
- @ → 159.89.157.63 (Proxied ☁️)
- www → 159.89.157.63 (Proxied ☁️)

Activa en SSL/TLS:
- Mode: Full (strict)
- Always Use HTTPS: ON
- Authenticated Origin Pulls: ON

## 📝 Comandos Útiles

```bash
# Ver estado
sudo systemctl status cardwars-kingdom-net.service
sudo systemctl status card-wars-kingdom-com.service

# Reiniciar servicios
sudo systemctl restart cardwars-kingdom-net.service
sudo systemctl restart card-wars-kingdom-com.service

# Actualizar desde GitHub (cardwars-kingdom.net)
cd /var/www/cardwars-kingdom && git pull origin main && source venv/bin/activate && pip install -r requirements.txt && sudo systemctl restart cardwars-kingdom-net.service

# Actualizar desde GitHub (card-wars-kingdom.com)
cd /var/www/cardwarskingdomrvd && git pull origin main && source venv/bin/activate && pip install -r requirements.txt && sudo systemctl restart card-wars-kingdom-com.service

# Ver logs
sudo journalctl -u card-wars-kingdom-app.service -f
sudo journalctl -u cardwars-kingdom-site.service -f
```

## 🌐 Arquitectura

### card-wars-kingdom.com
- **Principal:** 127.0.0.1:8000 (peso 2)
- **Backup:** 127.0.0.1:8001 (peso 1, backup)
- **Nginx:** HTTPS:443 → Gunicorn
- **Path:** /var/www/cardwarskingdomrvd

### cardwars-kingdom.net
- **Principal:** 127.0.0.1:8080 (peso 2)
- **Backup:** 127.0.0.1:8081 (peso 1, backup)
- **Nginx:** HTTPS:443 → Gunicorn
- **Path:** /var/www/Welcome-Card-Wars-Kingdom

## 🔐 Seguridad

- ✅ Cloudflare Origin Certificate SSL/TLS
- ✅ Authenticated Origin Pulls (solo Cloudflare puede conectarse)
- ✅ HTTPS forzado (HTTP → HTTPS redirect)
- ✅ Security headers (HSTS, XSS Protection, etc.)
- ✅ Firewall UFW configurado
- ✅ Fail2ban para protección contra brute force

## 📚 Documentación Completa

Lee [COMPLETE-DEPLOYMENT-GUIDE.md](./COMPLETE-DEPLOYMENT-GUIDE.md) para:
- Instrucciones detalladas paso a paso
- Troubleshooting
- Monitoreo y mantenimiento
- Comandos avanzados

## ✅ Checklist Post-Deployment

- [ ] Ambos proyectos clonados en /var/www/
- [ ] Certificados SSL instalados para ambos dominios
- [ ] 4 servicios systemd corriendo correctamente
- [ ] Nginx configurado y funcionando
- [ ] DNS configurado en Cloudflare
- [ ] SSL/TLS en modo Full (strict)
- [ ] Authenticated Origin Pulls activado
- [ ] Sitios accesibles vía HTTPS
- [ ] Health checks respondiendo OK

## 🆘 Soporte

Si encuentras problemas:
1. Revisa los logs: `sudo journalctl -u <service> -xe`
2. Verifica el estado: `bash scripts/status.sh`
3. Consulta COMPLETE-DEPLOYMENT-GUIDE.md sección Troubleshooting
