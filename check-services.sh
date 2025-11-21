#!/bin/bash

echo "========================================="
echo "  Card Wars Kingdom - Service Check"
echo "========================================="
echo ""

echo "1. Systemd Services Status:"
echo "----------------------------"
systemctl is-active card-wars-kingdom-com.service 2>/dev/null && echo "✓ card-wars-kingdom.com: RUNNING" || echo "✗ card-wars-kingdom.com: STOPPED"
systemctl is-active cardwars-kingdom-net.service && echo "✓ cardwars-kingdom.net: RUNNING" || echo "✗ cardwars-kingdom.net: STOPPED"
systemctl is-active nginx.service && echo "✓ Nginx: RUNNING" || echo "✗ Nginx: STOPPED"
echo ""

echo "2. Listening Ports:"
echo "-------------------"
sudo lsof -i :5000 2>/dev/null | grep LISTEN && echo "✓ Port 5000 (.com)" || echo "✗ Port 5000 not listening"
sudo lsof -i :8080 | grep LISTEN && echo "✓ Port 8080 (.net)" || echo "✗ Port 8080 not listening"
sudo lsof -i :80 | grep LISTEN && echo "✓ Port 80 (Nginx)" || echo "✗ Port 80 not listening"
echo ""

echo "3. Health Check Endpoints:"
echo "--------------------------"
curl -s http://localhost:5000/api/health > /dev/null 2>&1 && echo "✓ card-wars-kingdom.com responding" || echo "✗ card-wars-kingdom.com not responding"
curl -s http://localhost:8080/api/health > /dev/null 2>&1 && echo "✓ cardwars-kingdom.net responding" || echo "✗ cardwars-kingdom.net not responding"
curl -s http://localhost/api/health > /dev/null 2>&1 && echo "✓ Nginx proxy responding" || echo "✗ Nginx not responding"
echo ""

echo "4. Gunicorn Processes:"
echo "----------------------"
ps aux | grep gunicorn | grep -v grep | wc -l | xargs echo "Gunicorn processes running:"
echo ""

echo "========================================="
echo "  Check complete!"
echo "========================================="
