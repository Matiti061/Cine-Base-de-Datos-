-- *****************************************************************
-- 003_validar_horarios.sql
-- Evita que dos peliculas se programen en la misma sala al mismo tiempo.
-- *****************************************************************

SET search_path TO cine;

CREATE OR REPLACE FUNCTION trg_validar_horario() RETURNS TRIGGER AS '
DECLARE
    minutos_pelicula INT;
    cantidad_choques INT;
BEGIN
    SELECT duracion_minutos INTO minutos_pelicula 
    FROM peliculas WHERE pelicula_id = NEW.pelicula_id;

    SELECT COUNT(*) INTO cantidad_choques
    FROM funciones f
    JOIN peliculas p ON f.pelicula_id = p.pelicula_id
    WHERE f.sala_id = NEW.sala_id
      AND f.funcion_id != COALESCE(NEW.funcion_id, 0)
      AND NEW.fecha_hora_inicio < (f.fecha_hora_inicio + (p.duracion_minutos * interval ''1 minute''))
      AND (NEW.fecha_hora_inicio + (minutos_pelicula * interval ''1 minute'')) > f.fecha_hora_inicio;

    IF cantidad_choques > 0 THEN
        RAISE EXCEPTION ''Choca con otra pelicula en la sala'';
    END IF;

    RETURN NEW;
END;
' LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_valida_horario ON funciones;
CREATE TRIGGER trg_valida_horario BEFORE INSERT OR UPDATE ON funciones
FOR EACH ROW EXECUTE FUNCTION trg_validar_horario();

INSERT INTO schema_migrations (version) VALUES ('003_validar_horarios');
