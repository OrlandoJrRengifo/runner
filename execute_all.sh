#!/bin/sh

# Clonar el repositorio con las soluciones
git clone https://github.com/OrlandoJrRengifo/codigos.git
cd codigos

# Crear archivo de resultados
echo "Lenguaje | Tiempo (ms)" > results.txt

# Lista de lenguajes a procesar
for lang in c go javascript python rust
do
    # Verificar si existe la carpeta del lenguaje y su Dockerfile
    if [ -d "./$lang" ] && [ -f "./$lang/Dockerfile" ]; then
        echo "Ejecutando $lang..."
        
        # Construir la imagen Docker
        if docker build -t "$lang-benchmark" "./$lang"; then
            # Ejecutar el contenedor y capturar el tiempo de ejecución
            tiempo=$(docker run --rm "$lang-benchmark" 2>/dev/null)
            
            # Guardar el resultado en el archivo
            if [ -n "$tiempo" ]; then
                echo "$lang | $tiempo ms" >> results.txt
            else
                echo "$lang | Error en ejecución" >> results.txt
            fi
        else
            echo "$lang | Error al construir la imagen" >> results.txt
        fi
    else
        echo "$lang | Dockerfile no encontrado" >> results.txt
    fi
done

# Mostrar los resultados en la consola
cat results.txt
