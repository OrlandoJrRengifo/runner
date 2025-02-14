FROM docker:latest

# Instalar git y bash (en Alpine)
RUN apk add --no-cache git bash

WORKDIR /app
COPY execute_all.sh .
RUN chmod +x execute_all.sh

CMD ["./execute_all.sh"]
