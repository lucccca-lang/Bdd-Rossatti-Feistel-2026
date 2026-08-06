use mundial2026;


INSERT INTO seleccion VALUES (1,'Argentina','C','Lionel Scaloni');
INSERT INTO seleccion VALUES (2,'Francia','D','Didier Deschamps');
INSERT INTO seleccion VALUES (3,'Brasil','E','Carletto Ancelotti');
INSERT INTO seleccion VALUES (4,'España','B','Luis de la Fuente');
INSERT INTO seleccion VALUES (5,'Alemania','A','Julian Nagelsmann');

INSERT INTO estadio VALUES (1,'MetLife Stadium','Nueva York',82500);
INSERT INTO estadio VALUES (2,'Rose Bowl','Los Angeles',90888);
INSERT INTO estadio VALUES (3,'AT&T Stadium','Dallas',80000);
INSERT INTO estadio VALUES (4,'Estadio Azteca','Ciudad de Mexico',87523);
INSERT INTO estadio VALUES (5,'Gillette Stadium','Boston',65878);

INSERT INTO jugador VALUES (1,'Lionel Messi','Delantero',10,1,1);
INSERT INTO jugador VALUES (2,'Kylian Mbappe','Delantero',9,1,2);
INSERT INTO jugador VALUES (3,'Vinicius Jr','Delantero',7,1,3);
INSERT INTO jugador VALUES (4,'Pedri','Mediocampista',8,1,4);
INSERT INTO jugador VALUES (5,'Felix Nmecha','Mediocampista',10,1,5);

INSERT INTO partido VALUES (1,'2026-06-11 20:00:00','Grupos',1,2,1);
INSERT INTO partido VALUES (2,'2026-06-12 17:00:00','Grupos',3,4,2);
INSERT INTO partido VALUES (3,'2026-06-15 20:00:00','Grupos',5,1,3);
INSERT INTO partido VALUES (4,'2026-06-20 17:00:00','Cuartos',2,3,4);
INSERT INTO partido VALUES (5,'2026-06-25 20:00:00','Semifinal',4,5,5);

INSERT INTO gol VALUES (1,23,0,1,1);
INSERT INTO gol VALUES (2,45,0,2,1);
INSERT INTO gol VALUES (3,67,1,3,2);
INSERT INTO gol VALUES (4,12,0,4,3);
INSERT INTO gol VALUES (5,88,0,5,4);
INSERT INTO gol VALUES (6,75,0,4,1);

INSERT INTO alineacion VALUES(1,1);
INSERT INTO alineacion VALUES(2,1);
INSERT INTO alineacion VALUES(3,2);
INSERT INTO alineacion VALUES(4,2);
INSERT INTO alineacion VALUES(5,3);
/*Tiggers*/
/*1*/

DELIMITER //
CREATE TRIGGER verificar_jugador_en_partido /*para ver si el jugador jugo*/
BEFORE INSERT ON gol						/*con tabla nueva*/
FOR EACH ROW
BEGIN
    DECLARE v_jugador_en_partido INT DEFAULT 0;

    SELECT COUNT(*) INTO v_jugador_en_partido
    FROM alineacion
    WHERE jugador_id_jugador = NEW.jugador_id_jugador
      AND partido_id_partido = NEW.partido_id_partido;

    IF v_jugador_en_partido = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: el jugador no participó en este partido';
    END IF;
END//
DELIMITER ;

/*2*/

DELIMITER //
CREATE TRIGGER registrar_cambio_entrenador /*registrar en hist cuando cambia el entr en una sele*/
AFTER UPDATE ON seleccion					/*tiene tabla nueva*/
FOR EACH ROW
BEGIN
    IF OLD.entrenador != NEW.entrenador THEN
        INSERT INTO historial_entrenadores
            (seleccion, entrenador_anterior, entrenador_nuevo, fecha_cambio)
        VALUES
            (NEW.nombre, OLD.entrenador, NEW.entrenador, NOW());
    END IF;
END//
DELIMITER ; 

/*3*/

DELIMITER //
CREATE TRIGGER eliminar_goles_partido   /*al eliminar partido que se eliminen sus goles puestos*/
BEFORE DELETE ON partido
FOR EACH ROW
BEGIN
    DELETE FROM gol WHERE partido_id_partido = OLD.id_partido;
END//
DELIMITER ;



/*Eventos*/
/*1*/

DELIMITER //
CREATE EVENT generar_reporte_goleadores	/*para hacer un rank de goleadores por smemana*/
ON SCHEDULE EVERY 1 WEEK				/*con tabla nueva*/
STARTS NOW()
DO
BEGIN
    DELETE FROM reporte_goleadores;
    INSERT INTO reporte_goleadores (fecha_generacion, nombre_jugador, seleccion, cantidad_goles)
    SELECT
        NOW(),
        j.nombre,
        s.nombre,
        COUNT(g.id_gol)
    FROM gol g
    JOIN jugador j ON g.jugador_id_jugador = j.id_jugador
    JOIN seleccion s ON j.seleccion_id_seleccion = s.id_seleccion
    GROUP BY j.id_jugador, j.nombre, s.nombre
    ORDER BY COUNT(g.id_gol) DESC;
END//
DELIMITER ;

/*2*/

DELIMITER //
CREATE EVENT purgar_goles_fase_grupos    /*elimina los goles de la f de grupos cada 6 meses*/
ON SCHEDULE EVERY 6 MONTH
STARTS NOW() + INTERVAL 6 MONTH
DO
BEGIN
	DELETE FROM gol
    WHERE partido_id_partido IN (
		SELECT id_partido FROM partido WHERE fase = 'Grupos'
        );
END//
DELIMITER ;


/*Indices*/

/*para los goles en un partido*/
CREATE INDEX idx_gol_partido ON gol(partido_id_partido);

/*para ver los jugadores en una seleccion*/
CREATE INDEX idx_jugador_seleccion ON jugador(seleccion_id_seleccion);

/*para ver los partidos por fase*/
CREATE INDEX idx_partido_fase ON partido(fase);

/*para ver los partidos por estadio*/
CREATE INDEX idx_partido_estadio ON partido(estadio_id_estadio);



/*Roles*/

CREATE ROLE 'rol_usuario', 'rol_desarrollador', 'rol_administrador';

GRANT SELECT ON mundial2026.* TO 'rol_usuario';

/*solo otorga permisos de select, insert, update y delete*/
GRANT SELECT, INSERT, UPDATE, DELETE ON mundial2026.* TO 'rol_desarrollador' WITH GRANT OPTION;

/*le da todos los permisos*/
GRANT ALL PRIVILEGES ON mundial2026.* TO 'rol_administrador';

CREATE USER 'facuf'@'%' IDENTIFIED BY 'facuf1234';
CREATE USER 'luccar'@'%' IDENTIFIED BY 'luccr1232';
CREATE USER 'pattiadmin'@'localhost' IDENTIFIED BY 'admin576';

GRANT 'rol_usuario' TO 'facuf'@'%';
GRANT 'rol_desarrollador' TO 'luccar'@'%';
GRANT 'rol_administrador' TO 'pattiadmin'@'localhost';


/* En este modelo, la transaccion mas importante seria registrar un gol.
   Esta operacion verifica que el jugador exista y este activo, que el partido este en curso, e insertar el gol.
   si dos usuarios quieren registrar goles del mismo partido simultaneamente, podria ocurrir un error un problema de actualizacion,
   perdidas o lecturas no repetibles si uno lee el estado mientras el otro lo modifica.
   Para evitar esto, usamos una transaccion de exclusive lock(X-lock) sobre la fila del partido mediante select for update, 
   asegurando que mientras una transaccion este registrando un gol en ese partido, ninguna otra pueda leerla ni modificarla hasta que se haga el commit. 
   Esto asegura que los datos queden consistentes y no se pierda ningun gol registrado.