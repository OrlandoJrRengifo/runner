#!/bin/bash
set -e  # Detiene el script si ocurre algún error

OUTPUT_FILE="output.txt"
TIME_FILE="times.txt"

# Inicializa los archivos de salida
echo "Resultados de la ejecución:" > "$OUTPUT_FILE"
echo "" > "$TIME_FILE"

# Función para compilar, ejecutar y medir el tiempo de cada solución
run_solution() {
  local lang="$1"         # Nombre del lenguaje (ej. Go, Rust, etc.)
  local dir="$2"          # Directorio donde se encuentra la solución
  local compile_cmd="$3"  # Comando para compilar (si es necesario), vacío en caso contrario
  local run_cmd="$4"      # Comando para ejecutar la solución

  echo "Ejecutando solución en $lang..."
  cd "$dir"

  # Si se especifica un comando de compilación, se ejecuta
  if [ -n "$compile_cmd" ]; then
    eval "$compile_cmd"
  fi

  # Se mide el tiempo de ejecución
  start=$(date +%s%3N)         # Tiempo en milisegundos al inicio
  eval "$run_cmd" >> "../$OUTPUT_FILE"
  end=$(date +%s%3N)           # Tiempo en milisegundos al finalizar
  elapsed=$((end - start))

  # Se guarda el tiempo de ejecución junto con el nombre del lenguaje
  echo "$lang: $elapsed ms" >> "../$TIME_FILE"
  cd ..
}

### **Ejecución de las Soluciones**

# 1. **Solución en Go**
run_solution "Go" "go" "go build -o solution solution.go" "./solution"

# 2. **Solución en Rust**
run_solution "Rust" "rust" "rustc solution.rs -o solution" "./solution"

# 3. **Solución en JavaScript**
run_solution "JavaScript" "javascript" "" "node solution.js"

# 4. **Solución en Python**
run_solution "Python" "python" "" "python3 solution.py"

# 5. **Solución en C**
run_solution "C" "c" "gcc solution.c -o solution" "./solution"

### **Ordenar y Mostrar Tiempos**

echo "" >> "$OUTPUT_FILE"
echo "Tiempos de ejecución (ordenados de mayor a menor):" >> "$OUTPUT_FILE"

# Se usa el comando sort para ordenar numéricamente la columna del tiempo (después de los dos puntos)
sort -t: -k2 -nr "$TIME_FILE" >> "$OUTPUT_FILE"

echo "Ejecución completada. Consulta '$OUTPUT_FILE' para ver los resultados y los tiempos ordenados."
