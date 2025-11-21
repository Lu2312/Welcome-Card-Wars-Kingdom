#!/bin/bash

# Script para verificar el estado de la instalación

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Card Wars Kingdom - Estado de Instalación${NC}"
echo "=========================================="
echo ""

# Check 1: Directorio del proyecto
echo -e "${YELLOW}1. Verificando directorio del proyecto...${NC}"
if [ -d "/var/www/cardwars-kingdom" ]; then
    echo -e "${GREEN}✓ Directorio existe: /var/www/cardwars-kingdom${NC}"
else
    echo -e "${RED}✗ Directorio NO existe: /var/www/cardwars-kingdom${NC}"
fi
echo ""

# Check 2: Virtual environment
echo -e "${YELLOW}2. Verificando virtual environment...${NC}"
if [ -d "/var/www/cardwars-kingdom/venv" ]; then
    echo -e "${GREEN}✓ Virtual environment existe${NC}"
else
    echo -e "${RED}✗ Virtual environment NO existe${NC}"
fi
echo ""

# Check 3: Python dependencies
echo -e "${YELLOW}3. Verificando dependencias Python...${NC}"
if [ -f "/var/www/cardwars-kingdom/venv/bin/gunicorn" ]; then
    echo -e "${GREEN}✓ Gunicorn instalado${NC}"
else
    echo -e "${RED}✗ Gunicorn NO instalado${NC}"
fi
echo ""

# Check 4: Archivos de aplicación
echo -e "${YELLOW}4. Verificando archivos de aplicación...${NC}"
if [ -f "/var/www/cardwars-kingdom/app.py" ]; then
    echo -e "${GREEN}✓ app.py existe${NC}"
else
    echo -e "${RED}✗ app.py NO existe${NC}"
fi
if [ -f "/var/www/cardwars-kingdom/wsgi.py" ]; then
    echo -e "${GREEN}✓ wsgi.py existe${NC}"
else
    echo -e "${RED}✗ wsgi.py NO existe${NC}"
fi
echo ""

# Check 5: Nginx
echo -e "${YELLOW}5. Verificando Nginx...${NC}"
if systemctl is-active --quiet nginx; then
    echo -e "${GREEN}✓ Nginx está corriendo${NC}"
else
    echo -e "${RED}✗ Nginx NO está corriendo${NC}"
fi
if [ -f "/etc/nginx/sites-available/cardwars-kingdom-net" ]; then
    echo -e "${GREEN}✓ Configuración de Nginx existe${NC}"
else
    echo -e "${RED}✗ Configuración de Nginx NO existe${NC}"
fi
if [ -L "/etc/nginx/sites-enabled/cardwars-kingdom-net" ]; then
    echo -e "${GREEN}✓ Sitio habilitado en Nginx${NC}"
else
    echo -e "${RED}✗ Sitio NO habilitado en Nginx${NC}"
fi
echo ""

# Check 6: Systemd service
echo -e "${YELLOW}6. Verificando servicio systemd...${NC}"
if [ -f "/etc/systemd/system/cardwars-kingdom-net.service" ]; then
    echo -e "${GREEN}✓ Archivo de servicio existe${NC}"
    if systemctl is-active --quiet cardwars-kingdom-net.service; then
        echo -e "${GREEN}✓ Servicio está corriendo${NC}"
    else
        echo -e "${RED}✗ Servicio NO está corriendo${NC}"
    fi
    if systemctl is-enabled --quiet cardwars-kingdom-net.service; then
        echo -e "${GREEN}✓ Servicio habilitado para inicio automático${NC}"
    else
        echo -e "${RED}✗ Servicio NO habilitado para inicio automático${NC}"
    fi
else
    echo -e "${RED}✗ Archivo de servicio NO existe${NC}"
fi
echo ""

# Check 7: Logs
echo -e "${YELLOW}7. Verificando directorios de logs...${NC}"
if [ -d "/var/log/gunicorn" ]; then
    echo -e "${GREEN}✓ Directorio de logs de Gunicorn existe${NC}"
else
    echo -e "${RED}✗ Directorio de logs de Gunicorn NO existe${NC}"
fi
echo ""

# Resumen
echo -e "${GREEN}=========================================="
echo "Resumen:${NC}"
echo ""
echo "Pasos completados:"
echo "- Si todos los checks tienen ✓, la instalación está completa"
echo "- Si hay ✗, sigue los pasos del README.md para completar"
echo ""
echo "Comandos útiles:"
echo "  sudo systemctl status cardwars-kingdom-net.service  # Ver estado del servicio"
echo "  sudo journalctl -u cardwars-kingdom-net.service -n 50  # Ver logs"
echo "  sudo systemctl restart cardwars-kingdom-net.service  # Reiniciar servicio"
