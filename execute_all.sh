#!/bin/sh

# Iniciar el daemon de Docker
dockerd &
sleep 5  # Esperar a que el daemon esté listo

# Función para imprimir separadores
print_separator() {
    echo "----------------------------------------"
    echo "Running $1 solution"
    echo "----------------------------------------"
}

# Construir y ejecutar solución en Go
print_separator "Go"
docker build -f Dockerfile.go -t solution-go .
docker run --rm solution-go

# Construir y ejecutar solución en Rust
print_separator "Rust"
docker build -f Dockerfile.rust -t solution-rust .
docker run --rm solution-rust

# Construir y ejecutar solución en JavaScript
print_separator "JavaScript"
docker build -f Dockerfile.node -t solution-js .
docker run --rm solution-js

# Construir y ejecutar solución en Python
print_separator "Python"
docker build -f Dockerfile.python -t solution-python .
docker run --rm solution-python

# Construir y ejecutar solución en C
print_separator "C"
docker build -f Dockerfile.c -t solution-c .
docker run --rm solution-c

# Mostrar resumen
echo "----------------------------------------"
echo "All solutions completed"
echo "----------------------------------------"