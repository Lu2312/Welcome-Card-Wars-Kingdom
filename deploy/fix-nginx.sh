#!/bin/bash

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Arreglando configuración de Nginx...${NC}"
echo ""

# Detener Nginx
echo -e "${YELLOW}1. Deteniendo Nginx...${NC}"
sudo systemctl stop nginx

# Limpiar configuraciones conflictivas
echo -e "${YELLOW}2. Limpiando configuraciones antiguas...${NC}"
sudo rm -f /etc/nginx/sites-enabled/*
sudo rm -f /etc/nginx/sites-available/cardwars-kingdom-net

# Copiar nueva configuración
echo -e "${YELLOW}3. Copiando nueva configuración...${NC}"
sudo cp /tmp/Welcome-Card-Wars-Kingdom/deploy/nginx-config /etc/nginx/sites-available/cardwars-kingdom-net
sudo ln -sf /etc/nginx/sites-available/cardwars-kingdom-net /etc/nginx/sites-enabled/

# Instalar certificados SSL autofirmados temporales si no existen
if [ ! -f "/etc/ssl/certs/ssl-cert-snakeoil.pem" ]; then
    echo -e "${YELLOW}4. Instalando certificados SSL temporales...${NC}"
    sudo apt-get install -y ssl-cert
fi

# Verificar configuración
echo -e "${YELLOW}5. Verificando configuración...${NC}"
if sudo nginx -t; then
    echo -e "${GREEN}✓ Configuración válida${NC}"
else
    echo -e "${RED}✗ Error en configuración${NC}"
    exit 1
fi

# Iniciar Nginx
echo -e "${YELLOW}6. Iniciando Nginx...${NC}"
sudo systemctl start nginx

# Verificar estado
echo ""
if systemctl is-active --quiet nginx; then
    echo -e "${GREEN}✓ Nginx funcionando correctamente${NC}"
    
    # Probar conectividad
    echo ""
    echo -e "${YELLOW}Probando conectividad...${NC}"
    
    if curl -s http://localhost > /dev/null; then
        echo -e "${GREEN}✓ HTTP (puerto 80) funciona${NC}"
    else
        echo -e "${RED}✗ HTTP (puerto 80) no responde${NC}"
    fi
    
    if curl -ks https://localhost > /dev/null; then
        echo -e "${GREEN}✓ HTTPS (puerto 443) funciona${NC}"
    else
        echo -e "${RED}✗ HTTPS (puerto 443) no responde${NC}"
    fi
else
    echo -e "${RED}✗ Nginx no se pudo iniciar${NC}"
    echo ""
    echo "Ver logs:"
    sudo journalctl -u nginx -n 20
    exit 1
fi

echo ""
echo -e "${GREEN}=========================================="
echo "Nginx configurado correctamente!${NC}"
echo ""
echo "Próximos pasos:"
echo "1. Configura certificados SSL de Cloudflare (ver guía)"
echo "2. Actualiza nginx-config para usar certificados reales"
echo "3. Recarga Nginx: sudo systemctl reload nginx"
