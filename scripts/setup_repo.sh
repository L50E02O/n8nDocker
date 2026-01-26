#!/bin/bash
# Script de configuración inicial del repositorio

set -e

echo "🚀 Configuración inicial del repositorio de commits diarios"
echo "=========================================================="

# Verificar si Git está instalado
if ! command -v git &> /dev/null; then
    echo "❌ Git no está instalado. Por favor, instala Git primero."
    exit 1
fi

# Solicitar información del repositorio
read -p "📝 Ingresa la URL de tu repositorio GitHub (HTTPS): " REPO_URL
read -p "👤 Ingresa tu nombre de usuario Git: " GIT_USER
read -p "📧 Ingresa tu email Git: " GIT_EMAIL

# Crear directorio del repositorio si no existe
if [ ! -d "repo" ]; then
    echo "📁 Creando directorio del repositorio..."
    mkdir -p repo
fi

cd repo

# Inicializar Git si no existe
if [ ! -d ".git" ]; then
    echo "🔧 Inicializando repositorio Git..."
    git init
    
    echo "⚙️  Configurando usuario Git..."
    git config user.name "$GIT_USER"
    git config user.email "$GIT_EMAIL"
    
    echo "🔗 Agregando repositorio remoto..."
    git remote add origin "$REPO_URL"
    
    echo "📄 Creando README inicial..."
    cat > README.md << EOF
# Daily Commits Repository

Este repositorio contiene commits automáticos generados por el sistema de commits diarios.

## Información

- Sistema: Commit Diario Automatizado
- Automatización: n8n + Python
- Propósito: Mantener racha de contribuciones en GitHub

## Estadísticas

Los commits son generados automáticamente cada día a las horas configuradas.
EOF
    
    git add README.md
    git commit -m "Initial commit: Setup automated daily commits"
    
    echo "🌿 Creando rama main (si no existe)..."
    git branch -M main
    
    echo ""
    echo "✅ Repositorio configurado exitosamente!"
    echo ""
    echo "📤 Ahora necesitas hacer el push inicial:"
    echo "   cd repo"
    echo "   git push -u origin main"
    echo ""
    echo "⚠️  Nota: Necesitarás tu token de GitHub como contraseña"
    
else
    echo "⚠️  El repositorio ya está inicializado"
    
    # Verificar remoto
    if git remote get-url origin &> /dev/null; then
        CURRENT_REMOTE=$(git remote get-url origin)
        echo "📍 Remoto actual: $CURRENT_REMOTE"
        
        read -p "¿Deseas actualizar el remoto? (s/n): " UPDATE_REMOTE
        if [ "$UPDATE_REMOTE" = "s" ] || [ "$UPDATE_REMOTE" = "S" ]; then
            git remote set-url origin "$REPO_URL"
            echo "✅ Remoto actualizado"
        fi
    else
        git remote add origin "$REPO_URL"
        echo "✅ Remoto agregado"
    fi
    
    # Actualizar configuración de usuario
    git config user.name "$GIT_USER"
    git config user.email "$GIT_EMAIL"
    echo "✅ Configuración de usuario actualizada"
fi

cd ..

echo ""
echo "🎉 ¡Configuración completada!"
echo ""
echo "Próximos pasos:"
echo "1. Ejecuta: docker-compose up -d"
echo "2. Accede a n8n en: http://localhost:5678"
echo "3. Importa el workflow desde n8n-workflow.json"
echo "4. ¡Listo! Los commits se generarán automáticamente"
