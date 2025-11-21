#!/bin/bash

# Script de despliegue completo
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

PROJECT_DIR="/var/www/cardwars-kingdom"
REPO_DIR="/tmp/Welcome-Card-Wars-Kingdom"

echo -e "${GREEN}Card Wars Kingdom - Despliegue Completo${NC}"
echo "=========================================="
echo ""

# Verificar que estamos en el directorio correcto
if [ ! -d "$REPO_DIR" ]; then
    echo -e "${RED}Error: Directorio del repositorio no encontrado${NC}"
    exit 1
fi

# Paso 1: Copiar archivos de la aplicación
echo -e "${YELLOW}1. Copiando archivos de la aplicación...${NC}"
cp -r "$REPO_DIR"/{app.py,wsgi.py,requirements.txt,static,templates,.env.example} "$PROJECT_DIR/"
echo -e "${GREEN}✓ Archivos copiados${NC}"
echo ""

# Paso 2: Instalar dependencias
echo -e "${YELLOW}2. Instalando dependencias Python...${NC}"
source "$PROJECT_DIR/venv/bin/activate"
pip install --upgrade pip
pip install -r "$PROJECT_DIR/requirements.txt"
deactivate
echo -e "${GREEN}✓ Dependencias instaladas${NC}"
echo ""

# Paso 3: Configurar Nginx
echo -e "${YELLOW}3. Configurando Nginx...${NC}"
cp "$REPO_DIR/deploy/nginx-config" /etc/nginx/sites-available/cardwars-kingdom-net
ln -sf /etc/nginx/sites-available/cardwars-kingdom-net /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default
nginx -t
systemctl restart nginx
echo -e "${GREEN}✓ Nginx configurado${NC}"
echo ""

# Paso 4: Configurar permisos
echo -e "${YELLOW}4. Configurando permisos...${NC}"
chown -R www-data:www-data "$PROJECT_DIR"
echo -e "${GREEN}✓ Permisos configurados${NC}"
echo ""

# Paso 5: Iniciar servicio
echo -e "${YELLOW}5. Iniciando servicio...${NC}"
systemctl daemon-reload
systemctl restart cardwars-kingdom-net.service
systemctl status cardwars-kingdom-net.service --no-pager
echo -e "${GREEN}✓ Servicio iniciado${NC}"
echo ""

echo -e "${GREEN}=========================================="
echo "Despliegue completado!${NC}"
echo ""
echo "Verificar que todo funciona:"
echo "  curl http://localhost"
echo "  sudo bash $REPO_DIR/deploy/status.sh"
echo ""
