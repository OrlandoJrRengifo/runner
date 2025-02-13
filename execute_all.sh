#!/bin/bash

# Esperar a que el daemon de Docker esté listo
timeout=30
while [ $timeout -gt 0 ] && ! docker info >/dev/null 2>&1; do
    echo "Esperando que el daemon de Docker esté listo... ($timeout segundos restantes)"
    sleep 1
    timeout=$((timeout - 1))
done

if [ $timeout -eq 0 ]; then
    echo "Error: Tiempo de espera agotado esperando al daemon de Docker"
    exit 1
fi

# Configurar buildx de manera más robusta
docker buildx version || docker buildx install
docker buildx create --use --name builder default || true
docker buildx inspect --bootstrap || true

# Repositorio de soluciones
REPO_URL="https://github.com/Sebastiankz/benchmark.git"
DIRECTORY="benchmark"

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
    # Intentar primero con buildx, si falla usar el builder legacy
    if ! (cd "$LANG_DIR" && docker buildx build --load -t "$IMAGE_NAME" . 2>/dev/null); then
        echo "Buildx falló, intentando con builder legacy..."
        (cd "$LANG_DIR" && docker build -t "$IMAGE_NAME" . 2>/dev/null) || { echo "Error al construir $LANG"; continue; }
    fi

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