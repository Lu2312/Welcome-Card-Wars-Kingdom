# Guía: Configurar SSH para conectarte al VPS desde Windows

## Problema

Cuando intentas conectarte al VPS:
```powershell
ssh root@159.89.157.63
```

Recibes el error:
```
root@159.89.157.63: Permission denied (publickey).
```

Esto significa que el VPS solo acepta autenticación por clave SSH, no por contraseña.

---

## ✅ Solución 1: Configurar desde el Panel de Digital Ocean (Recomendado)

### Paso 1: Generar clave SSH en tu PC

Abre PowerShell en tu PC y ejecuta:

```powershell
cd "C:\Users\Luis Flores\Documents\GITHUB\Welcome-Card-Wars-Kingdom\vps-deployment\scripts"
.\setup-ssh-key.ps1
```

Este script:
- Verifica si ya tienes una clave SSH
- Si no existe, genera una nueva clave RSA 4096 bits
- Muestra tu clave pública para copiarla

### Paso 2: Copiar tu clave pública

El script mostrará tu clave pública (algo como):
```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDXxxx...xxx usuario@computadora
```

**Cópiala completamente** (desde `ssh-rsa` hasta el final)

### Paso 3: Agregar la clave en Digital Ocean

1. Ve a tu cuenta de Digital Ocean: https://cloud.digitalocean.com/account/security
2. En la sección **"SSH Keys"**, click en **"Add SSH Key"**
3. Pega tu clave pública en el campo **"SSH Key Content"**
4. Dale un nombre descriptivo (ej: "Mi PC Local Windows")
5. Click en **"Add SSH Key"**

### Paso 4: Agregar la clave al Droplet existente

**Opción A: Desde la consola web de Digital Ocean**

1. Ve a tu Droplet: https://cloud.digitalocean.com/droplets
2. Click en tu droplet (159.89.157.63)
3. Click en **"Access"** en el menú lateral
4. Click en **"Launch Droplet Console"** (se abre una consola en el navegador)
5. Inicia sesión como root (te pedirá contraseña si la tienes)
6. Ejecuta estos comandos:

```bash
# Crear directorio .ssh si no existe
mkdir -p ~/.ssh
chmod 700 ~/.ssh

# Editar archivo de claves autorizadas
nano ~/.ssh/authorized_keys
```

7. Pega tu clave pública al final del archivo
8. Guarda el archivo (Ctrl+O, Enter, Ctrl+X)
9. Establece permisos correctos:

```bash
chmod 600 ~/.ssh/authorized_keys
```

**Opción B: Recrear el Droplet (si no tienes nada importante)**

Si tu droplet es nuevo y no tiene datos importantes:

1. Ve a: https://cloud.digitalocean.com/droplets
2. Click en tu droplet
3. Click en **"Destroy"** (confirma)
4. Crea un nuevo droplet:
   - Selecciona Ubuntu 22.04 LTS
   - Elige el plan (mismo que tenías)
   - En **"Authentication"**, selecciona **"SSH Keys"** y marca tu clave recién agregada
   - Mismo datacenter que antes
   - Click **"Create Droplet"**

### Paso 5: Probar conexión

En PowerShell:

```powershell
ssh root@159.89.157.63
```

Ahora deberías conectarte sin problemas 🎉

---

## ✅ Solución 2: Si tienes contraseña temporal del VPS

Si Digital Ocean te dio una contraseña temporal por email:

### Paso 1: Generar clave SSH

```powershell
cd "C:\Users\Luis Flores\Documents\GITHUB\Welcome-Card-Wars-Kingdom\vps-deployment\scripts"
.\setup-ssh-key.ps1
```

### Paso 2: Copiar clave al VPS

```powershell
.\add-ssh-to-vps.ps1
```

Te pedirá la contraseña del VPS. Después de ingresarla, tu clave SSH se copiará automáticamente.

### Paso 3: Probar conexión

```powershell
ssh root@159.89.157.63
```

---

## 🔧 Verificar si tu clave SSH ya existe

```powershell
# Ver si ya tienes una clave
ls $env:USERPROFILE\.ssh\

# Ver tu clave pública
Get-Content $env:USERPROFILE\.ssh\id_rsa.pub
```

---

## 📝 Notas Importantes

1. **La clave privada (`id_rsa`) NUNCA se comparte** - quédate con ella en tu PC
2. **La clave pública (`id_rsa.pub`)** - es la que agregas al servidor
3. Si usas múltiples computadoras, cada una necesita su propia clave SSH agregada al VPS
4. Guarda tu clave privada de forma segura - si la pierdes, no podrás acceder al VPS

---

## 🐛 Troubleshooting

### Error: "ssh: command not found"

Instala OpenSSH en Windows:

```powershell
# Verificar si OpenSSH está instalado
Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*'

# Instalar OpenSSH Cliente
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
```

### Error: "Permission denied (publickey)" sigue apareciendo

Verifica los permisos en el VPS (desde la consola web de DO):

```bash
ls -la ~/.ssh/
# Debería mostrar:
# drwx------ (700) para .ssh/
# -rw------- (600) para authorized_keys

# Corregir permisos si es necesario
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

### No tengo contraseña del VPS y no puedo acceder

Opciones:

1. **Usar la consola web de Digital Ocean** (Access → Launch Droplet Console)
2. **Resetear la contraseña de root** desde el panel de Digital Ocean
3. **Recrear el droplet** (si no tiene datos importantes)

---

## ✅ Próximos Pasos

Una vez que puedas conectarte por SSH, continúa con el deployment:

```bash
# En tu VPS
cd /tmp
git clone https://github.com/Lu2312/Welcome-Card-Wars-Kingdom.git
cd Welcome-Card-Wars-Kingdom/vps-deployment
sudo bash scripts/setup-vps.sh
```

Sigue la guía completa en: `COMPLETE-DEPLOYMENT-GUIDE.md`
