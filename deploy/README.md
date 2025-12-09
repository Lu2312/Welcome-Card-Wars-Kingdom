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
# Conectar a VPS
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
