# Card Wars Kingdom - Welcome Site

Sitio web oficial de bienvenida para Card Wars Kingdom Revived - Un servidor privado del juego Card Wars Kingdom.

## 🌐 Sitio en Vivoenidoserror "would be overwritten by merge" en tu servidor al hacer `git pull`, ejecuta:

**URL:** [https://cardwars-kingdom.net](https://cardwars-kingdom.net)a-conflicto-de-git)
- [Sitio en Vivo](#-sitio-en-vivo)cd /var/www/cardwars-kingdom
## 📋 Descripción-descripción)/
- [Tecnologías](#-tecnologías)git commit -m "Add resources from server"
Este es el sitio web de bienvenida para Card Wars Kingdom, construido con Flask. Proporciona información sobre el juego, enlaces de descarga, estado del servidor y una galería de cartas.
- [Instalación Local](#-instalación-local)sudo bash deploy/sync-and-restart.sh
## 🛠️ Tecnologíasl Servidor](#-arquitectura-del-servidor-en-producción)
- [Actualizar el Servidor](#-actualizar-el-servidor-en-producción)
- **Backend:** Python 3.x + Flasky-logs)ualizará tu servidor.
- **Frontend:** HTML5, CSS3, JavaScript
- **Servidor Web:** Nginx + Gunicorng)
- **Hosting:** VPS Ubuntu (Digital Ocean)
- **CDN/SSL:** Cloudflare
- **Control de Versiones:** Git + GitHub
- [Enlaces](#-enlaces)**URL:** [https://cardwars-kingdom.net](https://cardwars-kingdom.net)
## 📁 Estructura del Proyectoints)
- [Consejos para Despliegue](#-consejos-para-despliegue)## 📋 Descripción
```Resumen de Cambios Recientes](#-resumen-de-cambios-recientes)
Welcome-Card-Wars-Kingdom/ngdom, construido con Flask. Proporciona información sobre el juego, enlaces de descarga, estado del servidor y una galería de cartas.
├── app.py                          # Aplicación Flask principal
├── wsgi.py                         # WSGI entry point para Gunicorn
├── gunicorn_config.py              # Configuración de Gunicornm.net)
├── requirements.txt                # Dependencias Python
├── static/                         # Archivos estáticos (CSS, JS, imágenes)
├── templates/                      # Plantillas HTML
│   ├── index.html                  # Página principaldom, construido con Flask. Proporciona información sobre el juego, enlaces de descarga, estado del servidor y una galería de cartas.
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
```atic/                         # Archivos estáticos (CSS, JS, imágenes)
```├── templates/                      # Plantillas HTML
## 🚀 Instalación Local (Desarrollo)rincipal
├── app.py                          # Aplicación Flask principal│   ├── cards.html                  # Galería de cartas
### Prerrequisitos                  # WSGI entry point para Gunicornl                 # Estado del servidor
├── gunicorn_config.py              # Configuración de Gunicorn│   └── download.html               # Página de descarga
- Python 3.8 o superior             # Dependencias Python             # Scripts de despliegue
- pip (gestor de paquetes de Python)# Archivos estáticos (CSS, JS, imágenes)# Configuración de Nginx
- Gitemplates/                      # Plantillas HTML── logs.sh                     # Script para ver logs
│   ├── index.html                  # Página principal│   ├── status.sh                   # Script para verificar estado
### Pasosards.html                  # Galería de cartaserify-hosts.sh             # Script de verificación completa
│   ├── status.html                 # Estado del servidor│   ├── sync-and-restart.sh         # Script de actualización
1. **Clonar el repositorio:**       # Página de descarga       # Script para configurar SSL
   ```bash/                         # Scripts de despliegue.md                       # Este archivo
   git clone https://github.com/Lu2312/Welcome-Card-Wars-Kingdom.git
   cd Welcome-Card-Wars-Kingdom     # Script para ver logs
   ```─ status.sh                   # Script para verificar estadoInstalación Local (Desarrollo)
│   ├── verify-hosts.sh             # Script de verificación completa
2. **Crear entorno virtual:**       # Script de actualización
   ```bashtup-ssl.sh                # Script para configurar SSL
   python3 -m venv venv             # Este archivo
   ip (gestor de paquetes de Python)
   # Windows
   venv\Scripts\activate(Desarrollo)
   sos
   # Linux/Macitos
   source venv/bin/activate
   ```on 3.8 o superiorbash
- pip (gestor de paquetes de Python)   git clone https://github.com/Lu2312/Welcome-Card-Wars-Kingdom.git
3. **Instalar dependencias:**
   ```bash
   pip install -r requirements.txt
   ```ntorno virtual:**
1. **Clonar el repositorio:**   ```bash
4. **Ejecutar servidor de desarrollo:**
   ```bashne https://github.com/Lu2312/Welcome-Card-Wars-Kingdom.git
   python app.pyrd-Wars-Kingdom
   ```v\Scripts\activate
   
5. **Abrir en navegador:**:**
   ```bashrce venv/bin/activate
   http://localhost:8000
   ```
   # Windows3. **Instalar dependencias:**
## 🖥️ Arquitectura del Servidor en Producción
      pip install -r requirements.txt
### Configuración VPS
   source venv/bin/activate
- **Sistema Operativo:** Ubuntu 24.04 LTS
- **IP:** 159.89.157.63
- **Dominio:** cardwars-kingdom.net
- **Puerto Interno:** 8000 (Gunicorn)
- **Puertos Externos:** 80 (HTTP), 443 (HTTPS)
   ```5. **Abrir en navegador:**
### Stack de Servicios
4. **Ejecutar servidor de desarrollo:**   http://localhost:8000
``````bash```
Internet (HTTPS)
    ↓`️ Arquitectura del Servidor en Producción
Cloudflare (CDN + SSL + DDoS Protection)
    ↓Abrir en navegador:**onfiguración VPS
Nginx (Reverse Proxy) - Puerto 80/443
    ↓tp://localhost:8000istema Operativo:** Ubuntu 24.04 LTS
Gunicorn (WSGI Server) - Puerto 8000
    ↓o:** cardwars-kingdom.net
Flask Application (Python)rvidor en Producción (Gunicorn)
```ertos Externos:** 80 (HTTP), 443 (HTTPS)
### Configuración VPS
### Flujo de Requests
- **Sistema Operativo:** Ubuntu 24.04 LTS
1. **Usuario** accede a `https://cardwars-kingdom.net`
2. **Cloudflare** maneja SSL/TLS y cacheo
3. **Nginx** recibe la petición y hace proxy a Gunicorn
4. **Gunicorn** ejecuta la aplicación FlaskPS)
5. **Flask** procesa la ruta y retorna la respuesta
6. La respuesta viaja de vuelta: Flask → Gunicorn → Nginx → Cloudflare → Usuario
    ↓
### Servicios Systemd
Internet (HTTPS)    ↓
- **cardwars-kingdom-net.service** - Servicio principal de Gunicorn
- **nginx.service** - Servidor web Nginx
    ↓
## 🔄 Actualizar el Servidor en Producción
    ↓
### Método 1: Script Automático (Recomendado)
    ↓2. **Cloudflare** maneja SSL/TLS y cacheo
Conectarte al VPS y ejecutar el script de sincronización:
```4. **Gunicorn** ejecuta la aplicación Flask
```bashrocesa la ruta y retorna la respuesta
# SSH al servidorestsiaja de vuelta: Flask → Gunicorn → Nginx → Cloudflare → Usuario
ssh root@159.89.157.63
1. **Usuario** accede a `https://cardwars-kingdom.net`### Servicios Systemd
# Ejecutar script de actualización cacheoautomáticamente)
cd /tmp/Welcome-Card-Wars-Kingdom hace proxy a Gunicorn* - Servicio principal de Gunicorn
git pull origin mainuta la aplicación Flask- Servidor web Nginx
sudo bash deploy/sync-and-restart.shna la respuesta
```La respuesta viaja de vuelta: Flask → Gunicorn → Nginx → Cloudflare → Usuario🔄 Actualizar el Servidor en Producción

El script automáticamente: (Recomendado)
- ✅ Descarga los últimos cambios de GitHub
- ✅ Sincroniza archivos a producción Servicio principal de Gunicornpt de sincronización:GitHubGitHub
- ✅ Actualiza dependencias Pythonb Nginx
- ✅ Recarga configuración de Nginx
- ✅ Reinicia el servicioidor en Produccióninxn de Nginx
- ✅ Verifica que todo funciona
### Método 1: Script Automático (Recomendado)- ✅ Verifica que todo funciona- ✅ Verifica que todo funciona
### Método 2: Manualtallado y manejo de errores
Conectarte al VPS y ejecutar el script de sincronización:cd /tmp/Welcome-Card-Wars-Kingdom### Método 2: Manual
```bashn mainodo 2: Manual
# 1. SSH al servidor.sh
ssh root@159.89.157.63
ssh root@159.89.157.63# 1. SSH al servidorssh root@159.89.157.63
# 2. Actualizar repositorio temporal
cd /tmp/Welcome-Card-Wars-Kingdomnde GitHub
git pull origin main-Wars-Kingdomvos a producciónsitorio temporal-Wars-Kingdom
git pull origin main- ✅ Actualiza dependencias Pythoncd /tmp/Welcome-Card-Wars-Kingdomgit pull origin main
# 3. Sincronizar archivos-restart.sh de Nginx
sudo rsync -av --exclude='.git' --exclude='venv' --exclude='__pycache__' \
    /tmp/Welcome-Card-Wars-Kingdom/ /var/www/cardwars-kingdom/
El script automáticamente:sudo rsync -av --exclude='.git' --exclude='venv' --exclude='__pycache__' \    /tmp/Welcome-Card-Wars-Kingdom/ /var/www/cardwars-kingdom/
# 4. Actualizar dependencias (si hay cambios en requirements.txt)
cd /var/www/cardwars-kingdomoducción
sudo -u www-data venv/bin/pip install -r requirements.txt
- ✅ Recarga configuración de Nginx# 1. SSH al servidorcd /var/www/cardwars-kingdomsudo -u www-data venv/bin/pip install -r requirements.txt
# 5. Reiniciar servicioon/pip install -r requirements.txt
sudo systemctl restart cardwars-kingdom-net.service
# 2. Actualizar repositorio temporal# 5. Reiniciar serviciosudo systemctl restart cardwars-kingdom-net.service
# 6. Verificar estadoars-Kingdomt cardwars-kingdom-net.service
sudo systemctl status cardwars-kingdom-net.service
```basherificar estadoo systemctl status cardwars-kingdom-net.service
# 1. SSH al servidor# 3. Sincronizar archivossudo systemctl status cardwars-kingdom-net.service```
### Método 3: Solo Reiniciar Servicioxclude='__pycache__' \
    /tmp/Welcome-Card-Wars-Kingdom/ /var/www/cardwars-kingdom/### Método 3: Solo Reiniciar Servicio
Si solo cambiaste código Python (sin nuevas dependencias ni configuración):
cd /tmp/Welcome-Card-Wars-Kingdom# 4. Actualizar dependencias (si hay cambios en requirements.txt)Si solo cambiaste código Python (sin nuevas dependencias ni configuración):
```bashl origin main/www/cardwars-kingdom cambiaste código Python (sin nuevas dependencias ni configuración):
ssh root@159.89.157.63uirements.txt
sudo systemctl restart cardwars-kingdom-net.service
```o rsync -av --exclude='.git' --exclude='venv' --exclude='__pycache__' \. Reiniciar servicio root@159.89.157.63o systemctl restart cardwars-kingdom-net.service
    /tmp/Welcome-Card-Wars-Kingdom/ /var/www/cardwars-kingdom/sudo systemctl restart cardwars-kingdom-net.servicesudo systemctl restart cardwars-kingdom-net.service```
## 📊 Monitoreo y Logs
# 4. Actualizar dependencias (si hay cambios en requirements.txt)# 6. Verificar estado## 📊 Monitoreo y Logs
### Ver Estado del Servidormars-kingdom-net.service
sudo -u www-data venv/bin/pip install -r requirements.txt```### Ver Estado del Servidor
```bashrvidor
# Verificación completaiciar Servicio
sudo bash /var/www/cardwars-kingdom/deploy/verify-hosts.sh
Si solo cambiaste código Python (sin nuevas dependencias ni configuración):# Verificación completasudo bash /var/www/cardwars-kingdom/deploy/verify-hosts.sh
# Estado del servicio/verify-hosts.sh
sudo systemctl status cardwars-kingdom-net.service
```ssh root@159.89.157.63# Estado del serviciosudo systemctl status cardwars-kingdom-net.service
# Estado de Nginxngdom-net.serviceatus cardwars-kingdom-net.service
sudo systemctl status nginxr Servicio
```de Nginxo systemctl status nginx
Si solo cambiaste código Python (sin nuevas dependencias ni configuración):## 📊 Monitoreo y Logssudo systemctl status nginx```
### Ver Logs
```bash### Ver Estado del Servidor### Ver Logs
**Script interactivo de logs:**
```bashstemctl restart cardwars-kingdom-net.serviceactivo de logs:**
sudo bash /var/www/cardwars-kingdom/deploy/logs.sh
```ash /var/www/cardwars-kingdom/deploy/verify-hosts.shbasho bash /var/www/cardwars-kingdom/deploy/logs.sh
## 📊 Monitoreo y Logssudo bash /var/www/cardwars-kingdom/deploy/logs.sh```
Opciones:cio
1. Ver logs de systemd (últimas 50 líneas)
2. Ver logs de systemd (tiempo real)
3. Ver logs de Gunicorn (access)
4. Ver logs de Gunicorn (error)
5. Ver logs de Nginx (access)ingdom/deploy/verify-hosts.sh
6. Ver logs de Nginx (error)
# Estado del servicio### Ver Logs5. Ver logs de Nginx (access)6. Ver logs de Nginx (error)
**Comandos directos:**cardwars-kingdom-net.service
```bashactivo de logs:**ectos:**
# Logs del servicio en tiempo real
sudo journalctl -u cardwars-kingdom-net.service -f
``````# Logs del servicio en tiempo realsudo journalctl -u cardwars-kingdom-net.service -f
# Últimas 50 líneas
sudo journalctl -u cardwars-kingdom-net.service -n 50
1. Ver logs de systemd (últimas 50 líneas)# Últimas 50 líneassudo journalctl -u cardwars-kingdom-net.service -n 50
# Logs de Nginxctivo de logs:**systemd (tiempo real) -u cardwars-kingdom-net.service -n 50
sudo tail -f /var/log/nginx/cardwars-kingdom-net-access.log
sudo tail -f /var/log/nginx/cardwars-kingdom-net-error.log
```5. Ver logs de Nginx (access)sudo tail -f /var/log/nginx/cardwars-kingdom-net-access.logsudo tail -f /var/log/nginx/cardwars-kingdom-net-error.log
# Logs de Gunicornx/cardwars-kingdom-net-error.log
sudo tail -f /var/log/gunicorn/cardwars-kingdom-net-access.log
sudo tail -f /var/log/gunicorn/cardwars-kingdom-net-error.log
```Ver logs de systemd (tiempo real)basho tail -f /var/log/gunicorn/cardwars-kingdom-net-access.logo tail -f /var/log/gunicorn/cardwars-kingdom-net-error.log
3. Ver logs de Gunicorn (access)# Logs del servicio en tiempo realsudo tail -f /var/log/gunicorn/cardwars-kingdom-net-error.log```
## 🔧 Comandos Útilesrn (error)rdwars-kingdom-net.service -f
5. Ver logs de Nginx (access)## 🔧 Comandos Útiles
### Gestión de Serviciosror)
sudo journalctl -u cardwars-kingdom-net.service -n 50### Gestión de Servicios
```bashdos directos:** Servicios
# Iniciar servicio
sudo systemctl start cardwars-kingdom-net.service
sudo journalctl -u cardwars-kingdom-net.service -fsudo tail -f /var/log/nginx/cardwars-kingdom-net-error.log# Iniciar serviciosudo systemctl start cardwars-kingdom-net.service
# Detener servicio
sudo systemctl stop cardwars-kingdom-net.service
sudo journalctl -u cardwars-kingdom-net.service -n 50sudo tail -f /var/log/gunicorn/cardwars-kingdom-net-access.log# Detener serviciosudo systemctl stop cardwars-kingdom-net.service
# Reiniciar serviciokingdom-net-error.logcardwars-kingdom-net.service
sudo systemctl restart cardwars-kingdom-net.service
sudo tail -f /var/log/nginx/cardwars-kingdom-net-access.log# Reiniciar serviciosudo systemctl restart cardwars-kingdom-net.service
# Recargar configuración (sin downtime)ngdom-net-error.log
sudo systemctl reload cardwars-kingdom-net.service
# Logs de Gunicorn### Gestión de Servicios# Recargar configuración (sin downtime)sudo systemctl reload cardwars-kingdom-net.service
# Ver estado /var/log/gunicorn/cardwars-kingdom-net-access.logrdwars-kingdom-net.service
sudo systemctl status cardwars-kingdom-net.servicet-error.log
```# Iniciar servicio# Ver estadosudo systemctl status cardwars-kingdom-net.service
# Habilitar inicio automático-net.service
sudo systemctl enable cardwars-kingdom-net.service
```ner servicioabilitar inicio automáticoo systemctl enable cardwars-kingdom-net.service
### Gestión de Serviciossudo systemctl stop cardwars-kingdom-net.servicesudo systemctl enable cardwars-kingdom-net.service```
### Gestión de Nginx
```bash# Reiniciar servicio### Gestión de Nginx
```bashar serviciostemctl restart cardwars-kingdom-net.servicetión de Nginx
# Probar configuraciónardwars-kingdom-net.service
sudo nginx -tsin downtime)ión
# Detener serviciosudo systemctl reload cardwars-kingdom-net.service# Probar configuraciónsudo nginx -t
# Recargar configuración (sin downtime)t.service
sudo systemctl reload nginx
# Reiniciar serviciosudo systemctl status cardwars-kingdom-net.service# Recargar configuración (sin downtime)sudo systemctl reload nginx
# Reiniciar Nginxstart cardwars-kingdom-net.service
sudo systemctl restart nginx
# Recargar configuración (sin downtime)sudo systemctl enable cardwars-kingdom-net.service# Reiniciar Nginxsudo systemctl restart nginx
# Ver estadotl reload cardwars-kingdom-net.servicet nginx
sudo systemctl status nginx
```er estado Gestión de Nginxer estadoo systemctl status nginx
sudo systemctl status cardwars-kingdom-net.servicesudo systemctl status nginx```
### Verificación de Puertos
# Habilitar inicio automático# Probar configuración### Verificación de Puertos
```bashstemctl enable cardwars-kingdom-net.serviceinx -tificación de Puertos
# Ver puertos en uso
sudo netstat -tlnp | grep -E ':(80|443|8000)'
### Gestión de Nginxsudo systemctl reload nginx# Ver puertos en usosudo netstat -tlnp | grep -E ':(80|443|8000)'
# O con ss (más moderno)
sudo ss -tlnp | grep -E ':(80|443|8000)'
# Probar configuraciónsudo systemctl restart nginx# O con ss (más moderno)sudo ss -tlnp | grep -E ':(80|443|8000)'
# Verificar conectividad local
curl http://localhost:8000
curl http://localhostión (sin downtime) nginxdad local:8000
```o systemctl reload nginxl http://localhost:8000l http://localhost
curl http://localhost```
## 🐛 Troubleshootingos
sudo systemctl restart nginx## 🐛 Troubleshooting
### Problema: Servicio no inicia
# Ver estado# Ver puertos en uso### Problema: Servicio no inicia
```bashstemctl status nginxtstat -tlnp | grep -E ':(80|443|8000)'blema: Servicio no inicia
# Ver logs detallados
sudo journalctl -u cardwars-kingdom-net.service -xe
### Verificación de Puertossudo ss -tlnp | grep -E ':(80|443|8000)'# Ver logs detalladossudo journalctl -u cardwars-kingdom-net.service -xe
# Verificar permisos
sudo chown -R www-data:www-data /var/www/cardwars-kingdom
# Ver puertos en usocurl http://localhost:8000# Verificar permisossudo chown -R www-data:www-data /var/www/cardwars-kingdom
# Verificar que el puerto no esté en uso000)'
sudo lsof -i :8000
``` con ss (más moderno)ficar que el puerto no esté en usoo lsof -i :8000
sudo ss -tlnp | grep -E ':(80|443|8000)'## 🐛 Troubleshootingsudo lsof -i :8000```
### Problema: Error 502 Bad Gateway
# Verificar conectividad local### Problema: Servicio no inicia### Problema: Error 502 Bad Gateway
```bashtp://localhost:8000Error 502 Bad Gateway
# Verificar que Gunicorn está corriendo
ps aux | grep gunicorn
sudo journalctl -u cardwars-kingdom-net.service -xe# Verificar que Gunicorn está corriendops aux | grep gunicorn
# Verificar logsoting
sudo journalctl -u cardwars-kingdom-net.service -n 50
### Problema: Servicio no iniciasudo chown -R www-data:www-data /var/www/cardwars-kingdom# Verificar logssudo journalctl -u cardwars-kingdom-net.service -n 50
# Reiniciar servicio
sudo systemctl restart cardwars-kingdom-net.service
```er logs detalladoso lsof -i :8000einiciar servicioo systemctl restart cardwars-kingdom-net.service
sudo journalctl -u cardwars-kingdom-net.service -xe```sudo systemctl restart cardwars-kingdom-net.service```
### Problema: Error "Too Many Redirects"
# Verificar permisos### Problema: Error 502 Bad Gateway### Problema: Error "Too Many Redirects"
Esto ocurre cuando hay conflicto entre Cloudflare y Nginx:
```bashEsto ocurre cuando hay conflicto entre Cloudflare y Nginx:
**Solución:**ue el puerto no esté en usoue Gunicorn está corriendouando hay conflicto entre Cloudflare y Nginx:
1. Ve a Cloudflare Dashboard → `cardwars-kingdom.net`
2. SSL/TLS → Overview → Selecciona **"Flexible"**
3. Limpia caché del navegador (Ctrl+Shift+Delete)
4. Prueba en modo incógnito Gateway-kingdom-net.service -n 50ecciona **"Flexible"**or (Ctrl+Shift+Delete)
3. Limpia caché del navegador (Ctrl+Shift+Delete)4. Prueba en modo incógnito
### Problema: Cambios no se reflejan
# Verificar que Gunicorn está corriendosudo systemctl restart cardwars-kingdom-net.service### Problema: Cambios no se reflejan
```bash| grep gunicorna: Cambios no se reflejan
# Limpiar caché de Cloudflare
# Ve a Cloudflare Dashboard → Caching → Purge Everything
sudo journalctl -u cardwars-kingdom-net.service -n 50# Limpiar caché de Cloudflare# Ve a Cloudflare Dashboard → Caching → Purge Everything
# Reiniciar servicioloudflare y Nginx:shboard → Caching → Purge Everything
sudo systemctl restart cardwars-kingdom-net.service
sudo systemctl restart cardwars-kingdom-net.service**Solución:**# Reiniciar serviciosudo systemctl restart cardwars-kingdom-net.service
# Verificar que los archivos se actualizaron
ls -la /var/www/cardwars-kingdom/
### Problema: Error "Too Many Redirects"3. Limpia caché del navegador (Ctrl+Shift+Delete)# Verificar que los archivos se actualizaronls -la /var/www/cardwars-kingdom/
# Ver la fecha de último commit
cd /var/www/cardwars-kingdomicto entre Cloudflare y Nginx:
git log -1s no se reflejanecha de último commitw/cardwars-kingdom
```olución:**r/www/cardwars-kingdom log -1
1. Ve a Cloudflare Dashboard → `cardwars-kingdom.net````bashgit log -1```
### Problema: Error "would be overwritten by merge" al hacer git pull
3. Limpia caché del navegador (Ctrl+Shift+Delete)# Ve a Cloudflare Dashboard → Caching → Purge Everything## 🔐 Seguridad
Esto ocurre cuando hay archivos no rastreados (untracked) que entran en conflicto con archivos del repositorio.
# Reiniciar servicio- ✅ HTTPS obligatorio (manejado por Cloudflare)
**Solución:** Cambios no se reflejanl restart cardwars-kingdom-net.serviceuando hay archivos no rastreados (untracked) que entran en conflicto con archivos del repositorio.UFW activo (puertos 22, 80, 443)
- ✅ Servicio corriendo como usuario `www-data` (no root)
```bashicar que los archivos se actualizaronión:**udflare DDoS Protection activo
# Opción 1: Si los archivos untracked NO son importantes (borrarlos)
git clean -fd  # Borra archivos y carpetas untrackedhing
git pull origin mainntracked NO son importantes (borrarlos)it pull origin main
# Reiniciar serviciocd /var/www/cardwars-kingdomgit clean -fd  # Borra archivos y carpetas untracked
# Opción 2: Si los archivos untracked SON importantes (guardarlos)
git add .  # Agrega todos los archivos (incluyendo untracked)
git commit -m "Add local resources"ualizaron
git pull origin main  # Ahora debería funcionargit pullndo untracked)
git commit -m "Add local resources"- `GET /status` - Estado del servidor
# Opción 3: Si quieres mantenerlos separados temporalmente archivos del repositorio.
mkdir ../backup-resourcesdom
mv resources/* ../backup-resources/  # Mueve los archivos
git pull origin mainine
mv ../backup-resources/* resources/  # Restaura después del pull
``` Problema: Error "would be overwritten by merge" al hacer git pullpción 1: Si los archivos untracked NO son importantes (borrarlos) pull origin main
git clean -fd  # Borra archivos y carpetas untrackedmv ../backup-resources/* resources/  # Restaura después del pull## 🤝 Contribuir
**¿Por qué ocurre?**ay archivos no rastreados (untracked) que entran en conflicto con archivos del repositorio.
- Archivos locales no subidos a Git entran en conflicto con cambios del repositorio.
- Suele pasar con carpetas como `resources/` que contienen muchos archivos.
git add .  # Agrega todos los archivos (incluyendo untracked)- Archivos locales no subidos a Git entran en conflicto con cambios del repositorio.3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
## 🔐 Seguridadl resources"da para el problema actual:**on carpetas como `resources/` que contienen muchos archivos.ma (`git push origin feature/AmazingFeature`)
# Opción 1: Si los archivos untracked NO son importantes (borrarlos)git pull origin main  # Ahora debería funcionar5. Abre un Pull Request
- ✅ HTTPS obligatorio (manejado por Cloudflare)acked
- ✅ Firewall UFW activo (puertos 22, 80, 443)
- ✅ Servicio corriendo como usuario `www-data` (no root)
- ✅ Cloudflare DDoS Protection activo SON importantes (guardarlos)# Mueve los archivosved.- ✅ Cloudflare DDoS Protection activo
- ✅ Headers de seguridad configurados en Nginxendo untracked)
git commit -m "Add local resources"mv ../backup-resources/* resources/  # Restaura después del pullgit pull origin main- ✅ Cloudflare DDoS Protection activo## 👤 Autor
## 📝 API Endpointsn  # Ahora debería funcionarhridad configurados en Nginx
```**Luis Flores**
### Público Si quieres mantenerlos separados temporalmenteocurre?**2312](https://github.com/Lu2312)### Público
mkdir ../backup-resources- Archivos locales no subidos a Git entran en conflicto con cambios del repositorio.## 🔐 Seguridad
- `GET /` - Página principalources/  # Mueve los archivosomo `resources/` que contienen muchos archivos.
- `GET /cards` - Galería de cartas
- `GET /status` - Estado del servidor# Restaura después del pull
- `GET /download` - Página de descarga
- `GET /api/health` - Health check del servicio
- `GET /api/latest-release` - Información de la última versión
- `GET /api/users/online` - Cantidad de usuarios online con cambios del repositorio.)
- `GET /api/users/heartbeat` - Actualizar actividad del usuarioos archivos.
- ✅ Headers de seguridad configurados en Nginx- `GET /api/users/online` - Cantidad de usuarios onlineSi tienes problemas con el despliegue o necesitas ayuda:
## 🤝 Contribuirzar actividad del usuario
## 📝 API Endpoints1. Revisa la sección de [Troubleshooting](#-troubleshooting)
1. Fork el proyectoio (manejado por Cloudflare)r
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Requestd configurados en Nginxa de cartasealth check del servicio`git commit -m 'Add some AmazingFeature'`)est
- `GET /status` - Estado del servidor- `GET /api/latest-release` - Información de la última versión4. Push a la rama (`git push origin feature/AmazingFeature`)
## 📄 Licenciaointsad` - Página de descargaers/online` - Cantidad de usuarios onlinel Requestlización:** Noviembre 2024## 📄 Licencia
- `GET /api/health` - Health check del servicio- `GET /api/users/heartbeat` - Actualizar actividad del usuario
Este proyecto es parte de Card Wars Kingdom Revived.
- `GET /api/users/online` - Cantidad de usuarios online## 🤝 ContribuirEste proyecto es parte de Card Wars Kingdom Revived.
## 👤 Autor Página principal/users/heartbeat` - Actualizar actividad del usuario de Card Wars Kingdom Revived.
- `GET /cards` - Galería de cartas1. Fork el proyecto## 👤 Autor
**Luis Flores** - Estado del servidorra para tu feature (`git checkout -b feature/AmazingFeature`)
- GitHub: [@Lu2312](https://github.com/Lu2312)
- `GET /api/health` - Health check del servicio1. Fork el proyecto4. Push a la rama (`git push origin feature/AmazingFeature`)**Luis Flores**- GitHub: [@Lu2312](https://github.com/Lu2312)
## 📞 Contactoatest-release` - Información de la última versiónama para tu feature (`git checkout -b feature/AmazingFeature`)ll Requestu2312](https://github.com/Lu2312)
- `GET /api/users/online` - Cantidad de usuarios online3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)## 🔗 Enlaces
- **GitHub:** [Lu2312](https://github.com/Lu2312)ctividad del usuario/AmazingFeature`)
- **Discord:** [Card Wars Kingdom](https://discord.gg/card-wars-revived-1227932764117143642)
- **Sitio Web:** [cardwars-kingdom.net](https://cardwars-kingdom.net)
## 📄 Licencia- [Repositorio del Juego](https://github.com/Sgsysysgsgsg/Card-Wars-Kingdom-Revived)- [Discord Community](https://discord.gg/cardwars) *(si aplica)*
---oyecto//discord.gg/cardwars) *(si aplica)*
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)Este proyecto es parte de Card Wars Kingdom Revived.## 📞 Soporte
¡Disfruta explorando el mundo de Card Wars Kingdom!eature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)## 👤 Autor- GitHub: [@Lu2312](https://github.com/Lu2312)Si tienes problemas con el despliegue o necesitas ayuda:























**Última actualización:** Noviembre 2024---4. Contacta al equipo de desarrollo3. Abre un issue en GitHub2. Verifica los logs del servidor1. Revisa la sección de [Troubleshooting](#-troubleshooting)Si tienes problemas con el despliegue o necesitas ayuda:## 📞 Soporte- [Discord Community](https://discord.gg/cardwars) *(si aplica)*- [Repositorio del Juego](https://github.com/Sgsysysgsgsg/Card-Wars-Kingdom-Revived)- [Sitio Web](https://cardwars-kingdom.net)## 🔗 Enlaces











**Última actualización:** Noviembre 2024---¡Tu sitio Card Wars Kingdom debería estar funcionando perfectamente!- **Backup regular:** Aunque Git maneja versiones, mantén backups importantes













**Última actualización:** Noviembre 2024---4. Contacta al equipo de desarrollo3. Abre un issue en GitHub2. Verifica los logs del servidor1. Revisa la sección de [Troubleshooting](#-troubleshooting)Si tienes problemas con el despliegue o necesitas ayuda:## 📞 Soporte






**Última actualización:** Noviembre 2024- ✅ **Manejo de errores:** Detección automática de problemas durante despliegue- ✅ **Logging detallado:** Mejor seguimiento del proceso de actualización- ✅ **Documentación de troubleshooting:** Soluciones para conflictos de Git



**Nota:** Los scripts de despliegue han sido actualizados para manejar automáticamente conflictos con archivos untracked.










**Última actualización:** Noviembre 2024---4. Contacta al equipo de desarrollo3. Abre un issue en GitHub2. Verifica los logs del servidor1. Revisa la sección de [Troubleshooting](#-troubleshooting)

