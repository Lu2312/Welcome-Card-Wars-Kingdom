# Script para agregar tu clave SSH al VPS (si tienes contraseña temporal)
# Ejecutar en PowerShell: .\add-ssh-to-vps.ps1

Write-Host "=================================================="
Write-Host "  Agregar SSH Key al VPS"
Write-Host "=================================================="
Write-Host ""

$vpsIP = "159.89.157.63"
$pubKeyPath = "$env:USERPROFILE\.ssh\id_rsa.pub"

# Verificar que existe la clave pública
if (-not (Test-Path $pubKeyPath)) {
    Write-Host "❌ Error: No se encuentra la clave SSH pública" -ForegroundColor Red
    Write-Host "Primero ejecuta: .\setup-ssh-key.ps1" -ForegroundColor Yellow
    exit 1
}

Write-Host "Este script intentará copiar tu clave SSH al VPS" -ForegroundColor Yellow
Write-Host "Necesitarás la contraseña de root del VPS" -ForegroundColor Yellow
Write-Host ""
Write-Host "VPS: $vpsIP" -ForegroundColor Cyan
Write-Host ""

# Leer la clave pública
$pubKey = Get-Content $pubKeyPath

Write-Host "Conectando al VPS..." -ForegroundColor Yellow
Write-Host ""

# Comando para ejecutar en el VPS
$command = @"
mkdir -p ~/.ssh && \
chmod 700 ~/.ssh && \
echo '$pubKey' >> ~/.ssh/authorized_keys && \
chmod 600 ~/.ssh/authorized_keys && \
echo 'Clave SSH agregada exitosamente'
"@

# Intentar copiar la clave
ssh root@$vpsIP $command

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✓ Clave SSH agregada al VPS exitosamente" -ForegroundColor Green
    Write-Host ""
    Write-Host "Ahora puedes conectarte sin contraseña:" -ForegroundColor Yellow
    Write-Host "  ssh root@$vpsIP" -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "❌ No se pudo agregar la clave SSH" -ForegroundColor Red
    Write-Host ""
    Write-Host "Si no tienes la contraseña, usa la Opción 1 de setup-ssh-key.ps1" -ForegroundColor Yellow
    Write-Host "(agregar la clave desde el panel de Digital Ocean)" -ForegroundColor Yellow
    Write-Host ""
}
