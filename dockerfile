FROM docker:latest

# Instalar Git y otros paquetes necesarios
RUN apk add --no-cache git bash

# Copiar el script run.sh al contenedor
COPY run.sh /run.sh

# Asignar permisos de ejecución al script
RUN chmod +x /run.sh

# Comando por defecto para ejecutar el script
CMD ["/execute_all.sh"] 