#!/bin/bash

echo "===== Card Wars Kingdom VPS Test ====="
echo ""

# 1. Verificar servicio Gunicorn
echo "1. Gunicorn service status:"
sudo systemctl status cardwars-kingdom-net.service --no-pager | head -15
echo ""

# 2. Verificar Nginx
echo "2. Nginx service status:"
sudo systemctl status nginx --no-pager | head -10
echo ""

# 3. Probar página principal
echo "3. Testing main page (HTTP):"
curl -I http://localhost | head -5
echo ""

# 4. Probar página principal (HTTPS, si aplica)
echo "4. Testing main page (HTTPS via Cloudflare):"
curl -I https://cardwars-kingdom.net | head -5
echo ""

# 5. Probar archivos estáticos (animaciones/gif/video/css)
echo "5. Testing static files:"
STATIC_FILES=(
    "/Welcome Card Wars Kingdom_files/home.gif"
    "/Welcome Card Wars Kingdom_files/main-characters.png"
    "/Welcome Card Wars Kingdom_files/home-hero.mp4"
    "/Welcome Card Wars Kingdom_files/a53f14ee4cfcc268.css"
)
for file in "${STATIC_FILES[@]}"; do
    echo -n "  $file: "
    curl -s -o /dev/null -w "%{http_code}\n" "http://localhost$file"
done
echo ""

# 6. Verificar logs de errores recientes
echo "6. Últimos errores de Nginx:"
sudo tail -n 10 /var/log/nginx/cardwars-kingdom-net-error.log
echo ""
echo "6. Últimos errores de Gunicorn:"
sudo tail -n 10 /var/log/gunicorn/cardwars-kingdom-net-error.log
echo ""

echo "===== Fin del test VPS ====="
