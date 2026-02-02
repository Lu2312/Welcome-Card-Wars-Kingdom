#!/bin/bash

# Card Wars Kingdom - Clean Deployment Script
# Este script realiza un despliegue limpio completo en la VPS

set -e  # Exit on any error

echo "🚀 Card Wars Kingdom - Clean Deployment Script"
echo "=============================================="

# Configuration
VPS_HOST="root@159.89.157.63"
PROJECT_PATH="/var/www/cardwars-kingdom"
REPO_URL="https://github.com/Lu2312/Welcome-Card-Wars-Kingdom.git"
SERVICE_NAME="cardwars-kingdom-net.service"

echo "📋 Configuration:"
echo "  VPS Host: $VPS_HOST"
echo "  Project Path: $PROJECT_PATH"
echo "  Repository: $REPO_URL"
echo "  Service: $SERVICE_NAME"
echo ""

read -p "¿Continuar con el despliegue limpio? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Despliegue cancelado."
    exit 1
fi

echo "🛑 Step 1: Stopping service..."
ssh $VPS_HOST "systemctl stop $SERVICE_NAME || true"

echo "📦 Step 2: Creating backup of existing deployment..."
BACKUP_NAME="$PROJECT_PATH.backup.$(date +%Y%m%d_%H%M%S)"
ssh $VPS_HOST "if [ -d '$PROJECT_PATH' ]; then mv '$PROJECT_PATH' '$BACKUP_NAME' && echo '✅ Backup created: $BACKUP_NAME'; else echo 'ℹ️  No existing deployment found'; fi"

echo "📥 Step 3: Cloning fresh repository..."
ssh $VPS_HOST "cd /var/www && git clone $REPO_URL cardwars-kingdom"

echo "🐍 Step 4: Setting up Python virtual environment..."
ssh $VPS_HOST "cd $PROJECT_PATH && python3 -m venv venv"

echo "📦 Step 5: Installing dependencies..."
ssh $VPS_HOST "cd $PROJECT_PATH && source venv/bin/activate && pip install -r requirements.txt"

echo "🔐 Step 6: Setting correct permissions..."
ssh $VPS_HOST "chown -R www-data:www-data $PROJECT_PATH"

echo "🚀 Step 7: Starting service..."
ssh $VPS_HOST "systemctl start $SERVICE_NAME"

echo "🔍 Step 8: Verifying deployment..."
sleep 3
SERVICE_STATUS=$(ssh $VPS_HOST "systemctl is-active $SERVICE_NAME")
if [ "$SERVICE_STATUS" = "active" ]; then
    echo "✅ Service is running!"
else
    echo "❌ Service failed to start. Status: $SERVICE_STATUS"
    ssh $VPS_HOST "systemctl status $SERVICE_NAME --no-pager -l"
    exit 1
fi

echo "🌐 Step 9: Testing website..."
HTTP_STATUS=$(ssh $VPS_HOST "curl -s -o /dev/null -w '%{http_code}' https://cardwars-kingdom.net/")
if [ "$HTTP_STATUS" = "200" ]; then
    echo "✅ Website is responding correctly!"
else
    echo "⚠️  Website returned HTTP $HTTP_STATUS"
fi

echo ""
echo "🎉 Clean deployment completed successfully!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Deployment Summary:"
echo "  • Service Status: $(ssh $VPS_HOST "systemctl is-active $SERVICE_NAME")"
echo "  • Website Status: HTTP $HTTP_STATUS"
echo "  • Backup Location: $BACKUP_NAME"
echo "  • Project Path: $PROJECT_PATH"
echo ""
echo "🔗 Website: https://cardwars-kingdom.net/"
echo "🔍 Check status: ssh $VPS_HOST 'systemctl status $SERVICE_NAME'"
echo "📋 View logs: ssh $VPS_HOST './deploy/logs.sh'"