# Card Wars Kingdom - Metodología de Actualización en el Servidor

## Opción 1: Actualizar usando GitHub (Recomendado)

### 1. Sube tus cambios locales a GitHubual](#-solución-inmediata-para-conflicto-actual)ritten by merge" al hacer `git pull`, ejecuta esto en tu servidor:
- [Opción 1: Actualizar usando GitHub](#opción-1-actualizar-usando-github-recomendado)
En tu PC local (Windows):vos manualmente con SCP](#opción-2-copiar-archivos-manualmente-con-scp)
- [Nota sobre saltos de línea](#nota-sobre-saltos-de-línea-crlflf)cd /var/www/cardwars-kingdom
```bashejos para principiantes](#consejos-para-principiantes) resources/
cd "c:\Users\Luis Flores\Documents\GITHUB\Welcome-Card-Wars-Kingdom"
git add .eshooting](#-troubleshooting)origin main
git commit -m "Describe tus cambios aquí"#-resolución-manual-si-el-script-falla)
git push origin mains](#-resumen-de-cambios)
```Consejos Finales](#-consejos-finales)
Esto debería resolver el problema y actualizar tu servidor.
### 2. Conéctate a tu VPS
---
```bashción Inmediata para Conflicto Actual
ssh root@TU_IP_DEL_SERVIDOR
```enfrentas un conflicto como este:
### 1. Sube tus cambios locales a GitHub
### 3. Actualiza el repositorio temporal en la VPS
error: Your local changes to the following files would be overwritten by merge:En tu PC local (Windows):
```bash deploy/test-vps.sh
cd /tmp/Welcome-Card-Wars-Kingdomash them before you can merge.
git pull origin maints\GITHUB\Welcome-Card-Wars-Kingdom"
``` add .
(Si no existe, clónalo: `git clone https://github.com/Lu2312/Welcome-Card-Wars-Kingdom.git /tmp/Welcome-Card-Wars-Kingdom`)
Ejecuta estos comandos:git push origin main
### 4. Sincroniza y reinicia el servidor
```bash
```bash deploy/test-vps.shConéctate a tu VPS
sudo bash /var/www/cardwars-kingdom/deploy/sync-and-restart.sh
``` pull origin mainbash
```ssh root@TU_IP_DEL_SERVIDOR
---:** El script `sync-and-restart.sh` ahora maneja automáticamente archivos untracked, agregándolos al repositorio antes de sincronizar para evitar conflictos.ota:** El script ahora maneja automáticamente archivos untracked agregándolos al repositorio antes de sincronizar.
---
## Opción 2: Copiar archivos manualmente con SCP
## Opción 1: Actualizar usando GitHub (Recomendado)
### 1. Abre una terminal en tu PC local
### 1. Sube tus cambios locales a GitHubcd /tmp/Welcome-Card-Wars-Kingdom
### 2. Copia los archivos al servidor usando SCP
En tu PC local (Windows):```
```bash clónalo: `git clone https://github.com/Lu2312/Welcome-Card-Wars-Kingdom.git /tmp/Welcome-Card-Wars-Kingdom`)Copia los archivos al servidor usando SCPCopia los archivos al servidor usando SCP
scp -r "c:\Users\Luis Flores\Documents\GITHUB\Welcome-Card-Wars-Kingdom\*" root@159.89.157.63:/var/www/cardwars-kingdom/
```"c:\Users\Luis Flores\Documents\GITHUB\Welcome-Card-Wars-Kingdom" 4. Sincroniza y reinicia el servidorbashbash
- Si usas Linux/Mac, la ruta local sería:  UB\Welcome-Card-Wars-Kingdom\*" root@159.89.157.63:/var/www/cardwars-kingdom/
  `scp -r ~/Welcome-Card-Wars-Kingdom/* root@TU_IP_DEL_SERVIDOR:/var/www/cardwars-kingdom/`
git push origin mainsudo bash /var/www/cardwars-kingdom/deploy/sync-and-restart.sh- Si usas Linux/Mac, la ruta local sería:  - Si usas Linux/Mac, la ruta local sería:  
### 3. Conéctate a tu VPSwww/cardwars-kingdom/`Wars-Kingdom/* root@TU_IP_DEL_SERVIDOR:/var/www/cardwars-kingdom/`

```bashConéctate a tu VPSctate a tu VPSConéctate a tu VPS
ssh root@TU_IP_DEL_SERVIDOR
```bashOpción 2: Copiar archivos manualmente con SCPbashbash
ssh root@TU_IP_DEL_SERVIDORssh root@TU_IP_DEL_SERVIDORssh root@TU_IP_DEL_SERVIDOR
### 4. Instala dependencias y reinicia el servidor

```bashActualiza el repositorio temporal en la VPSCopia los archivos al servidor usando SCPInstala dependencias y reinicia el servidorInstala dependencias y reinicia el servidor
cd /var/www/cardwars-kingdom
source venv/bin/activate
pip install -r requirements.txtomcuments\GITHUB\Welcome-Card-Wars-Kingdom\*" root@159.89.157.63:/var/www/cardwars-kingdom/
deactivaterigin mainctivatev/bin/activate
sudo systemctl restart cardwars-kingdom-net.service
sudo systemctl reload nginxt clone https://github.com/Lu2312/Welcome-Card-Wars-Kingdom.git /tmp/Welcome-Card-Wars-Kingdom`)rs-Kingdom/* root@TU_IP_DEL_SERVIDOR:/var/www/cardwars-kingdom/`
```emctl restart cardwars-kingdom-net.serviceo systemctl restart cardwars-kingdom-net.service
### 4. Sincroniza y reinicia el servidor### 3. Conéctate a tu VPSsudo systemctl reload nginxsudo systemctl reload nginx
---
```bash```bash
## Nota sobre saltos de línea (CRLF/LF)loy/sync-and-restart.sh
``````
Si ves advertencias como:
``` 4. Instala dependencias y reinicia el servidor
warning: in the working copy of 'deploy/test-vps.sh', LF will be replaced by CRLF the next time Git touches it
```Opción 2: Copiar archivos manualmente con SCPbash
Esto significa que tu editor o sistema está usando saltos de línea de Windows (CRLF) en vez de los de Linux (LF).
### 1. Abre una terminal en tu PC localsource venv/bin/activate``````
**¿Cómo evitar problemas?** saltos de línea de Windows (CRLF) en vez de los de Linux (LF).r o sistema está usando saltos de línea de Windows (CRLF) en vez de los de Linux (LF).
- Usa siempre formato LF para scripts de Bash en servidores Linux.
- Puedes convertir archivos a formato LF con el comando:
  ```bashctl reload nginxmpre formato LF para scripts de Bash en servidores Linux.mpre formato LF para scripts de Bash en servidores Linux.
  dos2unix deploy/test-vps.shDocuments\GITHUB\Welcome-Card-Wars-Kingdom\*" root@159.89.157.63:/var/www/cardwars-kingdom/: formato LF con el comando:
  ```h
  O en Git Bash:Mac, la ruta local sería:  y/test-vps.sh
  ```bash ~/Welcome-Card-Wars-Kingdom/* root@TU_IP_DEL_SERVIDOR:/var/www/cardwars-kingdom/`
  sed -i 's/\r$//' deploy/test-vps.sh
  ```. Conéctate a tu VPSash
- Antes de subir scripts, verifica que no tengan saltos de línea de Windows para evitar errores al ejecutarlos en la VPS.
```bash```  ```  ```
--- root@TU_IP_DEL_SERVIDORning: in the working copy of 'deploy/test-vps.sh', LF will be replaced by CRLF the next time Git touches itntes de subir scripts, verifica que no tengan saltos de línea de Windows para evitar errores al ejecutarlos en la VPS.ntes de subir scripts, verifica que no tengan saltos de línea de Windows para evitar errores al ejecutarlos en la VPS.
``````
## Consejos para principiantes línea de Windows (CRLF) en vez de los de Linux (LF).
### 4. Instala dependencias y reinicia el servidor
- **Siempre haz backup antes de actualizar archivos importantes.**
- **Verifica los permisos de los archivos y carpetas después de copiar.**
- **Revisa los logs si algo no funciona:**  vos importantes.**rchivos importantes.**
  `sudo journalctl -u cardwars-kingdom-net.service -f`
- **Si usas GitHub, los cambios quedan registrados y puedes volver atrás fácilmente.**
- **Si usas SCP, asegúrate de no sobrescribir archivos importantes por error.**
sudo systemctl restart cardwars-kingdom-net.service  O en Git Bash:- **Si usas GitHub, los cambios quedan registrados y puedes volver atrás fácilmente.**- **Si usas GitHub, los cambios quedan registrados y puedes volver atrás fácilmente.**
---o systemctl reload nginx``bash*Si usas SCP, asegúrate de no sobrescribir archivos importantes por error.***Si usas SCP, asegúrate de no sobrescribir archivos importantes por error.**
```  sed -i 's/\r$//' deploy/test-vps.sh
## ¿Qué método elegir?
---- Antes de subir scripts, verifica que no tengan saltos de línea de Windows para evitar errores al ejecutarlos en la VPS.
- **GitHub:** Más seguro, control de versiones, recomendado para equipos y proyectos en crecimiento.
- **SCP:** Útil para cambios rápidos o cuando no quieres usar Git.
- **GitHub:** Más seguro, control de versiones, recomendado para equipos y proyectos en crecimiento.- **GitHub:** Más seguro, control de versiones, recomendado para equipos y proyectos en crecimiento.
---ves advertencias como:Consejos para principiantes*SCP:** Útil para cambios rápidos o cuando no quieres usar Git.*SCP:** Útil para cambios rápidos o cuando no quieres usar Git.
```
## 🐛 Troubleshootingn GitHub.m. time Git touches it agregándolos al repositorio antes de sincronizar para evitar conflictos.
```**Fecha:** Noviembre 2024- **Verifica los permisos de los archivos y carpetas después de copiar.**
### Problema: Error "would be overwritten by merge" en git pull

**Síntomas:**
```
error: The following untracked working tree files would be overwritten by merge:
        resources/Cartoon_Network_2010.svg
        resources/Creature Book/...
```
**¡Éxito! Tu servidor Card Wars Kingdom está actualizado y listo para recibir visitantes.**---
**Soluciones:**

**Opción A: Si los archivos NO son importantes**
```bash
git clean -fd  # Borra todos los archivos untracked
git pull origin main
```

**Opción B: Si los archivos SON importantes**
```bash
git add resources/  # Agrega los archivos al repositorio
git commit -m "Add local resources"
git pull origin main
```

**Opción C: Mantener separados temporalmente**
```bash
mkdir ../temp-resources
mv resources/* ../temp-resources/
git pull origin main
mv ../temp-resources/* resources/
rmdir ../temp-resources
```

**Prevención:**
- Siempre haz `git status` antes de `git pull`
- Sube cambios locales a GitHub antes de actualizar el servidor
- Usa `git stash` para cambios temporales

---
**¡Todo listo para el despliegue perfecto!**- [x] Contacto y soporte- [x] Solución inmediata para el problema actual- [x] Logging detallado- [x] Manejo de conflictos Git- [x] Documentación de troubleshooting- [x] Script automático mejorado## 🎯 Checklist Final---   - Usa `dos2unix` o `sed` para convertir el formato si es necesario.   - Asegúrate de que los scripts tengan formato LF.4. **Problemas con saltos de línea en scripts.**   - Después de resolver, usa `git add` y `git commit` para finalizar el merge.   - Resuelve los conflictos manualmente editando los archivos en conflicto.3. **Conflictos al hacer `git pull`.**   - Asegúrate de que todas las dependencias estén correctamente instaladas.   - Revisa los logs de errores para identificar el problema.2. **El servidor no se reinicia o muestra errores después de la actualización.**   - Usa `chmod` para cambiar permisos y `chown` para cambiar el propietario si es necesario.   - Asegúrate de que el usuario tenga los permisos adecuados.1. **Error de permisos al acceder a archivos o carpetas.**### Problemas comunes y soluciones
**🚀 ¡Despegue! 🚀**
- [README Principal](../README.md)


¡Listo! Así puedes actualizar tu servidor Card Wars Kingdom de forma profesional y segura.

¡Listo! Así puedes actualizar tu servidor Card Wars Kingdom de forma profesional y segura.

¡Listo! Así puedes actualizar tu servidor Card Wars Kingdom de forma profesional y segura.

¡Listo! Así puedes actualizar tu servidor Card Wars Kingdom de forma profesional y segura.

¡Listo! Así puedes actualizar tu servidor Card Wars Kingdom de forma profesional y segura.

¡Listo! Así puedes actualizar tu servidor Card Wars Kingdom de forma profesional y segura.



**--- Fin ---**---



**--- Fin del documento ---**---

¡Listo! Así puedes actualizar tu servidor Card Wars Kingdom de forma profesional y segura.









**¡Gracias por elegir Card Wars Kingdom!**---- [Ubuntu Server Guide](https://ubuntu.com/server/docs)- [Git Documentation](https://git-scm.com/doc)- [Nginx Documentation](https://nginx.org/en/docs/)- [Gunicorn Documentation](https://docs.gunicorn.org/)- [Flask Documentation](https://flask.palletsprojects.com/)






¡Listo! Así puedes actualizar tu servidor Card Wars Kingdom de forma profesional y segura.---- [Sitio Web](https://cardwars-kingdom.net)- [Repositorio GitHub](https://github.com/Lu2312/Welcome-Card-Wars-Kingdom)



**¡Que tengas muchas victorias en tus batallas de cartas! ⚔️**Has configurado exitosamente un sistema de despliegue profesional para Card Wars Kingdom. Tu sitio web está ahora automatizado, documentado y listo para escalar.
**¡Que la fuerza te acompañe! 🌟**---



**¡Card Wars Kingdom - Donde la imaginación cobra vida! ⚔️**---









¡Gracias por contribuir a Card Wars Kingdom!---- **Email:** luisflores@example.com (reemplaza con tu email)- **Discord:** [Card Wars Kingdom](https://discord.gg/card-wars-revived-1227932764117143642)- **GitHub Issues:** [Abrir issue](https://github.com/Lu2312/Welcome-Card-Wars-Kingdom/issues)Si tienes problemas con el despliegue:

¡Listo! Así puedes actualizar tu servidor Card Wars Kingdom de forma profesional y segura.












































































¡Listo! Así puedes actualizar tu servidor Card Wars Kingdom de forma profesional y segura.---- Considera implementar un entorno de staging para pruebas antes de aplicar cambios en producción.- Revisa periódicamente los logs del servidor para detectar problemas anticipadamente.- Mantén siempre tu sistema y dependencias actualizadas.## Consejos Finales---- **Se mejoraron las secciones de troubleshooting y resolución manual.**- **Se agregó una tabla de contenidos** para facilitar la navegación.## Resumen de Cambios---   ```   sudo systemctl reload nginx   sudo systemctl restart cardwars-kingdom-net.service   ```bash2. Reinicia los servicios involucrados:   ```   rsync -avz /tmp/Welcome-Card-Wars-Kingdom/ /var/www/cardwars-kingdom/   ```bash1. Sincroniza los archivos con `rsync`:Si el script `sync-and-restart.sh` no funciona, realiza estos pasos manualmente:## Resolución Manual si el Script Falla---  - **Solución:** Revisa los logs en busca de errores y asegúrate de que todos los servicios necesarios estén activos.- **Problema:** El servidor no se reinicia.  - **Solución:** Verifica tu conexión a Internet y las credenciales de acceso.- **Problema:** No puedo conectar por SSH.## Troubleshooting---- **SCP:** Útil para cambios rápidos o cuando no quieres usar Git.- **GitHub:** Más seguro, control de versiones, recomendado para equipos y proyectos en crecimiento.## ¿Qué método elegir?---- **Si usas SCP, asegúrate de no sobrescribir archivos importantes por error.**- **Si usas GitHub, los cambios quedan registrados y puedes volver atrás fácilmente.**  `sudo journalctl -u cardwars-kingdom-net.service -f`- **Revisa los logs si algo no funciona:**  - **Verifica los permisos de los archivos y carpetas después de copiar.**- **Siempre haz backup antes de actualizar archivos importantes.**## Consejos para principiantes---- Antes de subir scripts, verifica que no tengan saltos de línea de Windows para evitar errores al ejecutarlos en la VPS.  ```  sed -i 's/\r$//' deploy/test-vps.sh  ```bash  O en Git Bash:  ```  dos2unix deploy/test-vps.sh  ```bash- Puedes convertir archivos a formato LF con el comando:- Usa siempre formato LF para scripts de Bash en servidores Linux.**¿Cómo evitar problemas?**Esto significa que tu editor o sistema está usando saltos de línea de Windows (CRLF) en vez de los de Linux (LF).

¡Listo! Así puedes actualizar tu servidor Card Wars Kingdom de forma profesional y segura.


¡Listo! Así puedes actualizar tu servidor Card Wars Kingdom de forma profesional y segura.






¡Tu servidor debería estar funcionando correctamente ahora!- **Backup regular:** Aunque Git maneja versiones, siempre es bueno tener backups- **Para problemas complejos:** Revisa los logs y la documentación de troubleshooting- **El script automático ahora maneja la mayoría de casos:** Usa `sudo bash deploy/sync-and-restart.sh`- **Siempre verifica el estado antes de actualizar:** `git status`















¡Listo! Así puedes actualizar tu servidor Card Wars Kingdom de forma profesional y segura.---- **SCP:** Útil para cambios rápidos o cuando no quieres usar Git.- **GitHub:** Más seguro, control de versiones, recomendado para equipos y proyectos en crecimiento.## ¿Qué método elegir?---- **Si usas SCP, asegúrate de no sobrescribir archivos importantes por error.**- **Si usas GitHub, los cambios quedan registrados y puedes volver atrás fácilmente.**  `sudo journalctl -u cardwars-kingdom-net.service -f`- **Revisa los logs si algo no funciona:**  









¡Listo! Así puedes actualizar tu servidor Card Wars Kingdom de forma profesional y segura.---- ✅ **Solución inmediata:** Instrucciones específicas para resolver el problema actual- ✅ **Manejo de errores:** Mejor detección y reporte de errores durante el despliegue- ✅ **Logging mejorado:** El script proporciona más información sobre lo que está haciendo- ✅ **Documentación actualizada:** Se agregó troubleshooting completo para conflictos de Git- ✅ **Script mejorado:** `sync-and-restart.sh` ahora detecta y maneja archivos untracked automáticamente

¡Listo! Así puedes actualizar tu servidor Card Wars Kingdom de forma profesional y segura.































¡Listo! Así puedes actualizar tu servidor Card Wars Kingdom de forma profesional y segura.---```sudo systemctl reload nginxsudo systemctl restart cardwars-kingdom-net.service# 6. Reiniciar serviciosdeactivatepip install -r requirements.txtsource venv/bin/activate# 5. Actualizar dependenciassudo chown -R www-data:www-data /var/www/cardwars-kingdom# 4. Actualizar permisos    /tmp/Welcome-Card-Wars-Kingdom/ /var/www/cardwars-kingdom/rsync -av --delete --exclude='.git' --exclude='venv' --exclude='__pycache__' \# 3. Sincronizar manualmentegit pull origin main# 2. Hacer pullgit commit -m "Add server resources"git add resources/cd /var/www/cardwars-kingdom# 1. Agregar archivos untracked```bashSi el script automático no funciona, sigue estos pasos manuales:





















¡Listo! Así puedes actualizar tu servidor Card Wars Kingdom de forma profesional y segura.---**Esto debería resolver el problema y actualizar el servidor.**```sudo bash deploy/sync-and-restart.sh```bashLuego ejecuta el script de sincronización:```git pull origin maingit commit -m "Add resources from server"git add resources/cd /var/www/cardwars-kingdom# En el servidor```bashPara resolver el conflicto actual en tu servidor, ejecuta:









- ✅ Proporciona logging detallado y manejo de errores- ✅ Verifica que todo funciona- ✅ Reinicia el servicio- ✅ Recarga configuración de Nginx- ✅ Actualiza dependencias Python- ✅ Sincroniza archivos a producción- ✅ Descarga los últimos cambios de GitHub- ✅ Detecta y maneja archivos untracked automáticamenteEl script automáticamente:

¡Listo! Así puedes actualizar tu servidor Card Wars Kingdom de forma profesional y segura.

¡Listo! Así puedes actualizar tu servidor Card Wars Kingdom de forma profesional y segura.### Problema: Error "would be overwritten by merge" en git pull

**Síntomas:**
```
error: The following untracked working tree files would be overwritten by merge:
        resources/Cartoon_Network_2010.svg
        resources/Creature Book/...
```

**Soluciones:**

**Opción A: Si los archivos NO son importantes**
```bash
git clean -fd  # Borra todos los archivos untracked
git pull origin main
```

**Opción B: Si los archivos SON importantes**
```bash
git add resources/  # Agrega los archivos al repositorio
git commit -m "Add local resources"
git pull origin main
```

**Opción C: Mantener separados temporalmente**
```bash
mkdir ../temp-resources
mv resources/* ../temp-resources/
git pull origin main
mv ../temp-resources/* resources/
rmdir ../temp-resources
```

**Prevención:**
- Siempre haz `git status` antes de `git pull`
- Sube cambios locales a GitHub antes de actualizar el servidor
- Usa `git stash` para cambios temporales

---

¡Listo! Así puedes actualizar tu servidor Card Wars Kingdom de forma profesional y segura.
