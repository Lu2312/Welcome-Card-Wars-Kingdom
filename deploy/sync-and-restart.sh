#!/bin/bash

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Card Wars Kingdom - Sincronización y Reinicio${NC}"
echo "==============================================="
echo ""

# 1. Actualizar repositorio temporal
echo -e "${YELLOW}1. Actualizando desde GitHub...${NC}"
cd /tmp/Welcome-Card-Wars-Kingdom
git config --global --add safe.directory /tmp/Welcome-Card-Wars-Kingdom
git pull origin main
echo -e "${GREEN}✓ Repositorio actualizado${NC}"
echo ""

# 2. Sincronizar con producción
echo -e "${YELLOW}2. Sincronizando archivos a producción...${NC}"
sudo rsync -av --exclude='.git' --exclude='venv' --exclude='__pycache__' \
    /tmp/Welcome-Card-Wars-Kingdom/ /var/www/cardwars-kingdom/
echo -e "${GREEN}✓ Archivos sincronizados${NC}"
echo ""

# 3. Establecer permisos
echo -e "${YELLOW}3. Configurando permisos...${NC}"
sudo chown -R www-data:www-data /var/www/cardwars-kingdom
sudo git config --global --add safe.directory /var/www/cardwars-kingdom
echo -e "${GREEN}✓ Permisos configurados${NC}"
echo ""

# 4. Actualizar dependencias Python
echo -e "${YELLOW}4. Actualizando dependencias Python...${NC}"
cd /var/www/cardwars-kingdom
if [ ! -d "venv" ]; then
    sudo -u www-data python3 -m venv venv
fi
sudo -u www-data venv/bin/pip install -q --upgrade pip
sudo -u www-data venv/bin/pip install -q -r requirements.txt
sudo -u www-data venv/bin/pip install -q gunicorn
echo -e "${GREEN}✓ Dependencias actualizadas${NC}"
echo ""

# 5. Actualizar configuración de Nginx
echo -e "${YELLOW}5. Actualizando configuración de Nginx...${NC}"
if [ -f "deploy/nginx-config" ]; then
    sudo cp deploy/nginx-config /etc/nginx/sites-available/cardwars-kingdom-net
    sudo ln -sf /etc/nginx/sites-available/cardwars-kingdom-net /etc/nginx/sites-enabled/
    if sudo nginx -t; then
        sudo systemctl reload nginx
        echo -e "${GREEN}✓ Nginx actualizado${NC}"
    else
        echo -e "${RED}✗ Error en configuración de Nginx${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Archivo nginx-config no encontrado${NC}"
fi
echo ""

# 6. Reiniciar servicio
echo -e "${YELLOW}6. Reiniciando servicio...${NC}"
sudo systemctl daemon-reload
sudo systemctl restart cardwars-kingdom-net.service
sleep 2

if systemctl is-active --quiet cardwars-kingdom-net.service; then
    echo -e "${GREEN}✓ Servicio reiniciado correctamente${NC}"
    echo ""
    systemctl status cardwars-kingdom-net.service --no-pager | head -15
else
    echo -e "${RED}✗ Error al reiniciar servicio${NC}"
    echo ""
    echo "Últimos logs:"
    journalctl -u cardwars-kingdom-net.service -n 20 --no-pager
    exit 1
fi
echo ""

# 7. Verificar conectividad
echo -e "${YELLOW}7. Verificando conectividad...${NC}"
if curl -s http://localhost:8000 > /dev/null; then
    echo -e "${GREEN}✓ Aplicación respondiendo en puerto 8000${NC}"
else
    echo -e "${RED}✗ Aplicación no responde en puerto 8000${NC}"
fi

if curl -s http://localhost > /dev/null; then
    echo -e "${GREEN}✓ Nginx respondiendo en puerto 80${NC}"
else
    echo -e "${RED}✗ Nginx no responde en puerto 80${NC}"
fi
echo ""

echo -e "${GREEN}==============================================="
echo "✓ Actualización completada!${NC}"
echo ""
echo "Probar en navegador:"
echo "  https://cardwars-kingdom.net"
echo ""
echo "Ver logs:"
echo "  sudo journalctl -u cardwars-kingdom-net.service -f"
echo "  sudo bash /var/www/cardwars-kingdom/deploy/logs.sh"
