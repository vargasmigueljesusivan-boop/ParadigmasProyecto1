document.addEventListener('DOMContentLoaded', () => {
    const form = document.getElementById('expert-form');
    const resultsContainer = document.getElementById('results-container');

    form.addEventListener('submit', async (e) => {
        e.preventDefault();

        // Obtener valores seleccionados por el usuario
        const carrera = document.getElementById('carrera').value;
        const presupuesto = parseFloat(document.getElementById('presupuesto').value);
        
        // Obtener checkboxes seleccionados
        const checkboxes = document.querySelectorAll('.checkbox-grid input[type="checkbox"]:checked');
        const herramientas = Array.from(checkboxes).map(cb => cb.value);

        // Mostrar indicador de carga
        resultsContainer.innerHTML = '<p class="placeholder-text">Consultando reglas lógicas en Prolog...</p>';

        try {
            // Petición HTTP POST al backend en Python
            const response = await fetch('/api/recomendar', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ carrera, presupuesto, herramientas })
            });

            const data = await response.json();

            if (!response.ok) {
                resultsContainer.innerHTML = `<p class="placeholder-text" style="color: red;">${data.error}</p>`;
                return;
            }

            mostrarResultados(data.resultados);

        } catch (error) {
            console.error('Error:', error);
            resultsContainer.innerHTML = '<p class="placeholder-text" style="color: red;">Error al conectar con el servidor backend.</p>';
        }
    });

    function mostrarResultados(resultados) {
        if (!resultados || resultados.length === 0) {
            resultsContainer.innerHTML = `
                <div class="result-item" style="border-left-color: #dc3545;">
                    <h3>Sin coincidencias suficientes</h3>
                    <p>El motor de inferencia no encontró opciones que cumplan con todos tus requerimientos dentro del presupuesto ingresado.</p>
                    <small>Sugerencia: Incrementa el presupuesto o ajusta las herramientas seleccionadas.</small>
                </div>
            `;
            return;
        }

        let html = `<p><strong>Opciones encontradas mediante retroceso (Backtracking):</strong> ${resultados.length}</p>`;

        resultados.forEach(item => {
            html += `
                <div class="result-item">
                    <h3>${item.marca} ${item.modelo} <span class="badge">$${item.precio.toLocaleString('es-MX')} MXN</span></h3>
                    <p><strong>Categoría Infirida:</strong> ${item.categoria}</p>
                    <p><strong>Especificaciones principales:</strong> ${item.ram} GB RAM | GPU Dedicada: ${item.gpu_dedicada.toUpperCase()}</p>
                </div>
            `;
        });

        resultsContainer.innerHTML = html;
    }
});