# Imagen base oficial de n8n
FROM n8nio/n8n:latest

# Variables de entorno por defecto
ENV N8N_LOG_LEVEL=info \
    GENERIC_TIMEZONE=America/Bogota \
    TZ=America/Bogota \
    NODE_ENV=production

# Exponer el puerto de n8n
EXPOSE 5678

# n8n ya tiene su propio CMD, no necesitamos especificarlo
