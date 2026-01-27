# 🐛 Solución de Problemas

Guía completa para resolver errores comunes.

## 🔍 Diagnóstico General

Antes de buscar un error específico, verifica:

```bash
# 1. Estado del servicio en Railway
Railway → Tu servicio → Debe estar "Active" (verde)

# 2. Ver logs en tiempo real
Railway → Deploy Logs

# 3. Verificar variables de entorno
Railway → Variables → Verifica que todas estén configuradas

# 4. Probar manualmente
railway run python3 /scripts/commit_automator.py
```

---

## 🚫 Errores de Despliegue

### Error: "failed to build: config: not found"

**Causa**: El directorio `config/` no está en GitHub.

**Solución**:
```bash
# Verifica que existe
dir config

# Agregar a git
git add config/
git commit -m "Add config directory"
git push
```

### Error: "apk: not found" o "apt-get: not found"

**Causa**: Dockerfile usa el gestor de paquetes incorrecto.

**Solución**: Ya está corregido en el Dockerfile actual (usa Alpine con `apk`).

### Error: "command start not found"

**Causa**: n8n no se está ejecutando correctamente.

**Solución**: Verifica que el Dockerfile tenga:
```dockerfile
CMD ["n8n", "start"]
```

---

## 🔐 Errores de Autenticación

### Error: "Authentication failed" al hacer push

**Causa**: Token de GitHub incorrecto o expirado.

**Solución**:
```bash
# 1. Genera un nuevo token en GitHub
# https://github.com/settings/tokens

# 2. En el contenedor, reconfigura:
railway run bash
cd /repo
git config credential.helper store
git push  # Usa el nuevo token como password
```

### Error: "Permission denied (publickey)"

**Causa**: Intentando usar SSH sin configurar claves.

**Solución**: Usa HTTPS en lugar de SSH:
```bash
git remote set-url origin https://github.com/USER/REPO.git
```

---

## 🔄 Errores del Workflow

### El workflow no se ejecuta automáticamente

**Causa**: Workflow no está activado o cron mal configurado.

**Solución**:
1. En n8n, verifica que el toggle esté **verde**
2. Verifica el Schedule Trigger:
   - Mode: Interval o Cron
   - Intervalo: 24 hours
3. Prueba ejecutar manualmente: Click "Execute Workflow"

### Error: "No hay repositorio remoto configurado"

**Causa**: El repo en `/repo` no está inicializado.

**Solución**:
```bash
railway run bash

cd /repo
git init
git config user.name "Tu Nombre"
git config user.email "tu@email.com"
git remote add origin https://github.com/USER/REPO.git
```

### Error: "No hay cambios para commitear"

**Causa**: El script no pudo crear el archivo de datos.

**Solución**:
```bash
# Verifica permisos
railway run bash
ls -la /repo

# Debe mostrar que 'node' es el owner
# Si no, ejecuta:
chown -R node:node /repo
```

---

## 🌐 Errores de Acceso

### Error: "Application failed to respond"

**Causa**: n8n no está escuchando en el puerto correcto.

**Solución**:
1. Verifica que el puerto en Railway → Networking sea **5678**
2. Verifica los logs: `railway logs`
3. Busca: `n8n ready on port 5678`

### Error: "Cannot connect" o timeout

**Causa**: Servicio no está corriendo o crasheó.

**Solución**:
```bash
# Ver estado
railway status

# Ver logs
railway logs

# Si está crashed, redeploy
railway up
```

### Error: Login no funciona en n8n

**Causa**: Credenciales incorrectas.

**Solución**:
```bash
# Verifica las variables
railway run env | grep N8N_BASIC_AUTH

# Debe mostrar:
# N8N_BASIC_AUTH_ACTIVE=true
# N8N_BASIC_AUTH_USER=admin
# N8N_BASIC_AUTH_PASSWORD=tu_password
```

---

## 🐍 Errores de Python

### Error: "requests module not found"

**Causa**: Librería requests no está instalada.

**Solución**: Ya está en el Dockerfile. Si persiste:
```bash
railway run bash
pip3 install --break-system-packages requests
```

### Error: "Permission denied" al ejecutar script

**Causa**: Scripts no tienen permisos de ejecución.

**Solución**:
```bash
railway run bash
chmod +x /scripts/*.py
```

---

## 🔄 Errores de Pull Request

### Error: "Token no tiene permisos"

**Causa**: Token no tiene scope `repo`.

**Solución**:
1. Crea nuevo token con scope `repo` completo
2. Actualiza en Railway → Variables → `GITHUB_TOKEN`

### Error: "Repository not found"

**Causa**: `github_repo_owner` o `github_repo_name` incorrectos.

**Solución**: Verifica en `config/config.json`:
```json
{
  "github_repo_owner": "tu_usuario_exacto",
  "github_repo_name": "nombre_repo_exacto"
}
```

### PRs se crean pero no se mergean

**Causa**: Token sin permisos de merge o conflictos.

**Solución**:
1. Verifica permisos del token
2. Revisa si hay conflictos en GitHub
3. Aumenta tiempo de espera en `pr_automator.py`:
   ```python
   time.sleep(10)  # En lugar de 5
   ```

---

## 💾 Errores de Volumen

### Workflows desaparecen después de redeploy

**Causa**: No hay volumen persistente configurado.

**Solución**:
1. Railway → Settings → Volumes
2. Add Volume:
   - Mount Path: `/home/node/.n8n`
   - Size: 1 GB

### Error: "No space left on device"

**Causa**: Volumen lleno.

**Solución**:
1. Aumenta el tamaño del volumen en Railway
2. O limpia archivos innecesarios:
   ```bash
   railway run bash
   du -sh /home/node/.n8n/*
   # Elimina logs viejos si es necesario
   ```

---

## 📊 Errores de Configuración

### Commits no aparecen en GitHub

**Causa**: Email en Git no coincide con GitHub.

**Solución**:
```bash
# El email debe ser el mismo que en tu cuenta de GitHub
git config user.email "tu-email-de-github@ejemplo.com"
```

### Zona horaria incorrecta

**Causa**: Variables de entorno mal configuradas.

**Solución**: En Railway → Variables:
```bash
GENERIC_TIMEZONE=America/Bogota
TZ=America/Bogota
```

Lista de zonas: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones

---

## 🔧 Comandos Útiles de Diagnóstico

```bash
# Ver estado general
railway status

# Ver logs en tiempo real
railway logs -f

# Ver variables de entorno
railway variables

# Conectar al contenedor
railway run bash

# Dentro del contenedor:
# - Ver configuración
cat /config/config.json

# - Ver estado de git
cd /repo && git status

# - Ver logs de n8n
ls -la /home/node/.n8n/

# - Probar script manualmente
python3 /scripts/commit_automator.py

# - Ver procesos corriendo
ps aux | grep n8n
```

---

## 🆘 Solución Nuclear

Si nada funciona, reconstruye desde cero:

```bash
# 1. En Railway, elimina el proyecto
Railway → Settings → Delete Project

# 2. Limpia el repo local
cd commitDiario
rm -rf .git

# 3. Reinicia
git init
git add .
git commit -m "Fresh start"
git remote add origin https://github.com/USER/NEW_REPO.git
git push -u origin main

# 4. Crea nuevo proyecto en Railway
# 5. Sigue QUICK_START.md desde el inicio
```

---

## 📞 Obtener Ayuda

Si ninguna solución funciona:

1. **Copia los logs completos**:
   ```bash
   railway logs > logs.txt
   ```

2. **Verifica la configuración**:
   ```bash
   railway run cat /config/config.json > config_actual.txt
   ```

3. **Abre un issue** en el repositorio con:
   - Descripción del problema
   - Logs relevantes
   - Configuración (sin tokens)
   - Pasos para reproducir

---

## 📚 Recursos Adicionales

- [Railway Documentation](https://docs.railway.app/)
- [n8n Documentation](https://docs.n8n.io/)
- [GitHub API Documentation](https://docs.github.com/en/rest)
- [Python requests Documentation](https://requests.readthedocs.io/)

---

## ✅ Checklist de Verificación

Antes de reportar un problema, verifica:

- [ ] Servicio en Railway está "Active"
- [ ] Todas las variables de entorno están configuradas
- [ ] Volumen persistente está montado
- [ ] Workflow está activado en n8n
- [ ] Repositorio Git está configurado en `/repo`
- [ ] Token de GitHub es válido (si usas PRs)
- [ ] Email de Git coincide con GitHub
- [ ] Probaste ejecutar el script manualmente

Si todo está ✅ y sigue sin funcionar, es hora de pedir ayuda.
