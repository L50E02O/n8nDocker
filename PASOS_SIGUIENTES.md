# 🎯 Próximos Pasos - Tu Configuración Específica

Ya tienes tu contenedor desplegado en Railway. Ahora sigue estos pasos para completar la configuración.

---

## ✅ Estado Actual

- ✅ Contenedor desplegado en Railway
- ✅ Archivos de configuración listos
- ✅ Scripts de automatización actualizados
- ✅ Workflows de n8n configurados para UTC-5
- ⏳ Pendiente: Configurar repositorio y activar workflow

---

## 📝 Pasos a Seguir

### Paso 1: Configurar Variables de Entorno en Railway ⚙️

Ve a tu proyecto en Railway → **Variables** y verifica/agrega estas variables:

```bash
# Autenticación de n8n (OBLIGATORIO)
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=TuPasswordSegura123

# Zona horaria UTC-5 (OBLIGATORIO)
GENERIC_TIMEZONE=America/Bogota
TZ=America/Bogota

# Logging
N8N_LOG_LEVEL=info

# Clave de encriptación (genera una aleatoria de 32+ caracteres)
N8N_ENCRYPTION_KEY=abc123xyz456def789ghi012jkl345mno678pqr

# Git - USA TU NOMBRE Y EMAIL DE GITHUB (OBLIGATORIO)
GIT_USER_NAME=Tu Nombre Completo
GIT_USER_EMAIL=tu-email@github.com

# Token de GitHub (SOLO si usarás modo PR)
GITHUB_TOKEN=ghp_tu_token_personal
```

**Importante**: El email debe coincidir con tu cuenta de GitHub para que los commits cuenten en tu perfil.

#### 🔐 Cómo Generar el Token de GitHub

1. Ve a GitHub → **Settings** → **Developer settings** → **Personal access tokens** → **Tokens (classic)**
   - URL directa: https://github.com/settings/tokens

2. Click en **"Generate new token (classic)"**

3. Configuración del token:
   - **Note**: `commitDiario - Railway Automation`
   - **Expiration**: 
     - ✅ **Recomendado**: `90 days` o `1 year`
     - ⚠️ Evita `No expiration` por seguridad
   
4. **Permisos necesarios**:
   
   **Para Commits Directos (básico):**
   - ✅ `repo` (Full control of private repositories)
   
   **Para Pull Requests (completo):**
   - ✅ `repo` (Full control of private repositories)
   - ✅ `workflow` (Update GitHub Action workflows) - opcional pero recomendado

5. Click en **"Generate token"**

6. **IMPORTANTE**: Copia el token inmediatamente (empieza con `ghp_`)
   - Solo se muestra una vez
   - Guárdalo en un lugar seguro (gestor de contraseñas)

7. Pega el token en Railway → Variables → `GITHUB_TOKEN`

**📖 Guía completa del token**: Ver [docs/GITHUB_TOKEN_GUIDE.md](docs/GITHUB_TOKEN_GUIDE.md) para más detalles sobre seguridad, renovación y solución de problemas.

---

### Paso 2: Hacer Push de los Cambios 📤

Los archivos ya están actualizados localmente. Ahora súbelos a GitHub:

```bash
# En tu terminal (PowerShell)
cd C:\Users\leoan\Desktop\commitDiario

# Ver cambios
git status

# Agregar todos los cambios
git add .

# Hacer commit
git commit -m "feat: configurar workflow para UTC-5 y agregar guías de configuración"

# Push a GitHub
git push origin main
```

Railway detectará los cambios y redespleará automáticamente.

---

### Paso 3: Configurar el Repositorio Git en Railway 🔧

Ahora necesitas configurar el repositorio dentro del contenedor de Railway:

#### Opción A: Script Automático (Recomendado) ⚡

```bash
# 1. Instalar Railway CLI (si no lo tienes)
npm install -g @railway/cli

# 2. Login
railway login

# 3. Conectar a tu proyecto
railway link

# 4. Ejecutar script de configuración
railway run bash /scripts/setup_railway.sh
```

El script te pedirá:
- Tu nombre completo
- Tu email de GitHub
- La URL de tu repositorio (este mismo: `https://github.com/TU_USUARIO/commitDiario.git`)

#### Opción B: Configuración Manual 🔨

```bash
# 1. Acceder al contenedor
railway run bash

# 2. Configurar Git
cd /repo
git init
git config user.name "Tu Nombre Completo"
git config user.email "tu-email@github.com"

# 3. Agregar remoto (CAMBIA TU_USUARIO por tu usuario de GitHub)
git remote add origin https://github.com/TU_USUARIO/commitDiario.git
git branch -M main

# 4. Crear commit inicial
echo "# Daily Commits - Automated System" > README.md
git add README.md
git commit -m "Initial commit: Setup automated commits"

# 5. Push (te pedirá usuario y token)
git push -u origin main
# Usuario: tu_usuario_github
# Password: ghp_tu_token_personal (genera uno en GitHub si no tienes)
```

---

### Paso 4: Configurar config.json 📝

Edita el archivo de configuración con tus datos:

```bash
# En tu máquina local
notepad C:\Users\leoan\Desktop\commitDiario\config\config.json
```

**Para Commits Directos (Recomendado para empezar):**

```json
{
  "commits_per_day": 1,
  "repo_path": "/repo",
  "commit_message_template": "🤖 Automated daily commit {date}",
  "git_user_name": "Tu Nombre Completo",
  "git_user_email": "tu-email@github.com",
  "auto_push": true,
  "timezone": "America/Bogota",
  
  "use_pr_workflow": false
}
```

**Para Pull Requests Automáticos:**

```json
{
  "commits_per_day": 1,
  "repo_path": "/repo",
  "commit_message_template": "🤖 Automated daily commit {date}",
  "git_user_name": "Tu Nombre Completo",
  "git_user_email": "tu-email@github.com",
  "auto_push": true,
  "timezone": "America/Bogota",
  
  "use_pr_workflow": true,
  "github_token": "",
  "github_repo_owner": "TU_USUARIO",
  "github_repo_name": "commitDiario",
  "merge_method": "squash",
  "auto_cleanup_branch": true
}
```

Guarda y haz push:

```bash
git add config/config.json
git commit -m "config: personalizar configuración"
git push
```

---

### Paso 5: Acceder a n8n e Importar Workflow 🔄

1. **Obtén tu URL de Railway**:
   - Railway Dashboard → Tu servicio → Settings → Domains
   - Copia la URL (ej: `https://tu-proyecto.railway.app`)

2. **Accede a n8n**:
   - Abre la URL en tu navegador
   - Login:
     - Usuario: `admin` (o el que configuraste)
     - Password: El de `N8N_BASIC_AUTH_PASSWORD`

3. **Importar Workflow**:
   - Click en **Workflows** (menú lateral)
   - Click en **"+"** → **"Import from File"**
   - Selecciona el archivo según tu modo:
     - **Commits directos**: `n8n-workflow.json`
     - **Pull Requests**: `n8n-workflow-pr.json`
   - El workflow se importará

4. **Configurar Horario**:
   - Click en el nodo **"Schedule Trigger"**
   - Ya está configurado para las 9:00 AM (UTC-5)
   - Puedes cambiarlo editando el cron expression:
     ```
     0 9 * * *   # 9:00 AM
     0 12 * * *  # 12:00 PM
     0 18 * * *  # 6:00 PM
     0 0 * * *   # Medianoche
     ```

5. **Activar Workflow**:
   - En la esquina superior derecha
   - Activa el toggle **"Active"** (debe ponerse verde ✅)

---

### Paso 6: Probar el Sistema 🧪

#### Prueba Automática de Configuración

```bash
railway run python3 /scripts/test_setup.py
```

Esto verificará:
- ✅ Archivo de configuración
- ✅ Directorio del repositorio
- ✅ Git instalado
- ✅ Configuración de Git
- ✅ Repositorio remoto
- ✅ Dependencias de Python
- ✅ Token de GitHub (si aplica)

#### Prueba Manual de Commit

```bash
# Modo commit directo
railway run python3 /scripts/commit_automator.py

# Modo Pull Request
railway run python3 /scripts/pr_automator.py
```

**Salida esperada:**

```
============================================================
🤖 Iniciando automatización de commits diarios
============================================================
⚙️  Configurando Git (user: Tu Nombre, email: tu@email.com)
📊 Commits a realizar: 1

🔄 Realizando commit 1/1...
✅ Commit #1 realizado exitosamente
📤 Empujando commits a la rama 'main'...
✅ Push realizado exitosamente

============================================================
✅ Proceso completado exitosamente
============================================================
```

#### Verificar en GitHub

1. Ve a tu repositorio: `https://github.com/TU_USUARIO/commitDiario`
2. Debes ver el commit recién creado
3. Verifica que el autor sea correcto

---

### Paso 7: Verificar Ejecución Automática 🎯

1. **En n8n**:
   - Ve a **Executions** (menú lateral)
   - Verifica que no haya errores
   - La próxima ejecución será a las 9:00 AM (UTC-5)

2. **Monitoreo**:
   ```bash
   # Ver logs en tiempo real
   railway logs -f
   ```

3. **Al día siguiente**:
   - Verifica que se haya creado un nuevo commit automáticamente
   - Revisa tu perfil de GitHub para ver la contribución

---

## 📊 Resumen de Configuración

### Horario Configurado

- **Frecuencia**: Cada 24 horas
- **Hora**: 9:00 AM (UTC-5)
- **Zona horaria**: America/Bogota (Colombia/Perú/Ecuador)

### Modo de Operación

Elige uno:

- **Commits Directos**: 1 contribución por día, configuración simple
- **Pull Requests**: 2+ contribuciones por día (commit + merge), requiere token

### Repositorio Objetivo

- **Repositorio**: Este mismo (`commitDiario`)
- **Rama**: `main`
- **Archivo modificado**: `daily_commit_data.txt` (commits directos) o `feature_*.md` (PRs)

---

## 🔍 Verificación Final

Antes de dar por terminado, verifica:

- [ ] Variables de entorno configuradas en Railway
- [ ] Cambios pusheados a GitHub
- [ ] Repositorio Git configurado en `/repo`
- [ ] `config.json` personalizado con tus datos
- [ ] Workflow importado en n8n
- [ ] Workflow **activado** (toggle verde)
- [ ] Prueba manual exitosa
- [ ] Commit visible en GitHub
- [ ] Email del commit coincide con tu GitHub

---

## 📚 Documentación Adicional

- **Guía completa de configuración**: [docs/CONFIGURACION_WORKFLOW.md](docs/CONFIGURACION_WORKFLOW.md)
- **Comandos útiles**: [docs/COMANDOS_RAPIDOS.md](docs/COMANDOS_RAPIDOS.md)
- **Solución de problemas**: [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)
- **Modo Pull Request**: [docs/PR_MODE.md](docs/PR_MODE.md)

---

## 🎉 ¡Listo!

Una vez completados todos los pasos, tu sistema estará funcionando automáticamente.

**Próxima ejecución**: Mañana a las 9:00 AM (UTC-5)

**Monitoreo**: n8n → Executions

---

## 💡 Tips Finales

1. **Email correcto**: Asegúrate de que el email en Git coincida con tu GitHub
2. **Token seguro**: Si usas modo PR, genera un token con permisos `repo` y configúralo para 90 días o 1 año
3. **Renovación del token**: Configura un recordatorio 1 semana antes de que expire para renovarlo
4. **Monitoreo**: Revisa las ejecuciones en n8n cada semana
5. **Backup**: Exporta tu workflow de n8n periódicamente
6. **Logs**: Si algo falla, revisa `railway logs -f`

### 🔄 Renovar Token Expirado

Si tu token expira, el sistema dejará de funcionar. Para renovarlo:

1. Genera un nuevo token en GitHub (mismo proceso)
2. Actualiza en Railway:
   ```bash
   railway variables set GITHUB_TOKEN=ghp_nuevo_token_aqui
   ```
3. Railway reiniciará automáticamente el servicio
4. Verifica que funcione: `railway run python3 /scripts/pr_automator.py`

---

## 🆘 ¿Necesitas Ayuda?

Si algo no funciona:

1. Ejecuta: `railway run python3 /scripts/test_setup.py`
2. Revisa: [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md)
3. Verifica logs: `railway logs -f`

---

**¡Éxito con tu automatización de commits! 🚀**
