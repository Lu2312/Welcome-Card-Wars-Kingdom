# Card Wars Kingdom - Metodología de Actualización en el Servidor

## Opción 1: Actualizar usando GitHub (Recomendado)

### 1. Sube tus cambios locales a GitHub

En tu PC local (Windows):

```bash
cd "c:\Users\Luis Flores\Documents\GITHUB\Welcome-Card-Wars-Kingdom"
git add .
git commit -m "Describe tus cambios aquí"
git push origin main
```

### 2. Conéctate a tu VPS

```bash
ssh root@TU_IP_DEL_SERVIDOR
```

### 3. Actualiza el repositorio temporal en la VPS

```bash
cd /tmp/Welcome-Card-Wars-Kingdom
git pull origin main
```
(Si no existe, clónalo: `git clone https://github.com/Lu2312/Welcome-Card-Wars-Kingdom.git /tmp/Welcome-Card-Wars-Kingdom`)

### 4. Sincroniza y reinicia el servidor

```bash
sudo bash /var/www/cardwars-kingdom/deploy/sync-and-restart.sh
```

---

## Opción 2: Copiar archivos manualmente con SCP

### 1. Abre una terminal en tu PC local

### 2. Copia los archivos al servidor usando SCP

```bash
scp -r "c:\Users\Luis Flores\Documents\GITHUB\Welcome-Card-Wars-Kingdom\*" root@TU_IP_DEL_SERVIDOR:/var/www/cardwars-kingdom/
```
- Si usas Linux/Mac, la ruta local sería:  
  `scp -r ~/Welcome-Card-Wars-Kingdom/* root@TU_IP_DEL_SERVIDOR:/var/www/cardwars-kingdom/`

### 3. Conéctate a tu VPS

```bash
ssh root@TU_IP_DEL_SERVIDOR
```

### 4. Instala dependencias y reinicia el servidor

```bash
cd /var/www/cardwars-kingdom
source venv/bin/activate
pip install -r requirements.txt
deactivate
sudo systemctl restart cardwars-kingdom-net.service
sudo systemctl reload nginx
```

---

## Nota sobre saltos de línea (CRLF/LF)

Si ves advertencias como:
```
warning: in the working copy of 'deploy/test-vps.sh', LF will be replaced by CRLF the next time Git touches it
```
Esto significa que tu editor o sistema está usando saltos de línea de Windows (CRLF) en vez de los de Linux (LF).

**¿Cómo evitar problemas?**
- Usa siempre formato LF para scripts de Bash en servidores Linux.
- Puedes convertir archivos a formato LF con el comando:
  ```bash
  dos2unix deploy/test-vps.sh
  ```
  O en Git Bash:
  ```bash
  sed -i 's/\r$//' deploy/test-vps.sh
  ```
- Antes de subir scripts, verifica que no tengan saltos de línea de Windows para evitar errores al ejecutarlos en la VPS.

---

## Consejos para principiantes

- **Siempre haz backup antes de actualizar archivos importantes.**
- **Verifica los permisos de los archivos y carpetas después de copiar.**
- **Revisa los logs si algo no funciona:**  
  `sudo journalctl -u cardwars-kingdom-net.service -f`
- **Si usas GitHub, los cambios quedan registrados y puedes volver atrás fácilmente.**
- **Si usas SCP, asegúrate de no sobrescribir archivos importantes por error.**

---

## ¿Qué método elegir?

- **GitHub:** Más seguro, control de versiones, recomendado para equipos y proyectos en crecimiento.
- **SCP:** Útil para cambios rápidos o cuando no quieres usar Git.

---

¡Listo! Así puedes actualizar tu servidor Card Wars Kingdom de forma profesional y segura.
