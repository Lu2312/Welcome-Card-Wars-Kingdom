#!/bin/bash

# Script para reiniciar todos los servicios
# Ejecutar: sudo bash restart-services.sh

echo "=================================================="
echo "  Reiniciando servicios Card Wars Kingdom"
echo "=================================================="
echo ""

systemctl restart card-wars-kingdom-app.service
echo "  • Reiniciado: card-wars-kingdom-app.service"

systemctl restart card-wars-kingdom-app-backup.service
echo "  • Reiniciado: card-wars-kingdom-app-backup.service"

systemctl restart cardwars-kingdom-site.service
echo "  • Reiniciado: cardwars-kingdom-site.service"

systemctl restart cardwars-kingdom-site-backup.service
echo "  • Reiniciado: cardwars-kingdom-site-backup.service"

echo ""
systemctl reload nginx
echo "  • Recargado: nginx"

echo ""
echo "✓ Todos los servicios reiniciados"
echo ""

# Mostrar estado
systemctl status card-wars-kingdom-app.service --no-pager -l
systemctl status cardwars-kingdom-site.service --no-pager -l
