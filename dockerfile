FROM docker:latest

# Instalar Git y Bash (en Alpine Linux)
RUN apk add --no-cache git bash

# Copiar el script al contenedor
COPY execute_all.sh /execute_all.sh
RUN chmod +x /execute_all.sh

# Ejecutar el script cuando se inicie el contenedor
CMD ["/execute_all.sh"]

