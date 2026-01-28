# Guía de Persistencia de Datos en Railway

## El Problema: ¿Por qué se pierde todo en cada deploy?

Los contenedores Docker son **efímeros** por naturaleza. Esto significa que:

- Cada deploy crea un contenedor completamente nuevo
- Todo lo que esté dentro del contenedor se borra
- Los archivos, configuraciones y datos se pierden

### ¿Qué se pierde sin configuración de persistencia?

1. **Workflows de n8n** - Tus automatizaciones configuradas
2. **Credenciales de n8n** - Tokens y configuraciones guardadas
3. **Historial de ejecuciones** - Logs de workflows ejecutados
4. **Configuración de n8n** - Ajustes personalizados

---

## La Solución: Volumen Persistente

### ⚠️ Importante: Persistencia Temporal vs Permanente

**Persistencia Temporal (sin volúmenes)**:
- ✅ Los datos persisten **mientras el contenedor NO se reinicie**
- ❌ Los datos se pierden cuando Railway hace un redeploy
- ❌ Los datos se pierden si el contenedor se reinicia por cualquier motivo
- ✅ Útil para pruebas o si no planeas hacer redeploys frecuentes

**Persistencia Permanente (con volúmenes)**:
- ✅ Los datos persisten **incluso después de redeploys**
- ✅ Los datos persisten después de reinicios del contenedor
- ✅ Solución recomendada para producción

### Volumen Persistente para n8n

**Qué es**: Un disco virtual que Railway mantiene entre deploys.

**Configuración**:

1. Railway → Tu servicio → **Settings** → **Volumes**
2. Click **"Add Volume"**
3. Configuración:
   ```
   Mount Path: /home/node/.n8n
   Size: 0.5 GB (máximo en plan gratuito)
   ```
4. Click **"Add"**

**Qué preserva**:
- ✅ Workflows de n8n
- ✅ Credenciales guardadas
- ✅ Configuración de n8n
- ✅ Historial de ejecuciones

**Costo en Plan Gratuito**:
- ✅ Volúmenes están disponibles en el plan gratuito
- 📦 Máximo 0.5 GB por volumen
- 📦 Máximo 1 volumen por proyecto
- 💰 $0.15 por GB/mes (se cobra del crédito mensual de $5)
- 💡 Con 0.5 GB, el costo es ~$0.075/mes (muy bajo)

---

## Configuración Paso a Paso

### Paso 1: Configurar Volumen para n8n (Opcional pero Recomendado)

**Si NO usas volúmenes**:
- Los datos persisten mientras el contenedor no se reinicie
- Si haces un redeploy, perderás los workflows de n8n
- Deberás recrear los workflows después de cada redeploy

**Si usas volúmenes** (recomendado):

1. Ve a Railway → Tu servicio → **Settings**
2. Scroll hasta **"Volumes"**
3. Si NO hay volumen configurado:
   - Click **"Add Volume"**
   - Mount Path: `/home/node/.n8n`
   - Size: `0.5 GB` (máximo en plan gratuito)
   - Click **"Add"**

Railway reiniciará el servicio automáticamente.

---

## Verificación de Persistencia

### Probar que n8n persiste:

1. Crea un workflow en n8n
2. Guárdalo y actívalo
3. Haz un redeploy: Railway → Settings → **"Redeploy"**
4. Espera a que inicie
5. Accede a n8n nuevamente
6. ✅ El workflow debería seguir ahí

---

## Preguntas Frecuentes

### ¿Puedo mantener datos sin volúmenes si no reinicio el contenedor?

**Respuesta**: **SÍ**, pero con limitaciones importantes:

✅ **Lo que SÍ funciona**:
- Los datos persisten en el sistema de archivos del contenedor
- Los workflows de n8n se mantienen
- La configuración se mantiene

❌ **Lo que NO funciona**:
- Si Railway hace un redeploy automático, pierdes todo
- Si el contenedor se reinicia por error, pierdes todo
- Si actualizas el código (push a GitHub), Railway puede hacer redeploy
- Si cambias variables de entorno, Railway puede reiniciar el servicio

**Recomendación**:
- Si solo estás probando y no planeas hacer redeploys: ✅ Funciona sin volúmenes
- Si quieres persistencia garantizada: ✅ Usa volúmenes (costo mínimo ~$0.075/mes)

### ¿Por qué el tamaño máximo es 0.5 GB?

**Respuesta**: Es el límite del plan gratuito de Railway. Para proyectos más grandes, puedes:
- Actualizar a un plan de pago (más espacio disponible)
- Optimizar tus workflows para usar menos espacio
- Exportar workflows antiguos y eliminarlos

### ¿Qué pasa si el volumen se llena?

**Respuesta**: 
- n8n puede dejar de funcionar correctamente
- Puedes ver errores al guardar workflows
- Solución: Exporta workflows antiguos, elimínalos, o actualiza a un plan con más espacio

---

## Costos de Persistencia

### Plan Gratuito de Railway:

- **Crédito mensual**: $5 USD
- **Volumen máximo**: 0.5 GB por volumen
- **Costo del volumen**: $0.15 por GB/mes
- **Costo estimado con 0.5 GB**: ~$0.075/mes

### Uso Real Estimado:

```
Servicio n8n + volumen 0.5GB:
- Costo del servicio: ~$1.50-2.00/mes
- Costo del volumen: ~$0.075/mes
- Total: ~$1.58-2.08/mes
- Crédito gratis: $5.00
- Resultado: GRATIS (dentro del crédito mensual)
```

### Sin Volúmenes (Persistencia Temporal):

- **Costo**: $0 adicional
- **Limitación**: Los datos se pierden en cada redeploy
- **Ventaja**: Funciona perfectamente mientras no reinicies el contenedor

---

## Solución de Problemas

### El volumen no se monta:

**Síntomas**: Los workflows se pierden en cada deploy

**Solución**:
1. Verifica en Railway → Settings → Volumes
2. Debe aparecer: `/home/node/.n8n` → 0.5 GB (o el tamaño que configuraste)
3. Si no está, agrégalo
4. Redeploy el servicio

**Nota**: Si no usas volúmenes, esto es normal. Los datos solo persisten mientras el contenedor no se reinicie.

### Error al guardar workflows:

**Síntomas**: No puedes guardar nuevos workflows

**Solución**:
1. Verifica que el volumen esté montado correctamente
2. Verifica que haya espacio disponible
3. Conecta al contenedor: `railway run bash`
4. Verifica espacio: `df -h /home/node/.n8n`
5. Si está lleno, exporta y elimina workflows antiguos

---

## Checklist de Persistencia

Usa este checklist para verificar que todo esté configurado:

- [ ] Volumen montado en `/home/node/.n8n`
- [ ] Workflow creado y guardado en n8n
- [ ] Prueba de redeploy realizada
- [ ] Workflow persiste después del redeploy

Si todos los checks están ✅, tu sistema está correctamente configurado y persistirá entre deploys.

---

## Resumen

### Lo que PERSISTE (con volumen):
- ✅ Workflows de n8n
- ✅ Credenciales de n8n
- ✅ Configuración de n8n
- ✅ Persiste incluso después de redeploys

### Lo que PERSISTE temporalmente (sin volumen):
- ✅ Workflows de n8n (mientras el contenedor no se reinicie)
- ✅ Credenciales de n8n (mientras el contenedor no se reinicie)
- ⚠️ Se pierde en cada redeploy o reinicio

### Lo que NUNCA se pierde:
- ✅ Variables de entorno (guardadas en Railway)
- ✅ Configuración del servicio (Railway la mantiene)

**Resultado**: 
- **Con volúmenes**: Sistema completamente funcional y persistente entre deploys. 🎉
- **Sin volúmenes**: Sistema funcional mientras no se reinicie el contenedor. ⚠️
