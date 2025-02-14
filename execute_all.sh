#!/bin/bash

echo "🚀 Iniciando benchmarks..."

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
        docker build -t "${dir}-benchmark" "$dir"
        
        # Ejecutar contenedor y capturar tiempo
        echo "   🏃 Ejecutando benchmark..."
        TIEMPO=$(docker run --rm "${dir}-benchmark")
        
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