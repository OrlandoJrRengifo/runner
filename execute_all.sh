#!/bin/bash
set -e
shopt -s nullglob

# Definir la ruta de clonación y el archivo temporal para los resultados
CODIGOS_PATH="/tmp/codigos"
RESULTS_FILE="/tmp/benchmark_results.txt"

# Limpiar archivo de resultados previo (si existe)
rm -f "$RESULTS_FILE"

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
    
    # Extraer el valor numérico (asumiendo formato "XX ms")
    TIME_NUM=$(echo "$TIME_OUTPUT" | sed 's/[^0-9]*//g')
    
    # Guardar el resultado en el archivo, con formato: tiempo y lenguaje
    echo "$TIME_NUM $lang" >> "$RESULTS_FILE"
  fi
done

echo "Tiempos de ejecución (de menor a mayor):"
# Ordenar los resultados numéricamente y mostrarlos
sort -n "$RESULTS_FILE" | while read time lang; do
    echo "$lang: ${time} ms"
done
