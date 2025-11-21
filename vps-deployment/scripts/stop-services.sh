#!/bin/bash

# Script para detener todos los servicios
# Ejecutar: sudo bash stop-services.sh

echo "=================================================="
echo "  Deteniendo servicios Card Wars Kingdom"
echo "=================================================="
echo ""

systemctl stop card-wars-kingdom-app.service
systemctl stop card-wars-kingdom-app-backup.service
systemctl stop cardwars-kingdom-site.service
systemctl stop cardwars-kingdom-site-backup.service

echo "✓ Todos los servicios detenidos"
echo ""
