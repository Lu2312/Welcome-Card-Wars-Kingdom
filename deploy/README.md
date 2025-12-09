# Scripts de Despliegue - Card Wars Kingdom

Scripts automatizados para configurar y mantener el servidor en VPS.

## 📋 Scripts Disponibles

### 1. `setup-vps.sh` - Instalación Inicial

Configura todo el servidor desde cero.

**Uso:**
```bash
# En el servidor VPS
wget https://raw.githubusercontent.com/Lu2312/Welcome-Card-Wars-Kingdom/main/deploy/setup-vps.sh
chmod +x setup-vps.sh
sudo ./setup-vps.sh
```

**Qué hace:**
- Actualiza el sistema
- Instala dependencias (Python, Nginx, Git, etc.)
- Clona el repositorio
- Crea entorno virtual e instala paquetes Python
- Configura Gunicorn
- Crea servicio systemd
- Configura Nginx
- Configura firewall
- Inicia servicios

### 2. `update-vps.sh` - Actualizar Proyecto

Actualiza el código del proyecto desde GitHub.

**Uso:**
```bash
cd /var/www/cardwars-kingdom.net
sudo ./deploy/update-vps.sh
```

**Qué hace:**
- Crea backup del proyecto actual
- Pull cambios de GitHub
- Actualiza dependencias Python
- Reinicia servicio
- Verifica que funcione

### 2.1. `clean-deploy.sh` - Despliegue Limpio (NUEVO)

Realiza un despliegue completamente limpio con git clone fresco.

**Uso:**
```bash
# Desde tu PC local
./deploy/clean-deploy.sh
```

**Qué hace:**
- Para el servicio actual
- Hace backup del directorio existente
- Clona repositorio fresco desde GitHub
- Configura entorno virtual limpio
- Instala dependencias
- Establece permisos correctos
- Inicia servicio
- Verifica funcionamiento

### 2.2. `sync-verify.sh` - Verificar Sincronización (NUEVO)

Compara archivos entre local y VPS para verificar sincronización.

**Uso:**
```bash
# Desde tu PC local
./deploy/sync-verify.sh
```

**Qué hace:**
- Compara checksums de archivos importantes
- Verifica estado del servicio
- Comprueba commits de git
- Proporciona recomendaciones de sincronización

### 3. `check-status.sh` - Verificar Estado

Muestra el estado completo del servidor.

**Uso:**
```bash
cd /var/www/cardwars-kingdom.net
./deploy/check-status.sh
```

**Muestra:**
- Estado de servicios systemd
- Puertos escuchando
- Endpoints funcionando
- Procesos corriendo
- Uso de disco y memoria
- Errores recientes

### 4. `logs.sh` - Ver Logs

Ver logs de diferentes servicios.

**Uso:**
```bash
cd /var/www/cardwars-kingdom.net
./deploy/logs.sh
```

**Opciones:**
1. Logs de systemd (últimas 50 líneas)
2. Logs de systemd (tiempo real)
3. Logs de Gunicorn access
4. Logs de Gunicorn error
5. Logs de Nginx access
6. Logs de Nginx error

## 🚀 Instalación Rápida

### Opción 1: Despliegue Limpio con Git Clone (Recomendado)

```bash
# Conectar a VPS
ssh root@159.89.157.63

# Parar servicio si existe
sudo systemctl stop cardwars-kingdom-net.service

# Hacer backup del directorio existente (si existe)
sudo mv /var/www/cardwars-kingdom.net /var/www/cardwars-kingdom.net.backup.$(date +%Y%m%d_%H%M%S)

# Clonar repositorio limpio
cd /var/www
git clone https://github.com/Lu2312/Welcome-Card-Wars-Kingdom.git cardwars-kingdom.net

# Configurar entorno virtual
cd cardwars-kingdom.net
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Establecer permisos correctos
sudo chown -R www-data:www-data /var/www/cardwars-kingdom.net

# Iniciar servicio
sudo systemctl start cardwars-kingdom-net.service
```

### Opción 2: Script Automático

```bash
# Conectar a VPSroot@ubuntu-s-1vcpu-1gb-sfo2-01:/var/www/cardwars-kingdom.net# git pull origin main
fatal: not a git repository (or any of the parent directories): .git
root@ubuntu-s-1vcpu-1gb-sfo2-01:/var/www/cardwars-kingdom.net# cd s
ssh root@159.89.157.63

# Descargar y ejecutar script
wget https://raw.githubusercontent.com/Lu2312/Welcome-Card-Wars-Kingdom/main/deploy/setup-vps.sh
chmod +x setup-vps.sh
sudo ./setup-vps.sh
```

### Opción 3: Copiar Scripts Manualmente

```bash
# Desde tu PC local
scp -r deploy root@159.89.157.63:/tmp/

# En el servidor
ssh root@159.89.157.63
cd /tmp/deploy
chmod +x *.sh
sudo ./setup-vps.sh
```

## 📊 Comandos Útiles

```bash
# Verificar estado
./deploy/check-status.sh

# Ver logs en tiempo real
./deploy/logs.sh

# Actualizar proyecto
sudo ./deploy/update-vps.sh

# Reiniciar servicio
sudo systemctl restart cardwars-kingdom-net.service

# Ver errores
sudo journalctl -u cardwars-kingdom-net.service -p err -n 20
```

## 🔧 Solución de Problemas

### Servicio no inicia

```bash
# Ver logs detallados
sudo journalctl -u cardwars-kingdom-net.service -n 100 --no-pager

# Probar manualmente
cd /var/www/cardwars-kingdom.net
source venv/bin/activate
python app.py
```

### Puerto ocupado

```bash
# Ver qué está usando el puerto
sudo lsof -i :8080
sudo lsof -i :80

# Matar proceso
sudo kill -9 PID
```

### Nginx error 502

```bash
# Verificar que Gunicorn está corriendo
sudo systemctl status cardwars-kingdom-net.service

# Verificar logs de Nginx
sudo tail -f /var/log/nginx/cardwars-kingdom-net-error.log
```

## 🔄 Sincronización Local → VPS

### Método 1: Copia Limpia Completa (Recomendado)

```bash
# 1. Conectar a VPS y hacer backup
ssh root@159.89.157.63 "systemctl stop cardwars-kingdom-net.service && mv /var/www/cardwars-kingdom.net /var/www/cardwars-kingdom.net.backup.$(date +%Y%m%d_%H%M%S)"

# 2. Clonar repositorio fresco
ssh root@159.89.157.63 "cd /var/www && git clone https://github.com/Lu2312/Welcome-Card-Wars-Kingdom.git cardwars-kingdom.net"

# 3. Configurar entorno
ssh root@159.89.157.63 "cd /var/www/cardwars-kingdom.net && python3 -m venv venv && source venv/bin/activate && pip install -r requirements.txt && chown -R www-data:www-data /var/www/cardwars-kingdom.net"

# 4. Reiniciar servicio
ssh root@159.89.157.63 "systemctl start cardwars-kingdom-net.service"
```

### Método 2: Copia Directa de Archivos

```bash
# Copiar archivos específicos desde local a VPS
scp app.py templates/creatures.html requirements.txt root@159.89.157.63:/var/www/cardwars-kingdom.net/
scp templates/*.html root@159.89.157.63:/var/www/cardwars-kingdom.net/templates/

# Corregir permisos y reiniciar
ssh root@159.89.157.63 "chown -R www-data:www-data /var/www/cardwars-kingdom.net && systemctl restart cardwars-kingdom-net.service"
```

### Método 3: Sincronización con rsync

```bash
# Excluir archivos no necesarios y sincronizar
rsync -avz --exclude='.git' --exclude='__pycache__' --exclude='venv' --exclude='*.pyc' . root@159.89.157.63:/var/www/cardwars-kingdom.net/

# Corregir permisos y reiniciar
ssh root@159.89.157.63 "chown -R www-data:www-data /var/www/cardwars-kingdom.net && systemctl restart cardwars-kingdom-net.service"
```

## 🔍 Verificación de Sincronización

```bash
# Comparar checksums entre local y VPS
echo "=== LOCAL ===" && md5sum app.py templates/creatures.html requirements.txt
echo "=== VPS ===" && ssh root@159.89.157.63 "cd /var/www/cardwars-kingdom.net && md5sum app.py templates/creatures.html requirements.txt"

# Verificar estado del servicio
ssh root@159.89.157.63 "systemctl status cardwars-kingdom-net.service --no-pager"

# Probar endpoint
curl -I https://cardwars-kingdom.net/
```

## 📝 Notas

- Todos los scripts requieren permisos de root
- Los backups se guardan en `/var/backups/cardwars-kingdom-TIMESTAMP` o `/var/www/cardwars-kingdom.net.backup.TIMESTAMP`
- Los logs están en `/var/log/gunicorn/` y `/var/log/nginx/`
- Siempre hacer backup antes de despliegues en producción
- Usar `Método 1: Copia Limpia Completa` para resolver problemas de sincronización

## 🔔 Nota importante — corrección Nginx & CDN (reciente)

Detectamos y corregimos un caso común donde Nginx apuntaba a la ruta equivocada para archivos estáticos y Cloudflare entregaba una copia antigua/404:

- Problema: `location /static` apuntaba a `/var/www/cardwars-kingdom/static` (carpeta antigua). Esto devolvía 404 aunque la copia correcta estaba en `/var/www/cardwars-kingdom.net/static` en el origen.
- Acción aplicada: Cambiar `alias` a `/var/www/cardwars-kingdom.net/static`, recargar Nginx y verificar. Ejemplo:

```bash
sudo cp /etc/nginx/sites-available/cardwars-kingdom-net /tmp/cardwars-kingdom-net.conf.bak
sudo sed -i 's#/var/www/cardwars-kingdom/static#/var/www/cardwars-kingdom.net/static#g' /etc/nginx/sites-available/cardwars-kingdom-net
sudo nginx -t && sudo systemctl reload nginx
```

- Nota: Cloudflare puede seguir devolviendo una versión cacheada (o 404) hasta que purgues la caché en Cloudflare. Revisa `cf-cache-status` y purga el asset si hace falta.

## 🔁 Cómo actualizar el código en la VPS (dos formas)

### A — Actualizar desde GitHub (recomendado cuando `.git` existe)

1. Entra al servidor y verifica que el directorio es un repo git:

```bash
cd /var/www/cardwars-kingdom.net
if [ -d .git ]; then git status || true; else echo ".git missing"; fi
```

2. Si `.git` existe y estás en la rama `main`:

```bash
sudo systemctl stop cardwars-kingdom-net.service
cd /var/www/cardwars-kingdom.net
git fetch origin
git pull origin main
python3 -m venv venv || true
source venv/bin/activate
pip install -r requirements.txt
sudo chown -R www-data:www-data /var/www/cardwars-kingdom.net
sudo systemctl start cardwars-kingdom-net.service
```

3. Si `.git` no existe (caso frecuente tras despliegues por tar/scp), usa la opción segura (re-clonar):

```bash
# Crea clon limpio en directorio temporal
cd /var/www
git clone https://github.com/Lu2312/Welcome-Card-Wars-Kingdom.git cardwars-kingdom.net.new

# Compara sin sobrescribir (opcional)
diff -ru /var/www/cardwars-kingdom.net /var/www/cardwars-kingdom.net.new | less

# Si está OK, usa backup y reemplaza
sudo systemctl stop cardwars-kingdom-net.service
sudo mv /var/www/cardwars-kingdom.net /var/www/cardwars-kingdom.net.backup.$(date +%Y%m%d_%H%M%S)
sudo mv /var/www/cardwars-kingdom.net.new /var/www/cardwars-kingdom.net
cd /var/www/cardwars-kingdom.net
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
sudo chown -R www-data:www-data /var/www/cardwars-kingdom.net
sudo systemctl start cardwars-kingdom-net.service
```

### B — Re-inicializar git en el directorio actual (cuidado)

Si quieres mantener los archivos actuales y recuperar el control con Git (más arriesgado):

```bash
cd /var/www/cardwars-kingdom.net
git init
git remote add origin https://github.com/Lu2312/Welcome-Card-Wars-Kingdom.git
git fetch origin
# Ver diferencias (no cambia archivos):
git diff --name-status origin/main
# Si quieres sobrescribir con origin/main (¡irrevocable para archivos sin respaldo!):
git reset --hard origin/main
```

## 🖥️ Actualizar desde tu máquina local → VPS

Se proporcionan 3 métodos según tu preferencia y herramientas:

1) Copia limpia con `scp`/tar (rápido pero manual):

```bash
# En tu PC: crear tar o copiar archivos seleccionados
tar czf repo-sync.tar.gz --exclude='.git' --exclude='venv' .
scp repo-sync.tar.gz root@159.89.157.63:/tmp/

# En la VPS:
ssh root@159.89.157.63
cd /var/www
sudo systemctl stop cardwars-kingdom-net.service
sudo mv cardwars-kingdom.net cardwars-kingdom.net.backup.$(date +%Y%m%d_%H%M%S)
sudo tar xzf /tmp/repo-sync.tar.gz -C /var/www/cardwars-kingdom.net
cd /var/www/cardwars-kingdom.net
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
sudo chown -R www-data:www-data /var/www/cardwars-kingdom.net
sudo systemctl start cardwars-kingdom-net.service
```

2) Copiar archivos concretos con `scp` (útil para cambios pequeños):

```bash
# Desde tu PC
scp app.py templates/index.html static/css/styles.css root@159.89.157.63:/var/www/cardwars-kingdom.net/

# En la VPS
ssh root@159.89.157.63
sudo chown www-data:www-data /var/www/cardwars-kingdom.net/app.py /var/www/cardwars-kingdom.net/templates/index.html /var/www/cardwars-kingdom.net/static/css/styles.css
sudo systemctl restart cardwars-kingdom-net.service
```

3) Sincronización segura con `rsync` (recomendada cuando tienes rsync instalado):

```bash
# Desde tu PC (en el repo raíz)
rsync -avz --delete --exclude='.git' --exclude='venv' --exclude='__pycache__' . root@159.89.157.63:/var/www/cardwars-kingdom.net/

# En la VPS
ssh root@159.89.157.63
sudo chown -R www-data:www-data /var/www/cardwars-kingdom.net
sudo systemctl restart cardwars-kingdom-net.service
```

### Evitar problemas con CDN / Cloudflare

Si el sitio usa Cloudflare y ves cambios no aplicados (CSS/JS viejos/404):

- Purga el asset en Cloudflare o activa Dev Mode temporalmente.
- Para purgar por API (reemplaza ZONE_ID / YOUR_API_TOKEN):

```bash
curl -X POST "https://api.cloudflare.com/client/v4/zones/<ZONE_ID>/purge_cache" \
	-H "Authorization: Bearer <YOUR_API_TOKEN>" \
	-H "Content-Type: application/json" \
	--data '{"files":["https://cardwars-kingdom.net/static/css/styles.css"]}'
```

o purgar todo:

```bash
curl -X POST "https://api.cloudflare.com/client/v4/zones/<ZONE_ID>/purge_cache" \
	-H "Authorization: Bearer <YOUR_API_TOKEN>" \
	-H "Content-Type: application/json" \
	--data '{"purge_everything":true}'
```

---

*Con estos pasos la VPS puede mantenerse sincronizada con GitHub y con una copia local de forma segura. Siempre realiza backup antes de aplicar cambios en producción.*
