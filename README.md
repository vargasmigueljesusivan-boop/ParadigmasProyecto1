# Sistema Experto: Recomendador de Laptops para Ingeniería

Este proyecto es un sistema experto interactivo que ayuda a estudiantes de ingeniería a elegir el equipo de cómputo ideal según sus materias, presupuesto y herramientas de software a utilizar. 

El motor de razonamiento lógico está desarrollado en Prolog y expuesto mediante una API REST en Python (Flask), interactuando con un frontend web responsivo.

---

## 🛠️ Requisitos Previos

Para ejecutar este proyecto de forma local necesitarás instalar:

- [SWI-Prolog](https://www.swi-prolog.org/)
- [Python 3.10+](https://www.python.org/)
- [Git](https://git-scm.com/)

---

## 🚀 Instalación y Ejecución Local

### 1. Clonar el repositorio
```bash
git clone https://github.com/TU-USUARIO/sistema-experto-laptops.git
cd sistema-experto-laptops
```

### 2. Configurar el entorno virtual de Python
```bash
# Crear entorno virtual
python -m venv venv

# Activar entorno virtual
# En Linux/macOS:
source venv/bin/activate
# En Windows (CMD):
venv\Scripts\activate
# En Windows (PowerShell):
.\venv\Scripts\Activate.ps1
```

### 3. Instalar dependencias
```bash
pip install -r requirements.txt
```

### 4. Probar el motor de Prolog en consola
Antes de iniciar el servidor web, puedes verificar la base de conocimientos ejecutando:
```bash
swipl -s prolog/motor_logico.pl
```
Y realizando consultas directas como:
```prolog
?- recomendar('Sistemas Computacionales', 18000, ['Docker', 'VS Code'], Equipo, Specs).
```

### 5. Iniciar la aplicación web
```bash
python backend/main.py
```
Abre tu navegador e ingresa a `http://localhost:5000`.

---

## 🏗️ Arquitectura Técnica

1. **Frontend**: HTML5, CSS3 y JavaScript ES6 (`fetch` API).
2. **Backend**: Python con Flask, encargado de traducir las peticiones del usuario a consultas de Prolog.
3. **Motor de Inferencia**: SWI-Prolog a través de ejecución de procesos (`subprocess`).
4. **Contenerización**: Docker para empaquetado y despliegue en la nube.

---

## 📋 Casos de Prueba Documentados

| ID | Carrera | Presupuesto ($) | Herramientas | Resultado Esperado |
| 1 | Sistemas | 25,000 | Docker, VirtualBox, VS Code | Laptop Alto Rendimiento / Dev |
| 2 | Computación | 12,000 | Dev C++, LaTeX | Laptop Gama Entrada / Básica |
| 3 | Mecatrónica | 22,000 | SolidWorks, MATLAB | Laptop con GPU Dedicada |
| 4 | Biónica | 15,000 | Python, Proteus | Laptop Gama Media |
| 5 | Industrial | 10,000 | Excel, Word | Laptop Básica |

---

## ✒️ Licencia y Declaración de IA
Proyecto desarrollado para la unidad de aprendizaje Paradigmas de Programación.
- IA Generativa: Utilizada para la generación del maquetado HTML/CSS, integración backend-frontend y configuración de infraestructura Docker.
- Base de Conocimientos Prolog (`.pl`): Desarrollada de forma 100% manual por Vargas Miguel Jesús Iván.