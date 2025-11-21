#!/bin/bash

# Script para iniciar todos los servicios
# Ejecutar: sudo bash start-services.sh

set -e

echo "=================================================="
echo "  Iniciando servicios Card Wars Kingdom"
echo "=================================================="
echo ""

# Colores
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Verificar que los certificados existen
echo -e "${YELLOW}Verificando certificados SSL...${NC}"

if [ ! -f "/etc/ssl/certs/card-wars-kingdom.com.crt" ] || [ ! -f "/etc/ssl/private/card-wars-kingdom.com.key" ]; then
    echo "❌ Error: Certificados para card-wars-kingdom.com no encontrados"
    echo "Por favor, instala los certificados primero"
    exit 1
fi

if [ ! -f "/etc/ssl/certs/cardwars-kingdom.net.crt" ] || [ ! -f "/etc/ssl/private/cardwars-kingdom.net.key" ]; then
    echo "❌ Error: Certificados para cardwars-kingdom.net no encontrados"
    echo "Por favor, instala los certificados primero"
    exit 1
fi

echo -e "${GREEN}✓ Certificados SSL encontrados${NC}"
echo ""

# Verificar configuración de Nginx
echo -e "${YELLOW}Verificando configuración de Nginx...${NC}"
nginx -t

if [ $? -ne 0 ]; then
    echo "❌ Error en la configuración de Nginx"
    exit 1
fi

echo -e "${GREEN}✓ Configuración de Nginx correcta${NC}"
echo ""

# Iniciar servicios de Gunicorn
echo -e "${YELLOW}Iniciando servicios de Gunicorn...${NC}"

systemctl start card-wars-kingdom-app.service
echo "  • card-wars-kingdom-app.service (puerto 8000)"

systemctl start card-wars-kingdom-app-backup.service
echo "  • card-wars-kingdom-app-backup.service (puerto 8001)"

systemctl start cardwars-kingdom-site.service
echo "  • cardwars-kingdom-site.service (puerto 8080)"

systemctl start cardwars-kingdom-site-backup.service
echo "  • cardwars-kingdom-site-backup.service (puerto 8081)"

echo ""

# Esperar un momento
sleep 3

# Verificar estado de servicios
echo -e "${YELLOW}Verificando estado de servicios...${NC}"
echo ""

check_service() {
    local service=$1
    local status=$(systemctl is-active $service)
    if [ "$status" = "active" ]; then
        echo -e "  ${GREEN}✓${NC} $service: ${GREEN}RUNNING${NC}"
    else
        echo -e "  ${RED}✗${NC} $service: ${RED}FAILED${NC}"
    fi
}

check_service card-wars-kingdom-app.service
check_service card-wars-kingdom-app-backup.service
check_service cardwars-kingdom-site.service
check_service cardwars-kingdom-site-backup.service

echo ""

# Recargar Nginx
echo -e "${YELLOW}Recargando Nginx...${NC}"
systemctl reload nginx
echo -e "${GREEN}✓ Nginx recargado${NC}"
echo ""

# Verificar puertos
echo -e "${YELLOW}Verificando puertos...${NC}"
netstat -tlnp | grep -E ':(80|443|8000|8001|8080|8081)' || true
echo ""

# Probar health checks
echo -e "${YELLOW}Probando health checks...${NC}"
echo ""

test_endpoint() {
    local url=$1
    local name=$2
    local response=$(curl -s -o /dev/null -w "%{http_code}" $url 2>/dev/null || echo "000")
    
    if [ "$response" = "200" ]; then
        echo -e "  ${GREEN}✓${NC} $name: ${GREEN}OK${NC} (HTTP $response)"
    else
        echo -e "  ${YELLOW}⚠${NC} $name: ${YELLOW}$response${NC}"
    fi
}

test_endpoint "http://localhost:8000/api/health" "card-wars-kingdom.com principal"
test_endpoint "http://localhost:8001/api/health" "card-wars-kingdom.com backup"
test_endpoint "http://localhost:8080/api/health" "cardwars-kingdom.net principal"
test_endpoint "http://localhost:8081/api/health" "cardwars-kingdom.net backup"

echo ""
echo -e "${GREEN}=================================================="
echo "  ✓ Todos los servicios iniciados"
echo "==================================================${NC}"
echo ""
echo "Para ver logs en tiempo real:"
echo "  sudo journalctl -u card-wars-kingdom-app.service -f"
echo "  sudo journalctl -u cardwars-kingdom-site.service -f"
echo ""
echo "Para ver logs de Nginx:"
echo "  sudo tail -f /var/log/nginx/card-wars-kingdom-error.log"
echo "  sudo tail -f /var/log/nginx/cardwars-kingdom-net-error.log"
echo ""
