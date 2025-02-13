FROM docker:dind

# Crear directorio de trabajo
WORKDIR /app

# Copiar los archivos necesarios
COPY . .

# Dar permisos de ejecución al script
RUN chmod +x execute_all.sh

# Comando por defecto
CMD ["./execute_all.sh"]