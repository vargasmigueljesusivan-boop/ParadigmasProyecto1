Imagen base ligera con Python y Debian

FROM python:3.10-slim-bullseye

Instalar SWI-Prolog y dependencias del sistema
RUN apt-get update && apt-get install -y --no-install-recommends swi-prolog && rm -rf /var/lib/apt/lists/*

Establecer directorio de trabajo
WORKDIR /app

Copiar archivo de requerimientos e instalarlos
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

Copiar todo el código del proyecto al contenedor
COPY . .

Exponer el puerto donde corre la aplicación Flask
EXPOSE 5000

Comando para iniciar el servidor web
CMD ["python", "backend/app.py"]