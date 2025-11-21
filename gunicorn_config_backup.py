# Gunicorn configuration file - Backup instance

bind = "127.0.0.1:8081"
workers = 4
worker_class = "sync"
worker_connections = 1000
timeout = 30
keepalive = 2
accesslog = "/var/log/gunicorn/access_backup.log"
errorlog = "/var/log/gunicorn/error_backup.log"
loglevel = "info"
proc_name = "cardwars-kingdom-backup"
daemon = False
umask = 0
