-- *****************************************************************
-- 000_modelo_inicial.sql
-- Crea las tablas principales del cine y la tabla de migraciones.
-- *****************************************************************

CREATE SCHEMA IF NOT EXISTS cine;
SET search_path TO cine;

CREATE TABLE IF NOT EXISTS schema_migrations (
    version TEXT PRIMARY KEY,
    applied_at TIMESTAMP DEFAULT now()
);

CREATE TABLE IF NOT EXISTS peliculas (
    pelicula_id SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    duracion_minutos INT NOT NULL
);

CREATE TABLE IF NOT EXISTS salas (
    sala_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    capacidad INT NOT NULL
);

CREATE TABLE IF NOT EXISTS asientos (
    asiento_id SERIAL PRIMARY KEY,
    sala_id INT REFERENCES salas(sala_id),
    codigo VARCHAR(10) NOT NULL 
);

CREATE TABLE IF NOT EXISTS funciones (
    funcion_id SERIAL PRIMARY KEY,
    pelicula_id INT REFERENCES peliculas(pelicula_id),
    sala_id INT REFERENCES salas(sala_id),
    fecha_hora_inicio TIMESTAMP NOT NULL,
    precio INT NOT NULL
);

CREATE TABLE IF NOT EXISTS clientes (
    cliente_id SERIAL PRIMARY KEY,
    rut VARCHAR(12) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL,
    nombre VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS entradas (
    entrada_id SERIAL PRIMARY KEY,
    funcion_id INT REFERENCES funciones(funcion_id),
    cliente_id INT REFERENCES clientes(cliente_id),
    asiento_id INT REFERENCES asientos(asiento_id)
);

INSERT INTO schema_migrations (version) VALUES ('000_modelo_inicial');
