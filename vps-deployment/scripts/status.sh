#!/bin/bash

# Script para ver el estado de todos los servicios
# Ejecutar: bash status.sh

echo "=================================================="
echo "  Estado de Card Wars Kingdom"
echo "=================================================="
echo ""

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

check_service() {
    local service=$1
    local port=$2
    local status=$(systemctl is-active $service 2>/dev/null || echo "inactive")
    
    if [ "$status" = "active" ]; then
        echo -e "  ${GREEN}✓${NC} $service (puerto $port): ${GREEN}RUNNING${NC}"
    else
        echo -e "  ${RED}✗${NC} $service (puerto $port): ${RED}STOPPED${NC}"
    fi
}

echo -e "${YELLOW}Servicios Gunicorn:${NC}"
check_service card-wars-kingdom-app.service 8000
check_service card-wars-kingdom-app-backup.service 8001
check_service cardwars-kingdom-site.service 8080
check_service cardwars-kingdom-site-backup.service 8081

echo ""
echo -e "${YELLOW}Nginx:${NC}"
check_service nginx 80/443

echo ""
echo -e "${YELLOW}Puertos en uso:${NC}"
netstat -tlnp 2>/dev/null | grep -E ':(80|443|8000|8001|8080|8081)' | awk '{print "  "$4" -> "$7}' || echo "  (netstat no disponible)"

echo ""
echo -e "${YELLOW}Health checks:${NC}"

test_endpoint() {
    local url=$1
    local name=$2
    local response=$(curl -s -o /dev/null -w "%{http_code}" $url 2>/dev/null || echo "000")
    
    if [ "$response" = "200" ]; then
        echo -e "  ${GREEN}✓${NC} $name: ${GREEN}OK${NC}"
    else
        echo -e "  ${RED}✗${NC} $name: ${RED}$response${NC}"
    fi
}

test_endpoint "http://localhost:8000/api/health" "card-wars-kingdom.com:8000"
test_endpoint "http://localhost:8001/api/health" "card-wars-kingdom.com:8001"
test_endpoint "http://localhost:8080/api/health" "cardwars-kingdom.net:8080"
test_endpoint "http://localhost:8081/api/health" "cardwars-kingdom.net:8081"

echo ""
echo -e "${YELLOW}Espacio en disco:${NC}"
df -h / | tail -n 1 | awk '{print "  Usado: "$3" / "$2" ("$5")"}'

echo ""
echo -e "${YELLOW}Memoria:${NC}"
free -h | grep Mem | awk '{print "  Usado: "$3" / "$2}'

echo ""
echo -e "${YELLOW}Últimos logs de error:${NC}"
echo "  card-wars-kingdom.com:"
journalctl -u card-wars-kingdom-app.service -n 3 --no-pager 2>/dev/null | tail -n 3 | sed 's/^/    /' || echo "    (no logs disponibles)"

echo ""
echo "  cardwars-kingdom.net:"
journalctl -u cardwars-kingdom-site.service -n 3 --no-pager 2>/dev/null | tail -n 3 | sed 's/^/    /' || echo "    (no logs disponibles)"

echo ""
echo "=================================================="
echo ""
