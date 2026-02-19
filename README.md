# n8nDocker - n8n en Railway y Render

<div align="center">

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Railway](https://img.shields.io/badge/deploy-railway-blueviolet.svg)
![Render](https://img.shields.io/badge/deploy-render-46e3b7.svg)
![n8n](https://img.shields.io/badge/automation-n8n-orange.svg)

**Despliega n8n con Docker en Railway o Render** 

[Inicio Rápido](#-inicio-rápido) • [Documentación](docs/) • [Licencia](#-licencia)
         
</div>

---

## Descripción

Contenedor Docker basado en la **imagen oficial de n8n** ([Docker Hub](https://hub.docker.com/r/n8nio/n8n)) para desplegar n8n en **Railway** o **Render**. Un solo repositorio, dos plataformas.

### Características

- **Imagen oficial** - Basado en `n8nio/n8n` desde Docker Hub
- **Railway y Render** - Mismo Dockerfile; `railway.json` y `render.yaml` listos
- **Puerto automático** - Compatible con el `PORT` que inyecta Render
- **Persistencia** - Volúmenes (Railway) o disco (Render plan de pago)
- **Fácil setup** - Despliegue en minutos

---

## Inicio Rápido

### Requisitos Previos

- Cuenta de GitHub
- Cuenta en [Railway](https://railway.app/) (gratis)

### Elegir plataforma y desplegar

1. **Configura dónde desplegar**: edita `deploy.yml` y pon `target: railway` o `target: render`.
2. **Sube el repo a GitHub** y conecta el repo a la plataforma elegida:
   - **Railway**: [railway.app](https://railway.app) → New Project → Deploy from GitHub repo (usa `railway.json`).
   - **Render**: [dashboard.render.com](https://dashboard.render.com) → New → Blueprint, elige este repo (usa `render.yaml`).

Guías: [Railway](docs/RAILWAY_DEPLOY.md) · [Render](docs/RENDER_DEPLOY.md)

---

## Configuración

### Variables de Entorno (Railway y Render)

Configura en **Railway** → Variables o **Render** → Environment:

```bash
# Autenticación básica (OBLIGATORIO)
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=TuPasswordSegura123!

# Clave de encriptación (OBLIGATORIO)
N8N_ENCRYPTION_KEY=genera-clave-aleatoria-larga-aqui-minimo-32-caracteres

# URL pública (recomendado para webhooks)
# Railway: https://tu-app.railway.app  |  Render: https://tu-app.onrender.com
WEBHOOK_URL=https://tu-url-final

# Zona horaria
GENERIC_TIMEZONE=America/Bogota
TZ=America/Bogota

# Logs
N8N_LOG_LEVEL=info
```

### Persistencia

- **Railway**: Settings → **Volumes** → Add Volume → Mount Path: `/home/node/.n8n`, Size: 0.5 GB. Ver [docs/PERSISTENCIA.md](docs/PERSISTENCIA.md).
- **Render**: En plan de pago, el `render.yaml` ya define un disco en `/home/node/.n8n`. En plan free no hay disco persistente.

---

## Documentación

| Documento | Descripción |
|-----------|-------------|
| [Despliegue en Railway](docs/RAILWAY_DEPLOY.md) | Guía paso a paso para Railway |
| [Despliegue en Render](docs/RENDER_DEPLOY.md) | Guía paso a paso para Render |
| [Persistencia de Datos](docs/PERSISTENCIA.md) | Volúmenes y discos para mantener workflows |
| [Solución de Problemas](docs/TROUBLESHOOTING.md) | Errores comunes y soluciones |

---

## Estructura del Proyecto

```
n8nDocker/
├── deploy.yml      # Configuración única: target (railway | render), env, persistencia
├── Dockerfile      # Imagen oficial n8nio/n8n
├── railway.json    # Usado cuando deploy.yml → target: railway
├── render.yaml    # Usado cuando deploy.yml → target: render
├── README.md
├── LICENSE
└── docs/
    ├── RAILWAY_DEPLOY.md
    ├── RENDER_DEPLOY.md
    ├── PERSISTENCIA.md
    └── TROUBLESHOOTING.md
```

---

## Tecnologías

- **[n8n](https://n8n.io/)** - Automatización de workflows ([imagen oficial](https://hub.docker.com/r/n8nio/n8n))
- **[Docker](https://www.docker.com/)** - Containerización
- **[Railway](https://railway.app/)** y **[Render](https://render.com/)** - Hosting

---

## Costos

### Railway (Plan Gratuito)

- **Crédito mensual**: $5 USD
- **Uso estimado**: ~$1-2/mes; volumen 0.5 GB ~$0.075/mes
- **Resultado**: Dentro del crédito gratuito

### Render

- **Plan free**: Sin disco persistente; servicio se apaga por inactividad.
- **Plan de pago**: Disco persistente vía `render.yaml`; ver [docs/RENDER_DEPLOY.md](docs/RENDER_DEPLOY.md).

---

## Licencia

Este proyecto está bajo la Licencia MIT. Ver [LICENSE](LICENSE) para más detalles.

```
MIT License - Copyright (c) 2026
```

---

## Soporte

### ¿Necesitas ayuda?

1. **Revisa la documentación**: [docs/](docs/)
2. **Solución de problemas**: [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)
3. **Abre un issue**: [GitHub Issues](https://github.com/TU_USUARIO/n8nDocker/issues)

### Enlaces Útiles

- [Documentación de Railway](https://docs.railway.app/)
- [Documentación de n8n](https://docs.n8n.io/)

---

<div align="center">

**¿Te resultó útil este proyecto? Dale una ⭐ en GitHub!**

[Documentación](docs/) • [Licencia](LICENSE)

</div>
