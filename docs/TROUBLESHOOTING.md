# Solución de Problemas

Guía completa para resolver errores comunes al desplegar n8n en Railway.

## Diagnóstico General

Antes de buscar un error específico, verifica:

1. **Estado del servicio en Railway**
   - Railway → Tu servicio → Debe estar "Active" (verde)

2. **Ver logs en tiempo real**
   - Railway → Deploy Logs
   - Busca mensajes de error en rojo

3. **Verificar variables de entorno**
   - Railway → Variables → Verifica que todas estén configuradas:
     - `N8N_BASIC_AUTH_ACTIVE=true`
     - `N8N_BASIC_AUTH_USER`
     - `N8N_BASIC_AUTH_PASSWORD`
     - `N8N_ENCRYPTION_KEY` (mínimo 32 caracteres)

---

## Errores de Despliegue

### Error: "Service crashed" o "Build failed"

**Causa**: Variables de entorno faltantes o incorrectas.

**Solución**:
1. Ve a Railway → **Variables**
2. Verifica que estas variables estén configuradas:
   ```bash
   N8N_BASIC_AUTH_ACTIVE=true
   N8N_BASIC_AUTH_USER=admin
   N8N_BASIC_AUTH_PASSWORD=TuPasswordSegura123!
   N8N_ENCRYPTION_KEY=clave-aleatoria-larga-minimo-32-caracteres
   ```
3. Verifica que `N8N_ENCRYPTION_KEY` tenga al menos 32 caracteres
4. Click en **"Redeploy"** después de corregir

### Error: "Dockerfile not found"

**Causa**: El Dockerfile no está en el repositorio o Railway no lo detecta.

**Solución**:
1. Verifica que el `Dockerfile` esté en la raíz del repositorio
2. Verifica que esté en GitHub (haz push si es necesario)
3. En Railway → Settings → **Redeploy**

### Error: "Port already in use"

**Causa**: Conflicto de puertos (poco común en Railway).

**Solución**: Railway maneja los puertos automáticamente. Si persiste:
1. Railway → Settings → **Redeploy**
2. Verifica que no haya otro servicio usando el mismo puerto

---

## Errores de Acceso

### Error 401: "Unauthorized" al acceder a n8n

**Causa**: Autenticación básica mal configurada.

**Solución**:
1. Verifica que `N8N_BASIC_AUTH_ACTIVE=true`
2. Verifica que `N8N_BASIC_AUTH_USER` y `N8N_BASIC_AUTH_PASSWORD` estén configurados
3. Usa las credenciales exactas que configuraste
4. Verifica que no haya espacios extra en las variables

### No puedo acceder a la URL de n8n

**Causa**: URL incorrecta o servicio no iniciado.

**Solución**:
1. Ve a Railway → Settings → **Domains**
2. Copia la URL correcta (ej: `https://xxx.railway.app`)
3. Verifica que el servicio esté "Active"
4. Espera unos minutos después del deploy inicial

### Error: "Connection refused"

**Causa**: El servicio no está corriendo o el puerto está mal configurado.

**Solución**:
1. Verifica que el servicio esté "Active" en Railway
2. Revisa los logs: Railway → Deploy Logs
3. Verifica que n8n esté iniciando correctamente
4. Si hay errores en los logs, corrígelos y haz redeploy

---

## Errores de Persistencia

### Los workflows se pierden después de redeploy

**Síntomas**: Workflows desaparecen después de cada deploy.

**Causa**: No hay volumen persistente configurado.

**Solución**:
1. Ve a Railway → Settings → **Volumes**
2. Verifica que exista un volumen montado en `/home/node/.n8n`
3. Si no existe, agrégalo:
   - Mount Path: `/home/node/.n8n`
   - Size: `0.5 GB`
4. Haz redeploy después de agregar el volumen
5. Ver guía completa: [PERSISTENCIA.md](PERSISTENCIA.md)

### Error al guardar workflows: "Disk full" o similar

**Causa**: El volumen está lleno.

**Solución**:
1. Conecta al contenedor: `railway run bash`
2. Verifica espacio: `df -h /home/node/.n8n`
3. Si está lleno:
   - Exporta workflows antiguos desde n8n
   - Elimina workflows que no uses
   - O actualiza a un plan con más espacio

---

## Errores de n8n

### El workflow no se ejecuta automáticamente

**Causa**: Workflow no está activado o configuración incorrecta.

**Solución**:
1. En n8n, verifica que el workflow esté **activado** (toggle verde)
2. Si usa Schedule Trigger, verifica:
   - Que el trigger esté configurado correctamente
   - Que la zona horaria sea correcta
3. Prueba ejecutar manualmente: Click "Execute Workflow"
4. Revisa los logs del workflow en n8n

### Error: "Encryption key not set"

**Causa**: `N8N_ENCRYPTION_KEY` no está configurado o es muy corto.

**Solución**:
1. Ve a Railway → Variables
2. Verifica que `N8N_ENCRYPTION_KEY` esté configurado
3. Debe tener mínimo 32 caracteres
4. Genera una nueva clave si es necesario
5. Haz redeploy

### Error al guardar credenciales

**Causa**: Problema con la clave de encriptación o permisos.

**Solución**:
1. Verifica que `N8N_ENCRYPTION_KEY` esté configurado correctamente
2. Verifica que el volumen tenga permisos correctos
3. Conecta al contenedor: `railway run bash`
4. Verifica permisos: `ls -la /home/node/.n8n`

---

## Problemas de Rendimiento

### n8n es muy lento

**Causa**: Recursos limitados o workflows complejos.

**Solución**:
1. Verifica el uso de recursos en Railway
2. Optimiza tus workflows (menos nodos, menos datos)
3. Considera actualizar a un plan con más recursos
4. Revisa los logs para identificar cuellos de botella

### El servicio se reinicia constantemente

**Causa**: Crash por falta de memoria o errores.

**Solución**:
1. Revisa los logs: Railway → Deploy Logs
2. Busca errores de memoria (OOM - Out of Memory)
3. Simplifica tus workflows
4. Verifica que todas las variables estén correctas

---

## Comandos Útiles para Diagnóstico

### Ver logs en tiempo real:

```bash
railway logs -f
```

### Conectar al contenedor:

```bash
railway run bash
```

### Ver variables configuradas:

```bash
railway variables
```

### Verificar espacio en volumen:

```bash
railway run bash
df -h /home/node/.n8n
```

### Verificar que n8n está corriendo:

```bash
railway run bash
ps aux | grep n8n
```

---

## Si Nada Funciona

### Resetear completamente:

1. **Exporta tus workflows** desde n8n (si es posible)
2. **Elimina el servicio** en Railway
3. **Crea un nuevo servicio** desde el mismo repositorio
4. **Configura las variables** nuevamente
5. **Agrega el volumen** persistente
6. **Importa tus workflows** exportados

### Obtener ayuda adicional:

1. **Revisa la documentación oficial**:
   - [Documentación de Railway](https://docs.railway.app/)
   - [Documentación de n8n](https://docs.n8n.io/)

2. **Revisa los logs completos**:
   - Railway → Deploy Logs
   - Busca mensajes de error específicos

3. **Abre un issue en GitHub**:
   - Describe el problema detalladamente
   - Incluye logs relevantes
   - Menciona qué soluciones ya intentaste

---

## Checklist de Verificación

Si tienes problemas, verifica:

- [ ] Servicio está "Active" en Railway
- [ ] Todas las variables obligatorias están configuradas
- [ ] `N8N_ENCRYPTION_KEY` tiene mínimo 32 caracteres
- [ ] Volumen está montado en `/home/node/.n8n` (si usas persistencia)
- [ ] Puedes acceder a la URL de Railway
- [ ] Las credenciales de login son correctas
- [ ] No hay errores en los logs de Railway
- [ ] n8n está iniciando correctamente (visible en logs)

---

## Enlaces Útiles

- [Guía de Despliegue](RAILWAY_DEPLOY.md)
- [Guía de Persistencia](PERSISTENCIA.md)
- [Documentación de Railway](https://docs.railway.app/)
- [Documentación de n8n](https://docs.n8n.io/)
