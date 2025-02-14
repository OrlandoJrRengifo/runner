#!/bin/bash

# Clonar el repositorio que contiene los códigos (si no lo has clonado previamente)
git clone https://github.com/OrlandoJrRengifo/codigos.git

# Entrar en el directorio runner
cd runner

echo "Ejecutando benchmarks..."

# Recorrer las carpetas de los lenguajes que están en el repositorio de códigos
# Se asume que la estructura clonada es: ../codigos/{c, go, javascript, python, rust}
for dir in ../codigos/*/; do
  if [ -d "$dir" ]; then
    LENGUAJE=$(basename "$dir")
    echo "🔹 Ejecutando $LENGUAJE..."

    # Construir la imagen Docker utilizando la carpeta del lenguaje
    docker build -t "${LENGUAJE//+/}-benchmark" "$dir"

    # Ejecutar el contenedor y capturar la salida
    TIEMPO=$(docker run --rm "${LENGUAJE//+/}-benchmark")

    if [ -n "$TIEMPO" ]; then
      echo "$LENGUAJE: $TIEMPO ms"
    else
      echo "❌ Error: Salida inesperada del contenedor para $LENGUAJE"
    fi
  fi
done


