-- *****************************************************************
-- 005_vista_llenado_sala.sql
-- Muestra el porcentaje de llenado historico por cada sala.
-- *****************************************************************

SET search_path TO cine;

CREATE OR REPLACE VIEW vista_llenado_sala AS
SELECT 
    s.sala_id,
    s.nombre,
    s.capacidad,
    CASE 
        WHEN COUNT(DISTINCT f.funcion_id) = 0 THEN 0
        ELSE (CAST(COUNT(e.entrada_id) AS FLOAT) / (s.capacidad * COUNT(DISTINCT f.funcion_id))) * 100
    END AS porcentaje_llenado
FROM salas s
LEFT JOIN funciones f ON s.sala_id = f.sala_id
LEFT JOIN entradas e ON f.funcion_id = e.funcion_id
GROUP BY s.sala_id, s.nombre, s.capacidad;

INSERT INTO schema_migrations (version) VALUES ('005_vista_llenado_sala');
