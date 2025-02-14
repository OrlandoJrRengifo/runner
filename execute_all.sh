#!/bin/bash
set -e
shopt -s nullglob

# Definir la ruta de clonación
CODIGOS_PATH="/tmp/codigos"

# Clonar (o actualizar) el repositorio de codigos
if [ ! -d "$CODIGOS_PATH" ]; then
  echo "Clonando repositorio de codigos..."
  git clone https://github.com/OrlandoJrRengifo/codigos.git "$CODIGOS_PATH"
else
  echo "Repositorio de codigos ya existe en $CODIGOS_PATH, actualizando..."
  cd "$CODIGOS_PATH" && git pull && cd -
fi

echo "Ejecutando benchmarks..."

# Recorrer cada carpeta de lenguaje
for lang_dir in "$CODIGOS_PATH"/*/; do
  if [ -d "$lang_dir" ]; then
    lang=$(basename "$lang_dir")
    echo "Procesando $lang..."
    
    # Construir la imagen Docker para el lenguaje
    docker build -t "${lang}-benchmark" "$lang_dir"
    
    # Ejecutar el contenedor y capturar la salida (tiempo de ejecución)
    TIME_OUTPUT=$(docker run --rm "${lang}-benchmark")
    
    # Imprimir el tiempo de ejecución
    echo "$lang: $TIME_OUTPUT"
  fi
done
