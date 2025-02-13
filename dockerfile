# Usa la imagen oficial docker:dind como base (basada en Alpine)
FROM docker:dind

# Establece la configuración de idioma
ENV LANG=C.UTF-8

# Actualiza el índice de paquetes e instala las dependencias necesarias:
# - build-base: herramientas esenciales para compilar en C (gcc, make, etc.)
# - go: para compilar programas en Go
# - rust: para compilar programas en Rust
# - nodejs y npm: para ejecutar soluciones en JavaScript
# - python3: para ejecutar soluciones en Python
RUN apk update && apk add --no-cache \
    build-base \
    go \
    rust \
    nodejs \
    npm \
    python3

# Establece el directorio de trabajo
WORKDIR /app

# Copia todo el contenido del repositorio en el contenedor
COPY . /app

# Otorga permisos de ejecución al script principal
RUN chmod +x execute_all.sh

# Sobrescribe el entrypoint para evitar que se inicie el daemon de Docker
ENTRYPOINT []

# Al iniciar el contenedor se ejecuta el script que compila y ejecuta todas las soluciones
CMD ["./execute_all.sh"]
