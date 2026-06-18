-- Top 3 peliculas por recaudacion total
SELECT 
    p.titulo, 
    SUM(f.precio) AS recaudacion_total
FROM peliculas p
JOIN funciones f ON p.pelicula_id = f.pelicula_id
JOIN entradas e ON f.funcion_id = e.funcion_id
GROUP BY p.pelicula_id, p.titulo
ORDER BY recaudacion_total DESC
LIMIT 3;

-- Que funcion tuvo el mayor porcentaje de ocupacion?
SELECT 
    f.funcion_id, 
    p.titulo AS pelicula, 
    s.nombre AS sala,
    (CAST(COUNT(e.entrada_id) AS FLOAT) / s.capacidad) * 100 AS porcentaje_ocupacion
FROM funciones f
JOIN peliculas p ON f.pelicula_id = p.pelicula_id
JOIN salas s ON f.sala_id = s.sala_id
LEFT JOIN entradas e ON f.funcion_id = e.funcion_id
GROUP BY f.funcion_id, p.titulo, s.nombre, s.capacidad
ORDER BY porcentaje_ocupacion DESC
LIMIT 1;

-- Que clientes compraron entradas en 3 o mas funciones distintas?
SELECT 
    c.rut, 
    c.nombre, 
    COUNT(DISTINCT e.funcion_id) AS cantidad_funciones
FROM clientes c
JOIN entradas e ON c.cliente_id = e.cliente_id
GROUP BY c.cliente_id, c.rut, c.nombre
HAVING COUNT(DISTINCT e.funcion_id) >= 3;

-- Recaudacion por sala y por dia
SELECT 
    s.nombre AS sala, 
    CAST(f.fecha_hora_inicio AS DATE) AS dia,
    SUM(f.precio) AS recaudacion_dia
FROM salas s
JOIN funciones f ON s.sala_id = f.sala_id
JOIN entradas e ON f.funcion_id = e.funcion_id
GROUP BY s.sala_id, s.nombre, CAST(f.fecha_hora_inicio AS DATE)
ORDER BY dia, s.nombre;

-- Que peliculas no tienen ninguna entrada vendida?
SELECT p.titulo
FROM peliculas p
WHERE p.pelicula_id NOT IN (
    -- Subconsulta de peliculas que si tienen entradas vendidas
    SELECT f.pelicula_id
    FROM funciones f
    JOIN entradas e ON f.funcion_id = e.funcion_id
);

-- Cual es el horario de inicio con mas entradas vendidas (la franja peak)?
SELECT 
    CAST(f.fecha_hora_inicio AS TIME) AS horario,
    COUNT(e.entrada_id) AS total_entradas
FROM funciones f
JOIN entradas e ON f.funcion_id = e.funcion_id
GROUP BY CAST(f.fecha_hora_inicio AS TIME)
ORDER BY total_entradas DESC
LIMIT 1;
