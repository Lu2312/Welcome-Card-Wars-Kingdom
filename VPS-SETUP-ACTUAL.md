# Configuración Real de VPS - Card Wars Kingdom

## 📋 Información de la VPS

**Servidor:** 159.89.157.63 (Ubuntu - Digital Ocean)  
**Acceso SSH:** `ssh root@159.89.157.63`

---

## 🗂️ Estructura de Directorios

```
/var/www/
├── cardwarskingdomrvd/          # card-wars-kingdom.com (Aplicación)
│   ├── venv/
│   ├── app.py
│   └── ...
├── cardwars-kingdom/            # cardwars-kingdom.net (Sitio Web) ← DIRECTORIO ACTIVO
│   ├── venv/
│   ├── app.py
│   ├── resources/
│   ├── static/
│   ├── templates/
│   └── ...
└── cardwars-kingdom.net/        # Copia antigua (NO SE USA - puede eliminarse)
```

---

## 🚀 Proyectos Activos

### 1. card-wars-kingdom.com (Aplicación Principal)
- **Repositorio:** https://github.com/Lu2312/cardwarskingdomrvd.git
- **Directorio:** `/var/www/cardwarskingdomrvd`
- **Servicio:** `card-wars-kingdom-com.service`
- **Puerto:** 8001
- **Dominio:** https://card-wars-kingdom.com

### 2. cardwars-kingdom.net (Sitio Web)
- **Repositorio:** https://github.com/Lu2312/Welcome-Card-Wars-Kingdom.git
- **Directorio:** `/var/www/cardwars-kingdom`
- **Servicio:** `cardwars-kingdom-net.service`
- **Puerto:** 8000
- **Dominio:** https://cardwars-kingdom.net

---

## ⚙️ Servicios Systemd

### Servicios Activos:
```bash
# Ver estado
systemctl status card-wars-kingdom-com.service    # Aplicación (.com)
systemctl status cardwars-kingdom-net.service     # Sitio Web (.net)

# Reiniciar
systemctl restart card-wars-kingdom-com.service
systemctl restart cardwars-kingdom-net.service

# Ver logs
journalctl -u card-wars-kingdom-com.service -f
journalctl -u cardwars-kingdom-net.service -f
```

---

## 🔄 Actualizar Proyectos desde GitHub

### Actualizar cardwars-kingdom.net (Sitio Web):
```bash
ssh root@159.89.157.63
cd /var/www/cardwars-kingdom
git pull origin main
source venv/bin/activate
pip install -r requirements.txt
deactivate
systemctl restart cardwars-kingdom-net.service
```

### Actualizar card-wars-kingdom.com (Aplicación):
```bash
ssh root@159.89.157.63
cd /var/www/cardwarskingdomrvd
git pull origin main
source venv/bin/activate
pip install -r requirements.txt
deactivate
systemctl restart card-wars-kingdom-com.service
```

### Actualizar ambos proyectos:
```bash
ssh root@159.89.157.63

# Actualizar cardwars-kingdom.net
cd /var/www/cardwars-kingdom && git pull && source venv/bin/activate && pip install -r requirements.txt && deactivate

# Actualizar card-wars-kingdom.com
cd /var/www/cardwarskingdomrvd && git pull && source venv/bin/activate && pip install -r requirements.txt && deactivate

# Reiniciar ambos servicios
systemctl restart cardwars-kingdom-net.service
systemctl restart card-wars-kingdom-com.service
```

---

## 🌐 Configuración de Nginx

### cardwars-kingdom.net:
- **Archivo config:** `/etc/nginx/sites-available/cardwars-kingdom-net`
- **Puerto backend:** 8000
- **Static files:** `/var/www/cardwars-kingdom/static`

### card-wars-kingdom.com:
- **Archivo config:** `/etc/nginx/sites-available/card-wars-kingdom-com`
- **Puerto backend:** 8001
- **Static files:** `/var/www/cardwarskingdomrvd/static`

### Comandos útiles de Nginx:
```bash
# Verificar configuración
nginx -t

# Recargar configuración
systemctl reload nginx

# Reiniciar Nginx
systemctl restart nginx

# Ver logs
tail -f /var/log/nginx/cardwars-kingdom-net-access.log
tail -f /var/log/nginx/card-wars-kingdom-com-access.log
```

---

## 📜 Scripts de PowerShell (Windows)

Desde tu computadora local con PowerShell:

### 1. Actualizar solo cardwars-kingdom.net:
```powershell
.\update-vps.ps1
```

### 2. Actualizar ambos proyectos:
```powershell
.\update-both-projects-vps.ps1
```

### 3. Verificar estado de la VPS:
```powershell
.\check-vps-status.ps1
```

---

## 🔧 Comandos Útiles

### Ver todos los servicios activos:
```bash
systemctl list-units --type=service | grep -E 'card|kingdom'
```

### Ver puertos en escucha:
```bash
ss -tlnp | grep -E ':(80|443|8000|8001)'
```

### Ver uso de recursos:
```bash
# CPU y Memoria
top -bn1 | head -20

# Espacio en disco
df -h

# Memoria
free -h
```

### Verificar logs recientes:
```bash
# Últimos 50 logs de cardwars-kingdom.net
journalctl -u cardwars-kingdom-net.service -n 50

# Logs en tiempo real
journalctl -u cardwars-kingdom-net.service -f

# Logs con errores (últimas 24h)
journalctl --since "24 hours ago" -u cardwars-kingdom-net.service -p err
```

---

## 🗑️ Limpieza (Opcional)

Si quieres liberar espacio eliminando la copia duplicada:

```bash
# PRECAUCIÓN: Verifica que /var/www/cardwars-kingdom esté actualizado primero
cd /var/www
du -sh cardwars-kingdom cardwars-kingdom.net  # Comparar tamaños

# Si estás seguro de eliminar la copia antigua:
rm -rf /var/www/cardwars-kingdom.net
```

---

## 📊 Arquitectura Visual

```
Internet (Cloudflare CDN)
         ↓
    Nginx (80/443)
         ↓
    ┌────┴─────┐
    ↓          ↓
Port 8000   Port 8001
    ↓          ↓
cardwars-  card-wars-
kingdom.   kingdom.
  net        com
    ↓          ↓
Gunicorn   Gunicorn
    ↓          ↓
 Flask      Flask
   App       App
```

---

## ✅ Verificación Rápida

```bash
# Test de conectividad local
curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://localhost:8000/
curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://localhost:8001/

# Test de servicios
systemctl is-active cardwars-kingdom-net.service
systemctl is-active card-wars-kingdom-com.service

# Test de Nginx
systemctl is-active nginx
```

---

## 🆘 Troubleshooting

### Si el sitio no responde:

1. **Verificar servicio:**
   ```bash
   systemctl status cardwars-kingdom-net.service
   ```

2. **Ver logs de errores:**
   ```bash
   journalctl -u cardwars-kingdom-net.service -n 100
   tail -f /var/log/gunicorn/cardwars-kingdom-net-error.log
   ```

3. **Reiniciar servicio:**
   ```bash
   systemctl restart cardwars-kingdom-net.service
   ```

4. **Verificar Nginx:**
   ```bash
   systemctl status nginx
   nginx -t  # Test de configuración
   ```

5. **Verificar que el puerto está escuchando:**
   ```bash
   ss -tlnp | grep 8000
   ```

### Si hay errores de permisos:

```bash
# Ajustar permisos del directorio
chown -R www-data:www-data /var/www/cardwars-kingdom
chmod -R 755 /var/www/cardwars-kingdom
```

---

## 📝 Notas Importantes

1. **Directorio activo:** `/var/www/cardwars-kingdom` (NO `/var/www/Welcome-Card-Wars-Kingdom`)
2. **Servicio real:** `cardwars-kingdom-net.service` (NO `cardwars-kingdom-site.service`)
3. **Puerto real:** 8000 para .net, 8001 para .com (NO 8080/8081)
4. **Siempre hacer backup antes de cambios importantes**
5. **Cloudflare maneja el SSL público, el servidor usa certificados locales**

---

Última actualización: 10 de enero de 2026
