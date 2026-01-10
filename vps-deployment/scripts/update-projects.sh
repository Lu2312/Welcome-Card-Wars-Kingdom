#!/bin/bash

# Script para actualizar ambos proyectos desde GitHub
# Ejecutar: sudo bash update-projects.sh

set -e

echo "=================================================="
echo "  Actualizando proyectos Card Wars Kingdom"
echo "=================================================="
echo ""

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Actualizar card-wars-kingdom.com
echo -e "${YELLOW}[1/4] Actualizando card-wars-kingdom.com...${NC}"
cd /var/www/cardwarskingdomrvd
git pull
venv/bin/pip install -r requirements.txt
echo -e "${GREEN}✓ card-wars-kingdom.com actualizado${NC}"
echo ""

# Actualizar cardwars-kingdom.net
echo -e "${YELLOW}[2/4] Actualizando cardwars-kingdom.net...${NC}"
cd /var/www/cardwars-kingdom
git pull
venv/bin/pip install -r requirements.txt
echo -e "${GREEN}✓ cardwars-kingdom.net actualizado${NC}"
echo ""

# Reiniciar servicios
echo -e "${YELLOW}[3/4] Reiniciando servicios...${NC}"
systemctl restart card-wars-kingdom-com.service
systemctl restart cardwars-kingdom-net.service
echo -e "${GREEN}✓ Servicios reiniciados${NC}"
echo ""

# Verificar estado
echo -e "${YELLOW}[4/4] Verificando estado...${NC}"
sleep 3

check_service() {
    local service=$1
    local status=$(systemctl is-active $service)
    if [ "$status" = "active" ]; then
        echo -e "  ${GREEN}✓${NC} $service: ${GREEN}OK${NC}"
    else
        echo -e "  ${RED}✗${NC} $service: ${RED}ERROR${NC}"
    fi
}

check_service card-wars-kingdom-com.service
check_service cardwars-kingdom-net.service

echo ""
echo -e "${GREEN}=================================================="
echo "  ✓ Actualización completada"
echo "==================================================${NC}"
echo ""
