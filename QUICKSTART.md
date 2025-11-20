# Quick Start Guide - Card Wars Kingdom

## ⚡ Para Comenzar Rápidamente

### Opción 1: Despliegue Local (5 minutos)

```bash
# 1. Clonar el repositorio
git clone https://github.com/Lu2312/Welcome-Card-Wars-Kingdom_files.git
cd Welcome-Card-Wars-Kingdom_files

# 2. Ejecutar el script de despliegue automático
chmod +x deploy.sh
./deploy.sh
```

El script hará todo automáticamente: crear entorno virtual, instalar dependencias, y preguntar cómo quieres ejecutar la app.

### Opción 2: Despliegue con Un Click ☁️

Elige tu plataforma favorita y despliega instantáneamente:

#### 🟢 Vercel (Más Rápido)
1. Ve a [vercel.com/new](https://vercel.com/new)
2. Importa este repositorio
3. Haz clic en "Deploy"
4. ¡Listo en 2 minutos! ✨

#### 🟣 Railway (Recomendado)
1. Ve a [railway.app/new](https://railway.app/new)
2. Selecciona "Deploy from GitHub repo"
3. Elige este repositorio
4. Railway desplegará automáticamente usando `railway.json`

#### 🎨 Render (Gratis con SSL)
1. Ve a [render.com](https://render.com)
2. Clic en "New +" → "Web Service"
3. Conecta tu cuenta de GitHub
4. Selecciona este repositorio
5. Render usará `render.yaml` automáticamente

### Opción 3: Docker (Para Expertos) 🐳

```bash
# Despliegue rápido
docker-compose up -d

# La aplicación estará disponible en:
# http://localhost:3000
```

## 📋 Configuración Mínima Requerida

Para cualquier plataforma, necesitas configurar estas variables:

| Variable | Valor | Descripción |
|----------|-------|-------------|
| `SECRET_KEY` | (generar) | Clave secreta para Flask |
| `FLASK_ENV` | `production` | Modo de producción |

### Generar SECRET_KEY:
```bash
python -c "import secrets; print(secrets.token_hex(32))"
```

## 🔗 URLs Después del Despliegue

Una vez desplegada, tu aplicación tendrá estas rutas:

- **Página Principal**: `/`
- **Cartas**: `/cards`
- **Estado del Servidor**: `/status`
- **Descargas**: `/download`
- **API Health Check**: `/api/health`
- **API Usuarios Online**: `/api/users/online`

## ✅ Verificación

Para verificar que todo funciona:

```bash
# Test local
curl http://localhost:3000/api/health

# Test en producción
curl https://tu-dominio.com/api/health
```

Deberías ver:
```json
{
  "status": "healthy",
  "service": "Card Wars Kingdom",
  "version": "1.0.0"
}
```

## 🆘 Problemas Comunes

### Error: "Module not found"
```bash
pip install -r requirements.txt
```

### Error: "Port already in use"
```bash
# Cambiar puerto en .env
PORT=8000
```

### Docker no construye
```bash
# Limpiar cache de Docker
docker system prune -a
docker-compose build --no-cache
```

## 📚 Documentación Completa

- **[Guía de Despliegue Completa (Español)](./DEPLOY.md)** - Todos los métodos de despliegue
- **[README.md](./README.md)** - Documentación general del proyecto

## 🎮 ¡A Jugar!

Una vez desplegado, abre tu navegador en la URL correspondiente y disfruta de Card Wars Kingdom.

¡Que comience la aventura! 🎴✨
