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
cp -r "$REPO_DIR"/{app.py,wsgi.py,requirements.txt,gunicorn_config.py,static,templates,.env.example} "$PROJECT_DIR/"
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

# Limpiar configuraciones antiguas
echo "Limpiando configuraciones antiguas..."
rm -f /etc/nginx/sites-enabled/cardwars-kingdom.net.conf
rm -f /etc/nginx/sites-available/cardwars-kingdom.net.conf
rm -f /etc/nginx/sites-enabled/default

# Copiar nueva configuración
cp "$REPO_DIR/deploy/nginx-config" /etc/nginx/sites-available/cardwars-kingdom-net
ln -sf /etc/nginx/sites-available/cardwars-kingdom-net /etc/nginx/sites-enabled/cardwars-kingdom-net

# Verificar configuración
if nginx -t; then
    echo -e "${GREEN}✓ Configuración de Nginx válida${NC}"
    systemctl restart nginx
    echo -e "${GREEN}✓ Nginx reiniciado${NC}"
else
    echo -e "${RED}✗ Error en configuración de Nginx${NC}"
    exit 1
fi
echo ""

# Paso 4: Configurar permisos
echo -e "${YELLOW}4. Configurando permisos...${NC}"
chown -R www-data:www-data "$PROJECT_DIR"
echo -e "${GREEN}✓ Permisos configurados${NC}"
echo ""

# Paso 4.5: Copiar archivo de servicio systemd
echo -e "${YELLOW}4.5. Actualizando servicio systemd...${NC}"
cp "$REPO_DIR/deploy/cardwars-kingdom-net.service" /etc/systemd/system/
echo -e "${GREEN}✓ Archivo de servicio actualizado${NC}"
echo ""

# Paso 5: Iniciar servicio
echo -e "${YELLOW}5. Iniciando servicio...${NC}"
systemctl daemon-reload

# Detener servicio si está corriendo
systemctl stop cardwars-kingdom-net.service || true

# Intentar iniciar
systemctl start cardwars-kingdom-net.service
sleep 3

if systemctl is-active --quiet cardwars-kingdom-net.service; then
    echo -e "${GREEN}✓ Servicio iniciado correctamente${NC}"
    systemctl status cardwars-kingdom-net.service --no-pager -l
else
    echo -e "${RED}✗ Error al iniciar servicio${NC}"
    echo ""
    echo "Últimos logs del servicio:"
    journalctl -u cardwars-kingdom-net.service -n 30 --no-pager
    echo ""
    echo "Estado del servicio:"
    systemctl status cardwars-kingdom-net.service --no-pager -l || true
    exit 1
fi
echo ""

echo -e "${GREEN}=========================================="
echo "Despliegue completado!${NC}"
echo ""
echo "Verificar que todo funciona:"
echo "  curl http://localhost"
echo "  sudo bash $REPO_DIR/deploy/status.sh"
echo ""
echo "Ver logs en tiempo real:"
echo "  sudo bash $REPO_DIR/deploy/logs.sh"
