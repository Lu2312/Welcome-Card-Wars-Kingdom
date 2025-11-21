#!/bin/bash

# Script para verificar el estado de ambos hosts

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔══════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Verificación de Hosts - Card Wars      ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════╝${NC}"
echo ""

# Función para verificar un servicio
check_service() {
    local service_name=$1
    echo -e "${YELLOW}Verificando: ${service_name}${NC}"
    
    if systemctl is-active --quiet $service_name; then
        echo -e "  ${GREEN}✓ Servicio activo${NC}"
        return 0
    else
        echo -e "  ${RED}✗ Servicio inactivo${NC}"
        return 1
    fi
}

# Función para verificar puerto
check_port() {
    local port=$1
    local name=$2
    
    if netstat -tlnp 2>/dev/null | grep -q ":$port "; then
        echo -e "  ${GREEN}✓ Puerto $port activo ($name)${NC}"
        return 0
    else
        echo -e "  ${RED}✗ Puerto $port no responde ($name)${NC}"
        return 1
    fi
}

# Función para verificar URL
check_url() {
    local url=$1
    local name=$2
    
    if curl -s -o /dev/null -w "%{http_code}" --max-time 5 "$url" | grep -q "200\|301\|302"; then
        echo -e "  ${GREEN}✓ $name accesible${NC}"
        return 0
    else
        echo -e "  ${RED}✗ $name no accesible${NC}"
        return 1
    fi
}

echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo -e "${BLUE}1. VERIFICANDO SERVICIOS SYSTEMD${NC}"
echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo ""

# Verificar servicios de card-wars-kingdom.com
echo -e "${YELLOW}card-wars-kingdom.com:${NC}"
check_service "card-wars-kingdom-app.service"
check_service "card-wars-kingdom-app-backup.service"
echo ""

# Verificar servicios de cardwars-kingdom.net
echo -e "${YELLOW}cardwars-kingdom.net:${NC}"
check_service "cardwars-kingdom-site.service" || check_service "cardwars-kingdom-net.service"
check_service "cardwars-kingdom-site-backup.service" || echo -e "  ${YELLOW}⚠ Servicio backup no encontrado${NC}"
echo ""

# Verificar Nginx
echo -e "${YELLOW}Nginx:${NC}"
check_service "nginx.service"
echo ""

echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo -e "${BLUE}2. VERIFICANDO PUERTOS${NC}"
echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo ""

check_port "80" "HTTP"
check_port "443" "HTTPS"
check_port "8000" "card-wars-kingdom.com principal"
check_port "8001" "card-wars-kingdom.com backup"
check_port "8080" "cardwars-kingdom.net principal"
check_port "8081" "cardwars-kingdom.net backup"
echo ""

echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo -e "${BLUE}3. VERIFICANDO URLS LOCALES${NC}"
echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo ""

echo -e "${YELLOW}card-wars-kingdom.com (puertos internos):${NC}"
check_url "http://localhost:8000" "Puerto 8000"
check_url "http://localhost:8001" "Puerto 8001 (backup)"
echo ""

echo -e "${YELLOW}cardwars-kingdom.net (puertos internos):${NC}"
check_url "http://localhost:8080" "Puerto 8080"
check_url "http://localhost:8081" "Puerto 8081 (backup)"
echo ""

echo -e "${YELLOW}Nginx (puerto 80):${NC}"
check_url "http://localhost" "Localhost HTTP"
echo ""

echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo -e "${BLUE}4. VERIFICANDO DOMINIOS PÚBLICOS${NC}"
echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo ""

echo -e "${YELLOW}card-wars-kingdom.com:${NC}"
check_url "https://card-wars-kingdom.com" "https://card-wars-kingdom.com"
check_url "https://www.card-wars-kingdom.com" "https://www.card-wars-kingdom.com"
echo ""

echo -e "${YELLOW}cardwars-kingdom.net:${NC}"
check_url "https://cardwars-kingdom.net" "https://cardwars-kingdom.net"
check_url "https://www.cardwars-kingdom.net" "https://www.cardwars-kingdom.net"
echo ""

echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo -e "${BLUE}5. VERIFICANDO DNS${NC}"
echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo ""

SERVER_IP=$(curl -s ifconfig.me)
echo -e "${YELLOW}IP del servidor: ${GREEN}$SERVER_IP${NC}"
echo ""

echo -e "${YELLOW}DNS card-wars-kingdom.com:${NC}"
DNS1=$(dig +short card-wars-kingdom.com @8.8.8.8 | tail -n1)
if [[ $DNS1 =~ ^(104\.|172\.|162\.|198\.|141\.) ]]; then
    echo -e "  ${GREEN}✓ Apuntando a Cloudflare: $DNS1${NC}"
else
    echo -e "  ${YELLOW}⚠ DNS: $DNS1${NC}"
fi

echo -e "${YELLOW}DNS cardwars-kingdom.net:${NC}"
DNS2=$(dig +short cardwars-kingdom.net @8.8.8.8 | tail -n1)
if [[ $DNS2 =~ ^(104\.|172\.|162\.|198\.|141\.) ]]; then
    echo -e "  ${GREEN}✓ Apuntando a Cloudflare: $DNS2${NC}"
else
    echo -e "  ${YELLOW}⚠ DNS: $DNS2${NC}"
fi
echo ""

echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo -e "${BLUE}6. VERIFICANDO CERTIFICADOS SSL${NC}"
echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo ""

echo -e "${YELLOW}Certificados locales:${NC}"
if [ -f "/etc/ssl/certs/card-wars-kingdom.com.crt" ]; then
    echo -e "  ${GREEN}✓ card-wars-kingdom.com.crt existe${NC}"
else
    echo -e "  ${RED}✗ card-wars-kingdom.com.crt no encontrado${NC}"
fi

if [ -f "/etc/ssl/certs/cardwars-kingdom.net.crt" ]; then
    echo -e "  ${GREEN}✓ cardwars-kingdom.net.crt existe${NC}"
else
    echo -e "  ${RED}✗ cardwars-kingdom.net.crt no encontrado${NC}"
fi

if [ -f "/etc/ssl/certs/cloudflare-origin-pull.crt" ]; then
    echo -e "  ${GREEN}✓ cloudflare-origin-pull.crt existe${NC}"
else
    echo -e "  ${RED}✗ cloudflare-origin-pull.crt no encontrado${NC}"
fi
echo ""

echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo -e "${BLUE}7. VERIFICANDO LOGS RECIENTES${NC}"
echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo ""

echo -e "${YELLOW}Últimos 5 errores de Nginx:${NC}"
if [ -f "/var/log/nginx/error.log" ]; then
    sudo tail -5 /var/log/nginx/error.log | while read line; do
        echo -e "  ${RED}$line${NC}"
    done
else
    echo -e "  ${GREEN}No hay log de errores${NC}"
fi
echo ""

echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo -e "${BLUE}RESUMEN${NC}"
echo -e "${BLUE}═══════════════════════════════════════════${NC}"
echo ""

# Contar servicios activos
ACTIVE_SERVICES=0
TOTAL_SERVICES=0

for service in card-wars-kingdom-app.service card-wars-kingdom-app-backup.service cardwars-kingdom-site.service cardwars-kingdom-net.service nginx.service; do
    if systemctl list-units --full -all | grep -q "$service"; then
        TOTAL_SERVICES=$((TOTAL_SERVICES + 1))
        if systemctl is-active --quiet $service; then
            ACTIVE_SERVICES=$((ACTIVE_SERVICES + 1))
        fi
    fi
done

echo -e "Servicios activos: ${GREEN}$ACTIVE_SERVICES${NC}/$TOTAL_SERVICES"

# Verificar accesibilidad web
WEB_OK=0
WEB_TOTAL=4

curl -s -o /dev/null -w "%{http_code}" --max-time 5 "https://card-wars-kingdom.com" | grep -q "200\|301\|302" && WEB_OK=$((WEB_OK + 1))
curl -s -o /dev/null -w "%{http_code}" --max-time 5 "https://www.card-wars-kingdom.com" | grep -q "200\|301\|302" && WEB_OK=$((WEB_OK + 1))
curl -s -o /dev/null -w "%{http_code}" --max-time 5 "https://cardwars-kingdom.net" | grep -q "200\|301\|302" && WEB_OK=$((WEB_OK + 1))
curl -s -o /dev/null -w "%{http_code}" --max-time 5 "https://www.cardwars-kingdom.net" | grep -q "200\|301\|302" && WEB_OK=$((WEB_OK + 1))

echo -e "URLs accesibles: ${GREEN}$WEB_OK${NC}/$WEB_TOTAL"
echo ""

if [ $ACTIVE_SERVICES -eq $TOTAL_SERVICES ] && [ $WEB_OK -eq $WEB_TOTAL ]; then
    echo -e "${GREEN}╔══════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║     ✓ TODO FUNCIONANDO CORRECTAMENTE    ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════╝${NC}"
else
    echo -e "${YELLOW}╔══════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║  ⚠ ALGUNOS SERVICIOS TIENEN PROBLEMAS   ║${NC}"
    echo -e "${YELLOW}╚══════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}Comandos útiles para diagnóstico:${NC}"
    echo -e "  sudo systemctl status card-wars-kingdom-app.service"
    echo -e "  sudo systemctl status cardwars-kingdom-net.service"
    echo -e "  sudo journalctl -u nginx.service -n 50"
    echo -e "  sudo tail -f /var/log/nginx/error.log"
fi

echo ""
