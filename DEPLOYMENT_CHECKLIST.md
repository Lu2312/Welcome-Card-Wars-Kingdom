# ✅ Deployment Checklist - Card Wars Kingdom

Usa esta lista de verificación para asegurar un despliegue exitoso.

## 📋 Antes del Despliegue

### Preparación del Código
- [ ] Código está en un repositorio Git
- [ ] Todas las dependencias están en `requirements.txt`
- [ ] Variables de entorno están en `.env.example` (no en `.env`)
- [ ] `.gitignore` incluye `.env`, `venv/`, `__pycache__/`
- [ ] `README.md` está actualizado
- [ ] Tests básicos pasan localmente

### Configuración
- [ ] `SECRET_KEY` generada (nunca usar la de ejemplo)
- [ ] `FLASK_ENV=production` configurado
- [ ] Puerto correcto configurado (3000 o $PORT para plataformas)
- [ ] Logs configurados correctamente

### Archivos de Despliegue
- [ ] `Procfile` existe (para Heroku)
- [ ] `runtime.txt` especifica versión de Python (Heroku)
- [ ] `vercel.json` configurado (para Vercel)
- [ ] `render.yaml` configurado (para Render)
- [ ] `railway.json` configurado (para Railway)
- [ ] `Dockerfile` funcional (para Docker)
- [ ] `docker-compose.yml` configurado
- [ ] `nginx.conf` preparado (para VPS)
- [ ] `cardwars.service` preparado (para systemd)

## 🚀 Durante el Despliegue

### Plataforma Cloud
- [ ] Cuenta creada en la plataforma elegida
- [ ] Repositorio conectado
- [ ] Variables de entorno configuradas
- [ ] Plan/tier seleccionado
- [ ] Región/ubicación seleccionada
- [ ] Build inicia correctamente
- [ ] Deploy completa sin errores

### VPS
- [ ] Servidor accesible por SSH
- [ ] Python 3.8+ instalado
- [ ] Nginx instalado y configurado
- [ ] Certbot instalado (para SSL)
- [ ] Firewall configurado (puertos 80, 443, 22)
- [ ] Servicio systemd creado
- [ ] Servicio habilitado y iniciado

### Docker
- [ ] Docker instalado
- [ ] Imagen construye exitosamente
- [ ] Contenedor inicia correctamente
- [ ] Puerto mapeado correctamente
- [ ] Variables de entorno pasadas al contenedor
- [ ] Logs son accesibles

## ✅ Después del Despliegue

### Verificación Básica
- [ ] Aplicación responde en la URL
- [ ] `/api/health` devuelve 200 OK
- [ ] Página principal carga correctamente
- [ ] Archivos estáticos se cargan (CSS, JS, imágenes)
- [ ] No hay errores 500 en los logs
- [ ] Certificado SSL funciona (si aplica)

### Pruebas Funcionales
- [ ] Navegación entre páginas funciona
- [ ] API endpoints responden correctamente
- [ ] `/cards` muestra las cartas
- [ ] `/status` muestra el estado
- [ ] `/download` carga correctamente
- [ ] `/api/users/online` funciona

### Seguridad
- [ ] HTTPS habilitado (en producción)
- [ ] `SECRET_KEY` es única y segura
- [ ] `.env` NO está en el repositorio
- [ ] Headers de seguridad configurados
- [ ] Firewall configurado correctamente
- [ ] Puertos innecesarios cerrados
- [ ] Actualizaciones de seguridad aplicadas

### Performance
- [ ] Tiempo de respuesta < 2 segundos
- [ ] Archivos estáticos tienen cache
- [ ] Compresión gzip habilitada
- [ ] Workers de Gunicorn adecuados para el tráfico
- [ ] Límites de recursos configurados

### Monitoreo
- [ ] Logs son accesibles
- [ ] Sistema de monitoreo configurado (opcional)
- [ ] Alertas configuradas (opcional)
- [ ] Backup configurado (si hay datos)

## 📊 Configuración por Plataforma

### Vercel
- [ ] Proyecto creado
- [ ] Build settings correctos
- [ ] Environment variables agregadas
- [ ] Dominio personalizado (opcional)
- [ ] Deploy hooks configurados (opcional)

### Railway
- [ ] Proyecto creado
- [ ] GitHub conectado
- [ ] Variables de entorno configuradas
- [ ] Dominio asignado
- [ ] Monitoreo activo

### Render
- [ ] Web service creado
- [ ] Build y start commands correctos
- [ ] Environment variables configuradas
- [ ] Health check path configurado
- [ ] Auto-deploy habilitado

### Heroku
- [ ] App creada
- [ ] Git remote agregado
- [ ] Config vars configuradas
- [ ] Dynos asignados
- [ ] Add-ons instalados (si es necesario)

### Docker
- [ ] Imagen tagged correctamente
- [ ] Puerto expuesto
- [ ] Volúmenes montados (si es necesario)
- [ ] Network configurada
- [ ] Restart policy configurada

### VPS
- [ ] Usuario de servicio creado
- [ ] Permisos configurados correctamente
- [ ] Nginx configurado como proxy reverso
- [ ] SSL/TLS certificado instalado
- [ ] Systemd service funcionando
- [ ] Auto-start habilitado

## 🔄 Post-Despliegue

### Documentación
- [ ] URL de producción documentada
- [ ] Credenciales guardadas de forma segura
- [ ] Procedimientos de rollback documentados
- [ ] Contactos de soporte listados

### Comunicación
- [ ] Equipo notificado del despliegue
- [ ] Usuarios informados (si aplica)
- [ ] Changelog actualizado
- [ ] Release notes publicadas

### Mantenimiento
- [ ] Plan de actualización definido
- [ ] Calendario de mantenimiento establecido
- [ ] Procedimiento de backup probado
- [ ] Plan de recuperación ante desastres

## 🆘 Troubleshooting

### Si algo falla:

1. **Revisar logs**
   ```bash
   # Vercel/Railway/Render: Ver en dashboard
   # Heroku: heroku logs --tail
   # Docker: docker logs nombre-contenedor
   # VPS: sudo journalctl -u cardwars -f
   ```

2. **Verificar variables de entorno**
   ```bash
   # Asegurarse de que estén configuradas
   # Verificar que SECRET_KEY esté presente
   ```

3. **Revisar conectividad**
   ```bash
   curl -I https://tu-dominio.com
   curl https://tu-dominio.com/api/health
   ```

4. **Reiniciar servicio**
   ```bash
   # Plataforma Cloud: Redeploy desde dashboard
   # VPS: sudo systemctl restart cardwars
   # Docker: docker restart nombre-contenedor
   ```

## 📝 Notas Importantes

- **Nunca** uses `DEBUG=True` en producción
- **Siempre** usa HTTPS en producción
- **Actualiza** dependencias regularmente
- **Monitorea** logs y métricas
- **Haz backup** regularmente
- **Prueba** los rollbacks antes de necesitarlos

## ✨ Optimizaciones Opcionales

- [ ] CDN para archivos estáticos
- [ ] Redis para caché
- [ ] Load balancer para alta disponibilidad
- [ ] Auto-scaling configurado
- [ ] CI/CD pipeline automatizado
- [ ] Monitoring con Prometheus/Grafana
- [ ] Logging centralizado

---

## 🎯 Estado de Despliegue

Marca el estado de tu despliegue:

- [ ] 🔴 No desplegado
- [ ] 🟡 En progreso
- [ ] 🟢 Desplegado exitosamente
- [ ] ✅ Verificado y funcionando

**Fecha de despliegue**: _____________

**URL de producción**: _____________

**Plataforma usada**: _____________

**Notas adicionales**: 

_________________________________________________________________

_________________________________________________________________

---

¡Buena suerte con tu despliegue! 🚀🎴
