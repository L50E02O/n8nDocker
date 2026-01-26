#!/usr/bin/env python3
"""
Script de prueba para verificar que el sistema de commits funciona correctamente.

Este script realiza un commit de prueba sin afectar la configuración de producción.
"""

import sys
import subprocess
from pathlib import Path


def run_command(command, cwd=None):
    """
    Ejecuta un comando y retorna el resultado.
    
    Args:
        command: Lista con el comando y argumentos
        cwd: Directorio de trabajo
    
    Returns:
        Tupla (exitoso, salida, error)
    """
    try:
        result = subprocess.run(
            command,
            cwd=cwd,
            capture_output=True,
            text=True,
            check=True
        )
        return True, result.stdout, result.stderr
    except subprocess.CalledProcessError as e:
        return False, e.stdout, e.stderr


def main():
    """Función principal de prueba."""
    print("🧪 Iniciando prueba del sistema de commits")
    print("=" * 60)
    
    # Verificar estructura del proyecto
    required_files = [
        Path("/config/config.json"),
        Path("/scripts/commit_automator.py"),
        Path("/repo")
    ]
    
    print("\n📋 Verificando archivos necesarios...")
    all_exist = True
    for file_path in required_files:
        exists = file_path.exists()
        status = "✅" if exists else "❌"
        print(f"  {status} {file_path}")
        if not exists:
            all_exist = False
    
    if not all_exist:
        print("\n❌ Faltan archivos necesarios. Verifica la instalación.")
        return False
    
    # Verificar que el directorio repo sea un repositorio Git
    print("\n🔍 Verificando repositorio Git...")
    repo_path = Path("/repo")
    git_dir = repo_path / ".git"
    
    if not git_dir.exists():
        print("  ❌ El directorio /repo no es un repositorio Git")
        print("  💡 Ejecuta: git init en /repo")
        return False
    print("  ✅ Repositorio Git encontrado")
    
    # Verificar configuración de Git
    print("\n⚙️  Verificando configuración de Git...")
    success, user_name, _ = run_command(
        ["git", "config", "user.name"],
        cwd=repo_path
    )
    success2, user_email, _ = run_command(
        ["git", "config", "user.email"],
        cwd=repo_path
    )
    
    if success and success2:
        print(f"  ✅ Usuario: {user_name.strip()}")
        print(f"  ✅ Email: {user_email.strip()}")
    else:
        print("  ⚠️  Configuración de Git incompleta")
    
    # Verificar remoto
    print("\n🌐 Verificando repositorio remoto...")
    success, remote_url, _ = run_command(
        ["git", "remote", "get-url", "origin"],
        cwd=repo_path
    )
    
    if success:
        print(f"  ✅ Remoto configurado: {remote_url.strip()}")
    else:
        print("  ⚠️  No hay repositorio remoto configurado")
        print("  💡 Para agregar uno: git remote add origin <URL>")
    
    # Probar el script de automatización
    print("\n🚀 Ejecutando script de automatización...")
    print("-" * 60)
    
    success, stdout, stderr = run_command(
        ["python3", "/scripts/commit_automator.py"]
    )
    
    print(stdout)
    if stderr:
        print(stderr)
    
    print("-" * 60)
    
    if success:
        print("\n✅ Prueba completada exitosamente")
        print("\n📊 Verifica los commits con:")
        print("   docker-compose exec n8n sh -c 'cd /repo && git log'")
        return True
    else:
        print("\n❌ La prueba falló. Revisa los errores arriba.")
        return False


if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
