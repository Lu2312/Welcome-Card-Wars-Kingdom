#!/bin/bash

# Script para actualizar el proyecto en la VPS

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}  Card Wars Kingdom - Update${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""

PROJECT_DIR="/var/www/cardwars-kingdom.net"

# Hacer backup
echo -e "${YELLOW}[1/5] Creando backup...${NC}"
BACKUP_DIR="/var/backups/cardwars-kingdom-$(date +%Y%m%d-%H%M%S)"
sudo cp -r $PROJECT_DIR $BACKUP_DIR
echo "Backup guardado en: $BACKUP_DIR"

# Pull cambios
echo -e "${YELLOW}[2/5] Obteniendo cambios de GitHub...${NC}"
# Configurar el directorio como seguro para git
git config --global --add safe.directory /var/www/cardwars-kingdom.net 2>/dev/null || true
git config --global --add safe.directory /tmp/Welcome-Card-Wars-Kingdom 2>/dev/null || true

# Usar el repositorio temporal en lugar del directorio de producción
cd /tmp/Welcome-Card-Wars-Kingdom
git pull origin main

# Copiar archivos actualizados
cp -r /tmp/Welcome-Card-Wars-Kingdom/{app.py,wsgi.py,requirements.txt,gunicorn_config.py,static,templates} /var/www/cardwars-kingdom/
cp /tmp/Welcome-Card-Wars-Kingdom/deploy/nginx-config /etc/nginx/sites-available/cardwars-kingdom-net

cd /var/www/cardwars-kingdom

# Actualizar dependencias
echo -e "${YELLOW}[3/5] Actualizando dependencias...${NC}"
source venv/bin/activate
pip install -r requirements.txt
deactivate

# Reiniciar servicio
echo -e "${YELLOW}[4/5] Reiniciando servicio...${NC}"
sudo systemctl restart cardwars-kingdom-net.service

# Verificar
echo -e "${YELLOW}[5/5] Verificando...${NC}"
systemctl status cardwars-kingdom-net.service --no-pager -l

echo ""
echo -e "${GREEN}✅ Actualización completada!${NC}"
echo ""
# Probar en el puerto correcto (8000, no 8080)
curl -s http://localhost:8000 > /dev/null && echo "✅ Servicio respondiendo correctamente" || echo "⚠️  El servicio no responde en el puerto 8000"
