"""
WSGI entry point for production deployment with Gunicorn
Usage: gunicorn --bind 0.0.0.0:3000 --workers 4 wsgi:app
"""
from app import app

if __name__ == "__main__":
    app.run()
