# Script para actualizar AMBOS repositorios en la VPS
# Uso: .\update-both-projects-vps.ps1

$VPS_HOST = "root@159.89.157.63"
$PROJECT1_PATH = "/var/www/cardwarskingdomrvd"
$PROJECT2_PATH = "/var/www/cardwars-kingdom"

Write-Host "`n========================================================" -ForegroundColor Green
Write-Host "  Actualizando AMBOS proyectos Card Wars Kingdom en VPS" -ForegroundColor Green
Write-Host "========================================================`n" -ForegroundColor Green

# Verificar conexión SSH
Write-Host "[1/7] Verificando conexión a VPS..." -ForegroundColor Yellow
$testConnection = ssh -o ConnectTimeout=5 $VPS_HOST "echo 'OK'"
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Error: No se puede conectar a la VPS" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Conexión establecida`n" -ForegroundColor Green

# Actualizar card-wars-kingdom.com (Aplicación principal)
Write-Host "[2/7] Actualizando card-wars-kingdom.com..." -ForegroundColor Yellow
ssh $VPS_HOST @"
cd $PROJECT1_PATH
git fetch origin
git pull origin main
source venv/bin/activate
pip install -r requirements.txt --quiet
deactivate
"@
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Error al actualizar card-wars-kingdom.com" -ForegroundColor Red
} else {
    Write-Host "✓ card-wars-kingdom.com actualizado`n" -ForegroundColor Green
}

# Actualizar cardwars-kingdom.net (Sitio web)
Write-Host "[3/7] Actualizando cardwars-kingdom.net..." -ForegroundColor Yellow
ssh $VPS_HOST @"
cd $PROJECT2_PATH
git fetch origin
git pull origin main
source venv/bin/activate
pip install -r requirements.txt --quiet
deactivate
"@
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Error al actualizar cardwars-kingdom.net" -ForegroundColor Red
} else {
    Write-Host "✓ cardwars-kingdom.net actualizado`n" -ForegroundColor Green
}

# Reiniciar servicios de card-wars-kingdom.com
Write-Host "[4/7] Reiniciando servicios de card-wars-kingdom.com..." -ForegroundColor Yellow
ssh $VPS_HOST @"
systemctl restart card-wars-kingdom-com.service
"@
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Error al reiniciar servicios de card-wars-kingdom.com" -ForegroundColor Red
} else {
    Write-Host "✓ Servicios de card-wars-kingdom.com reiniciados`n" -ForegroundColor Green
}

# Reiniciar servicios de cardwars-kingdom.net
Write-Host "[5/7] Reiniciando servicios de cardwars-kingdom.net..." -ForegroundColor Yellow
ssh $VPS_HOST @"
systemctl restart cardwars-kingdom-net.service
"@
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Error al reiniciar servicios de cardwars-kingdom.net" -ForegroundColor Red
} else {
    Write-Host "✓ Servicios de cardwars-kingdom.net reiniciados`n" -ForegroundColor Green
}

# Esperar a que los servicios se estabilicen
Write-Host "[6/7] Esperando estabilización de servicios..." -ForegroundColor Yellow
Start-Sleep -Seconds 5
Write-Host "✓ Listo`n" -ForegroundColor Green

# Verificar estado de todos los servicios
Write-Host "[7/7] Verificando estado de todos los servicios:" -ForegroundColor Cyan
ssh $VPS_HOST @"
echo ""
echo "card-wars-kingdom.com (Aplicación):"
echo "  - Servicio principal:"
systemctl is-active card-wars-kingdom-com.service && echo "      Status: Active ✓" || echo "      Status: Inactive ✗"

echo ""
echo "cardwars-kingdom.net (Sitio Web):"
echo "  - Servicio principal:"
systemctl is-active cardwars-kingdom-net.service && echo "      Status: Active ✓" || echo "      Status: Inactive ✗"

echo ""
echo "Nginx:"
systemctl is-active nginx && echo "      Status: Active ✓" || echo "      Status: Inactive ✗"
"@

Write-Host "`n========================================================" -ForegroundColor Green
Write-Host "  ✓ Actualización de ambos proyectos completada" -ForegroundColor Green
Write-Host "========================================================`n" -ForegroundColor Green

Write-Host "Sitios disponibles:" -ForegroundColor Cyan
Write-Host "  - Aplicación: https://card-wars-kingdom.com" -ForegroundColor White
Write-Host "  - Sitio Web:  https://cardwars-kingdom.net`n" -ForegroundColor White
