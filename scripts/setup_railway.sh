#!/bin/bash
# Script de configuración rápida para Railway
# Este script configura el repositorio Git dentro del contenedor de Railway

set -e

echo "=========================================="
echo "🚀 Configuración de Repositorio en Railway"
echo "=========================================="
echo ""

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Verificar que estamos en Railway
if [ ! -d "/repo" ]; then
    print_error "Este script debe ejecutarse dentro del contenedor de Railway"
    exit 1
fi

# Leer configuración
CONFIG_FILE="/config/config.json"
if [ ! -f "$CONFIG_FILE" ]; then
    print_error "Archivo de configuración no encontrado: $CONFIG_FILE"
    exit 1
fi

print_info "Leyendo configuración..."
GIT_USER_NAME=$(python3 -c "import json; print(json.load(open('$CONFIG_FILE'))['git_user_name'])" 2>/dev/null || echo "")
GIT_USER_EMAIL=$(python3 -c "import json; print(json.load(open('$CONFIG_FILE'))['git_user_email'])" 2>/dev/null || echo "")

# Solicitar datos si no están en config
if [ -z "$GIT_USER_NAME" ]; then
    read -p "Ingresa tu nombre completo: " GIT_USER_NAME
fi

if [ -z "$GIT_USER_EMAIL" ]; then
    read -p "Ingresa tu email de GitHub: " GIT_USER_EMAIL
fi

read -p "Ingresa la URL de tu repositorio (ej: https://github.com/usuario/repo.git): " REPO_URL

if [ -z "$REPO_URL" ]; then
    print_error "La URL del repositorio es obligatoria"
    exit 1
fi

echo ""
print_info "Configuración:"
echo "  Nombre: $GIT_USER_NAME"
echo "  Email: $GIT_USER_EMAIL"
echo "  Repositorio: $REPO_URL"
echo ""

read -p "¿Es correcta esta información? (s/n): " CONFIRM
if [ "$CONFIRM" != "s" ] && [ "$CONFIRM" != "S" ]; then
    print_warning "Configuración cancelada"
    exit 0
fi

echo ""
print_info "Configurando repositorio..."

# Ir al directorio del repo
cd /repo

# Inicializar Git si no existe
if [ ! -d ".git" ]; then
    print_info "Inicializando repositorio Git..."
    git init
    print_success "Repositorio inicializado"
fi

# Configurar usuario
print_info "Configurando usuario Git..."
git config user.name "$GIT_USER_NAME"
git config user.email "$GIT_USER_EMAIL"
print_success "Usuario configurado"

# Configurar remoto
print_info "Configurando repositorio remoto..."
if git remote get-url origin &>/dev/null; then
    print_warning "El remoto 'origin' ya existe, actualizándolo..."
    git remote set-url origin "$REPO_URL"
else
    git remote add origin "$REPO_URL"
fi
print_success "Remoto configurado"

# Verificar si hay rama
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "")
if [ -z "$CURRENT_BRANCH" ]; then
    print_info "Creando rama principal..."
    git branch -M main
    print_success "Rama 'main' creada"
fi

# Verificar si hay commits
if ! git rev-parse HEAD &>/dev/null; then
    print_info "Creando commit inicial..."
    
    # Crear archivo README si no existe
    if [ ! -f "README.md" ]; then
        cat > README.md << 'EOF'
# Daily Commits - Automated

Sistema de commits automáticos para mantener una racha de contribuciones en GitHub.

## 🤖 Automatización

Este repositorio utiliza n8n para generar commits automáticos cada 24 horas.

## 📊 Estadísticas

Los commits son generados automáticamente por el sistema de automatización.

---

*Generado automáticamente por commitDiario*
EOF
    fi
    
    git add .
    git commit -m "Initial commit: Setup automated commits system"
    print_success "Commit inicial creado"
fi

# Intentar pull
print_info "Sincronizando con el repositorio remoto..."
if git pull origin main --rebase 2>/dev/null; then
    print_success "Repositorio sincronizado"
else
    print_warning "No se pudo sincronizar (puede ser normal si el repo está vacío)"
fi

# Push
print_info "Empujando cambios al repositorio remoto..."
echo ""
print_warning "Se te pedirá tu usuario y token de GitHub:"
print_info "  Usuario: tu_usuario_github"
print_info "  Password: ghp_tu_token_personal"
echo ""

if git push -u origin main; then
    print_success "Cambios empujados exitosamente"
else
    print_error "Error al empujar cambios"
    print_info "Verifica tu token de GitHub y permisos del repositorio"
    exit 1
fi

echo ""
echo "=========================================="
print_success "¡Configuración completada exitosamente!"
echo "=========================================="
echo ""
print_info "Próximos pasos:"
echo "  1. Ve a n8n en tu URL de Railway"
echo "  2. Importa el workflow (n8n-workflow.json o n8n-workflow-pr.json)"
echo "  3. Activa el workflow (toggle verde)"
echo "  4. Prueba manualmente: python3 /scripts/commit_automator.py"
echo ""
print_success "El sistema está listo para generar commits automáticos cada 24 horas"
echo ""
