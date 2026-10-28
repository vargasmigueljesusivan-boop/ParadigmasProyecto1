import os
import subprocess
import json
import shutil
from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS

# NOTA: Asegúrate de que 'Fronted' o 'Frontend' coincida exactamente con el nombre de tu carpeta en el proyecto
app = Flask(__name__, static_folder='../Fronted', static_url_path='')
CORS(app)

# Ruta hacia el archivo Prolog
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
PROLOG_FILE = os.path.join(BASE_DIR, '../Prolog/motor_logico.pl')

def ejecutar_consulta_prolog(carrera, presupuesto, herramientas):
    """
    Construye y ejecuta la consulta de Prolog a través de subprocess para evitar dependencias
    complejas de C/Python como pyswip en servidores de despliegue.
    """
    # Formatear la lista de herramientas para la sintaxis de Prolog ['Tool1', 'Tool2']
    herramientas_prolog = "[" + ", ".join([f"'{h}'" for h in herramientas]) + "]"
    
    # Invocación de la consulta a Prolog utilizando atomos y variables
    query = (
        f"consultar_equipo('{carrera}', {presupuesto}, {herramientas_prolog}, "
        f"Marca, Modelo, Precio, RAM, GPU, Categoria), "
        f"write(Marca), write(','), write(Modelo), write(','), write(Precio), "
        f"write(','), write(RAM), write(','), write(GPU), write(','), write(Categoria), nl, fail; true."
    )

    # Detección automática: busca 'swipl' en el sistema (Linux/Docker/Variables de entorno) 
    # o usa la ruta de Windows si está local.
    ruta_swipl = shutil.which('swipl') or r"C:\Program Files\swipl\bin\swipl.exe"

    # Comando de consola para ejecutar SWI-Prolog en modo batch
    comando = [
        ruta_swipl,
        '-q',
        '-s', PROLOG_FILE,
        '-g', query,
        '-t', 'halt'
    ]

    try:
        resultado = subprocess.run(comando, capture_output=True, text=True, check=True)
        salida = resultado.stdout.strip().split('\n')
        
        resultados = []
        for linea in salida:
            if not linea:
                continue
            partes = linea.split(',')
            if len(partes) >= 6:
                resultados.append({
                    "marca": partes[0].strip(),
                    "modelo": partes[1].strip(),
                    "precio": float(partes[2].strip()),
                    "ram": int(partes[3].strip()),
                    "gpu_dedicada": partes[4].strip(),
                    "categoria": partes[5].strip()
                })
        return resultados

    except subprocess.CalledProcessError as e:
        print(f"Error al ejecutar SWI-Prolog: {e.stderr}")
        return []
    except Exception as e:
        print(f"Error en el servidor: {str(e)}")
        return []

@app.route('/')
def serve_frontend():
    """ Sirve la interfaz web desde la carpeta frontend """
    return send_from_directory(app.static_folder, 'pagina.html')

@app.route('/api/recomendar', methods=['POST'])
def recomendar():
    """ Endpoint que recibe los criterios del usuario y consulta el motor en Prolog """
    datos = request.get_json()
    
    carrera = datos.get('carrera', '')
    presupuesto = datos.get('presupuesto', 0)
    herramientas = datos.get('herramientas', [])

    # Validación básica de datos de entrada
    if not carrera or presupuesto <= 0:
        return jsonify({
            "error": "Por favor ingrese una carrera y un presupuesto válido."
        }), 400

    # Ejecutar inferencia lógica
    opciones = ejecutar_consulta_prolog(carrera, presupuesto, herramientas)

    return jsonify({
        "total_resultados": len(opciones),
        "resultados": opciones
    })

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port, debug=True)