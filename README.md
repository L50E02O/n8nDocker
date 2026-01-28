# n8nDocker - n8n en Railway

<div align="center">

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Railway](https://img.shields.io/badge/deploy-railway-blueviolet.svg)
![n8n](https://img.shields.io/badge/automation-n8n-orange.svg)

**Despliega n8n en Railway de forma rápida y sencilla** 

[Inicio Rápido](#-inicio-rápido) • [Documentación](docs/) • [Licencia](#-licencia)
         
</div>

---

## Descripción

Contenedor Docker optimizado para desplegar n8n en Railway. Incluye configuración lista para usar y documentación completa para el despliegue.

### Características

- **Contenedor Docker simple** - Basado en la imagen oficial de n8n
- **Listo para Railway** - Configuración optimizada para Railway
- **Plan Gratuito** - Funciona en el plan gratuito de Railway ($5 crédito/mes)
- **Persistencia** - Configuración de volúmenes para mantener tus workflows
- **Fácil Setup** - Despliegue en menos de 5 minutos

---

## Inicio Rápido

### Requisitos Previos

- Cuenta de GitHub
- Cuenta en [Railway](https://railway.app/) (gratis)

### Despliegue en 3 Pasos

```bash
# 1. Clonar este repositorio
git clone https://github.com/TU_USUARIO/n8nDocker.git
cd n8nDocker

# 2. Subir a tu GitHub
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/TU_USUARIO/n8nDocker.git
git push -u origin main

# 3. Desplegar en Railway
# Ve a railway.app → New Project → Deploy from GitHub repo
```

**Guía completa**: [docs/RAILWAY_DEPLOY.md](docs/RAILWAY_DEPLOY.md)

---

## Configuración

### Variables de Entorno en Railway

Configura estas variables en Railway → Variables:

```bash
# Autenticación básica (OBLIGATORIO)
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=TuPasswordSegura123!

# Clave de encriptación (OBLIGATORIO)
N8N_ENCRYPTION_KEY=genera-clave-aleatoria-larga-aqui-minimo-32-caracteres

# Zona horaria
GENERIC_TIMEZONE=America/Bogota
TZ=America/Bogota

# Logs
N8N_LOG_LEVEL=info
```

### Volumen Persistente (Recomendado)

Para mantener tus workflows entre deploys:

1. Railway → Tu servicio → **Settings** → **Volumes**
2. Click **"Add Volume"**
3. Configuración:
   ```
   Mount Path: /home/node/.n8n
   Size: 0.5 GB
   ```
4. Click **"Add"**

**Guía completa**: [docs/PERSISTENCIA.md](docs/PERSISTENCIA.md)

---

## Documentación

| Documento | Descripción |
|-----------|-------------|
| [Despliegue en Railway](docs/RAILWAY_DEPLOY.md) | Guía paso a paso para desplegar en Railway |
| [Persistencia de Datos](docs/PERSISTENCIA.md) | Configuración de volúmenes para mantener workflows |
| [Solución de Problemas](docs/TROUBLESHOOTING.md) | Errores comunes y soluciones |

---

## Estructura del Proyecto

```
n8nDocker/
├── Dockerfile          # Configuración de Docker
├── railway.json        # Configuración de Railway
├── README.md           # Este archivo
├── LICENSE             # Licencia MIT
└── docs/               # Documentación
    ├── RAILWAY_DEPLOY.md
    ├── PERSISTENCIA.md
    └── TROUBLESHOOTING.md
```

---

## Tecnologías

- **[n8n](https://n8n.io/)** - Plataforma de automatización de workflows
- **[Docker](https://www.docker.com/)** - Containerización
- **[Railway](https://railway.app/)** - Plataforma de hosting

---

## Costos

### Railway (Plan Gratuito)

- **Crédito mensual**: $5 USD
- **Uso estimado**: ~$1-2/mes
- **Volumen 0.5 GB**: ~$0.075/mes
- **Resultado**: **Completamente gratis** dentro del crédito mensual

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
