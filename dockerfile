FROM docker:24.0-dind

# Instalar dependencias necesarias
RUN apk add --no-cache git bash

# Configurar BuildKit
ENV DOCKER_BUILDKIT=1
RUN mkdir -p /etc/docker && \
    echo '{"features": {"buildkit": true}}' > /etc/docker/daemon.json && \
    echo '{"experimental": true}' >> /etc/docker/daemon.json

# Crear directorio de trabajo
WORKDIR /app

# Copiar script de ejecución
COPY execute_all.sh .

# Dar permisos de ejecución
RUN chmod +x execute_all.sh

# Iniciar Docker y ejecutar el script
ENTRYPOINT ["dockerd-entrypoint.sh"]
CMD ["bash", "./execute_all.sh"]