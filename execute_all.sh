#!/bin/sh

# Limpiar si existe una clonación previa
rm -rf codigos
rm -rf results.txt

# Clonar el repositorio con las soluciones
echo "📥 Clonando repositorio..."
git clone https://github.com/OrlandoJrRengifo/codigos.git
cd codigos

# Crear archivo de resultados
echo "Lenguaje | Tiempo (ms)" > results.txt
echo "----------------------" >> results.txt

# Lista de lenguajes a procesar
for lang in c go javascript python rust
do
    # La ruta correcta es dentro de 'codigos/[lenguaje]'
    if [ -d "$lang" ] && [ -f "$lang/dockerfile" ]; then
        echo "🔨 Construyendo $lang..."
        
        # Construir la imagen Docker
        if docker build -t "$lang-benchmark" "$lang"; then
            echo "🏃 Ejecutando $lang..."
            # Ejecutar el contenedor y capturar el tiempo de ejecución
            tiempo=$(docker run --rm "$lang-benchmark" 2>/dev/null)
            
            # Guardar el resultado en el archivo
            if [ -n "$tiempo" ]; then
                echo "$lang | $tiempo" >> results.txt
            else
                echo "$lang | Error en ejecución" >> results.txt
            fi
        else
            echo "$lang | Error al construir la imagen" >> results.txt
        fi
    else
        echo "$lang | Dockerfile no encontrado en $lang/dockerfile" >> results.txt
    fi
done

# Mostrar los resultados en la consola
echo "\n📊 Resultados:"
cat results.txt

# Limpiar después de terminar
cd ..