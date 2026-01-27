# 🔄 Modo Pull Request

Guía completa para automatizar Pull Requests en GitHub.

## 📖 ¿Qué es el Modo PR?

En lugar de hacer commits directos a la rama principal, el sistema:
1. Crea una nueva rama
2. Hace un commit en esa rama
3. Crea un Pull Request
4. Mergea el PR automáticamente
5. Limpia la rama

**Ventaja**: Genera **2+ contribuciones** por día (commit + merge) en lugar de 1.

## ⚙️ Configuración

### 1️⃣ Crear Token de GitHub

Necesitas un token con permisos completos de repositorio:

1. Ve a: https://github.com/settings/tokens
2. **Generate new token (classic)**
3. Selecciona scope: **`repo`** (todos los permisos)
4. Genera y copia el token

### 2️⃣ Configurar Variables en Railway

Railway → Variables → Agregar:

```bash
GITHUB_TOKEN=ghp_tu_token_completo_aqui
```

### 3️⃣ Actualizar config.json

```json
{
  "use_pr_workflow": true,
  "github_token": "ghp_tu_token_aqui",
  "github_repo_owner": "tu_usuario_github",
  "github_repo_name": "nombre_del_repositorio",
  "merge_method": "squash",
  "auto_cleanup_branch": true
}
```

### 4️⃣ Importar Workflow de PRs

En n8n:
1. **Workflows** → **Import from File**
2. Selecciona `n8n-workflow-pr.json`
3. **Desactiva** el workflow anterior
4. **Activa** este nuevo workflow

## 🔧 Parámetros de Configuración

### `use_pr_workflow`
- **Tipo**: Boolean
- **Default**: `false`
- **Descripción**: Activa el modo Pull Request
- **Valores**: `true` / `false`

### `github_token`
- **Tipo**: String
- **Descripción**: Token de GitHub con permisos `repo`
- **Formato**: `ghp_xxxxxxxxxxxxxxxxxxxx`
- **Seguridad**: Nunca lo compartas públicamente

### `github_repo_owner`
- **Tipo**: String
- **Descripción**: Tu usuario de GitHub
- **Ejemplo**: `"juanperez"`

### `github_repo_name`
- **Tipo**: String
- **Descripción**: Nombre del repositorio
- **Ejemplo**: `"daily-commits"`

### `merge_method`
- **Tipo**: String
- **Default**: `"squash"`
- **Opciones**:
  - `"squash"`: Combina todos los commits en uno (recomendado)
  - `"merge"`: Merge commit tradicional
  - `"rebase"`: Rebase y fast-forward

### `auto_cleanup_branch`
- **Tipo**: Boolean
- **Default**: `true`
- **Descripción**: Elimina la rama después del merge
- **Valores**: `true` / `false`

## 🚀 Cómo Funciona

### Flujo Completo

```
1. Workflow se ejecuta (cada 24h)
   ↓
2. Crea rama: auto-contribution-20260126-140530
   ↓
3. Hace commit en la rama
   ↓
4. Push de la rama a GitHub
   ↓
5. Crea Pull Request usando GitHub API
   ↓
6. Espera 5 segundos
   ↓
7. Mergea el PR automáticamente
   ↓
8. Elimina la rama (si auto_cleanup_branch=true)
   ↓
9. ✅ Completado
```

### Contribuciones Generadas

Cada ejecución genera:
- ✅ 1 commit (en la rama)
- ✅ 1 merge (del PR)
- ✅ Total: **2 contribuciones** por día

## 🧪 Prueba Manual

```bash
# Conectar a Railway
railway run bash

# Ejecutar script de PRs
python3 /scripts/pr_automator.py
```

Deberías ver:
```
🤖 Iniciando automatización de Pull Request
🌿 Creando rama: auto-contribution-20260126-140530
✅ Rama creada
✅ Commit creado
📤 Empujando rama...
✅ Rama empujada exitosamente
📝 Creando Pull Request...
✅ Pull Request #123 creado exitosamente
🔗 URL: https://github.com/user/repo/pull/123
⏳ Esperando 5 segundos antes del merge...
🔄 Mergeando Pull Request #123...
✅ Pull Request #123 mergeado exitosamente
🗑️  Eliminando rama...
✅ Rama eliminada completamente
✅ Proceso de PR completado exitosamente
```

## 📊 Comparación: Commits vs PRs

| Característica | Commits Directos | Pull Requests |
|----------------|------------------|---------------|
| **Contribuciones/día** | 1 | 2+ |
| **Visibilidad** | Timeline | Timeline + PRs tab |
| **Complejidad** | Simple | Moderada |
| **Token requerido** | No | Sí (con permisos repo) |
| **Limpieza** | No aplica | Automática |

## 🔐 Seguridad del Token

### Mejores Prácticas

1. **Nunca hagas commit del token** en el código
2. **Usa variables de entorno** en Railway
3. **Rota el token** cada 3-6 meses
4. **Usa tokens con permisos mínimos** necesarios
5. **Considera Fine-grained tokens** (más seguros)

### Fine-grained Tokens (Recomendado)

GitHub ahora ofrece tokens más seguros:

1. https://github.com/settings/tokens?type=beta
2. **Generate new token**
3. **Repository access**: Solo el repo específico
4. **Permissions**:
   - Contents: Read and write
   - Pull requests: Read and write
5. Genera y usa este token

## 🐛 Solución de Problemas

### Error: "Token no tiene permisos"

**Solución**: Verifica que el token tenga scope `repo` completo.

### Error: "Repository not found"

**Solución**: Verifica `github_repo_owner` y `github_repo_name` en config.json.

### Error: "Merge conflict"

**Solución**: Asegúrate de que no haya cambios manuales en el repo que causen conflictos.

### PRs se crean pero no se mergean

**Solución**: 
1. Verifica que el token tenga permisos de merge
2. Aumenta el tiempo de espera en el script (línea con `time.sleep(5)`)

## 📝 Personalización

### Cambiar Nombre de Ramas

Edita `pr_automator.py`, línea ~120:

```python
branch_name = f"auto-contribution-{timestamp}"
# Cambia a:
branch_name = f"daily-update-{timestamp}"
```

### Cambiar Título del PR

Edita `pr_automator.py`, línea ~200:

```python
"title": f"🤖 Automated Contribution - {datetime.now().strftime('%Y-%m-%d')}"
# Cambia a:
"title": f"chore: daily update {datetime.now().strftime('%Y-%m-%d')}"
```

### Cambiar Descripción del PR

Edita `pr_automator.py`, línea ~201:

```python
"body": f"""## Automated Contribution
...
"""
```

## 📚 Siguiente Paso

- [Solución de Problemas](TROUBLESHOOTING.md)
- [API y Scripts](API.md)
- [Volver a Configuración](CONFIGURATION.md)
