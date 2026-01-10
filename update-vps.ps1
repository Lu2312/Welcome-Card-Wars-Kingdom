# Script para actualizar el repositorio Welcome-Card-Wars-Kingdom en la VPS
# Uso: .\update-vps.ps1

$VPS_HOST = "root@159.89.157.63"
$PROJECT_PATH = "/var/www/cardwars-kingdom"

Write-Host "`n================================================" -ForegroundColor Green
Write-Host "  Actualizando Welcome-Card-Wars-Kingdom en VPS" -ForegroundColor Green
Write-Host "================================================`n" -ForegroundColor Green

# Verificar conexión SSH
Write-Host "[1/5] Verificando conexión a VPS..." -ForegroundColor Yellow
$testConnection = ssh -o ConnectTimeout=5 $VPS_HOST "echo 'OK'"
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Error: No se puede conectar a la VPS" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Conexión establecida`n" -ForegroundColor Green

# Respaldar cambios locales en la VPS (si los hay)
Write-Host "[2/5] Verificando estado del repositorio..." -ForegroundColor Yellow
ssh $VPS_HOST "cd $PROJECT_PATH && git status"
Write-Host ""

# Confirmar actualización
$confirmation = Read-Host "¿Deseas continuar con la actualización? (S/N)"
if ($confirmation -ne "S" -and $confirmation -ne "s") {
    Write-Host "Actualización cancelada" -ForegroundColor Yellow
    exit 0
}

# Actualizar código desde GitHub
Write-Host "`n[3/5] Actualizando código desde GitHub..." -ForegroundColor Yellow
ssh $VPS_HOST @"
cd $PROJECT_PATH
git fetch origin
git reset --hard origin/main
git pull origin main
"@
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Error al actualizar el repositorio" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Código actualizado`n" -ForegroundColor Green

# Instalar dependencias
Write-Host "[4/5] Instalando dependencias..." -ForegroundColor Yellow
ssh $VPS_HOST @"
cd $PROJECT_PATH
source venv/bin/activate
pip install -r requirements.txt --quiet
deactivate
"@
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Error al instalar dependencias" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Dependencias instaladas`n" -ForegroundColor Green

# Reiniciar servicios
Write-Host "[5/5] Reiniciando servicios..." -ForegroundColor Yellow
ssh $VPS_HOST @"
systemctl restart cardwars-kingdom-net.service
sleep 3
"@
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Error al reiniciar servicios" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Servicios reiniciados`n" -ForegroundColor Green

# Verificar estado de los servicios
Write-Host "Verificando estado de los servicios:" -ForegroundColor Cyan
ssh $VPS_HOST @"
echo "  cardwars-kingdom.net (puerto 8000):"
systemctl is-active cardwars-kingdom-net.service && echo "    Status: Active ✓" || echo "    Status: Inactive ✗"
"@

Write-Host "`n================================================" -ForegroundColor Green
Write-Host "  ✓ Actualización completada exitosamente" -ForegroundColor Green
Write-Host "================================================`n" -ForegroundColor Green

Write-Host "Accede a tu sitio en: https://cardwars-kingdom.net`n" -ForegroundColor Cyan
