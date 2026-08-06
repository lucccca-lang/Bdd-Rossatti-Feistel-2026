CREATE DATABASE mundial2026;
use mundial2026;

CREATE TABLE seleccion (
    id_seleccion INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    grupo VARCHAR(5),
    entrenador VARCHAR(150)
);

CREATE TABLE estadio (
    id_estadio INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(150) NOT NULL,
    ciudad VARCHAR(100),
    capacidad INT
);

CREATE TABLE jugador (
    id_jugador INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(150) NOT NULL,
    posicion VARCHAR(50),
    dorsal INT,
    activo TINYINT(1) DEFAULT 1,
    seleccion_id_seleccion INT,
    FOREIGN KEY (seleccion_id_seleccion) REFERENCES seleccion(id_seleccion)
);

CREATE TABLE partido (
    id_partido INT PRIMARY KEY AUTO_INCREMENT,
    fecha TIMESTAMP,
    fase VARCHAR(50),
    seleccion_local INT,
    seleccion_visitante INT,
    estadio_id_estadio INT,
    FOREIGN KEY (seleccion_local) REFERENCES seleccion(id_seleccion),
    FOREIGN KEY (seleccion_visitante) REFERENCES seleccion(id_seleccion),
    FOREIGN KEY (estadio_id_estadio) REFERENCES estadio(id_estadio)
);

CREATE TABLE gol (
    id_gol INT PRIMARY KEY AUTO_INCREMENT,
    minuto INT,
    es_penal TINYINT(1) DEFAULT 0,
    jugador_id_jugador INT,
    partido_id_partido INT,
    FOREIGN KEY (jugador_id_jugador) REFERENCES jugador(id_jugador),
    FOREIGN KEY (partido_id_partido) REFERENCES partido(id_partido)
);

CREATE TABLE alineacion (
    jugador_id_jugador INT,
    partido_id_partido INT,
    PRIMARY KEY (jugador_id_jugador, partido_id_partido),
    FOREIGN KEY (jugador_id_jugador) REFERENCES jugador(id_jugador),
    FOREIGN KEY (partido_id_partido) REFERENCES partido(id_partido)
);

CREATE TABLE reporte_goleadores (
    id_reporte INT PRIMARY KEY AUTO_INCREMENT,
    fecha_generacion TIMESTAMP,
    nombre_jugador VARCHAR(150),
    seleccion VARCHAR(100),
    cantidad_goles INT
);

CREATE TABLE historial_entrenadores (
	id INT PRIMARY KEY AUTO_INCREMENT,
    seleccion VARCHAR(100),
    entrenador_anterior VARCHAR(150),
    entrenador_nuevo VARCHAR(150),
    fecha_cambio TIMESTAMP
);