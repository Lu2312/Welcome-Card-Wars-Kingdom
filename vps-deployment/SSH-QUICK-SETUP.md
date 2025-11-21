# Guía Rápida: Generar y Configurar SSH Key en Windows

## Problema: Scripts de PowerShell bloqueados

Si recibes el error:
```
La ejecución de scripts está deshabilitada en este sistema
```

## ✅ Solución Simple (Comandos Manuales)

### Paso 1: Generar tu clave SSH

Abre PowerShell y ejecuta estos comandos uno por uno:

```powershell
# Ir al directorio home
cd ~

# Verificar si ya tienes una clave SSH
Test-Path .ssh\id_rsa

# Si muestra "False", genera una nueva clave:
ssh-keygen -t rsa -b 4096

# Presiona ENTER 3 veces (para usar ubicación default y sin passphrase)
```

### Paso 2: Ver tu clave pública

```powershell
# Mostrar tu clave pública
Get-Content $env:USERPROFILE\.ssh\id_rsa.pub
```

**Copia toda la línea** que aparece (desde `ssh-rsa` hasta el final)

### Paso 3: Agregar la clave al VPS

**Opción A: Desde la consola web de Digital Ocean (Recomendado)**

1. Ve a: https://cloud.digitalocean.com/droplets
2. Click en tu droplet (IP: 159.89.157.63)
3. Click en **"Access"** (menú lateral)
4. Click en **"Launch Droplet Console"** (abre una terminal en el navegador)
5. En la consola, ejecuta:

```bash
# Crear directorio .ssh
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Editar archivo de claves autorizadas
nano ~/.ssh/authorized_keys
```

6. Pega tu clave pública (la que copiaste en el Paso 2)
7. Guarda el archivo:
   - Presiona `Ctrl + O` (para escribir)
   - Presiona `Enter` (confirmar nombre)
   - Presiona `Ctrl + X` (salir)

8. Establece los permisos correctos:

```bash
chmod 600 ~/.ssh/authorized_keys
```

9. Sal de la consola web (puedes cerrar la pestaña)

### Paso 4: Conectar desde tu PC

En PowerShell:

```powershell
ssh root@159.89.157.63
```

¡Listo! Deberías conectarte sin problemas 🎉

---

## 🔧 Alternativa: Habilitar ejecución de scripts

Si prefieres usar los scripts de PowerShell, ejecuta esto **como Administrador**:

```powershell
# Abrir PowerShell como Administrador (clic derecho -> "Ejecutar como administrador")
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Luego ya puedes ejecutar:
cd "C:\Users\Luis Flores\Documents\GITHUB\Welcome-Card-Wars-Kingdom\vps-deployment\scripts"
.\setup-ssh-key.ps1
```

---

## 📋 Resumen Rápido

```powershell
# 1. Generar clave SSH (si no existe)
ssh-keygen -t rsa -b 4096

# 2. Ver tu clave pública
Get-Content $env:USERPROFILE\.ssh\id_rsa.pub

# 3. Copiar esa clave al VPS (usando consola web de Digital Ocean)

# 4. Conectar
ssh root@159.89.157.63
```

---

## 🆘 Si sigues teniendo problemas

### Verificar que OpenSSH está instalado:

```powershell
Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*'
```

Si no está instalado:

```powershell
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
```

### Probar la conexión con verbose para ver el error:

```powershell
ssh -v root@159.89.157.63
```

Esto te mostrará más detalles sobre qué está fallando.

---

## 📹 Video Tutorial (si prefieres visual)

1. **Generar SSH Key**: https://www.youtube.com/watch?v=2LlYlVr4hSk
2. **Agregar a Digital Ocean**: https://www.youtube.com/watch?v=D3H3VKGvPWE

---

## ✅ Próximo paso después de conectarte

Una vez que puedas hacer `ssh root@159.89.157.63`, ejecuta en el VPS:

```bash
cd /tmp
git clone https://github.com/Lu2312/Welcome-Card-Wars-Kingdom.git
cd Welcome-Card-Wars-Kingdom/vps-deployment
bash scripts/setup-vps.sh
```

Esto instalará todo automáticamente en tu VPS.
