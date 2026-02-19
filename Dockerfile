# Imagen oficial n8n: https://hub.docker.com/r/n8nio/n8n
# Configuración de despliegue: deploy.yml (target: railway | render)
FROM n8nio/n8n:latest

ENV N8N_LOG_LEVEL=info \
    GENERIC_TIMEZONE=America/Bogota \
    TZ=America/Bogota \
    NODE_ENV=production \
    N8N_PORT=10000

EXPOSE 5678

# Sin CMD: el ENTRYPOINT de la imagen ejecuta n8n. Render usa PORT=10000 por defecto;
# N8N_PORT=10000 hace que n8n escuche en el puerto correcto. Railway puede sobreescribir N8N_PORT=5678.
