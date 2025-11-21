#!/bin/bash

# Script para configurar SSL con Let's Encrypt
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

DOMAIN="cardwars-kingdom.net"

echo -e "${GREEN}Card Wars Kingdom - Configuración SSL${NC}"
echo "======================================"
echo ""

# Verificar que el dominio está apuntando al servidor
echo -e "${YELLOW}Verificando DNS...${NC}"
IP=$(curl -s ifconfig.me)
DNS_IP=$(dig +short $DOMAIN @8.8.8.8 | tail -n1)

# Si Cloudflare está en modo Proxied, mostrará una IP de Cloudflare
if [[ $DNS_IP =~ ^(104\.|172\.|162\.|198\.|141\.) ]]; then
    echo -e "${GREEN}✓ DNS configurado correctamente (usando Cloudflare Proxy)${NC}"
    echo "IP del servidor: $IP"
    echo "IP de Cloudflare: $DNS_IP"
else
    if [ "$IP" != "$DNS_IP" ]; then
        echo -e "${RED}⚠ Advertencia: El dominio $DOMAIN no apunta a este servidor${NC}"
        echo "IP del servidor: $IP"
        echo "IP del dominio: $DNS_IP"
        echo ""
        read -p "¿Deseas continuar de todas formas? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
fi
echo ""

# Instalar Certbot
echo -e "${YELLOW}Instalando Certbot...${NC}"
apt-get update
apt-get install -y certbot python3-certbot-nginx

# Obtener certificado SSL
echo -e "${YELLOW}Obteniendo certificado SSL...${NC}"
certbot --nginx -d $DOMAIN -d www.$DOMAIN --non-interactive --agree-tos --email admin@$DOMAIN --redirect

# Configurar renovación automática
echo -e "${YELLOW}Configurando renovación automática...${NC}"
systemctl enable certbot.timer
systemctl start certbot.timer

echo ""
echo -e "${GREEN}=========================================="
echo "SSL configurado exitosamente!${NC}"
echo ""
echo "Tu sitio ahora está disponible en:"
echo "  https://$DOMAIN"
echo "  https://www.$DOMAIN"
echo ""
echo "El certificado se renovará automáticamente cada 60 días."
echo ""
echo "IMPORTANTE: Si usas Cloudflare en modo Proxied (nube naranja):"
echo "1. Ve a Cloudflare Dashboard → SSL/TLS → Overview"
echo "2. Cambia el modo SSL/TLS a: Full (strict)"
echo ""
