# ⚙️ Configuración Avanzada

Guía completa de personalización del sistema.

## 📄 Archivo config.json

Ubicación: `/config/config.json`

```json
{
  "commits_per_day": 1,
  "repo_path": "/repo",
  "commit_message_template": "Commit automático del {date} #{number}",
  "git_user_name": "Commit Bot",
  "git_user_email": "bot@commitdiario.com",
  "auto_push": true,
  "timezone": "America/Bogota",
  
  "use_pr_workflow": false,
  "github_token": "",
  "github_repo_owner": "",
  "github_repo_name": "",
  "merge_method": "squash",
  "auto_cleanup_branch": true
}
```

## 🔧 Parámetros de Configuración

### Commits Básicos

#### `commits_per_day`
- **Tipo**: Número entero
- **Default**: `1`
- **Descripción**: Número de commits a realizar cada día
- **Ejemplo**: `3` (hará 3 commits diarios)

#### `commit_message_template`
- **Tipo**: String
- **Default**: `"Commit automático del {date} #{number}"`
- **Variables disponibles**:
  - `{date}`: Fecha actual (YYYY-MM-DD)
  - `{number}`: Número del commit del día
- **Ejemplos**:
  ```json
  "Daily update {date}"
  "🎯 Automated commit #{number} on {date}"
  "chore: daily maintenance"
  ```

#### `auto_push`
- **Tipo**: Boolean
- **Default**: `true`
- **Descripción**: Push automático después del commit
- **Valores**: `true` / `false`

### Configuración de Git

#### `git_user_name`
- **Tipo**: String
- **Descripción**: Nombre que aparecerá en los commits
- **Ejemplo**: `"Juan Pérez"`

#### `git_user_email`
- **Tipo**: String
- **Descripción**: Email asociado a los commits
- **Ejemplo**: `"juan@ejemplo.com"`
- **Nota**: Debe coincidir con tu email de GitHub para que cuenten las contribuciones

### Zona Horaria

#### `timezone`
- **Tipo**: String
- **Default**: `"America/Bogota"`
- **Descripción**: Zona horaria para los timestamps
- **Ejemplos**:
  - `"America/New_York"` (UTC-5/UTC-4)
  - `"America/Mexico_City"` (UTC-6)
  - `"Europe/Madrid"` (UTC+1/UTC+2)
  - `"Asia/Tokyo"` (UTC+9)
- **Lista completa**: [TZ Database](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)

### Modo Pull Request

Ver [PR_MODE.md](PR_MODE.md) para configuración completa.

## 🕐 Configuración del Horario

El horario se configura en el workflow de n8n:

### Opción 1: Intervalo Simple

En n8n → Schedule Trigger:
- **Mode**: Interval
- **Hours**: 24

### Opción 2: Cron Expression

Para hora específica:

```
# Formato: minuto hora día mes día_semana

# Diario a las 9:00 AM (hora local)
0 9 * * *

# Diario a las 6:00 PM (hora local)
0 18 * * *

# Diario a la medianoche
0 0 * * *

# Cada 12 horas
0 */12 * * *
```

**Nota**: n8n usa UTC internamente. Ajusta según tu zona horaria.

## 🔐 Variables de Entorno en Railway

Variables obligatorias:

```bash
# Autenticación de n8n
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=tu_password_seguro

# Zona horaria
GENERIC_TIMEZONE=America/Bogota
TZ=America/Bogota

# Logging
N8N_LOG_LEVEL=info

# Git (para commits)
GIT_USER_NAME=Tu Nombre
GIT_USER_EMAIL=tu@email.com
```

Variables opcionales (solo para modo PR):

```bash
# Token de GitHub
GITHUB_TOKEN=ghp_tu_token_aqui
```

## 📝 Personalización de Mensajes

### Mensajes Simples

```json
{
  "commit_message_template": "Daily update"
}
```

### Mensajes con Fecha

```json
{
  "commit_message_template": "Update {date}"
}
```

### Mensajes con Emojis

```json
{
  "commit_message_template": "🚀 Daily commit {date}"
}
```

### Mensajes Estilo Conventional Commits

```json
{
  "commit_message_template": "chore: automated daily update {date}"
}
```

## 🔄 Cambiar Configuración en Producción

### Método 1: Editar en Railway

```bash
# Conectar a Railway
railway login
railway link

# Acceder al contenedor
railway run bash

# Editar config
cd /config
vi config.json  # o nano config.json

# Reiniciar n8n (Railway lo hace automáticamente)
```

### Método 2: Actualizar en GitHub

1. Edita `config/config.json` localmente
2. Commit y push:
   ```bash
   git add config/config.json
   git commit -m "Update configuration"
   git push
   ```
3. Railway redespleará automáticamente

## 🎨 Ejemplos de Configuración

### Configuración Minimalista

```json
{
  "commits_per_day": 1,
  "commit_message_template": "update",
  "git_user_name": "Bot",
  "git_user_email": "bot@example.com"
}
```

### Configuración Completa

```json
{
  "commits_per_day": 3,
  "commit_message_template": "🎯 Automated commit #{number} on {date}",
  "git_user_name": "Juan Pérez",
  "git_user_email": "juan@ejemplo.com",
  "auto_push": true,
  "timezone": "America/Mexico_City",
  "use_pr_workflow": true,
  "github_token": "ghp_token_here",
  "github_repo_owner": "juanperez",
  "github_repo_name": "daily-commits",
  "merge_method": "squash",
  "auto_cleanup_branch": true
}
```

## 🔍 Verificar Configuración

```bash
# Ver configuración actual
railway run cat /config/config.json

# Verificar variables de entorno
railway run env | grep N8N
railway run env | grep GIT
```

## 📚 Siguiente Paso

- [Modo Pull Request](PR_MODE.md)
- [Solución de Problemas](TROUBLESHOOTING.md)
- [API y Scripts](API.md)
