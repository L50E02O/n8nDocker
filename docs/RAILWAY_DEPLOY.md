# Guía de Despliegue de n8n en Railway

Usa esta guía cuando en **deploy.yml** tengas `target: railway`.

Despliegue de n8n en Railway paso a paso.

## Requisitos Previos

- Cuenta de GitHub
- Cuenta en [Railway](https://railway.app/) (gratis)
- Repositorio de este proyecto en GitHub

---

## Pasos de Despliegue

### Paso 1: Preparar el Repositorio

```bash
# Si aún no has subido el proyecto a GitHub:
git init
git add .
git commit -m "Initial commit: n8n Docker para Railway"
git remote add origin https://github.com/TU_USUARIO/n8nDocker.git
git branch -M main
git push -u origin main
```

### Paso 2: Crear Proyecto en Railway

1. Ve a **https://railway.app/**
2. Click en **"Start a New Project"** o **"Login"**
3. **Regístrate con GitHub** (recomendado para deployment automático)
4. Autoriza Railway para acceder a tus repositorios
5. Click **"New Project"**
6. Selecciona **"Deploy from GitHub repo"**
7. Selecciona tu repositorio `n8nDocker`
8. Railway detectará automáticamente el `Dockerfile` y comenzará a desplegar

### Paso 3: Configurar Variables de Entorno

Mientras se despliega, configura las variables en Railway:

1. En Railway, ve a tu proyecto
2. Click en el servicio (aparecerá automáticamente)
3. Ve a la pestaña **"Variables"**
4. Click en **"New Variable"** y agrega cada una:

#### Variables Obligatorias:

```bash
# Autenticación básica (OBLIGATORIO)
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=TuPasswordSegura123!

# Clave de encriptación (OBLIGATORIO - mínimo 32 caracteres)
N8N_ENCRYPTION_KEY=genera-clave-aleatoria-larga-aqui-abc123xyz789

# Zona horaria
GENERIC_TIMEZONE=America/Bogota
TZ=America/Bogota

# Nivel de logs
N8N_LOG_LEVEL=info
```

**Consejo**: Para generar `N8N_ENCRYPTION_KEY`, usa cualquier texto largo y aleatorio (mínimo 32 caracteres). Puedes usar un generador online o simplemente escribir caracteres aleatorios.

### Paso 4: Configurar Volumen Persistente (Recomendado)

**IMPORTANTE**: Sin esto, cada deploy borrará tus workflows y configuración.

Para mantener tus workflows de n8n guardados entre deploys:

1. En Railway → Tu servicio → **"Settings"**
2. Scroll hasta **"Volumes"**
3. Click **"Add Volume"**
4. Configuración:
   - **Mount Path**: `/home/node/.n8n`
   - **Size**: `0.5 GB` (máximo en plan gratuito)
5. Click **"Add"**

Railway reiniciará el servicio automáticamente.

**Guía completa**: [PERSISTENCIA.md](PERSISTENCIA.md)

---

## Verificación Post-Despliegue

### 1. Verificar que el servicio está corriendo:

- Railway → Tu servicio → Estado debe ser **"Active"** (verde)

### 2. Obtener la URL:

- Railway → Settings → **Domains**
- Copia la URL (ej: `https://xxx.railway.app`)
- O Railway generará una URL automáticamente

### 3. Acceder a n8n:

- Abre la URL en tu navegador
- Login:
  - Usuario: `admin` (o el que configuraste en `N8N_BASIC_AUTH_USER`)
  - Password: La que pusiste en `N8N_BASIC_AUTH_PASSWORD`

### 4. Crear tu primer workflow:

1. En n8n, click **"Add workflow"**
2. Crea tu workflow personalizado
3. **Activa** el workflow (toggle verde)
4. ¡Listo! Tu n8n está funcionando en Railway

---

## Repositorios Privados

### ¿Puedo hacer mi proyecto privado después de desplegarlo?

**Respuesta**: **SÍ**, pero hay algunas consideraciones:

✅ **Lo que funciona**:
- El servicio seguirá desplegado en Railway
- Railway seguirá teniendo acceso si ya autorizaste la Railway GitHub App
- Los deploys automáticos seguirán funcionando

⚠️ **Qué puede pasar**:
- Railway puede hacer un redeploy automático cuando detecte el cambio
- Si no autorizaste acceso a repositorios privados, puede fallar

### Cómo verificar permisos de Railway:

1. Ve a GitHub → **Settings** → **Applications** → **Installed GitHub Apps**
2. Busca **Railway**
3. Verifica que tenga acceso a **"All repositories"** o al menos a tu repositorio privado
4. Si no tiene acceso, click en **"Configure"** y otorga permisos

---

## Checklist Final

Antes de dar por terminado, verifica:

- [ ] Servicio en Railway está **"Active"**
- [ ] Puedes acceder a n8n con la URL de Railway
- [ ] Login funciona con las credenciales configuradas
- [ ] Variables de entorno están configuradas
- [ ] Volumen persistente está montado (`/home/node/.n8n`)
- [ ] Puedes crear y activar workflows en n8n

---

## Solución de Problemas

### El servicio no inicia:

**Síntomas**: Estado "Crashed" o "Error"

**Solución**:
1. Ve a **Deploy Logs** para ver el error
2. Verifica que el `Dockerfile` esté correcto
3. Verifica que todas las variables obligatorias estén configuradas:
   - `N8N_BASIC_AUTH_ACTIVE`
   - `N8N_BASIC_AUTH_USER`
   - `N8N_BASIC_AUTH_PASSWORD`
   - `N8N_ENCRYPTION_KEY`
4. Click en **"Redeploy"** después de corregir

### No puedo acceder a n8n:

**Síntomas**: Error 401 o página en blanco

**Solución**:
1. Verifica que `N8N_BASIC_AUTH_ACTIVE=true`
2. Verifica que `N8N_BASIC_AUTH_USER` y `N8N_BASIC_AUTH_PASSWORD` estén configurados
3. Usa las credenciales exactas que configuraste
4. Verifica la URL en Railway → Settings → Domains

### Los workflows se pierden después de redeploy:

**Síntomas**: Workflows desaparecen después de cada deploy

**Solución**:
1. Verifica que el volumen esté montado: Railway → Settings → Volumes
2. Debe aparecer: `/home/node/.n8n` → 0.5 GB
3. Si no está, agrégalo siguiendo el Paso 4
4. Ver guía completa: [PERSISTENCIA.md](PERSISTENCIA.md)

---

## Comandos Útiles

### Ver logs en tiempo real:

```bash
railway logs -f
```

### Redeploy manual:

```bash
railway up
```

### Ver variables configuradas:

```bash
railway variables
```

### Conectar al contenedor:

```bash
railway run bash
```

---

## ¡Todo Listo!

Si completaste todos los pasos del checklist, tu n8n está funcionando correctamente en Railway.

Puedes comenzar a crear tus workflows de automatización. 🎉

---

## Enlaces Útiles

- [Documentación oficial de Railway](https://docs.railway.app/)
- [Documentación oficial de n8n](https://docs.n8n.io/)
- [Guía de Persistencia](PERSISTENCIA.md)
- [Solución de Problemas](TROUBLESHOOTING.md)
