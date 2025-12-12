# Card Wars Kingdom - Welcome Site

Sitio web oficial de bienvenida para Card Wars Kingdom Revived - Un servidor privado del juego Card Wars Kingdom.

## 🌐 Sitio en Vivo

**URL:** [https://cardwars-kingdom.net](https://cardwars-kingdom.net)

## 📋 Descripción

Este es el sitio web de bienvenida para Card Wars Kingdom, construido con Flask. Proporciona información sobre el juego, enlaces de descarga, estado del servidor y una galería de cartas.

## 🛠️ Tecnologías

- **Backend:** Python 3.x + Flask
- **Frontend:** HTML5, CSS3, JavaScript
- **Servidor Web:** Nginx + Gunicorn
- **Hosting:** VPS Ubuntu (Digital Ocean)
- **CDN/SSL:** Cloudflare
- **Control de Versiones:** Git + GitHub

## 📁 Estructura del Proyecto

```
Welcome-Card-Wars-Kingdom/
├── app.py                          # Aplicación Flask principal
├── wsgi.py                         # WSGI entry point para Gunicorn
├── gunicorn_config.py              # Configuración de Gunicorn
├── requirements.txt                # Dependencias Python
├── static/                         # Archivos estáticos (CSS, JS, imágenes)
├── templates/                      # Plantillas HTML
│   ├── index.html                  # Página principal
│   ├── cards.html                  # Galería de cartas
│   ├── heroes.html                 # Página de héroes
│   ├── dungeon.html                # Página de dungeons
│   ├── pvpseason.html              # Página de PvP seasons
│   ├── status.html                 # Estado del servidor
│   └── download.html               # Página de descarga
├── resources/                      # Recursos estáticos
│   ├── Heroes/                     # Imágenes de héroes
│   └── dungeon/                    # Imágenes de dungeons
├── data/                           # Archivos de datos JSON
├── cwk_wiki/                       # Wiki de cartas
├── deploy/                         # Scripts de despliegue
│   ├── DEPLOYMENT_METHODS.md       # Documentación completa de deployment
│   ├── nginx-config                # Configuración de Nginx
│   ├── logs.sh                     # Script para ver logs
│   ├── status.sh                   # Script para verificar estado
│   ├── verify-hosts.sh             # Script de verificación completa
│   ├── sync-and-restart.sh         # Script de actualización
│   └── setup-ssl.sh                # Script para configurar SSL
└── README.md                       # Este archivo
```

## 🚀 Instalación Local (Desarrollo)

### Prerrequisitos

- Python 3.8 o superior
- pip (gestor de paquetes de Python)
- Git

### Pasos

1. **Clonar el repositorio:**
   ```bash
   git clone https://github.com/Lu2312/Welcome-Card-Wars-Kingdom.git
   cd Welcome-Card-Wars-Kingdom
   ```

2. **Crear entorno virtual:**
   ```bash
   python3 -m venv venv
   
   # Windows
   venv\Scripts\activate
   
   # Linux/Mac
   source venv/bin/activate
   ```

3. **Instalar dependencias:**
   ```bash
   pip install -r requirements.txt
   ```

4. **Ejecutar servidor de desarrollo:**
   ```bash
   python app.py
   ```
   
5. **Abrir en navegador:**
   ```
   http://localhost:8000
   ```

## 🖥️ Arquitectura del Servidor en Producción

### Configuración VPS

- **Sistema Operativo:** Ubuntu 24.04 LTS
- **IP:** 159.89.157.63
- **Dominio:** cardwars-kingdom.net
- **Puerto Interno:** 8000 (Gunicorn)
- **Puertos Externos:** 80 (HTTP), 443 (HTTPS)

### Stack de Servicios

```
Internet (HTTPS)
    ↓
Cloudflare (CDN + SSL + DDoS Protection)
    ↓
Nginx (Reverse Proxy) - Puerto 80/443
    ↓
Gunicorn (WSGI Server) - Puerto 8000
    ↓
Flask Application (Python)
```

### Flujo de Requests

1. **Usuario** accede a `https://cardwars-kingdom.net`
2. **Cloudflare** maneja SSL/TLS y cacheo
3. **Nginx** recibe la petición y hace proxy a Gunicorn
4. **Gunicorn** ejecuta la aplicación Flask
5. **Flask** procesa la ruta y retorna la respuesta
6. La respuesta viaja de vuelta: Flask → Gunicorn → Nginx → Cloudflare → Usuario

### Servicios Systemd

- **cardwars-kingdom-net.service** - Servicio principal de Gunicorn
- **nginx.service** - Servidor web Nginx

## 🔄 Actualizar el Servidor en Producción

### Método 1: Script Automático (Recomendado)

Conectarte al VPS y ejecutar el script de sincronización:

```bash
# SSH al servidor
ssh root@159.89.157.63

# Ejecutar script de actualización
cd /tmp/Welcome-Card-Wars-Kingdom
git pull origin main
sudo bash deploy/sync-and-restart.sh
```

El script automáticamente:
- ✅ Descarga los últimos cambios de GitHub
- ✅ Sincroniza archivos a producción
- ✅ Actualiza dependencias Python
- ✅ Recarga configuración de Nginx
- ✅ Reinicia el servicio
- ✅ Verifica que todo funciona

### Método 2: Manual

```bash
# 1. SSH al servidor
ssh root@159.89.157.63

# 2. Actualizar repositorio temporal
cd /tmp/Welcome-Card-Wars-Kingdom
git pull origin main

# 3. Sincronizar archivos
sudo rsync -av --exclude='.git' --exclude='venv' --exclude='__pycache__' \
    /tmp/Welcome-Card-Wars-Kingdom/ /var/www/cardwars-kingdom/

# 4. Actualizar dependencias (si hay cambios en requirements.txt)
cd /var/www/cardwars-kingdom
sudo -u www-data venv/bin/pip install -r requirements.txt

# 5. Reiniciar servicio
sudo systemctl restart cardwars-kingdom-net.service

# 6. Verificar estado
sudo systemctl status cardwars-kingdom-net.service
```

### Método 3: Solo Reiniciar Servicio

Si solo cambiaste código Python (sin nuevas dependencias ni configuración):

```bash
ssh root@159.89.157.63
sudo systemctl restart cardwars-kingdom-net.service
```

## 📊 Monitoreo y Logs

### Ver Estado del Servidor

```bash
# Verificación completa
sudo bash /var/www/cardwars-kingdom/deploy/verify-hosts.sh

# Estado del servicio
sudo systemctl status cardwars-kingdom-net.service

# Estado de Nginx
sudo systemctl status nginx
```

### Ver Logs

**Script interactivo de logs:**
```bash
sudo bash /var/www/cardwars-kingdom/deploy/logs.sh
```

Opciones:
1. Ver logs de systemd (últimas 50 líneas)
2. Ver logs de systemd (tiempo real)
3. Ver logs de Gunicorn (access)
4. Ver logs de Gunicorn (error)
5. Ver logs de Nginx (access)
6. Ver logs de Nginx (error)

**Comandos directos:**
```bash
# Logs del servicio en tiempo real
sudo journalctl -u cardwars-kingdom-net.service -f

# Últimas 50 líneas
sudo journalctl -u cardwars-kingdom-net.service -n 50

# Logs de Nginx
sudo tail -f /var/log/nginx/cardwars-kingdom-net-access.log
sudo tail -f /var/log/nginx/cardwars-kingdom-net-error.log

# Logs de Gunicorn
sudo tail -f /var/log/gunicorn/cardwars-kingdom-net-access.log
sudo tail -f /var/log/gunicorn/cardwars-kingdom-net-error.log
```

## 🔧 Comandos Útiles

### Gestión de Servicios

```bash
# Iniciar servicio
sudo systemctl start cardwars-kingdom-net.service

# Detener servicio
sudo systemctl stop cardwars-kingdom-net.service

# Reiniciar servicio
sudo systemctl restart cardwars-kingdom-net.service

# Recargar configuración (sin downtime)
sudo systemctl reload cardwars-kingdom-net.service

# Ver estado
sudo systemctl status cardwars-kingdom-net.service

# Habilitar inicio automático
sudo systemctl enable cardwars-kingdom-net.service
```

### Gestión de Nginx

```bash
# Probar configuración
sudo nginx -t

# Recargar configuración (sin downtime)
sudo systemctl reload nginx

# Reiniciar Nginx
sudo systemctl restart nginx

# Ver estado
sudo systemctl status nginx
```

### Verificación de Puertos

```bash
# Ver puertos en uso
sudo netstat -tlnp | grep -E ':(80|443|8000)'

# O con ss (más moderno)
sudo ss -tlnp | grep -E ':(80|443|8000)'

# Verificar conectividad local
curl http://localhost:8000
curl http://localhost
```

## 🐛 Troubleshooting

### Problema: Servicio no inicia

```bash
# Ver logs detallados
sudo journalctl -u cardwars-kingdom-net.service -xe

# Verificar permisos
sudo chown -R www-data:www-data /var/www/cardwars-kingdom

# Verificar que el puerto no esté en uso
sudo lsof -i :8000
```

### Problema: Error 502 Bad Gateway

```bash
# Verificar que Gunicorn está corriendo
ps aux | grep gunicorn

# Verificar logs
sudo journalctl -u cardwars-kingdom-net.service -n 50

# Reiniciar servicio
sudo systemctl restart cardwars-kingdom-net.service
```

### Problema: Error "Too Many Redirects"

Esto ocurre cuando hay conflicto entre Cloudflare y Nginx:

**Solución:**
1. Ve a Cloudflare Dashboard → `cardwars-kingdom.net`
2. SSL/TLS → Overview → Selecciona **"Flexible"**
3. Limpia caché del navegador (Ctrl+Shift+Delete)
4. Prueba en modo incógnito

### Problema: Cambios no se reflejan

```bash
# Limpiar caché de Cloudflare
# Ve a Cloudflare Dashboard → Caching → Purge Everything

# Reiniciar servicio
sudo systemctl restart cardwars-kingdom-net.service

# Verificar que los archivos se actualizaron
ls -la /var/www/cardwars-kingdom/

# Ver la fecha de último commit
cd /var/www/cardwars-kingdom
git log -1
```

### Problema: Error "would be overwritten by merge" al hacer git pull

Esto ocurre cuando hay archivos no rastreados (untracked) que entran en conflicto con archivos del repositorio.

**Solución:**

```bash
# Opción 1: Si los archivos untracked NO son importantes (borrarlos)
git clean -fd  # Borra archivos y carpetas untracked
git pull origin main

# Opción 2: Si los archivos untracked SON importantes (guardarlos)
git add .  # Agrega todos los archivos (incluyendo untracked)
git commit -m "Add local resources"
git pull origin main  # Ahora debería funcionar

# Opción 3: Si quieres mantenerlos separados temporalmente
mkdir ../backup-resources
mv resources/* ../backup-resources/  # Mueve los archivos
git pull origin main
mv ../backup-resources/* resources/  # Restaura después del pull
```

**¿Por qué ocurre?**
- Archivos locales no subidos a Git entran en conflicto con cambios del repositorio.
- Suele pasar con carpetas como `resources/` que contienen muchos archivos.

### 🚨 Problema: Archivos estáticos no cargan (CSS/JS)

**Síntomas:**
- El sitio web carga pero sin estilos
- Error 404 en archivos `/static/css/styles.css`
- Iconos y elementos visuales no se muestran

**Diagnóstico:**
```bash
# Verificar configuración de nginx
sudo nginx -t

# Verificar archivos estáticos existen
ls -la /var/www/cardwars-kingdom/static/

# Verificar permisos
ls -la /var/www/cardwars-kingdom/static/css/styles.css

# Probar acceso directo
curl -I http://localhost/static/css/styles.css
```

**Solución:**
```bash
# 1. Verificar ruta correcta en nginx
sudo nano /etc/nginx/sites-available/cardwars-kingdom-net
# Debe contener: alias /var/www/cardwars-kingdom/static;

# 2. Corregir permisos de archivos estáticos
sudo chmod -R 755 /var/www/cardwars-kingdom/static/

# 3. Verificar propietario correcto
sudo chown -R www-data:www-data /var/www/cardwars-kingdom/static/

# 4. Recargar nginx
sudo systemctl reload nginx
```

### 🚨 Problema: Servicio no inicia o falla constantemente

**Síntomas:**
- `systemctl status` muestra servicio como "failed"
- Error "WorkingDirectory not found"
- Servicio se reinicia constantemente

**Diagnóstico:**
```bash
# Ver logs detallados del servicio
sudo journalctl -u cardwars-kingdom-net.service -f

# Verificar configuración del servicio
sudo systemctl cat cardwars-kingdom-net.service

# Verificar directorio de trabajo
ls -la /var/www/cardwars-kingdom/
```

**Solución:**
```bash
# 1. Corregir rutas en servicio systemd
sudo nano /etc/systemd/system/cardwars-kingdom-net.service
# WorkingDirectory debe ser /var/www/cardwars-kingdom

# 2. Recargar configuración
sudo systemctl daemon-reload

# 3. Reiniciar servicio
sudo systemctl restart cardwars-kingdom-net.service

# 4. Verificar estado
sudo systemctl status cardwars-kingdom-net.service
```

### 🚨 Problema: Nginx configuration test failed

**Síntomas:**
- `nginx -t` muestra errores de sintaxis
- Nginx no se recarga/reinicia
- Sitio web no accesible

**Solución:**
```bash
# 1. Restaurar configuración desde backup
sudo cp /var/www/cardwars-kingdom/nginx/cardwars-kingdom.conf /etc/nginx/sites-available/cardwars-kingdom-net

# 2. Verificar configuración básica
cat > /etc/nginx/sites-available/cardwars-kingdom-net << 'EOF'
server {
    listen 80;
    server_name cardwars-kingdom.net www.cardwars-kingdom.net;
    
    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
    
    location /static {
        alias /var/www/cardwars-kingdom/static;
    }
}
EOF

# 3. Probar configuración
sudo nginx -t

# 4. Si es exitoso, recargar
sudo systemctl reload nginx
```

## 🔐 Seguridad

- ✅ HTTPS obligatorio (manejado por Cloudflare)
- ✅ Firewall UFW activo (puertos 22, 80, 443)
- ✅ Servicio corriendo como usuario `www-data` (no root)
- ✅ Cloudflare DDoS Protection activo
- ✅ Headers de seguridad configurados en Nginx

## 📝 API Endpoints

### Público

- `GET /` - Página principal
- `GET /cards` - Galería de cartas
- `GET /heroes` - Página de héroes
- `GET /dungeons` - Página de dungeons
- `GET /pvp-seasons` - Página de PvP seasons
- `GET /status` - Estado del servidor
- `GET /download` - Página de descarga
- `GET /spells` - Book of Spells / Action Cards (rendered page)
- `GET /api/health` - Health check del servicio
- `GET /api/latest-release` - Información de la última versión
- `GET /api/users/online` - Cantidad de usuarios online
- `GET /api/users/heartbeat` - Actualizar actividad del usuario
- `GET /api/spells/database` - Obtener JSON de action cards / spells (externo)

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 👤 Autor

**Luis Flores**
- GitHub: [@Lu2312](https://github.com/Lu2312)

## 🔗 Enlaces

- **Sitio Web:** [cardwars-kingdom.net](https://cardwars-kingdom.net)
- **Repositorio del Juego:** [Card Wars Kingdom Revived](https://github.com/Sgsysysgsgsg/Card-Wars-Kingdom-Revived)
- **Discord:** [Card Wars Kingdom Community](https://discord.gg/card-wars-revived-1227932764117143642)

## 📞 Soporte

Si tienes problemas con el despliegue o necesitas ayuda:

1. Revisa la sección de [Troubleshooting](#-troubleshooting)
2. Verifica los logs del servidor
3. Abre un issue en GitHub
4. Contacta al equipo de desarrollo

## 📄 Licencia

Este proyecto es parte de Card Wars Kingdom Revived.

---

**Última actualización:** Diciembre 2024

¡Disfruta explorando el mundo de Card Wars Kingdom!

