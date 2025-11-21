# Script para configurar SSH key en Windows para conectarse al VPS
# Ejecutar en PowerShell: .\setup-ssh-key.ps1

Write-Host "=================================================="
Write-Host "  Configuración de SSH Key para VPS"
Write-Host "=================================================="
Write-Host ""

$sshDir = "$env:USERPROFILE\.ssh"
$keyPath = "$sshDir\id_rsa"
$pubKeyPath = "$keyPath.pub"

# Verificar si ya existe una clave SSH
if (Test-Path $keyPath) {
    Write-Host "✓ Ya tienes una clave SSH en: $keyPath" -ForegroundColor Green
    Write-Host ""
    
    # Mostrar la clave pública
    if (Test-Path $pubKeyPath) {
        Write-Host "Tu clave pública es:" -ForegroundColor Yellow
        Write-Host ""
        Get-Content $pubKeyPath
        Write-Host ""
    }
} else {
    # Crear directorio .ssh si no existe
    if (-not (Test-Path $sshDir)) {
        New-Item -ItemType Directory -Path $sshDir | Out-Null
    }
    
    Write-Host "Generando nueva clave SSH..." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Presiona ENTER cuando te pida un passphrase (o escribe uno para mayor seguridad)" -ForegroundColor Cyan
    Write-Host ""
    
    # Generar clave SSH
    ssh-keygen -t rsa -b 4096 -f $keyPath
    
    Write-Host ""
    Write-Host "✓ Clave SSH generada exitosamente" -ForegroundColor Green
    Write-Host ""
}

# Mostrar instrucciones
Write-Host "=================================================="
Write-Host "  SIGUIENTE PASO"
Write-Host "=================================================="
Write-Host ""
Write-Host "Necesitas agregar tu clave pública al VPS. Tienes 2 opciones:" -ForegroundColor Yellow
Write-Host ""
Write-Host "OPCIÓN 1: Usar el panel de Digital Ocean" -ForegroundColor Cyan
Write-Host "  1. Copia tu clave pública (está abajo)"
Write-Host "  2. Ve a: https://cloud.digitalocean.com/account/security"
Write-Host "  3. Click en 'Add SSH Key'"
Write-Host "  4. Pega tu clave y dale un nombre"
Write-Host "  5. Reinicia tu droplet desde el panel de Digital Ocean"
Write-Host ""
Write-Host "OPCIÓN 2: Usar contraseña temporal (si la tienes)" -ForegroundColor Cyan
Write-Host "  Ejecuta: .\add-ssh-to-vps.ps1"
Write-Host ""
Write-Host "=================================================="
Write-Host "  TU CLAVE PÚBLICA (cópiala)"
Write-Host "=================================================="
Write-Host ""

if (Test-Path $pubKeyPath) {
    Get-Content $pubKeyPath | Write-Host -ForegroundColor Green
} else {
    Write-Host "Error: No se pudo encontrar la clave pública" -ForegroundColor Red
}

Write-Host ""
Write-Host "=================================================="
Write-Host ""
Write-Host "Después de agregar la clave, podrás conectarte con:" -ForegroundColor Yellow
Write-Host "  ssh root@159.89.157.63" -ForegroundColor Green
Write-Host ""
