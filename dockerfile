FROM docker:24.0-dind

# Instalar dependencias necesarias
RUN apk add --no-cache git bash

# Configurar BuildKit y Docker daemon
ENV DOCKER_BUILDKIT=1
RUN mkdir -p /etc/docker && \
    echo '{"features": {"buildkit": true}, "experimental": true}' > /etc/docker/daemon.json

# Instalar y configurar buildx durante la construcción
RUN dockerd & \
    sleep 5 && \
    docker buildx install && \
    docker buildx create --name builder --use && \
    docker buildx inspect --bootstrap && \
    pkill dockerd

# Crear directorio de trabajo
WORKDIR /app

# Copiar script de ejecución
COPY execute_all.sh .

# Dar permisos de ejecución
RUN chmod +x execute_all.sh

# Ejecutar el script
ENTRYPOINT ["dockerd-entrypoint.sh"]
CMD ["bash", "./execute_all.sh"]