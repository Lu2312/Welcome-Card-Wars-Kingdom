#!/bin/bash

# Script para verificar el estado del servidor

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}  Card Wars Kingdom - Status Check${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""

echo "1. Systemd Service Status:"
echo "----------------------------"
systemctl is-active cardwars-kingdom-net.service >/dev/null 2>&1 && echo -e "${GREEN}✓ cardwars-kingdom.net: RUNNING${NC}" || echo -e "${RED}✗ cardwars-kingdom.net: STOPPED${NC}"
systemctl is-active nginx.service >/dev/null 2>&1 && echo -e "${GREEN}✓ Nginx: RUNNING${NC}" || echo -e "${RED}✗ Nginx: STOPPED${NC}"
echo ""

echo "2. Listening Ports:"
echo "-------------------"
sudo lsof -i :8080 2>/dev/null | grep LISTEN >/dev/null && echo -e "${GREEN}✓ Port 8080 (Gunicorn)${NC}" || echo -e "${RED}✗ Port 8080 not listening${NC}"
sudo lsof -i :80 2>/dev/null | grep LISTEN >/dev/null && echo -e "${GREEN}✓ Port 80 (Nginx)${NC}" || echo -e "${RED}✗ Port 80 not listening${NC}"
echo ""

echo "3. Health Check Endpoints:"
echo "--------------------------"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/api/health)
if [ "$HTTP_CODE" -eq 200 ]; then
    echo -e "${GREEN}✓ Gunicorn responding (HTTP $HTTP_CODE)${NC}"
else
    echo -e "${RED}✗ Gunicorn not responding (HTTP $HTTP_CODE)${NC}"
fi

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/api/health)
if [ "$HTTP_CODE" -eq 200 ]; then
    echo -e "${GREEN}✓ Nginx responding (HTTP $HTTP_CODE)${NC}"
else
    echo -e "${RED}✗ Nginx not responding (HTTP $HTTP_CODE)${NC}"
fi
echo ""

echo "4. Gunicorn Processes:"
echo "----------------------"
PROCESS_COUNT=$(ps aux | grep gunicorn | grep -v grep | wc -l)
echo "Gunicorn processes running: $PROCESS_COUNT"
echo ""

echo "5. Disk Usage:"
echo "--------------"
df -h /var/www/cardwars-kingdom.net | tail -1
echo ""

echo "6. Memory Usage:"
echo "----------------"
free -h | grep Mem
echo ""

echo "7. Recent Errors (last 5):"
echo "--------------------------"
sudo journalctl -u cardwars-kingdom-net.service -p err -n 5 --no-pager 2>/dev/null || echo "No recent errors"
echo ""

echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}  Check complete!${NC}"
echo -e "${GREEN}=========================================${NC}"
