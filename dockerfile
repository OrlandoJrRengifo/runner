# Usa una imagen base de Ubuntu
FROM ubuntu:20.04

# Configura variables para evitar interacciones (para que apt-get sea no interactivo)
ENV DEBIAN_FRONTEND=noninteractive

# Actualiza el sistema e instala las dependencias necesarias
RUN apt-get update && apt-get install -y \
    build-essential \
    golang \
    rustc \
    nodejs \
    npm \
    python3 \
    python3-pip \
 && rm -rf /var/lib/apt/lists/*

# Establece el directorio de trabajo
WORKDIR /app

# Copia todo el contenido del repositorio en el contenedor
COPY . /app

# Otorga permisos de ejecución al script
RUN chmod +x execute_all.sh

# Al iniciar el contenedor se ejecutará el script que compila y ejecuta todas las soluciones
CMD ["./execute_all.sh"]
