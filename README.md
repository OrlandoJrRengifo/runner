# benchmark-runner

Pasos para la ejecución:

1. Clonar el repositorio: git clone https://github.com/OrlandoJrRengifo/runner.git
   
2. Ubicarse en cd runner
   
3. Construye la imagen del contenedor base: docker build -t ttkjunior/runner

4. Ejecutar el contenedor con: docker run -it --rm \-v /var/run/docker.sock:/var/run/docker.sock \-e DOCKER_HOST=unix:///var/run/docker.sock \ttkjunior/runner

Enlace al Repositorio con los Códigos del Benchmark:
https://github.com/OrlandoJrRengifo/codigos 
