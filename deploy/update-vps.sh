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
cd $PROJECT_DIR
sudo git pull origin main

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
sleep 2
sudo systemctl status cardwars-kingdom-net.service --no-pager -l

echo ""
echo -e "${GREEN}✅ Actualización completada!${NC}"
echo ""
curl http://localhost:8080/api/health
echo ""
