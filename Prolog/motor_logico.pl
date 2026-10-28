/* =========================================================================
   BASE DE CONOCIMIENTOS: SISTEMA EXPERTO RECOMENDADOR DE LAPTOPS
   (Versión de práctica - Aprendiz de Prolog)
========================================================================= */

% -------------------------------------------------------------------------
% 1. HECHOS (Datos fijos sobre laptops, herramientas y carreras)
% -------------------------------------------------------------------------

% Hechos sobre Laptops (id, marca, modelo, precio, ram_gb, cpu_nivel, gpu_dedicada)
laptop(l1, 'Lenovo', 'IdeaPad 3', 11000, 8, i3, no).
laptop(l2, 'HP', 'Pavilion 15', 14500, 8, i5, no).
laptop(l3, 'Dell', 'Inspirion 14', 16000, 16, i5, no).
laptop(l4, 'ASUS', 'TUF Gaming A15', 21000, 16, ryzen7, si).
laptop(l5, 'Lenovo', 'Legion Pro 5', 28000, 32, i7, si).
laptop(l6, 'Acer', 'Aspire 5', 12500, 8, ryzen5, no).
laptop(l7, 'Apple', 'MacBook Air M2', 23000, 8, m2, no).
laptop(l8, 'Dell', 'G15', 22500, 16, i7, si).
laptop(l9, 'HP', 'ProBook 445', 13500, 16, ryzen5, no).
laptop(l10, 'Acer', 'Extensa 15', 14000, 16, i5, no).
laptop(l11, 'Acer', 'Nitro 5 (Basica)', 17500, 16, i5, si).

% Hechos sobre Requerimientos de Herramientas (herramienta, min_ram, gpu_requerida)
requiere_tool('Docker', 16, no).
requiere_tool('VirtualBox', 8, no).
requiere_tool('SolidWorks', 16, si).
requiere_tool('MATLAB', 8, no).
requiere_tool('Proteus', 8, no).
requiere_tool('AutoCAD', 16, si).
requiere_tool('VS Code', 8, no).
requiere_tool('Dev C++', 4, no).

% Hechos sobre Exigencia por Carrera (carrera, nivel_exigencia)
carrera_exigencia('Sistemas Computacionales', alto).
carrera_exigencia('Mecatrónica', alto).
carrera_exigencia('Biónica', medio).
carrera_exigencia('Industrial', medio).
carrera_exigencia('Inteligencia Artificial', alto).
carrera_exigencia('Matemáticas Algorítmicas', medio).


% -------------------------------------------------------------------------
% 2. REGLAS LÓGICAS (Condiciones para relacionar los datos)
% -------------------------------------------------------------------------

% Regla 1: Determina si el presupuesto cubre el costo de la laptop
presupuesto_suficiente(PrecioMax, Precio) :-
    Precio =< PrecioMax.

% Regla 2: Valida si la memoria RAM satisface un requerimiento de herramienta
ram_suficiente(RAM_Laptop, RAM_Minima) :-
    RAM_Laptop >= RAM_Minima.

% Regla 3: Verifica compatibilidad de tarjeta gráfica
gpu_compatible(si, si).
gpu_compatible(_, no).

% Regla 4: Recorre recursivamente una lista de herramientas para ver si el equipo las soporta
soporta_herramientas(_, []).
soporta_herramientas(ID, [H|T]) :-
    laptop(ID, _, _, _, RAM, _, GPU),
    requiere_tool(H, RAM_Req, GPU_Req),
    ram_suficiente(RAM, RAM_Req),
    gpu_compatible(GPU, GPU_Req),
    soporta_herramientas(ID, T).

% Regla 5: Categoría de perfil ligero
perfil_basico(RAM, GPU) :-
    RAM =< 8,
    GPU == no.

% Regla 6: Categoría de perfil avanzado
perfil_avanzado(RAM, GPU) :-
    RAM >= 16,
    GPU == si.

% Regla 7: Clasificación de perfil intermedio
perfil_intermedio(RAM, GPU) :-
    RAM >= 16,
    GPU == no.

% Regla 8: Recomendar laptop según carrera, presupuesto y herramientas (Inferencia principal)
recomendar_laptop(Carrera, Presupuesto, Herramientas, Marca, Modelo, Precio, RAM, GPU) :-
    carrera_exigencia(Carrera, _),
    laptop(ID, Marca, Modelo, Precio, RAM, _, GPU),
    presupuesto_suficiente(Presupuesto, Precio),
    soporta_herramientas(ID, Herramientas).

% Regla 9: Determina el tipo de recomendación obtenida
tipo_recomendacion(RAM, GPU, 'Estacion de Trabajo / Gaming') :- perfil_avanzado(RAM, GPU).
tipo_recomendacion(RAM, GPU, 'Desarrollo Avanzado / Multitarea') :- perfil_intermedio(RAM, GPU).
tipo_recomendacion(RAM, GPU, 'Uso Basico / Programacion Ligera') :- perfil_basico(RAM, GPU).

% Regla 10: Justificación de la recomendación basada en las reglas cumplidas
explicacion_recomendacion(RAM, GPU, Explicacion) :-
    tipo_recomendacion(RAM, GPU, Tipo),
    atom_concat('El equipo fue seleccionado por pertenecer a la categoria de ', Tipo, Explicacion).


% -------------------------------------------------------------------------
% 3. PREDICADOS PROPIOS PARA CONSULTAS (Interfaces para el usuario)
% -------------------------------------------------------------------------

% Predicado 1: Consulta principal completa
consultar_equipo(Carrera, Presupuesto, Herramientas, Marca, Modelo, Precio, RAM, GPU, Categoria) :-
    recomendar_laptop(Carrera, Presupuesto, Herramientas, Marca, Modelo, Precio, RAM, GPU),
    tipo_recomendacion(RAM, GPU, Categoria).

% Predicado 2: Filtrar laptops solo por presupuesto máximo
laptops_por_presupuesto(PresupuestoMax, Modelo, Precio) :-
    laptop(_, _, Modelo, Precio, _, _, _),
    Precio =< PresupuestoMax.

% Predicado 3: Obtener herramientas que soporta cierto nivel de RAM
herramientas_compatibles(RAM, Herramienta) :-
    requiere_tool(Herramienta, RAM_Req, _),
    RAM >= RAM_Req.

% Predicado 4: Verificar si al menos una herramienta de la lista requiere GPU
requiere_gpu_lista([H|_]) :- requiere_tool(H, _, si), !.
requiere_gpu_lista([_|T]) :- requiere_gpu_lista(T).

% Predicado 5: Contar total de opciones encontradas usando findall
total_opciones(Presupuesto, Cantidad) :-
    findall(ID, (laptop(ID, _, _, P, _, _, _), P =< Presupuesto), Lista),
    length(Lista, Cantidad).