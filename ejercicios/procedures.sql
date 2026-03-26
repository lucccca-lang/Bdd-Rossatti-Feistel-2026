use classicmodels;

/*1*/

/*1*/


delimiter // 
CREATE PROCEDURE precioAlto(out cantP int)
BEGIN
	
    SELECT p.productName FROM products p
    WHERE buyPrice > (SELECT AVG(p.buyPrice) FROM products p);
    
    SET cantP = (SELECT count(p.productName) FROM products p
    WHERE buyPrice > (SELECT AVG(p.buyPrice) FROM products p));

END //
delimiter ;

DROP procedure precioAlto;

call precioAlto(@cant);
select @cant;

    
    
    
/*2*/

DELIMITER //

DROP PROCEDURE  IF EXISTS BorrarOrden //

CREATE PROCEDURE BorrarOrden(IN p_order_number int,OUT p_afected_Rows INT)
BEGIN
	
	SELECT 0 INTO p_afected_Rows;
	
	DELETE FROM orderdetails
	WHERE orderNumber = p_order_number;

	SELECT ROW_COUNT()  INTO p_afected_Rows;

	DELETE FROM orders 
	WHERE orderNumber = p_order_number;
	
	
END //

DELIMITER ;

CALL BorrarOrden(10100,@afected_Rows);
SELECT @afected_Rows AS Filas_Eliminadas;

/*3*/

delimiter // 
create procedure borrarLinea(IN linea TEXT, out respuesta TEXT)
BEGIN
 
	IF EXISTS (select productLine from products p where productLine = linea) THEN
    set respuesta = "La línea de productos no pudo borrarse porque contiene productos asociados";
    
    else 
    delete from products p
    where products = productsLine;
	set respuesta = "La línea de productos fue borrada";
    
    END IF;

END //
delimiter ;

call borrarLinea ("Classic Cars", @respuesta);
select @respuesta;

/*1*/

/*1*/


delimiter // 
CREATE PROCEDURE precioAlto(out cantP int)
BEGIN
	
    SELECT p.productName FROM products p
    WHERE buyPrice > (SELECT AVG(p.buyPrice) FROM products p);
    
    SET cantP = (SELECT count(p.productName) FROM products p
    WHERE buyPrice > (SELECT AVG(p.buyPrice) FROM products p));

END //
delimiter ;

DROP procedure precioAlto;

call precioAlto(@cant);
select @cant;

    
    
    
/*2*/

DELIMITER //

DROP PROCEDURE  IF EXISTS BorrarOrden //

CREATE PROCEDURE BorrarOrden(IN numeroOrden int,OUT filas INT)
BEGIN
	
	SELECT 0 INTO filas;
	
	DELETE FROM orderdetails
	WHERE orderNumber = numeroOrden;

	SELECT ROW_COUNT()  INTO filas;

	DELETE FROM orders 
	WHERE orderNumber = numeroOrden;
	
	
END //

DELIMITER ;

CALL BorrarOrden(10100,@filas);
SELECT @filas AS Filas_Eliminadas;

/*3*/

delimiter // 
create procedure borrarLinea(IN linea TEXT, out respuesta TEXT)
BEGIN
 
	IF EXISTS (select productLine from products p where productLine = linea) THEN
    set respuesta = "La lÃ­nea de productos no pudo borrarse porque contiene productos asociados";
    
    else 
    delete from products p
    where products = productsLine;
	set respuesta = "La lÃ­nea de productos fue borrada";
    
    END IF;

END //
delimiter ;

call borrarLinea ( "Classic Cars", @respuesta);
select @respuesta;


/*8*/
delimiter //
CREATE PROCEDURE modificarComment(in orden int, in comm TEXT, out funciono int)
BEGIN
	IF EXISTS(SELECT orderNumber FROM orders WHERE orderNumber = orden)THEN
    
    UPDATE orders
    SET comments = comm
    WHERE orderNumber = orden;
    
    SET funciono = 1;
    
    ELSE
    
    SET funciono = 0;
    
    END IF;

END //
delimiter ;

CALL modificarComment(312, "hola" , @funciono);
SELECT @funciono;