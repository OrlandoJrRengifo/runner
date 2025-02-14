#!/bin/sh
set -e

# Clonar el repositorio con las soluciones
git clone https://github.com/OrlandoJrRengifo/runner.git cloned_repo

cd cloned_repo

# Archivo donde se acumularán todas las salidas
OUTPUT_FILE="master_output.txt"
> $OUTPUT_FILE

# Lista de lenguajes (asegúrate de que los nombres de las carpetas coinciden)
LANGUAGES="c go rust javascript python"

for lang in $LANGUAGES; do
    echo "=== Ejecutando solución en $lang ===" | tee -a $OUTPUT_FILE
    cd $lang
    # Construye la imagen con el Dockerfile de la carpeta actual
    docker build -t solution_$lang .
    # Ejecuta el contenedor y agrega su salida al archivo maestro
    docker run --rm solution_$lang >> ../$OUTPUT_FILE
    cd ..
    echo "" >> $OUTPUT_FILE
done

# Imprime la salida final
cat $OUTPUT_FILE
