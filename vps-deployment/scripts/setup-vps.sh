#!/bin/bash

# Script de instalación automatizada para VPS Ubuntu
# Para card-wars-kingdom.com y cardwars-kingdom.net
# Ejecutar como root: sudo bash setup-vps.sh

set -e  # Salir si hay algún error

echo "=================================================="
echo "  Card Wars Kingdom - VPS Setup"
echo "  Configuración de 2 proyectos con SSL Cloudflare"
echo "=================================================="
echo ""

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar que se ejecuta como root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Error: Este script debe ejecutarse como root${NC}"
    echo "Usa: sudo bash setup-vps.sh"
    exit 1
fi

echo -e "${GREEN}✓ Ejecutando como root${NC}"

# Paso 1: Actualizar sistema
echo ""
echo -e "${YELLOW}[1/10] Actualizando sistema...${NC}"
apt update && apt upgrade -y

# Paso 2: Instalar dependencias
echo ""
echo -e "${YELLOW}[2/10] Instalando dependencias...${NC}"
apt install -y nginx python3-pip python3-venv git curl ufw fail2ban

# Paso 3: Crear directorios necesarios
echo ""
echo -e "${YELLOW}[3/10] Creando directorios...${NC}"
mkdir -p /var/log/gunicorn
mkdir -p /var/run/gunicorn
mkdir -p /etc/ssl/certs
mkdir -p /etc/ssl/private
chmod 700 /etc/ssl/private
chown -R www-data:www-data /var/log/gunicorn
chown -R www-data:www-data /var/run/gunicorn

# Paso 4: Descargar certificado de Cloudflare Origin Pull
echo ""
echo -e "${YELLOW}[4/10] Descargando certificado Cloudflare Origin Pull...${NC}"
curl -o /etc/ssl/certs/cloudflare-origin-pull.crt https://developers.cloudflare.com/ssl/static/authenticated_origin_pull_ca.pem
chmod 644 /etc/ssl/certs/cloudflare-origin-pull.crt

# Paso 5: Clonar proyecto 1 - card-wars-kingdom.com
echo ""
echo -e "${YELLOW}[5/10] Clonando proyecto card-wars-kingdom.com...${NC}"
cd /var/www
if [ -d "cardwarskingdomrvd" ]; then
    echo "Directorio cardwarskingdomrvd ya existe, actualizando..."
    cd cardwarskingdomrvd
    git pull
    cd ..
else
    git clone https://github.com/Lu2312/cardwarskingdomrvd.git
fi

cd cardwarskingdomrvd
python3 -m venv venv
venv/bin/pip install --upgrade pip
venv/bin/pip install -r requirements.txt gunicorn
cd ..
chown -R www-data:www-data cardwarskingdomrvd

# Paso 6: Clonar proyecto 2 - cardwars-kingdom.net
echo ""
echo -e "${YELLOW}[6/10] Clonando proyecto cardwars-kingdom.net...${NC}"
cd /var/www
if [ -d "Welcome-Card-Wars-Kingdom" ]; then
    echo "Directorio Welcome-Card-Wars-Kingdom ya existe, actualizando..."
    cd Welcome-Card-Wars-Kingdom
    git pull
    cd ..
else
    git clone https://github.com/Lu2312/Welcome-Card-Wars-Kingdom.git
fi

cd Welcome-Card-Wars-Kingdom
python3 -m venv venv
venv/bin/pip install --upgrade pip
venv/bin/pip install -r requirements.txt gunicorn
cd ..
chown -R www-data:www-data Welcome-Card-Wars-Kingdom

# Paso 7: Instalar servicios systemd
echo ""
echo -e "${YELLOW}[7/10] Configurando servicios systemd...${NC}"
cp /var/www/Welcome-Card-Wars-Kingdom/vps-deployment/systemd/*.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable card-wars-kingdom-app.service
systemctl enable card-wars-kingdom-app-backup.service
systemctl enable cardwars-kingdom-site.service
systemctl enable cardwars-kingdom-site-backup.service

# Paso 8: Configurar Nginx
echo ""
echo -e "${YELLOW}[8/10] Configurando Nginx...${NC}"
cp /var/www/Welcome-Card-Wars-Kingdom/vps-deployment/nginx-card-wars-kingdom.com.conf /etc/nginx/sites-available/
cp /var/www/Welcome-Card-Wars-Kingdom/vps-deployment/nginx-cardwars-kingdom.net.conf /etc/nginx/sites-available/
rm -f /etc/nginx/sites-enabled/default
ln -sf /etc/nginx/sites-available/nginx-card-wars-kingdom.com.conf /etc/nginx/sites-enabled/
ln -sf /etc/nginx/sites-available/nginx-cardwars-kingdom.net.conf /etc/nginx/sites-enabled/

# Paso 9: Configurar firewall
echo ""
echo -e "${YELLOW}[9/10] Configurando firewall UFW...${NC}"
ufw --force enable
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw status

# Paso 10: Mensaje final
echo ""
echo -e "${YELLOW}[10/10] Finalizando instalación...${NC}"
echo ""
echo -e "${GREEN}=================================================="
echo "  ✓ Instalación base completada"
echo "==================================================${NC}"
echo ""
echo -e "${YELLOW}SIGUIENTE PASO:${NC}"
echo ""
echo "1. Genera los certificados Origin en Cloudflare:"
echo "   - Para card-wars-kingdom.com"
echo "   - Para cardwars-kingdom.net"
echo ""
echo "2. Copia los certificados al servidor:"
echo ""
echo "   ${GREEN}# Para card-wars-kingdom.com:${NC}"
echo "   sudo nano /etc/ssl/certs/card-wars-kingdom.com.crt"
echo "   sudo nano /etc/ssl/private/card-wars-kingdom.com.key"
echo "   sudo chmod 600 /etc/ssl/private/card-wars-kingdom.com.key"
echo ""
echo "   ${GREEN}# Para cardwars-kingdom.net:${NC}"
echo "   sudo nano /etc/ssl/certs/cardwars-kingdom.net.crt"
echo "   sudo nano /etc/ssl/private/cardwars-kingdom.net.key"
echo "   sudo chmod 600 /etc/ssl/private/cardwars-kingdom.net.key"
echo ""
echo "3. Inicia los servicios:"
echo "   ${GREEN}sudo bash /var/www/Welcome-Card-Wars-Kingdom/vps-deployment/scripts/start-services.sh${NC}"
echo ""
echo "4. Configura DNS en Cloudflare apuntando a: ${GREEN}159.89.157.63${NC}"
echo ""
echo "5. Activa SSL Full (strict) y Authenticated Origin Pulls en Cloudflare"
echo ""
echo -e "${YELLOW}Consulta COMPLETE-DEPLOYMENT-GUIDE.md para más detalles${NC}"
echo ""
