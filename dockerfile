FROM docker:stable

# Establece el directorio de trabajo
WORKDIR /app

# Copia el script de ejecución al contenedor
COPY execute_all.sh .

# Otorga permisos de ejecución
RUN chmod +x execute_all.sh

# Al iniciar, se ejecuta el script
CMD ["./execute_all.sh"] 