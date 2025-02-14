#!/bin/bash

# Clonar el repositorio con las soluciones
git clone https://github.com/OrlandoJrRengifo/codigos.git
cd codigos

# Recorrer carpetas de lenguajes
echo "Ejecutando benchmarks..."
for dir in */; do
  # Verifica si es un directorio válido
  if [ -d "$dir" ]; then
    LENGUAJE=$(basename "$dir")
    echo "🔹 Ejecutando $LENGUAJE..."

    # Construir imagen Docker
    docker build -t "${LENGUAJE//+/}-benchmark" "$dir"

    # Ejecutar contenedor y capturar tiempo (montando el socket de Docker)
    TIEMPO=$(docker run --rm -v /var/run/docker.sock:/var/run/docker.sock "${LENGUAJE//+/}-benchmark")

    if [ -n "$TIEMPO" ]; then
      echo "$LENGUAJE: $TIEMPO ms"
    else
      echo "❌ Error: Salida inesperada del contenedor para $LENGUAJE"
    fi
  fi
done
