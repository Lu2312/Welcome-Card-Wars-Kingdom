#!/bin/bash

# Card Wars Kingdom - Quick Deploy Script
# This script helps you deploy the application quickly

set -e

echo "🎴 Card Wars Kingdom - Quick Deploy"
echo "===================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}Error: Python 3 is not installed${NC}"
    echo "Please install Python 3.8 or higher"
    exit 1
fi

echo -e "${GREEN}✓ Python 3 found${NC}"

# Check Python version
PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
echo "  Version: $PYTHON_VERSION"

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo ""
    echo "Creating virtual environment..."
    python3 -m venv venv
    echo -e "${GREEN}✓ Virtual environment created${NC}"
fi

# Activate virtual environment
echo ""
echo "Activating virtual environment..."
source venv/bin/activate

# Install dependencies
echo ""
echo "Installing dependencies..."
pip install -r requirements.txt --quiet
echo -e "${GREEN}✓ Dependencies installed${NC}"

# Check if .env exists, if not create from example
if [ ! -f ".env" ]; then
    if [ -f ".env.example" ]; then
        echo ""
        echo "Creating .env file from .env.example..."
        cp .env.example .env
        
        # Generate a random secret key
        SECRET_KEY=$(python3 -c "import secrets; print(secrets.token_hex(32))")
        
        # Update .env with generated secret key
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s/your-secret-key-here-change-me/$SECRET_KEY/" .env
        else
            sed -i "s/your-secret-key-here-change-me/$SECRET_KEY/" .env
        fi
        
        echo -e "${GREEN}✓ .env file created with secure SECRET_KEY${NC}"
    else
        echo -e "${YELLOW}! No .env.example found, skipping .env creation${NC}"
    fi
else
    echo -e "${GREEN}✓ .env file already exists${NC}"
fi

# Display menu
echo ""
echo "How would you like to run the application?"
echo ""
echo "1) Development mode (Flask built-in server)"
echo "2) Production mode (Gunicorn)"
echo "3) Docker"
echo "4) Exit"
echo ""
read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        echo ""
        echo "Starting in development mode..."
        echo -e "${YELLOW}Press CTRL+C to stop${NC}"
        echo ""
        python app.py
        ;;
    2)
        echo ""
        echo "Starting in production mode with Gunicorn..."
        echo -e "${YELLOW}Press CTRL+C to stop${NC}"
        echo ""
        gunicorn --bind 0.0.0.0:3000 --workers 4 wsgi:app
        ;;
    3)
        if ! command -v docker &> /dev/null; then
            echo -e "${RED}Error: Docker is not installed${NC}"
            exit 1
        fi
        
        echo ""
        echo "Building Docker image..."
        docker build -t card-wars-kingdom .
        
        echo ""
        echo "Starting Docker container..."
        docker run -p 3000:3000 --name card-wars-kingdom-app card-wars-kingdom
        ;;
    4)
        echo "Goodbye!"
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac
