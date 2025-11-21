#!/bin/bash

# Script para ver logs del servidor

GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}Card Wars Kingdom - Logs${NC}"
echo "=========================="
echo ""
echo "Opciones:"
echo "1. Ver logs de systemd (últimas 50 líneas)"
echo "2. Ver logs de systemd (tiempo real)"
echo "3. Ver logs de Gunicorn (access)"
echo "4. Ver logs de Gunicorn (error)"
echo "5. Ver logs de Nginx (access)"
echo "6. Ver logs de Nginx (error)"
echo ""
read -p "Selecciona una opción (1-6): " option

case $option in
    1)
        sudo journalctl -u cardwars-kingdom-net.service -n 50 --no-pager
        ;;
    2)
        echo "Presiona Ctrl+C para salir"
        sudo journalctl -u cardwars-kingdom-net.service -f
        ;;
    3)
        sudo tail -f /var/log/gunicorn/cardwars-kingdom-net-access.log
        ;;
    4)
        sudo tail -f /var/log/gunicorn/cardwars-kingdom-net-error.log
        ;;
    5)
        sudo tail -f /var/log/nginx/cardwars-kingdom-net-access.log
        ;;
    6)
        sudo tail -f /var/log/nginx/cardwars-kingdom-net-error.log
        ;;
    *)
        echo "Opción inválida"
        ;;
esac
