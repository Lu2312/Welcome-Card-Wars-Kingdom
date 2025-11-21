#!/bin/bash

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Card Wars Kingdom - Setup de Producción${NC}"
echo "=========================================="
echo ""

# Copiar a producción si no existe
if [ ! -d "/var/www/cardwars-kingdom" ]; then
    echo -e "${YELLOW}1. Copiando proyecto a producción...${NC}"
    sudo cp -r /tmp/Welcome-Card-Wars-Kingdom /var/www/cardwars-kingdom
    echo -e "${GREEN}✓ Proyecto copiado${NC}"
else
    echo -e "${GREEN}✓ Proyecto ya existe en /var/www/cardwars-kingdom${NC}"
fi
echo ""

# Establecer permisos
echo -e "${YELLOW}2. Configurando permisos...${NC}"
sudo chown -R www-data:www-data /var/www/cardwars-kingdom
echo -e "${GREEN}✓ Permisos configurados${NC}"
echo ""

# Crear venv e instalar dependencias
echo -e "${YELLOW}3. Configurando entorno virtual...${NC}"
cd /var/www/cardwars-kingdom
if [ ! -d "venv" ]; then
    sudo -u www-data python3 -m venv venv
fi
sudo -u www-data venv/bin/pip install --upgrade pip -q
sudo -u www-data venv/bin/pip install -r requirements.txt -q
sudo -u www-data venv/bin/pip install gunicorn -q
echo -e "${GREEN}✓ Dependencias instaladas${NC}"
echo ""

# Configurar Nginx
echo -e "${YELLOW}4. Configurando Nginx...${NC}"
sudo cp deploy/nginx-config /etc/nginx/sites-available/cardwars-kingdom-net
sudo ln -sf /etc/nginx/sites-available/cardwars-kingdom-net /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
echo -e "${GREEN}✓ Nginx configurado${NC}"
echo ""

# Configurar systemd
echo -e "${YELLOW}5. Configurando servicio systemd...${NC}"
sudo systemctl daemon-reload
sudo systemctl restart cardwars-kingdom-net.service
sudo systemctl enable cardwars-kingdom-net.service
echo -e "${GREEN}✓ Servicio configurado${NC}"
echo ""

# Verificar
echo -e "${YELLOW}6. Verificando estado...${NC}"
if systemctl is-active --quiet cardwars-kingdom-net.service; then
    echo -e "${GREEN}✓ Servicio activo${NC}"
    systemctl status cardwars-kingdom-net.service --no-pager | head -15
else
    echo -e "${RED}✗ Servicio no activo${NC}"
    journalctl -u cardwars-kingdom-net.service -n 20
fi
echo ""

echo -e "${GREEN}=========================================="
echo "Setup completado!${NC}"
echo ""
echo "Próximos pasos:"
echo "1. Configura Cloudflare SSL/TLS a modo 'Flexible'"
echo "2. Limpia caché del navegador"
echo "3. Visita: https://cardwars-kingdom.net"
echo ""
echo "Ver logs: sudo bash /var/www/cardwars-kingdom/deploy/logs.sh"
