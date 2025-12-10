# Card Wars Kingdom - Métodos de Actualización en el Servidor

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
cd /var/www/cardwars-kingdom
git pull origin main
```

### 3. Sincroniza y reinicia el servidor

```bash
sudo bash /var/www/cardwars-kingdom/deploy/sync-and-restart.sh
```

**Nota:** El script `sync-and-restart.sh` maneja automáticamente archivos untracked agregándolos al repositorio antes de sincronizar para evitar conflictos.

---

## Opción 2: Copiar archivos manualmente con SCP

### 1. Abre una terminal en tu PC local

En tu PC local (Windows):
```bash
scp -r "c:\Users\Luis Flores\Documents\GITHUB\Welcome-Card-Wars-Kingdom\*" root@TU_IP_DEL_SERVIDOR:/var/www/cardwars-kingdom/
```

En Linux/Mac:
```bash
scp -r ~/Welcome-Card-Wars-Kingdom/* root@TU_IP_DEL_SERVIDOR:/var/www/cardwars-kingdom/
```

### 2. Conéctate a tu VPS

```bash
ssh root@TU_IP_DEL_SERVIDOR
cd /var/www/cardwars-kingdom
```

### 3. Instala dependencias y reinicia el servidor

```bash
source venv/bin/activate
pip install -r requirements.txt
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
  ```bash
  sudo journalctl -u cardwars-kingdom-net.service -f
  ```
- **Si usas GitHub, los cambios quedan registrados y puedes volver atrás fácilmente.**
- **Si usas SCP, asegúrate de no sobrescribir archivos importantes por error.**

---

## ¿Qué método elegir?

- **GitHub:** Más seguro, control de versiones, recomendado para equipos y proyectos en crecimiento.
- **SCP:** Útil para cambios rápidos o cuando no quieres usar Git.

---

## 🐛 Troubleshooting

### ✅ SOLUCIONADO: Problemas de Nginx y Archivos Estáticos (Diciembre 2024)

**Problemas resueltos automáticamente:**
- ✅ Configuración de nginx corrompida por comandos mezclados
- ✅ Puerto incorrecto (8080/8081 → 8000) en configuración nginx
- ✅ Ruta incorrecta de archivos estáticos (`/var/www/cardwars-kingdom.net/static` → `/var/www/cardwars-kingdom/static`)
- ✅ Servicio systemd apuntando a directorio incorrecto (`cardwars-kingdom.net` → `cardwars-kingdom`)
- ✅ Permisos restrictivos en archivos estáticos (700 → 755)

**Si experimentas estos problemas nuevamente:**

```bash
# 1. Verificar y corregir configuración de nginx
sudo cp /var/www/cardwars-kingdom/nginx/cardwars-kingdom.conf /etc/nginx/sites-available/cardwars-kingdom-net

# O crear configuración simple funcional:
cat > /etc/nginx/sites-available/cardwars-kingdom-net << 'EOF'
server {
    listen 80;
    server_name cardwars-kingdom.net www.cardwars-kingdom.net;
    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
    location /static {
        alias /var/www/cardwars-kingdom/static;
        expires 30d;
    }
}
EOF

# 2. Corregir rutas en servicio systemd
sudo sed -i 's|/var/www/cardwars-kingdom.net|/var/www/cardwars-kingdom|g' /etc/systemd/system/cardwars-kingdom-net.service

# 3. Corregir permisos de archivos estáticos
sudo chmod -R 755 /var/www/cardwars-kingdom/static/

# 4. Aplicar cambios
sudo nginx -t && sudo systemctl reload nginx
sudo systemctl daemon-reload && sudo systemctl restart cardwars-kingdom-net.service

# 5. Verificar funcionamiento
curl -I http://localhost/static/css/styles.css
curl -I https://cardwars-kingdom.net/
```

### Problema: Error "would be overwritten by merge" en git pull

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

## Consejos Finales

- Considera implementar un entorno de staging para pruebas antes de aplicar cambios en producción.
- Revisa periódicamente los logs del servidor para detectar problemas anticipadamente.
- Mantén siempre tu sistema y dependencias actualizadas.

---

## Resumen de Cambios

- ✅ **Solución inmediata:** Instrucciones específicas para resolver el problema actual
- ✅ **Manejo de errores:** Mejor detección y reporte de errores durante el despliegue
- ✅ **Logging mejorado:** El script proporciona más información sobre lo que está haciendo
- ✅ **Documentación actualizada:** Se agregó troubleshooting completo para conflictos de Git
- ✅ **Script mejorado:** `sync-and-restart.sh` ahora detecta y maneja archivos untracked automáticamente

---

## Resolución Manual si el Script Falla

Si el script `sync-and-restart.sh` no funciona, realiza estos pasos manualmente:

1. Sincroniza los archivos con `rsync`:
   ```bash
   rsync -av --delete --exclude='.git' --exclude='venv' --exclude='__pycache__' /tmp/Welcome-Card-Wars-Kingdom/ /var/www/cardwars-kingdom/
   ```

2. Reinicia los servicios involucrados:
   ```bash
   sudo systemctl reload nginx
   sudo systemctl restart cardwars-kingdom-net.service
   ```

---

## Problemas comunes y soluciones

1. **Error de permisos al acceder a archivos o carpetas.**
   - **Solución:** Usa `chmod` para cambiar permisos y `chown` para cambiar el propietario si es necesario.

2. **El servidor no se reinicia o muestra errores después de la actualización.**
   - **Solución:** Asegúrate de que todas las dependencias estén correctamente instaladas. Revisa los logs de errores para identificar el problema.

3. **Conflictos al hacer `git pull`.**
   - **Solución:** Resuelve los conflictos manualmente editando los archivos en conflicto. Después de resolver, usa `git add` y `git commit` para finalizar el merge.

4. **Problemas con saltos de línea en scripts.**
   - **Solución:** Usa `dos2unix` o `sed` para convertir el formato si es necesario. Asegúrate de que los scripts tengan formato LF.

---

## Checklist Final

- [x] Contacto y soporte
- [x] Solución inmediata para el problema actual
- [x] Logging detallado
- [x] Manejo de conflictos Git
- [x] Documentación de troubleshooting
- [x] Script automático mejorado

---

## 🚀 ¡Despegue! 🚀

¡Listo! Así puedes actualizar tu servidor Card Wars Kingdom de forma profesional y segura.

**¡Que tengas muchas victorias en tus batallas de cartas! ⚔️**

---

**¡Card Wars Kingdom - Donde la imaginación cobra vida! ⚔️**

---

**¡Gracias por elegir Card Wars Kingdom!**

---

Si tienes problemas con el despliegue:
- **Email:** luisflores@example.com (reemplaza con tu email)
- **Discord:** [Card Wars Kingdom](https://discord.gg/card-wars-revived-1227932764117143642)
- **GitHub Issues:** [Abrir issue](https://github.com/Lu2312/Welcome-Card-Wars-Kingdom/issues)

---

**Enlaces útiles:**
- [Sitio Web](https://cardwars-kingdom.net)
- [Repositorio GitHub](https://github.com/Lu2312/Welcome-Card-Wars-Kingdom)
- [Flask Documentation](https://flask.palletsprojects.com/)
- [Gunicorn Documentation](https://docs.gunicorn.org/)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [Git Documentation](https://git-scm.com/doc)
- [Ubuntu Server Guide](https://ubuntu.com/server/docs)

---

**¡Que la fuerza te acompañe! 🌟**

---

**--- Fin del documento ---**