-- *****************************************************************
-- 006_vista_ventas_funcion.sql
-- Muestra la recaudación de cada función y su peso en el dia.
-- *****************************************************************

SET search_path TO cine;

CREATE OR REPLACE VIEW vista_ventas_funcion AS
SELECT 
    f.funcion_id,
    p.titulo AS pelicula,
    s.nombre AS sala,
    f.fecha_hora_inicio,
    COUNT(e.entrada_id) * f.precio AS monto_total,
    CASE 
        WHEN (SELECT SUM(f2.precio) FROM entradas e2 JOIN funciones f2 ON e2.funcion_id = f2.funcion_id WHERE CAST(f2.fecha_hora_inicio AS DATE) = CAST(f.fecha_hora_inicio AS DATE)) = 0 THEN 0
        ELSE (CAST(COUNT(e.entrada_id) * f.precio AS FLOAT) / (SELECT SUM(f2.precio) FROM entradas e2 JOIN funciones f2 ON e2.funcion_id = f2.funcion_id WHERE CAST(f2.fecha_hora_inicio AS DATE) = CAST(f.fecha_hora_inicio AS DATE))) * 100
    END AS porcentaje_del_dia
FROM funciones f
JOIN peliculas p ON f.pelicula_id = p.pelicula_id
JOIN salas s ON f.sala_id = s.sala_id
LEFT JOIN entradas e ON f.funcion_id = e.funcion_id
GROUP BY f.funcion_id, p.titulo, s.nombre, f.fecha_hora_inicio, f.precio;

INSERT INTO schema_migrations (version) VALUES ('006_vista_ventas_funcion');
