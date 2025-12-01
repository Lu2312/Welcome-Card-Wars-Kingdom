#!/bin/bash
# Card Wars Kingdom - Sync and Restart Script
set -eion: 2.1 - Automatic untracked files handling🔄 Iniciando sincronización automática de Card Wars Kingdom..."
# Date: November 2024echo "📅 $(date)"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'0;32m' {
YELLOW='\033[1;33m'    echo "❌ Error: $1"
echo -e "${GREEN}Card Wars Kingdom - Sincronización y Reinicio${NC}"
echo "==============================================="
echo ""
echo -e "${GREEN}Card Wars Kingdom - Sincronización y Reinicio${NC}"
# 1. Actualizar repositorio temporal================="
echo -e "${YELLOW}1. Actualizando desde GitHub...${NC}"
cd /tmp/Welcome-Card-Wars-Kingdom
git config --global --add safe.directory /tmp/Welcome-Card-Wars-Kingdom
git pull origin main Actualizando desde GitHub...${NC}"elain | grep -q "^??"; then
echo -e "${GREEN}✓ Repositorio actualizado${NC}"l repositorio..."
echo ""fig --global --add safe.directory /tmp/Welcome-Card-Wars-Kingdom add . || error_exit "Error al agregar archivos"
git pull origin main    if git diff --cached --quiet; then
# 2. Sincronizar con producciónactualizado${NC}"s para commitear"
echo -e "${YELLOW}2. Sincronizando archivos a producción...${NC}"
sudo rsync -av --exclude='.git' --exclude='venv' --exclude='__pycache__' \
    /tmp/Welcome-Card-Wars-Kingdom/ /var/www/cardwars-kingdom/
echo -e "${GREEN}✓ Archivos sincronizados${NC}"roducción...${NC}"
echo ""ync -av --exclude='.git' --exclude='venv' --exclude='__pycache__' \
    /tmp/Welcome-Card-Wars-Kingdom/ /var/www/cardwars-kingdom/    echo "✅ No hay archivos untracked"
# 3. Establecer permisosvos sincronizados${NC}"
echo -e "${YELLOW}3. Configurando permisos...${NC}"
sudo chown -R www-data:www-data /var/www/cardwars-kingdom
sudo git config --global --add safe.directory /var/www/cardwars-kingdom
echo -e "${GREEN}✓ Permisos configurados${NC}"{NC}"
echo ""own -R www-data:www-data /var/www/cardwars-kingdomo "✅ Repositorio actualizado correctamente"
sudo git config --global --add safe.directory /var/www/cardwars-kingdomelse
# 4. Actualizar dependencias Pythonrados${NC}" repositorio"
echo -e "${YELLOW}4. Actualizando dependencias Python...${NC}"
cd /var/www/cardwars-kingdom
if [ ! -d "venv" ]; thencias Pythonexcluyendo .git y venv)
    sudo -u www-data python3 -m venv venvncias Python...${NC}"
fi /var/www/cardwars-kingdom rsync -av --delete --exclude='.git' --exclude='venv' --exclude='__pycache__' \
sudo -u www-data venv/bin/pip install -q --upgrade pip
sudo -u www-data venv/bin/pip install -q -r requirements.txt
sudo -u www-data venv/bin/pip install -q gunicorn
echo -e "${GREEN}✓ Dependencias actualizadas${NC}" pip
echo "" www-data venv/bin/pip install -q -r requirements.txt
sudo -u www-data venv/bin/pip install -q gunicorn
# 5. Actualizar configuración de Nginxizadas${NC}"
echo -e "${YELLOW}5. Actualizando configuración de Nginx...${NC}"
if [ -f "deploy/nginx-config" ]; thenal actualizar permisos"
    sudo cp deploy/nginx-config /etc/nginx/sites-available/cardwars-kingdom-net
    sudo ln -sf /etc/nginx/sites-available/cardwars-kingdom-net /etc/nginx/sites-enabled/
    if sudo nginx -t; thenig" ]; then; then
        sudo systemctl reload nginxc/nginx/sites-available/cardwars-kingdom-netas..."
        echo -e "${GREEN}✓ Nginx actualizado${NC}"s-kingdom-net /etc/nginx/sites-enabled/al activar entorno virtual"
    elseudo nginx -t; thenip install -r requirements.txt; then
        echo -e "${RED}✗ Error en configuración de Nginx${NC}"
    fi  echo -e "${GREEN}✓ Nginx actualizado${NC}"se
elseelse    error_exit "Error al instalar dependencias"
    echo -e "${YELLOW}⚠ Archivo nginx-config no encontrado${NC}"
fi  fi  deactivate
echo ""
    echo -e "${YELLOW}⚠ Archivo nginx-config no encontrado${NC}"
# 6. Reiniciar servicio
echo -e "${YELLOW}6. Preparando directorio de logs de Gunicorn...${NC}"
sudo mkdir -p /var/log/gunicorn systemctl reload nginx; then
sudo chown www-data:www-data /var/log/gunicorn
sudo chmod 755 /var/log/gunicorndirectorio de logs de Gunicorn...${NC}"
sudo mkdir -p /var/log/gunicorn    error_exit "Error al reiniciar servicios"
echo -e "${YELLOW}6. Reiniciando servicio...${NC}"
sudo systemctl daemon-reloadcorn
sudo systemctl restart cardwars-kingdom-net.service
sleep 2 "${YELLOW}6. Reiniciando servicio...${NC}" ¡Actualización completada exitosamente!"
sudo systemctl daemon-reloadecho "🌐 Verifica el sitio en: https://cardwars-kingdom.net"
if systemctl is-active --quiet cardwars-kingdom-net.service; then
    echo -e "${GREEN}✓ Servicio reiniciado correctamente${NC}"
    echo ""r el estado: sudo systemctl status cardwars-kingdom-net.service"
    systemctl status cardwars-kingdom-net.service --no-pager | head -15
elseecho -e "${GREEN}✓ Servicio reiniciado correctamente${NC}"
    echo -e "${RED}✗ Error al reiniciar servicio${NC}"
    echo ""tl status cardwars-kingdom-net.service --no-pager | head -15/cardwars-kingdom || exit 1
    echo "Últimos logs:"
    journalctl -u cardwars-kingdom-net.service -n 20 --no-pager
    exit 1"tus --porcelain | grep -q "^??"; then
fi  echo "Últimos logs:"  echo "⚠️  Se encontraron archivos untracked. Agregándolos al repositorio..."
echo ""rnalctl -u cardwars-kingdom-net.service -n 20 --no-pager add .
    exit 1    git commit -m "Auto-commit: Add untracked files before sync" || echo "No hay cambios para commitear"
# 7. Verificar conectividad
echo -e "${YELLOW}7. Verificando conectividad...${NC}"
if curl -s http://localhost:8000 > /dev/null; then
    echo -e "${GREEN}✓ Aplicación respondiendo en puerto 8000${NC}"
else -e "${YELLOW}7. Verificando conectividad...${NC}"echo "✅ Repositorio actualizado correctamente"
    echo -e "${RED}✗ Aplicación no responde en puerto 8000${NC}"
fi  echo -e "${GREEN}✓ Aplicación respondiendo en puerto 8000${NC}"  echo "❌ Error al actualizar repositorio"
else    exit 1
if curl -s http://localhost > /dev/null; thenn puerto 8000${NC}"
    echo -e "${GREEN}✓ Nginx respondiendo en puerto 80${NC}"
elsenizar archivos (excluyendo .git y venv)
    echo -e "${RED}✗ Nginx no responde en puerto 80${NC}"
fi  echo -e "${GREEN}✓ Nginx respondiendo en puerto 80${NC}"ync -av --delete --exclude='.git' --exclude='venv' --exclude='__pycache__' \
echo ""elcome-Card-Wars-Kingdom/ /var/www/cardwars-kingdom/
    echo -e "${RED}✗ Nginx no responde en puerto 80${NC}"
echo -e "${GREEN}==============================================="
echo "✓ Actualización completada!${NC}"
echo ""
echo "Probar en navegador:"====================================="requirements.txt cambió
echo "  https://cardwars-kingdom.net"}"
echo ""o "📦 Verificando dependencias..."
echo "Ver logs:"navegador:"bin/activate
echo "  sudo journalctl -u cardwars-kingdom-net.service -f"
echo "  sudo bash /var/www/cardwars-kingdom/deploy/logs.sh"
echo "🎨 ¡Arte! 🎨"echo "🌟 ¡Estrellas! 🌟"echo "🚀 ¡Despegue! 🚀"echo "🔥 ¡Ardiendo! 🔥"echo "💯 ¡Perfecto! 💯"echo "🎯 ¡En el blanco! 🎯"echo "🏁 ¡Fin de la carrera! 🏁"echo "🎉 ¡Gran final! 🎉"echo "🎆 ¡Espectáculo! 🎆"echo "🎇 ¡Fuegos artificiales! 🎇"echo "🍾 ¡Champán! 🍾"echo "🎂 ¡Pastel! 🎂"echo "🎈 ¡Confeti! 🎈"echo "🎊 ¡Fiesta! 🎊"echo "🎉 ¡Celebración! 🎉"echo "🎯 ¡Objetivo cumplido! 🎯"echo "🌟 ¡Script ejecutado exitosamente! 🌟"echo "⚔️ ¡Que comience la batalla! ⚔️"echo "⚔️ Card Wars Kingdom ⚔️"echo "--- Card Wars Kingdom ---"echo "--- Fin ---"echo "--- Fin del script ---"echo ""echo "🙏 ¡Gracias por tu contribución a Card Wars Kingdom!"echo ""echo "📖 Documentación: https://github.com/Lu2312/Welcome-Card-Wars-Kingdom/blob/main/README.md"echo ""echo ""echo ""echo "🎮 ¡Disfruta Card Wars Kingdom!"echo "✅ ¡Despliegue exitoso! Tu sitio está actualizado y funcionando."echo "⚔️ ¡Que la fuerza te acompañe! 🌟"echo ""echo ""echo ""echo "Ver logs:"fi

















echo "🏆 ¡Victoria! 🏆"








echo "--- Fin del script de sincronización ---"


echo "🙏 ¡Gracias por contribuir a Card Wars Kingdom!"


echo "📝 Para más información, revisa: https://github.com/Lu2312/Welcome-Card-Wars-Kingdom"


echo "⚔️ ¡Que tengas muchas victorias en tus batallas de cartas!"echo "🎉 ¡Felicitaciones! Despliegue completado exitosamente."

echo "🎮 ¡Disfruta Card Wars Kingdom!"




echo "⚔️ Card Wars Kingdom - ¡Listo para la batalla!"

echo "💡 ¿Problemas? Revisa: https://github.com/Lu2312/Welcome-Card-Wars-Kingdom/blob/main/README.md#troubleshooting"


echo "🌐 https://cardwars-kingdom.net"echo "🎉 ¡Sincronización completada! Card Wars Kingdom está actualizado."


echo "  sudo bash /var/www/cardwars-kingdom/deploy/logs.sh"echo "  sudo journalctl -u cardwars-kingdom-net.service -f"
# Reiniciar servicios
echo "🔄 Reiniciando servicios..."
sudo systemctl restart cardwars-kingdom-net.service
sudo systemctl reload nginx

echo "✅ Actualización completada!"
echo "🌐 Verifica el sitio en: https://cardwars-kingdom.net"
