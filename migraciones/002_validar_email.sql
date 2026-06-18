-- *****************************************************************
-- 002_validar_email.sql
-- Valida que el email tenga un formato basico con @ y un punto.
-- *****************************************************************

SET search_path TO cine;

CREATE OR REPLACE FUNCTION trg_validar_email() RETURNS TRIGGER AS '
BEGIN
    IF NEW.email NOT LIKE ''%@%.%'' THEN
        RAISE EXCEPTION ''El correo le falta el arroba o el punto'';
    END IF;
    RETURN NEW;
END;
' LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_valida_email ON clientes;
CREATE TRIGGER trg_valida_email BEFORE INSERT OR UPDATE ON clientes
FOR EACH ROW EXECUTE FUNCTION trg_validar_email();

INSERT INTO schema_migrations (version) VALUES ('002_validar_email');
