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

### Opción 1: Desde GitHub (Recomendado)

```bash
# Conectar a VPS
ssh root@159.89.157.63

# Descargar y ejecutar script
wget https://raw.githubusercontent.com/Lu2312/Welcome-Card-Wars-Kingdom/main/deploy/setup-vps.sh
chmod +x setup-vps.sh
sudo ./setup-vps.sh
```

### Opción 2: Copiar Scripts Manualmente

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

## 📝 Notas

- Todos los scripts requieren permisos de root
- Los backups se guardan en `/var/backups/cardwars-kingdom-TIMESTAMP`
- Los logs están en `/var/log/gunicorn/` y `/var/log/nginx/`
