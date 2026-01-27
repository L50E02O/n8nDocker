# 🔐 Guía Completa del Token de GitHub

Guía detallada para crear y gestionar tu token de GitHub para la automatización.

---

## 📋 ¿Qué es un Token de GitHub?

Un **Personal Access Token (PAT)** es una alternativa segura a usar tu contraseña para autenticar operaciones de Git y acceder a la API de GitHub.

### ¿Cuándo lo necesitas?

- ✅ **Modo Pull Requests**: **OBLIGATORIO** (para crear y mergear PRs)
- ⚠️ **Modo Commits Directos**: **OPCIONAL** (solo si tu repo requiere autenticación)

---

## 🎯 Paso a Paso: Crear el Token

### 1. Acceder a la Configuración

Ve a GitHub y navega a:

```
GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
```

**URL directa**: https://github.com/settings/tokens

### 2. Generar Nuevo Token

Click en **"Generate new token (classic)"**

> ⚠️ **Nota**: Usa "Tokens (classic)", NO "Fine-grained tokens" (aún en beta)

### 3. Configurar el Token

#### Nombre del Token (Note)

```
commitDiario - Railway Automation
```

O cualquier nombre descriptivo que te ayude a identificarlo.

#### Tiempo de Expiración (Expiration)

Opciones disponibles y recomendaciones:

| Opción | Recomendación | Pros | Contras |
|--------|---------------|------|---------|
| **7 days** | ❌ No recomendado | Muy seguro | Demasiado corto, renovación constante |
| **30 days** | ⚠️ Aceptable | Seguro | Renovación mensual |
| **60 days** | ✅ Bueno | Balance seguridad/comodidad | Renovación cada 2 meses |
| **90 days** | ✅ **RECOMENDADO** | Buen balance | Renovación trimestral |
| **1 year** | ✅ Aceptable | Cómodo | Renovación anual |
| **No expiration** | ❌ **NO RECOMENDADO** | Nunca expira | Riesgo de seguridad si se filtra |

**Recomendación final**: **90 días** (3 meses)

#### Permisos (Scopes)

Selecciona según tu modo de operación:

##### Para Commits Directos (Básico)

```
✅ repo (Full control of private repositories)
   ├─ repo:status
   ├─ repo_deployment
   ├─ public_repo
   ├─ repo:invite
   └─ security_events
```

**Solo necesitas marcar `repo`**, los demás se incluyen automáticamente.

##### Para Pull Requests (Completo)

```
✅ repo (Full control of private repositories)
   ├─ repo:status
   ├─ repo_deployment
   ├─ public_repo
   ├─ repo:invite
   └─ security_events

✅ workflow (Update GitHub Action workflows) [OPCIONAL]
```

**Marca `repo` y opcionalmente `workflow`** si usas GitHub Actions.

### 4. Generar y Copiar

1. Scroll hasta abajo y click **"Generate token"**
2. **IMPORTANTE**: El token se muestra **solo una vez**
3. Copia el token (empieza con `ghp_`)
4. Guárdalo en un lugar seguro

---

## 💾 Guardar el Token de Forma Segura

### ✅ Formas Seguras

1. **Gestor de Contraseñas** (Recomendado)
   - 1Password
   - Bitwarden
   - LastPass
   - Dashlane

2. **Variables de Entorno** (Solo en servidores)
   - Railway Variables
   - Archivo `.env` (nunca lo subas a Git)

3. **Archivo Encriptado**
   - KeePass
   - Archivo protegido con contraseña

### ❌ Formas INSEGURAS (NUNCA hagas esto)

- ❌ Subirlo a GitHub en el código
- ❌ Guardarlo en un archivo de texto plano
- ❌ Compartirlo por email o chat
- ❌ Dejarlo en el portapapeles
- ❌ Escribirlo en un post-it

---

## 🔧 Configurar el Token en Railway

### Método 1: Dashboard Web

1. Ve a tu proyecto en Railway
2. Click en tu servicio
3. Tab **"Variables"**
4. Click **"New Variable"**
5. Nombre: `GITHUB_TOKEN`
6. Valor: `ghp_tu_token_aqui`
7. Click **"Add"**

Railway reiniciará el servicio automáticamente.

### Método 2: Railway CLI

```bash
# Instalar Railway CLI
npm install -g @railway/cli

# Login
railway login

# Conectar a tu proyecto
railway link

# Agregar variable
railway variables set GITHUB_TOKEN=ghp_tu_token_aqui
```

---

## 🧪 Verificar que Funciona

### Prueba Rápida

```bash
# Acceder al contenedor
railway run bash

# Verificar que la variable existe
echo $GITHUB_TOKEN

# Probar el script de PRs
python3 /scripts/pr_automator.py
```

### Salida Esperada

```
============================================================
🤖 Iniciando automatización de Pull Request
============================================================
⚙️  Configurando Git (user: Tu Nombre, email: tu@email.com)
🌿 Creando rama: auto-contribution-20260127-093045
📥 Actualizando rama main...
✅ Rama auto-contribution-20260127-093045 creada
✅ Commit creado: feat: automated contribution 2026-01-27
📤 Empujando rama auto-contribution-20260127-093045...
✅ Rama auto-contribution-20260127-093045 empujada exitosamente
📝 Creando Pull Request en TU_USUARIO/commitDiario...
✅ Pull Request #1 creado exitosamente
🔗 URL: https://github.com/TU_USUARIO/commitDiario/pull/1
⏳ Esperando 5 segundos antes del merge...
🔄 Mergeando Pull Request #1...
✅ Pull Request #1 mergeado exitosamente
============================================================
✅ Proceso de PR completado exitosamente
============================================================
```

---

## 🔄 Renovar Token Expirado

### Síntomas de Token Expirado

- ❌ Error en n8n: "Bad credentials"
- ❌ Error en logs: "401 Unauthorized"
- ❌ PRs no se crean automáticamente

### Pasos para Renovar

1. **Generar Nuevo Token**
   - Ve a https://github.com/settings/tokens
   - Click **"Generate new token (classic)"**
   - Usa la misma configuración que antes
   - Copia el nuevo token

2. **Actualizar en Railway**
   
   **Opción A: Dashboard**
   - Railway → Variables → `GITHUB_TOKEN` → Edit → Pegar nuevo token → Save

   **Opción B: CLI**
   ```bash
   railway variables set GITHUB_TOKEN=ghp_nuevo_token_aqui
   ```

3. **Verificar**
   ```bash
   railway run python3 /scripts/pr_automator.py
   ```

### Configurar Recordatorio

Para no olvidar renovar el token:

1. **Google Calendar / Outlook**
   - Crea evento recurrente 1 semana antes de la expiración
   - Título: "Renovar Token GitHub - commitDiario"

2. **Recordatorio en el teléfono**
   - Alarma recurrente cada 3 meses (si elegiste 90 días)

3. **Nota en gestor de contraseñas**
   - Agrega fecha de expiración en las notas del token

---

## 🔒 Seguridad del Token

### Permisos del Token

El token con permiso `repo` puede:

- ✅ Leer código de tus repositorios
- ✅ Crear commits
- ✅ Crear ramas
- ✅ Crear Pull Requests
- ✅ Mergear Pull Requests
- ✅ Leer y escribir issues
- ✅ Gestionar webhooks

### ⚠️ Qué NO puede hacer

- ❌ Eliminar repositorios (requiere permiso adicional)
- ❌ Cambiar configuración de la cuenta
- ❌ Acceder a otros repositorios (solo los que tengas acceso)
- ❌ Transferir ownership de repos

### Si el Token se Filtra

**Acción inmediata:**

1. Ve a https://github.com/settings/tokens
2. Encuentra el token comprometido
3. Click **"Delete"**
4. Genera un nuevo token
5. Actualiza en Railway

**Prevención:**

- ✅ Nunca subas el token a Git
- ✅ Usa `.gitignore` para archivos `.env`
- ✅ No compartas el token por chat/email
- ✅ Revisa periódicamente los tokens activos

---

## 📊 Gestión de Múltiples Tokens

Si tienes varios proyectos, puedes crear tokens específicos para cada uno:

```
Token 1: commitDiario - Railway Automation
  Permisos: repo
  Expira: 2026-04-27
  Usado en: Railway (commitDiario)

Token 2: Proyecto2 - Automation
  Permisos: repo, workflow
  Expira: 2026-05-15
  Usado en: Otro servidor

Token 3: CI/CD Pipeline
  Permisos: repo, workflow, write:packages
  Expira: 2026-06-01
  Usado en: GitHub Actions
```

### Ventajas de Tokens Separados

- ✅ Mejor organización
- ✅ Fácil revocar uno sin afectar otros
- ✅ Permisos específicos por proyecto
- ✅ Trazabilidad de uso

---

## 🆘 Solución de Problemas

### Error: "Bad credentials"

**Causa**: Token inválido o expirado

**Solución**:
```bash
# Verificar que el token está configurado
railway run bash -c "echo \$GITHUB_TOKEN"

# Si está vacío o incorrecto, actualízalo
railway variables set GITHUB_TOKEN=ghp_nuevo_token
```

### Error: "Resource not accessible by personal access token"

**Causa**: Permisos insuficientes

**Solución**:
1. Ve a https://github.com/settings/tokens
2. Click en tu token
3. Verifica que `repo` esté marcado
4. Si no, genera un nuevo token con los permisos correctos

### Error: "API rate limit exceeded"

**Causa**: Demasiadas peticiones a la API de GitHub

**Solución**:
- Los tokens autenticados tienen límite de 5,000 requests/hora
- Esto es más que suficiente para este proyecto
- Si ocurre, espera 1 hora y reintenta

### Token No Funciona en Repositorio Privado

**Causa**: El token no tiene acceso al repositorio

**Solución**:
1. Verifica que el permiso `repo` esté marcado (no solo `public_repo`)
2. Si el repo pertenece a una organización, verifica que tengas acceso
3. Regenera el token si es necesario

---

## 📚 Recursos Adicionales

### Documentación Oficial

- [GitHub Personal Access Tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
- [GitHub API Authentication](https://docs.github.com/en/rest/overview/authenticating-to-the-rest-api)
- [Token Scopes](https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/scopes-for-oauth-apps)

### Guías Relacionadas

- [Configuración del Workflow](CONFIGURACION_WORKFLOW.md)
- [Modo Pull Request](PR_MODE.md)
- [Solución de Problemas](TROUBLESHOOTING.md)

---

## ✅ Checklist de Token

Antes de continuar, verifica:

- [ ] Token generado con nombre descriptivo
- [ ] Expiración configurada (recomendado: 90 días)
- [ ] Permiso `repo` marcado
- [ ] Token copiado y guardado en lugar seguro
- [ ] Token configurado en Railway como `GITHUB_TOKEN`
- [ ] Servicio reiniciado en Railway
- [ ] Token verificado con prueba manual
- [ ] Recordatorio configurado para renovación

---

**¿Listo para continuar?** Vuelve a [PASOS_SIGUIENTES.md](../PASOS_SIGUIENTES.md) para completar la configuración.
