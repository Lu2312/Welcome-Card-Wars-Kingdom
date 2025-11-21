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
│   ├── status.html                 # Estado del servidor
│   └── download.html               # Página de descarga
├── deploy/                         # Scripts de despliegue
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
   python -m venv venv
   
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
- `GET /status` - Estado del servidor
- `GET /download` - Página de descarga
- `GET /api/health` - Health check del servicio
- `GET /api/latest-release` - Información de la última versión
- `GET /api/users/online` - Cantidad de usuarios online
- `GET /api/users/heartbeat` - Actualizar actividad del usuario

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto es parte de Card Wars Kingdom Revived.

## 👤 Autor

**Luis Flores**
- GitHub: [@Lu2312](https://github.com/Lu2312)

## 🔗 Enlaces

- [Sitio Web](https://cardwars-kingdom.net)
- [Repositorio del Juego](https://github.com/Sgsysysgsgsg/Card-Wars-Kingdom-Revived)
- [Discord Community](https://discord.gg/cardwars) *(si aplica)*

## 📞 Soporte

Si tienes problemas con el despliegue o necesitas ayuda:

1. Revisa la sección de [Troubleshooting](#-troubleshooting)
2. Verifica los logs del servidor
3. Abre un issue en GitHub
4. Contacta al equipo de desarrollo

---

**Última actualización:** Noviembre 2024

