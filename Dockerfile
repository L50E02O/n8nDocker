FROM n8nio/n8n:latest

USER root

# Instalar dependencias adicionales
RUN apk add --no-cache \
    git \
    python3 \
    py3-pip \
    bash \
    curl

# Instalar dependencias de Python
RUN pip3 install --no-cache-dir requests

# Crear directorios necesarios
RUN mkdir -p /scripts /config /repo /logs && \
    chown -R node:node /scripts /config /repo /logs

# Copiar scripts (siempre existe)
COPY --chown=node:node scripts/ /scripts/

# Copiar config (debe existir ahora)
COPY --chown=node:node config/ /config/

# Dar permisos de ejecución
RUN chmod +x /scripts/*.py 2>/dev/null || true && \
    chmod +x /scripts/*.sh 2>/dev/null || true

USER node

# Variables de entorno
ENV N8N_LOG_LEVEL=info \
    GENERIC_TIMEZONE=America/Bogota \
    TZ=America/Bogota

EXPOSE 5678

WORKDIR /data

CMD ["n8n"]
