#!/bin/bash

# Clonar ambos repositorios
git clone https://github.com/OrlandoJrRengifo/codigos.git
git clone https://github.com/OrlandoJrRengifo/runner.git

# Cambiar al directorio donde están los códigos
cd codigos

echo "Ejecutando benchmarks..."

# Lista de lenguajes a procesar
LENGUAJES=("c" "go" "javascript" "python" "rust")

# Procesar cada lenguaje
for LENGUAJE in "${LENGUAJES[@]}"; do
    echo "🔹 Ejecutando $LENGUAJE..."
    
    # Construir imagen Docker
    docker build -t "${LENGUAJE}-benchmark" "$LENGUAJE"
    
    # Ejecutar contenedor y capturar tiempo
    TIEMPO=$(docker run --rm "${LENGUAJE}-benchmark")
    
    if [ -n "$TIEMPO" ]; then
        echo "$LENGUAJE: $TIEMPO ms"
    else
        echo "❌ Error: Salida inesperada del contenedor para $LENGUAJE"
    fi
done

# Regresar al directorio original
cd ..