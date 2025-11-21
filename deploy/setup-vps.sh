#!/bin/bash

# VPS Setup Script for Card Wars Kingdom
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}Card Wars Kingdom - VPS Setup${NC}"
echo "=============================="
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Please run as root (use sudo)${NC}"
    exit 1
fi

# Update system
echo -e "${YELLOW}Updating system packages...${NC}"
apt-get update && apt-get upgrade -y

# Install dependencies
echo -e "${YELLOW}Installing dependencies...${NC}"
apt-get install -y python3-pip python3-venv nginx git curl

# Create project directory
PROJECT_DIR="/var/www/cardwars-kingdom"
echo -e "${YELLOW}Creating project directory: $PROJECT_DIR${NC}"
mkdir -p $PROJECT_DIR

# Setup virtual environment
echo -e "${YELLOW}Setting up Python virtual environment...${NC}"
python3 -m venv $PROJECT_DIR/venv

# Create log directories
echo -e "${YELLOW}Creating log directories...${NC}"
mkdir -p /var/log/gunicorn
mkdir -p /var/log/nginx

# Set permissions
echo -e "${YELLOW}Setting permissions...${NC}"
chown -R www-data:www-data $PROJECT_DIR
chown -R www-data:www-data /var/log/gunicorn

echo ""
echo -e "${GREEN}Setup completed successfully!${NC}"
echo ""
echo "Next steps:"
echo "1. Copy your application files to $PROJECT_DIR"
echo "2. Install requirements: source $PROJECT_DIR/venv/bin/activate && pip install -r requirements.txt"
echo "3. Configure Nginx: copy nginx config to /etc/nginx/sites-available/"
echo "4. Configure systemd service: copy service file to /etc/systemd/system/"
echo "5. Start services: systemctl start cardwars-kingdom-net.service"
