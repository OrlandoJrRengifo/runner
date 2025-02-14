#!/bin/sh

# Función para verificar el estado de Docker
check_docker() {
    # Intentar iniciar el servicio Docker si no está corriendo
    if ! systemctl is-active --quiet docker; then
        echo "🔄 Iniciando servicio Docker..."
        sudo systemctl start docker
        sleep 5
    fi

    # Verificar si Docker está funcionando correctamente
    if ! docker info > /dev/null 2>&1; then
        echo "❌ Error: Docker no está funcionando correctamente"
        echo "Intentando reiniciar Docker..."
        sudo systemctl restart docker
        sleep 5
    fi
}

# Limpiar contenedores e imágenes previas
cleanup() {
    echo "🧹 Limpiando ambiente Docker..."
    docker system prune -af --volumes > /dev/null 2>&1
}

# Verificar y preparar el ambiente
echo "🔍 Verificando ambiente..."
check_docker
cleanup

# Limpiar directorio previo si existe
rm -rf codigos
rm -f results.txt

# Clonar el repositorio
echo "📥 Clonando repositorio..."
git clone https://github.com/OrlandoJrRengifo/codigos.git
cd codigos

# Crear archivo de resultados
echo "Lenguaje | Tiempo (ms)" > results.txt
echo "----------------------" >> results.txt

# Procesar cada lenguaje
for lang in c go javascript python rust; do
    echo "\n🔨 Procesando $lang..."
    
    if [ -d "$lang" ]; then
        # Verificar si existe el Dockerfile y su contenido
        if [ -f "$lang/dockerfile" ] || [ -f "$lang/Dockerfile" ]; then
            echo "📝 Construyendo imagen para $lang..."
            
            # Construir con red host y timeout aumentado
            if docker build --network host --timeout 120 -t "$lang-benchmark" "$lang"; then
                echo "🏃 Ejecutando contenedor para $lang..."
                
                # Ejecutar con red host y timeout
                tiempo=$(docker run --rm --network host "$lang-benchmark" 2>/dev/null)
                
                if [ -n "$tiempo" ]; then
                    echo "$lang | $tiempo" >> results.txt
                    echo "✅ $lang completado: $tiempo"
                else
                    echo "$lang | Error en ejecución" >> results.txt
                    echo "❌ Error en la ejecución de $lang"
                fi
            else
                echo "$lang | Error al construir la imagen" >> results.txt
                echo "❌ Error al construir la imagen de $lang"
            fi
        else
            echo "$lang | Dockerfile no encontrado" >> results.txt
            echo "❌ No se encontró Dockerfile para $lang"
        fi
    else
        echo "$lang | Directorio no encontrado" >> results.txt
        echo "❌ No se encontró el directorio para $lang"
    fi
done

# Mostrar resultados
echo "\n📊 Resultados finales:"
cat results.txt

# Limpiar
cd ..