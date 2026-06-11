USE stock;

/*1*/

DELIMITER //

DROP PROCEDURE IF EXISTS insertar_20k_pedidos //

CREATE PROCEDURE insertar_20k_pedidos()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE max_id INT DEFAULT 0;

    -- Variables para almacenar los IDs en memoria
    DECLARE lista_clientes TEXT;
    DECLARE lista_estados TEXT;

    DECLARE cant_clientes INT;
    DECLARE cant_estados INT;

    DECLARE cliente_elegido VARCHAR(20);
    DECLARE estado_elegido INT;
    DECLARE fecha_aleatoria DATETIME;
 
    -- Forzar a que no falle por tiempos de espera en esta sesión
    SET @@SESSION.max_execution_time = 0;
    SET @@SESSION.net_read_timeout = 300;
    SET @@SESSION.net_write_timeout = 300;

    -- Optimización de inserción masiva
    SET @@SESSION.unique_checks = 0;
    SET @@SESSION.foreign_key_checks = 0;

    
    SET SESSION group_concat_max_len = 1000000;
 
   
    SELECT GROUP_CONCAT(codCliente) INTO lista_clientes FROM cliente;
    SELECT GROUP_CONCAT(idEstado) INTO lista_estados FROM estado;

    -- Contamos cuántos tenemos de cada uno
    SET cant_clientes = CHAR_LENGTH(lista_clientes) - CHAR_LENGTH(REPLACE(lista_clientes, ',', '')) + 1;
    SET cant_estados = CHAR_LENGTH(lista_estados) - CHAR_LENGTH(REPLACE(lista_estados, ',', '')) + 1;
 
    -- Control de seguridad: Si no hay datos, salimos para evitar bucle infinito
    IF lista_clientes IS NULL OR lista_estados IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Las tablas cliente o estado están vacías.';
    END IF;
 
    -- Obtener el ID máximo inicial de pedido
    SELECT COALESCE(MAX(idPedido), 0) INTO max_id FROM pedido;
 
    -- Iniciar una transacción para que guarde todo de golpe en memoria antes de escribir en disco
    START TRANSACTION;
 
    -- Bucle super veloz (Garantizado 20.000 iteraciones)
    WHILE i <= 20000 DO

        -- Elegir cliente de la lista en memoria
        SET cliente_elegido = SUBSTRING_INDEX(SUBSTRING_INDEX(lista_clientes, ',', FLOOR(1 + RAND() * cant_clientes)), ',', -1);

        -- Elegir estado de la lista en memoria
        SET estado_elegido = CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(lista_estados, ',', FLOOR(1 + RAND() * cant_estados)), ',', -1) AS UNSIGNED);

        -- Fecha aleatoria
        SET fecha_aleatoria = NOW() - INTERVAL FLOOR(RAND() * 365) DAY - INTERVAL FLOOR(RAND() * 86400) SECOND;

        SET max_id = max_id + 1;
 
        INSERT INTO pedido (idPedido, fecha, Estado_idEstado, Cliente_codCliente)
        VALUES (max_id, fecha_aleatoria, estado_elegido, cliente_elegido);
 
        SET i = i + 1;
    END WHILE;
 
    -- Confirmar todos los cambios juntos
    COMMIT;
 
    -- Restaurar configuraciones de seguridad
    SET @@SESSION.unique_checks = 1;
    SET @@SESSION.foreign_key_checks = 1;

END //

DELIMITER ;

call insertar_20k_pedidos();

/*2*/
EXPLAIN ANALYZE SELECT * FROM pedido WHERE idPedido = 19999;
/*
'-> Rows fetched before execution  (cost=0..0 rows=1) (actual time=118e-6..219e-6 rows=1 loops=1)\n'
*/

/*3*/
EXPLAIN ANALYZE SELECT * FROM pedido where fecha = "2025-07-04";
/*
'-> Index lookup on pedido using FECHA_INDICE (fecha=TIMESTAMP\'2025-07-04 00:00:00\')  
(cost=0.35 rows=1) (actual time=0.0279..0.0279 rows=0 loops=1)\n'
*/

/*4*/
CREATE INDEX FECHA_INDICE ON pedido(fecha);

/*5*/
EXPLAIN ANALYZE SELECT * FROM pedido where fecha = "2025-07-04";
/*
'-> Index lookup on pedido using FECHA_INDICE (fecha=TIMESTAMP\'2025-07-04 00:00:00\') 
 (cost=0.35 rows=1) (actual time=0.0297..0.0297 rows=0 loops=1)\n'
*/

/*6*/
CREATE INDEX INDICE_COMP ON pedido(Cliente_codCliente, Estado_idEstado);

/*7*/
EXPLAIN ANALYZE SELECT * FROM pedido WHERE Cliente_codCliente = 'CO2' AND Estado_idEstado = 1;
/*
'-> Filter: (pedido.Estado_idEstado = 1)  (cost=0.259 rows=0.0919) (actual time=0.0106..0.0106 rows=0 loops=1)\n
    -> Index lookup on pedido using fk_Pedido_Cliente1_idx (Cliente_codCliente=\'CO2\')  (cost=0.259 rows=1) (actual time=0.0101..0.0101 rows=0 loops=1)\n'
*/

EXPLAIN ANALYZE SELECT * FROM pedido WHERE Estado_idEstado = 1;
/*
'-> Index lookup on pedido using fk_Pedido_Estado1_idx (Estado_idEstado=1) 
 (cost=260 rows=1871) (actual time=1.54..7.88 rows=1871 loops=1)\n'
*/

EXPLAIN ANALYZE SELECT * FROM pedido WHERE Cliente_codCliente = 'CO2';
/*
'-> Index lookup on pedido using fk_Pedido_Cliente1_idx (Cliente_codCliente=\'CO2\')  
(cost=0.35 rows=1) (actual time=0.0315..0.0315 rows=0 loops=1)\n'
*/
