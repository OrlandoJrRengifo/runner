#!/bin/bash

# Repositorio de soluciones
REPO_URL="https://github.com/OrlandoJrRengifo/codigos.git"
DIRECTORY="CODIGOS"

# Clonar el repositorio si no existe
if [ ! -d "$DIRECTORY" ]; then
    git clone "$REPO_URL" "$DIRECTORY" || { echo "Error clonando el repositorio"; exit 1; }
else
    echo "Repositorio ya clonado, actualizando..."
    (cd "$DIRECTORY" && git pull)
fi

# Lenguajes y nombres de imágenes
declare -A LANGUAGES=(
    ["go"]="go-app"
    ["rust"]="rust-app"
    ["javascript"]="node-app"
    ["python"]="python-app"
    ["c"]="c-app"
)

# Crear carpeta de logs y archivo de resultados
mkdir -p logs
OUTPUT_FILE="execution_results.txt"
echo "Comparación de tiempos de ejecución" > "$OUTPUT_FILE"
echo "------------------------------------" >> "$OUTPUT_FILE"

for LANG in "go" "rust" "javascript" "python" "c"; do
    IMAGE_NAME=${LANGUAGES[$LANG]}
    LANG_DIR="$DIRECTORY/$LANG"
    LOG_FILE="logs/$LANG/output.txt"

    if [ ! -d "$LANG_DIR" ]; then
        echo "Error: No se encontró el directorio $LANG_DIR"
        continue
    fi

    echo "Construyendo imagen para $LANG..."
    (cd "$LANG_DIR" && docker buildx build --load -t "$IMAGE_NAME" .) || { echo "Error al construir $LANG"; continue; }

    echo "Ejecutando contenedor para $LANG..."
    mkdir -p "logs/$LANG"

    # Ejecutar y capturar salida
    docker run --rm "$IMAGE_NAME" | tee "$LOG_FILE"

    # Extraer el tiempo de ejecución en diferentes formatos (ms, segundos, etc.)
    EXEC_TIME=$(grep -Eo '[0-9]+(\.[0-9]+)? (ms|s)' "$LOG_FILE" | head -n 1)

    if [ -z "$EXEC_TIME" ]; then
        EXEC_TIME="Tiempo no encontrado"
    fi

    echo "$LANG: $EXEC_TIME" | tee -a "$OUTPUT_FILE"
done

# Mostrar los resultados
echo "------------------------------------"
cat "$OUTPUT_FILE"