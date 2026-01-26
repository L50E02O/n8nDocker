FROM n8nio/n8n:latest

# Cambiar a root para instalar dependencias
USER root

# Actualizar apk e instalar dependencias
RUN apk update && \
    apk add --no-cache \
    git \
    python3 \
    py3-pip \
    bash \
    curl \
    && rm -rf /var/cache/apk/*

# Instalar dependencias de Python
RUN python3 -m pip install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir requests

# Crear directorios necesarios
RUN mkdir -p /scripts /config /repo /logs && \
    chown -R node:node /scripts /config /repo /logs

# Copiar scripts
COPY --chown=node:node scripts/ /scripts/

# Copiar configuración
COPY --chown=node:node config/ /config/

# Dar permisos de ejecución
RUN find /scripts -type f -name "*.py" -exec chmod +x {} \; && \
    find /scripts -type f -name "*.sh" -exec chmod +x {} \;

# Volver al usuario node por seguridad
USER node

# Variables de entorno
ENV N8N_LOG_LEVEL=info \
    GENERIC_TIMEZONE=America/Bogota \
    TZ=America/Bogota

EXPOSE 5678

WORKDIR /data

CMD ["n8n"]
