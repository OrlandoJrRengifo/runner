FROM docker:latest

# Instalar Git y otros paquetes necesarios
RUN apk add --no-cache git bash

# Copiar el script run.sh al contenedor
COPY execute_all.sh /execute_all.sh

# Asignar permisos de ejecución al script
RUN chmod +x /execute_all.sh

# Comando por defecto para ejecutar el script
CMD ["/execute_all.sh"] 