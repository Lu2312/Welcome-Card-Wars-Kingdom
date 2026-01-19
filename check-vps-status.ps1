# Script para verificar el estado de los servicios en la VPS
# Uso: .\check-vps-status.ps1

$VPS_HOST = "root@159.89.157.63"

Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "  Estado de Servicios - Card Wars Kingdom" -ForegroundColor Cyan
Write-Host "============================================`n" -ForegroundColor Cyan

# Verificar conexión
$testConnection = ssh -o ConnectTimeout=5 $VPS_HOST "echo 'OK'" 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Error: No se puede conectar a la VPS" -ForegroundColor Red
    exit 1
}

# Obtener información detallada
ssh $VPS_HOST @"
# Colores para bash
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo "========================================="
echo " SERVICIOS SYSTEMD"
echo "========================================="

check_service() {
    local service=\$1
    local name=\$2
    local port=\$3
    
    if systemctl is-active --quiet \$service; then
        echo -e "  \${GREEN}✓\${NC} \$name (puerto \$port): \${GREEN}ACTIVO\${NC}"
        
        # Mostrar uptime
        local uptime=\$(systemctl show -p ActiveEnterTimestamp \$service | cut -d= -f2)
        echo "      Activo desde: \$uptime"
        
        # Verificar si el puerto está escuchando
        if ss -tlnp | grep -q ":\$port "; then
            echo -e "      Puerto \$port: \${GREEN}Escuchando\${NC}"
        else
            echo -e "      Puerto \$port: \${RED}No escuchando\${NC}"
        fi
    else
        echo -e "  \${RED}✗\${NC} \$name (puerto \$port): \${RED}INACTIVO\${NC}"
    fi
    echo ""
}

# card-wars-kingdom.com (Aplicación)
echo ""
echo "card-wars-kingdom.com (Aplicación principal):"
check_service "card-wars-kingdom-com.service" "Servicio Principal" "8001"

# cardwars-kingdom.net (Sitio Web)
echo "cardwars-kingdom.net (Sitio Web):"
check_service "cardwars-kingdom-net.service" "Servicio Principal" "8000"

# Nginx
echo "Nginx (Reverse Proxy):"
if systemctl is-active --quiet nginx; then
    echo -e "  \${GREEN}✓\${NC} Nginx: \${GREEN}ACTIVO\${NC}"
    echo "      Puertos HTTP/HTTPS: 80, 443"
else
    echo -e "  \${RED}✗\${NC} Nginx: \${RED}INACTIVO\${NC}"
fi

echo ""
echo "========================================="
echo " USO DE RECURSOS"
echo "========================================="
echo ""

# CPU y Memoria
echo "CPU y Memoria:"
top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print "  CPU en uso: " 100 - \$1 "%"}'
free -h | awk 'NR==2{printf "  Memoria: %s / %s (%.2f%%)\n", \$3, \$2, \$3*100/\$2}'

echo ""

# Espacio en disco
echo "Espacio en disco:"
df -h / | awk 'NR==2{printf "  Disco /: %s / %s (%s usado)\n", \$3, \$2, \$5}'

echo ""
echo "========================================="
echo " LOGS RECIENTES"
echo "========================================="
echo ""

# Últimas líneas de logs con errores
echo "Errores recientes en los servicios (últimas 24h):"
journalctl --since "24 hours ago" -u card-wars-kingdom-com.service -u cardwars-kingdom-net.service --no-pager -p err | tail -n 5

if [ \$? -eq 0 ]; then
    echo -e "  \${GREEN}No hay errores recientes\${NC}"
fi

echo ""
echo "========================================="
echo " INFORMACIÓN DE RED"
echo "========================================="
echo ""

# Verificar puertos
echo "Puertos en escucha:"
ss -tlnp | grep -E ":(80|443|8000|8001) " | awk '{print "  " \$4 " - " \$6}'

echo ""
"@

Write-Host "============================================`n" -ForegroundColor Cyan
