#!/bin/bash

echo "🚀 Iniciando benchmarks..."

# Verificar que Docker esté corriendo
if ! docker info >/dev/null 2>&1; then
    echo "❌ Error: Docker no está corriendo. Intentando iniciar Docker..."
    sudo systemctl start docker
    sleep 5  # Esperar a que Docker inicie completamente
    
    if ! docker info >/dev/null 2>&1; then
        echo "❌ Error: No se pudo iniciar Docker. Por favor, verifica la instalación."
        exit 1
    fi
fi

# Limpiar directorio temporal si existe
rm -rf ./temp_codigos
mkdir -p ./temp_codigos

# Clonar el repositorio con las soluciones
echo "📥 Clonando repositorio de soluciones..."
git clone https://github.com/OrlandoJrRengifo/codigos.git ./temp_codigos

# Entrar al directorio de soluciones
cd ./temp_codigos

# Recorrer las carpetas de lenguajes
echo "⚙️ Ejecutando benchmarks para cada lenguaje..."
for dir in c go javascript python rust; do
    if [ -d "$dir" ]; then
        echo "🔹 Procesando $dir..."
        
        # Construir imagen Docker
        echo "   🏗️ Construyendo imagen Docker para $dir..."
        docker build -t "${dir}-benchmark" "$dir" || {
            echo "   ❌ Error: Fallo al construir la imagen para $dir"
            continue
        }
        
        # Ejecutar contenedor y capturar tiempo usando --network host
        echo "   🏃 Ejecutando benchmark..."
        TIEMPO=$(docker run --rm --network host "${dir}-benchmark") || {
            echo "   ❌ Error: Fallo al ejecutar el contenedor para $dir"
            continue
        }
        
        if [ -n "$TIEMPO" ]; then
            echo "   ✅ $dir: $TIEMPO"
        else
            echo "   ❌ Error: No se pudo obtener el tiempo de ejecución para $dir"
        fi
    else
        echo "⚠️ No se encontró el directorio para $dir"
    fi
done

# Limpiar después de terminar
cd ..
rm -rf ./temp_codigos

echo "🏁 Benchmarks completados"