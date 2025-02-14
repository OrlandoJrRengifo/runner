#!/bin/bash
# Habilitar nullglob para que los patrones sin coincidencias se expandan a nada
shopt -s nullglob

# Definir la ruta en la que se clonará el repositorio "codigos"
CODIGOS_PATH="/tmp/codigos"

# Clonar el repositorio de códigos si no existe, o actualizarlo si ya está clonado
if [ ! -d "$CODIGOS_PATH" ]; then
  echo "Clonando repositorio de códigos..."
  git clone https://github.com/OrlandoJrRengifo/codigos.git "$CODIGOS_PATH" || {
    echo "❌ Error al clonar el repositorio de códigos."
    exit 1
  }
else
  echo "Repositorio de códigos ya clonado en $CODIGOS_PATH. Actualizando..."
  cd "$CODIGOS_PATH" && git pull && cd -
fi

echo "Ejecutando benchmarks..."

# Obtener la lista de subdirectorios (cada uno representa un lenguaje)
LANG_DIRS=("$CODIGOS_PATH"/*/)

if [ ${#LANG_DIRS[@]} -eq 0 ]; then
  echo "❌ No se encontraron directorios en $CODIGOS_PATH. Verifica la estructura del repositorio."
  exit 1
fi

# Recorrer cada subdirectorio para construir y ejecutar la imagen Docker correspondiente
for dir in "${LANG_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    LENGUAJE=$(basename "$dir")
    echo "🔹 Procesando lenguaje: $LENGUAJE..."

    # Construir la imagen Docker usando el Dockerfile de la carpeta
    docker build -t "${LENGUAJE}-benchmark" "$dir" || {
      echo "❌ Error al construir la imagen para $LENGUAJE."
      continue
    }

    # Ejecutar el contenedor y capturar la salida (se espera que imprima el tiempo, p.ej., "23 ms")
    TIEMPO=$(docker run --rm "${LENGUAJE}-benchmark")
    if [ -n "$TIEMPO" ]; then
      echo "$LENGUAJE: $TIEMPO"
    else
      echo "❌ Error: no se obtuvo salida para $LENGUAJE."
    fi
  fi
done
