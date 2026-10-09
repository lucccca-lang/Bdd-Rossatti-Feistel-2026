use ecommerce;

/* STORED FUNCTIONS */

/*1*/
/* el tiemp prom q un usuario tarda en vender sus prod */

DELIMITER //
CREATE FUNCTION tiempoPromedioVenta (idUsuarioParam INT) RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(10,2);
    SELECT AVG(DATEDIFF(v.fechaVenta, p.fechaPublicacion)) INTO promedio
    FROM venta v
    JOIN publicacion p ON v.idPublicacion = p.idPublicacion
    WHERE p.idUsuarioVendedor = idUsuarioParam;
    RETURN promedio;
END//
DELIMITER ;

SELECT tiempoPromedioVenta(4);

/*2*/
/* Comisión segun nivel y monto de la venta */

DELIMITER //
CREATE FUNCTION calcularComision (montoVenta DECIMAL(10,2), nivelVendedor VARCHAR(20)) RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
    DECLARE comision DECIMAL(10,2);
    CASE nivelVendedor
        WHEN 'Normal' THEN SET comision = montoVenta * 0.08;
        WHEN 'Platinum' THEN SET comision = montoVenta * 0.05;
        WHEN 'Gold' THEN SET comision = montoVenta * 0.03;
        ELSE SET comision = -1;
    END CASE;
    RETURN comision;
END//
DELIMITER ;

SELECT calcularComision(50000, 'Gold');
SELECT calcularComision(50000, 'Bronce');

/*3*/
/*Porcentaje de ventas concretadas por vendedor y si no tiene publicaciones 0*/

DELIMITER //
CREATE FUNCTION porcentajeVentasConcretadas (idUsuarioParam INT) RETURNS DECIMAL(5,2) DETERMINISTIC
BEGIN
    DECLARE totalPublicaciones INT;
    DECLARE totalVentas INT;
    SELECT COUNT(*) INTO totalPublicaciones FROM publicacion WHERE idUsuarioVendedor = idUsuarioParam;
    IF totalPublicaciones = 0 THEN
        RETURN 0;
    END IF;
    SELECT COUNT(*) INTO totalVentas
    FROM publicacion WHERE idUsuarioVendedor = idUsuarioParam AND estado = 'Finalizada';
    RETURN (totalVentas / totalPublicaciones) * 100;
END//
DELIMITER ;

SELECT porcentajeVentasConcretadas(4);

/*4*/
/*Mayor oferta para una subasta, si no es sub -1, si no hay pujas 0 */

DELIMITER //
CREATE FUNCTION mayorOfertaSubasta (idPub INT) RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
    DECLARE tipoPub VARCHAR(20);
    DECLARE maxOferta DECIMAL(10,2);
    SELECT tipoPublicacion INTO tipoPub FROM publicacion WHERE idPublicacion = idPub;
    IF tipoPub <> 'Subasta' THEN
        RETURN -1;
    END IF;
    SELECT MAX(monto) INTO maxOferta FROM oferta WHERE idPublicacion = idPub;
    IF maxOferta IS NULL THEN
        RETURN 0;
    END IF;
    RETURN maxOferta;
END//
DELIMITER ;

SELECT mayorOfertaSubasta(4);
SELECT mayorOfertaSubasta(1);

/*5*/
/*Precio promedio de los prod de cada categoria */

DELIMITER //
CREATE FUNCTION precioPromedioCategoria (idCategoriaParam INT) RETURNS DECIMAL(10,2) DETERMINISTIC
BEGIN
    DECLARE promedio DECIMAL(10,2);
    SELECT AVG(precio) INTO promedio FROM publicacion WHERE idCategoria = idCategoriaParam;
    RETURN promedio;
END//
DELIMITER ;

SELECT precioPromedioCategoria(1);

/*6*/
/*Ultima fecha que compro un usuario */

DELIMITER //
CREATE FUNCTION ultimaFechaCompra (idUsuarioParam INT) RETURNS DATETIME DETERMINISTIC
BEGIN
    DECLARE ultimaFecha DATETIME;
    SELECT MAX(fechaVenta) INTO ultimaFecha FROM venta WHERE idUsuarioComprador = idUsuarioParam;
    RETURN ultimaFecha;
END//
DELIMITER ;

SELECT ultimaFechaCompra(2);

/* STORED PROCEDURES */

/*1*/
/*Que permite listar publicaciones que tengan el nombre del prod y mostrar detalles */

DELIMITER //
CREATE PROCEDURE listarPublicacionesPorProducto (IN textoBusqueda VARCHAR(100))
BEGIN
    SELECT pu.idPublicacion, pr.nombre AS titulo, pu.precio
    FROM publicacion pu
    JOIN producto pr ON pu.idProducto = pr.idProducto
    WHERE pr.nombre LIKE CONCAT('%', textoBusqueda, '%')
    OR pr.descripcion LIKE CONCAT('%', textoBusqueda, '%');
END//
DELIMITER ;

CALL listarPublicacionesPorProducto('zapatillas');

/*2*/
/*Que permita pujar un prod entonces la publi tiene q ser una subast 
y mas grande que lo ofertado y q no este finalizada*/

DELIMITER //
CREATE PROCEDURE pujarProducto (
    IN idPub INT, IN idUsuarioParam INT, IN montoOfertado DECIMAL(10,2),
    OUT operacionOk BOOLEAN
)
BEGIN
    DECLARE tipoPub VARCHAR(20);
    DECLARE estadoPub VARCHAR(20);
    DECLARE maxOferta DECIMAL(10,2);
    SET operacionOk = FALSE;

    SELECT tipoPublicacion, estado INTO tipoPub, estadoPub
    FROM publicacion WHERE idPublicacion = idPub;

    SELECT MAX(monto) INTO maxOferta FROM oferta WHERE idPublicacion = idPub;

    IF tipoPub = 'Subasta' AND estadoPub <> 'Finalizada'
        AND (maxOferta IS NULL OR montoOfertado > maxOferta) THEN
        INSERT INTO oferta (idPublicacion, idUsuario, monto, fechaOferta)
        VALUES (idPub, idUsuarioParam, montoOfertado, NOW());
        SET operacionOk = TRUE;
    END IF;
END//
DELIMITER ;

CALL pujarProducto(4, 8, 145000, @ok);
SELECT @ok;

/*3*/
/*Que solo el vendedor pueda pausar una publi, solo si es una venta que no haya finalizado */

DELIMITER //
CREATE PROCEDURE pausarPublicacion (
    IN idPub INT, IN idUsuarioSolicitante INT, OUT operacionOk BOOLEAN
)
BEGIN
    DECLARE tipoPub VARCHAR(20);
    DECLARE estadoPub VARCHAR(20);
    DECLARE idVendedor INT;
    SET operacionOk = FALSE;

    SELECT tipoPublicacion, estado, idUsuarioVendedor INTO tipoPub, estadoPub, idVendedor
    FROM publicacion WHERE idPublicacion = idPub;

    IF tipoPub = 'Venta directa' AND estadoPub <> 'Finalizada' AND idUsuarioSolicitante = idVendedor THEN
        UPDATE publicacion SET estado = 'Pausada' WHERE idPublicacion = idPub;
        SET operacionOk = TRUE;
    END IF;
END//
DELIMITER ;

CALL pausarPublicacion(1, 1, @ok);
SELECT @ok;
SELECT estado FROM publicacion WHERE idPublicacion = 1;

/*4*/
/*Que actualice el nivel de usuario y diga el nuevo nivel */

DELIMITER //
CREATE PROCEDURE actualizarNivelUsuario (IN idUsuarioParam INT, OUT nuevoNivel VARCHAR(20))
BEGIN
    DECLARE ventasUsuario INT;
    DECLARE facturacionUsuario DECIMAL(10,2);

    SELECT cantidadVentas, facturacion INTO ventasUsuario, facturacionUsuario
    FROM usuario WHERE idUsuario = idUsuarioParam;
    
    IF ventasUsuario >= 11 OR facturacionUsuario >= 1000000 THEN
        SET nuevoNivel = 'Gold';
    ELSEIF ventasUsuario >= 6 OR facturacionUsuario >= 100000 THEN
        SET nuevoNivel = 'Platinum';
    ELSE
        SET nuevoNivel = 'Normal';
    END IF;

    UPDATE usuario SET tipoUsuario = nuevoNivel WHERE idUsuario = idUsuarioParam;
END//
DELIMITER ;

CALL actualizarNivelUsuario(3, @nivel);
SELECT @nivel;

/*5*/
/*Para calificar usuarios que se fije que la calif este en el rango 
permitido para que exista la compra y que se pueda calificar al vendedor y comprador */

DELIMITER //
CREATE PROCEDURE calificarUsuario (
    IN idVentaParam INT, IN idUsuarioCalificado INT, IN calificacionParam INT,
    OUT operacionOk BOOLEAN
)
BEGIN
    DECLARE idComprador INT;
    DECLARE idVendedor INT;
    SET operacionOk = FALSE;

    SELECT v.idUsuarioComprador, p.idUsuarioVendedor INTO idComprador, idVendedor
    FROM venta v
    JOIN publicacion p ON v.idPublicacion = p.idPublicacion
    WHERE v.idVenta = idVentaParam;

    IF calificacionParam BETWEEN 0 AND 100 AND idComprador IS NOT NULL THEN
        IF idUsuarioCalificado = idComprador THEN
            UPDATE venta SET calificacionComprador = calificacionParam WHERE idVenta = idVentaParam;
            SET operacionOk = TRUE;
        ELSEIF idUsuarioCalificado = idVendedor THEN
            UPDATE venta SET calificacionVendedor = calificacionParam WHERE idVenta = idVentaParam;
            SET operacionOk = TRUE;
        END IF;
    END IF;
END//
DELIMITER ;

CALL calificarUsuario(1, 3, 88, @ok);
SELECT @ok;
CALL calificarUsuario(1, 6, 92, @ok);
SELECT @ok;

/*6*/
/*que muestre el usuario ganadr d una subasta, mostrand usu, mail, nomb prod, cant ofert, valr min, valr ganadr*/
DELIMITER //
CREATE PROCEDURE ganadorSubasta (IN idPub INT)
BEGIN
    SELECT u.nombre, u.email, pr.nombre AS producto,
        (SELECT COUNT(DISTINCT idUsuario) FROM oferta WHERE idPublicacion = idPub) AS cantidadOferentes,
        pu.precio AS valorInicial,
        MAX(o.monto) AS valorGanador
    FROM oferta o
    JOIN usuario u ON o.idUsuario = u.idUsuario
    JOIN publicacion pu ON o.idPublicacion = pu.idPublicacion
    JOIN producto pr ON pu.idProducto = pr.idProducto
    WHERE o.idPublicacion = idPub
    GROUP BY u.idUsuario, u.nombre, u.email, pr.nombre, pu.precio
    ORDER BY valorGanador DESC
    LIMIT 1;
END//
DELIMITER ;

CALL ganadorSubasta(4);

/*7*/
/*crear pregunta, viendo q publi existe y activa, q no sea nulo y q usuario no dueño*/
DELIMITER //
CREATE PROCEDURE crearPregunta (
    IN idPub INT, IN idUsuarioParam INT, IN textoParam VARCHAR(255),
    OUT operacionOk BOOLEAN
)
BEGIN
    DECLARE estadoPub VARCHAR(20);
    DECLARE idVendedor INT;
    SET operacionOk = FALSE;

    SELECT estado, idUsuarioVendedor INTO estadoPub, idVendedor
    FROM publicacion WHERE idPublicacion = idPub;

    IF estadoPub = 'Activa' AND textoParam IS NOT NULL AND idUsuarioParam <> idVendedor THEN
        INSERT INTO pregunta (idPublicacion, idUsuario, textoPregunta, fechaPregunta)
        VALUES (idPub, idUsuarioParam, textoParam, NOW());
        SET operacionOk = TRUE;
    END IF;
END//
DELIMITER ;

CALL crearPregunta(9, 2, '¿Incluye caja original?', @ok);
SELECT @ok;

/*8*/
/*stats vendedor mostrar pub activs y terminads, ventas totals, facturacion, precio prom prods, cant preg,
 tiemp prom desde publicado hasta vendido*/
DELIMITER //
CREATE PROCEDURE estadisticasVendedor (IN idVendedorParam INT)
BEGIN
    SELECT
        (SELECT COUNT(*) FROM publicacion WHERE idUsuarioVendedor = idVendedorParam AND estado = 'Activa') AS publicacionesActivas,
        (SELECT COUNT(*) FROM publicacion WHERE idUsuarioVendedor = idVendedorParam AND estado = 'Finalizada') AS publicacionesFinalizadas,
        (SELECT cantidadVentas FROM usuario WHERE idUsuario = idVendedorParam) AS ventasTotales,
        (SELECT facturacion FROM usuario WHERE idUsuario = idVendedorParam) AS facturacionTotal,
        (SELECT AVG(precio) FROM publicacion WHERE idUsuarioVendedor = idVendedorParam) AS precioPromedio,
        (SELECT COUNT(*) FROM pregunta pr JOIN publicacion pu ON pr.idPublicacion = pu.idPublicacion
            WHERE pu.idUsuarioVendedor = idVendedorParam) AS preguntasRecibidas,
        (SELECT AVG(DATEDIFF(v.fechaVenta, pu.fechaPublicacion))
            FROM venta v JOIN publicacion pu ON v.idPublicacion = pu.idPublicacion
            WHERE pu.idUsuarioVendedor = idVendedorParam) AS diasPromedioHastaVenta;
END//
DELIMITER ;

CALL estadisticasVendedor(4);

/*9*/
/*top 10 vendedors d mes, recibe rango d fechas*/
DELIMITER //
CREATE PROCEDURE topVendedores (IN fechaInicio DATE, IN fechaFin DATE)
BEGIN
    SELECT u.idUsuario, u.nombre, COUNT(*) AS cantidadVentas
    FROM venta v
    JOIN publicacion p ON v.idPublicacion = p.idPublicacion
    JOIN usuario u ON p.idUsuarioVendedor = u.idUsuario
    WHERE v.fechaVenta BETWEEN fechaInicio AND fechaFin
    GROUP BY u.idUsuario, u.nombre
    ORDER BY cantidadVentas DESC
    LIMIT 10;
END//
DELIMITER ;

CALL topVendedores('2026-07-01', '2026-08-01');

/*VISTAS*/

/*1*/
/*muestre preg sin respuesta y lo demas*/
CREATE OR REPLACE VIEW vistaPreguntasSinResponder AS
SELECT preg.idPregunta, preg.textoPregunta AS descripcion, preg.idPublicacion,
    pr.nombre AS nombreProducto, u.nombre AS nombreVendedor
FROM pregunta preg
JOIN publicacion pu ON preg.idPublicacion = pu.idPublicacion
JOIN producto pr ON pu.idProducto = pr.idProducto
JOIN usuario u ON pu.idUsuarioVendedor = u.idUsuario
LEFT JOIN respuesta r ON r.idPregunta = preg.idPregunta
WHERE pu.estado = 'Activa' AND r.idRespuesta IS NULL;

SELECT * FROM vistaPreguntasSinResponder;

/*2*/
/*top 10 cat mas presentes en publis d esta semana*/
CREATE VIEW vistaTopCategoriasSemana AS
SELECT c.nombre AS categoria, COUNT(*) AS cantidadPublicaciones
FROM publicacion p
JOIN categoria c ON p.idCategoria = c.idCategoria
WHERE p.fechaPublicacion >= (CURRENT_DATE() - INTERVAL 7 DAY)
GROUP BY c.nombre
ORDER BY cantidadPublicaciones DESC
LIMIT 10;

SELECT * FROM vistaTopCategoriasSemana;

/*3*/
/*muestre publis en tendencia osea q tengan mas pregs*/
CREATE VIEW vistaTendenciasHoy AS
SELECT p.idPublicacion, pr.nombre AS producto, COUNT(preg.idPregunta) AS cantidadPreguntas
FROM publicacion p
JOIN producto pr ON p.idProducto = pr.idProducto
JOIN pregunta preg ON preg.idPublicacion = p.idPublicacion
WHERE DATE(preg.fechaPregunta) = CURRENT_DATE()
GROUP BY p.idPublicacion, pr.nombre
ORDER BY cantidadPreguntas DESC;

SELECT * FROM vistaTendenciasHoy;

/*4*/
/*muestre nomb vendedor y categoria con mejor reputacion*/
CREATE VIEW vistaMejorReputacionPorCategoria AS
SELECT c.nombre AS categoria, u.nombre AS vendedor
FROM usuario u
JOIN publicacion p ON u.idUsuario = p.idUsuarioVendedor
JOIN categoria c ON p.idCategoria = c.idCategoria
WHERE u.reputacion = (
    SELECT MAX(u2.reputacion)
    FROM usuario u2
    JOIN publicacion p2 ON u2.idUsuario = p2.idUsuarioVendedor
    WHERE p2.idCategoria = c.idCategoria
)
GROUP BY c.nombre, u.nombre;

SELECT * FROM vistaMejorReputacionPorCategoria;

/*TRIGGERS*/

/*1*/
/*antes d eliminar una preg, q elimine las respuestas*/
DELIMITER //
CREATE TRIGGER antes_eliminar_pregunta
BEFORE DELETE ON pregunta
FOR EACH ROW
BEGIN
    DELETE FROM respuesta WHERE idPregunta = OLD.idPregunta;
END//
DELIMITER ;


DELETE FROM pregunta WHERE idPregunta = 3;
SELECT * FROM respuesta WHERE idPregunta = 3;

/*2*/
/*q dsp de realizar una venta actualice el nivel d usuario*/
DELIMITER //
CREATE TRIGGER despues_actualizar_nivel
AFTER INSERT ON venta
FOR EACH ROW
BEGIN
    DECLARE idVendedor INT;
    DECLARE montoVenta DECIMAL(10,2);
    DECLARE ventasVendedor INT;
    DECLARE facturacionVendedor DECIMAL(10,2);

    SELECT idUsuarioVendedor, precio INTO idVendedor, montoVenta
    FROM publicacion WHERE idPublicacion = NEW.idPublicacion;

    UPDATE usuario
    SET cantidadVentas = cantidadVentas + 1,
        facturacion = facturacion + montoVenta
    WHERE idUsuario = idVendedor;

    SELECT cantidadVentas, facturacion INTO ventasVendedor, facturacionVendedor
    FROM usuario WHERE idUsuario = idVendedor;

    IF ventasVendedor >= 11 OR facturacionVendedor >= 1000000 THEN
        UPDATE usuario SET tipoUsuario = 'Gold' WHERE idUsuario = idVendedor;
    ELSEIF ventasVendedor >= 6 OR facturacionVendedor >= 100000 THEN
        UPDATE usuario SET tipoUsuario = 'Platinum' WHERE idUsuario = idVendedor;
    ELSE
        UPDATE usuario SET tipoUsuario = 'Normal' WHERE idUsuario = idVendedor;
    END IF;
END//
DELIMITER ;

INSERT INTO venta (idPublicacion, idUsuarioComprador, fechaVenta) VALUES (7, 8, NOW());
UPDATE publicacion SET estado = 'Finalizada' WHERE idPublicacion = 7;
SELECT idUsuario, cantidadVentas, facturacion, tipoUsuario FROM usuario WHERE idUsuario = 3;

/*3*/
/*q actualice la reputacion d usuario dsp d ser calificado*/
DELIMITER //
CREATE TRIGGER actualizar_reputacion
AFTER UPDATE ON venta
FOR EACH ROW
BEGIN
    DECLARE idVendedor INT;
    DECLARE promedioVendedor DECIMAL(5,2);
    DECLARE promedioComprador DECIMAL(5,2);

    SELECT idUsuarioVendedor INTO idVendedor
    FROM publicacion WHERE idPublicacion = NEW.idPublicacion;

    IF NEW.calificacionVendedor IS NOT NULL AND (OLD.calificacionVendedor IS NULL OR NEW.calificacionVendedor <> OLD.calificacionVendedor) THEN
        SELECT AVG(v.calificacionVendedor) INTO promedioVendedor
        FROM venta v
        JOIN publicacion p ON v.idPublicacion = p.idPublicacion
        WHERE p.idUsuarioVendedor = idVendedor AND v.calificacionVendedor IS NOT NULL;

        UPDATE usuario SET reputacion = promedioVendedor WHERE idUsuario = idVendedor;
    END IF;

    IF NEW.calificacionComprador IS NOT NULL AND (OLD.calificacionComprador IS NULL OR NEW.calificacionComprador <> OLD.calificacionComprador) THEN
        SELECT AVG(calificacionComprador) INTO promedioComprador
        FROM venta
        WHERE idUsuarioComprador = NEW.idUsuarioComprador AND calificacionComprador IS NOT NULL;

        UPDATE usuario SET reputacion = promedioComprador WHERE idUsuario = NEW.idUsuarioComprador;
    END IF;
END//
DELIMITER ;

UPDATE venta SET calificacionVendedor = 80 WHERE idVenta = 3;
SELECT idUsuario, reputacion FROM usuario WHERE idUsuario = 3;

/*4*/
/*q si se realiza una puja, la publi no este vencida, usuario no sea vendedor y monto pujado sea el mayor*/
DELIMITER //
CREATE TRIGGER verificar_puja
BEFORE INSERT ON oferta
FOR EACH ROW
BEGIN
    DECLARE estadoPub VARCHAR(20);
    DECLARE vendedorPub INT;
    DECLARE maxOferta DECIMAL(10,2);

    SELECT estado, idUsuarioVendedor INTO estadoPub, vendedorPub
    FROM publicacion WHERE idPublicacion = NEW.idPublicacion;

    IF estadoPub = 'Finalizada' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La publicación ya está finalizada';
    END IF;

    IF NEW.idUsuario = vendedorPub THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El vendedor no puede pujar en su propia publicación';
    END IF;

    SELECT MAX(monto) INTO maxOferta FROM oferta WHERE idPublicacion = NEW.idPublicacion;

    IF maxOferta IS NOT NULL AND NEW.monto <= maxOferta THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El monto debe ser mayor a la oferta actual';
    END IF;
END//
DELIMITER ;

INSERT INTO oferta (idPublicacion, idUsuario, monto, fechaOferta) VALUES (4, 7, 140000, NOW());

/*EVENTOS*/

/*1*/
/*1 x semana, q elimine las publis pausadas y creadas hace mas de 90 dias*/
DELIMITER //
CREATE EVENT eliminarPublicacionesPausadas
ON SCHEDULE EVERY 1 WEEK STARTS NOW()
DO
BEGIN
    DELETE FROM publicacion
    WHERE estado = 'Pausada' AND fechaPublicacion < (CURRENT_DATE() - INTERVAL 90 DAY);
END//
DELIMITER ;

DELETE FROM publicacion
WHERE estado = 'Pausada' AND fechaPublicacion < (CURRENT_DATE() - INTERVAL 90 DAY);
SELECT * FROM publicacion WHERE idPublicacion IN (5, 10);

/*2*/
/*diario, marque como observadaslas publis activas d tipo venta directa q no tengan medio d pago*/
DELIMITER //
CREATE EVENT marcarPublicacionesObservadas
ON SCHEDULE EVERY 1 DAY STARTS NOW()
DO
BEGIN
    UPDATE publicacion p
    SET p.observada = TRUE
    WHERE p.estado = 'Activa'
    AND p.tipoPublicacion = 'Venta directa'
    AND NOT EXISTS (
        SELECT 1 FROM publicacionMedioPago pmp WHERE pmp.idPublicacion = p.idPublicacion
    );
END//
DELIMITER ;

UPDATE publicacion p
SET p.observada = TRUE
WHERE p.estado = 'Activa' AND p.tipoPublicacion = 'Venta directa'
AND NOT EXISTS (SELECT 1 FROM publicacionMedioPago pmp WHERE pmp.idPublicacion = p.idPublicacion);
SELECT idPublicacion, observada FROM publicacion WHERE idPublicacion = 2;

/*3*/
/*todos los dias a las 10, mande noti a los usuarios con las pregs sin responder*/
DELIMITER //
CREATE EVENT notificarPreguntasSinResponder
ON SCHEDULE EVERY 1 DAY STARTS CONCAT(CURRENT_DATE(), ' 10:00:00')
DO
BEGIN
    DECLARE finCursor BOOLEAN DEFAULT FALSE;
    DECLARE idPub INT;
    DECLARE tituloProd VARCHAR(100);
    DECLARE idVend INT;
    DECLARE cantSinResponder INT;

    DECLARE cursorPreguntas CURSOR FOR
        SELECT pu.idPublicacion, pr.nombre, pu.idUsuarioVendedor, COUNT(*)
        FROM pregunta preg
        JOIN publicacion pu ON preg.idPublicacion = pu.idPublicacion
        JOIN producto pr ON pu.idProducto = pr.idProducto
        LEFT JOIN respuesta r ON r.idPregunta = preg.idPregunta
        WHERE r.idRespuesta IS NULL
        GROUP BY pu.idPublicacion, pr.nombre, pu.idUsuarioVendedor;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finCursor = TRUE;

    OPEN cursorPreguntas;
    bucle: LOOP
        FETCH cursorPreguntas INTO idPub, tituloProd, idVend, cantSinResponder;
        IF finCursor THEN
            LEAVE bucle;
        END IF;
        INSERT INTO notificacion (idUsuario, mensaje, fechaNotificacion)
        VALUES (idVend, CONCAT('La publicación sobre ', tituloProd, ' tiene ', cantSinResponder, ' preguntas sin responder'), NOW());
    END LOOP bucle;
    CLOSE cursorPreguntas;
END//
DELIMITER ;

/*se prueba con el horario*/
SELECT * FROM notificacion;

/*4*/
/*todos los dias a las 00, haga stats*/
DELIMITER //
CREATE EVENT generarEstadisticasDiarias
ON SCHEDULE EVERY 1 DAY STARTS CONCAT(CURRENT_DATE(), ' 00:00:00')
DO
BEGIN
    INSERT INTO estadisticaDiaria (fecha, cantidadVendedores, cantidadCompradores, cantidadProductos)
    VALUES (
        CURRENT_DATE(),
        (SELECT COUNT(DISTINCT idUsuarioVendedor) FROM publicacion),
        (SELECT COUNT(DISTINCT idUsuarioComprador) FROM venta),
        (SELECT COUNT(*) FROM producto)
    );
END//
DELIMITER ;

/*tmb con el horario*/
SELECT * FROM estadisticaDiaria;

/*INDICES*/

/*1*/
/*para acelerar busq x nombre d prod*/
CREATE INDEX idx_nombreProducto ON producto(nombre);

/*2*/
/*asegurar q no se repitan mail en usuarios*/
CREATE UNIQUE INDEX uidx_emailUsuario ON usuario(email);

/*3*/
/*para mejorar las consultas sobre pub activas, pausads o finalizadas*/
CREATE INDEX idx_estadoPublicacion ON publicacion(estado);

/*TRANSACCIONES*/

/*1*/
/*para comprar*/
DELIMITER //
CREATE PROCEDURE comprarPublicacion (
    IN idPub INT, IN idUsuarioComprador INT, OUT operacionOk BOOLEAN
)
BEGIN
    DECLARE estadoPub VARCHAR(20);
    SET operacionOk = FALSE;

    START TRANSACTION;

    SELECT estado INTO estadoPub FROM publicacion WHERE idPublicacion = idPub FOR UPDATE;

    IF estadoPub = 'Activa' THEN
        INSERT INTO venta (idPublicacion, idUsuarioComprador, fechaVenta)
        VALUES (idPub, idUsuarioComprador, NOW());

        UPDATE publicacion SET estado = 'Finalizada' WHERE idPublicacion = idPub;

        SET operacionOk = TRUE;
        COMMIT;
    ELSE
        ROLLBACK;
    END IF;
END//
DELIMITER ;

CALL comprarPublicacion(8, 2, @ok);
SELECT @ok;

/*insertar una venta y despues cambiar a finalizada el estado 
porque van de la mano siempre que se realice una compra*/

/*2*/
/*oferta en subasta*/
DELIMITER //
CREATE PROCEDURE ofertarSubasta (
    IN idPub INT, IN idUsuarioParam INT, IN montoOfertado DECIMAL(10,2),
    OUT operacionOk BOOLEAN
)
BEGIN
    DECLARE maxOferta DECIMAL(10,2);
    SET operacionOk = FALSE;

    START TRANSACTION;

    SELECT MAX(monto) INTO maxOferta FROM oferta WHERE idPublicacion = idPub FOR UPDATE;

    IF maxOferta IS NULL OR montoOfertado > maxOferta THEN
        INSERT INTO oferta (idPublicacion, idUsuario, monto, fechaOferta)
        VALUES (idPub, idUsuarioParam, montoOfertado, NOW());

        SET operacionOk = TRUE;
        COMMIT;
    ELSE
        ROLLBACK;
    END IF;
END//
DELIMITER ;

CALL ofertarSubasta(9, 5, 530000, @ok);
SELECT @ok;

/*para evitar que si 2 realizan una oferta al mismo tiempo no se pongan ambas como maximo, para eso 
se bloquea la fila antes de insertar*/

/*3*/
/*la tercer trans la hice que cree una publicacion con sus medios de pago y envio*/
DELIMITER //
CREATE PROCEDURE crearPublicacionConMedios (
    IN idProductoParam INT, IN idCategoriaParam INT, IN idVendedorParam INT,
    IN precioParam DECIMAL(10,2), IN tipoPublicacionParam VARCHAR(20),
    IN nivelPublicacionParam VARCHAR(20),
    IN idMedioPagoParam INT, IN idMedioEnvioParam INT,
    OUT operacionOk BOOLEAN
)
BEGIN
    DECLARE nuevaPublicacion INT;
    SET operacionOk = FALSE;

    START TRANSACTION;

    INSERT INTO publicacion (idProducto, idCategoria, idUsuarioVendedor, precio, tipoPublicacion, nivelPublicacion, estado, fechaPublicacion)
    VALUES (idProductoParam, idCategoriaParam, idVendedorParam, precioParam, tipoPublicacionParam, nivelPublicacionParam, 'Activa', CURDATE());

    SET nuevaPublicacion = LAST_INSERT_ID();

    INSERT INTO publicacionMedioPago (idPublicacion, idMedioPago) VALUES (nuevaPublicacion, idMedioPagoParam);
    INSERT INTO publicacionMedioEnvio (idPublicacion, idMedioEnvio) VALUES (nuevaPublicacion, idMedioEnvioParam);

    SET operacionOk = TRUE;
    COMMIT;
END//
DELIMITER ;

CALL crearPublicacionConMedios(2, 1, 1, 45000, 'Venta directa', 'Bronce', 1, 1, @ok);
SELECT @ok;

/*ROLES Y ACCESO*/

/*1*/
CREATE ROLE 'auditor';
GRANT SELECT ON ecommerce.vistaPreguntasSinResponder TO 'auditor';
GRANT SELECT ON ecommerce.vistaTopCategoriasSemana TO 'auditor';
GRANT SELECT ON ecommerce.vistaTendenciasHoy TO 'auditor';
GRANT SELECT ON ecommerce.vistaMejorReputacionPorCategoria TO 'auditor';

/*2*/
CREATE ROLE 'desarrollador';
GRANT SELECT ON ecommerce.* TO 'desarrollador';
GRANT CREATE ROUTINE, ALTER ROUTINE, EXECUTE ON ecommerce.* TO 'desarrollador';

/*3*/
CREATE ROLE 'admin';
GRANT ALL PRIVILEGES ON ecommerce.* TO 'admin';