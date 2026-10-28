# Imagen base ligera de Python en Linux
FROM python:3.10-slim

# Instalar SWI-Prolog en el sistema Linux del contenedor
RUN apt-get update && apt-get install -y swi-prolog && rm -rf /var/lib/apt/lists/*

# Establecer carpeta de trabajo
WORKDIR /app

# Copiar requerimientos e instalar dependencias de Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar todo el código del proyecto
COPY . .

# Exponer el puerto de Flask
EXPOSE 5000

# Comando para ejecutar el servidor backend
CMD ["python", "backend/app.py"]