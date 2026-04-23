/*9*/
DELIMITER //

CREATE PROCEDURE getCiudadesOffices(OUT resultado VARCHAR(4000))
BEGIN
    DECLARE existenRegistros BOOLEAN;
    DECLARE ciudadActual VARCHAR(45) DEFAULT "";
    DECLARE cursorOficinas CURSOR FOR SELECT o.city FROM offices o;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET existenRegistros = 0;

    SET resultado = "";
    
    OPEN cursorOficinas;

    cicloOficinas: LOOP
        FETCH cursorOficinas INTO ciudadActual;

        IF existenRegistros = 0 THEN
            LEAVE cicloOficinas;
        END IF;

        SET resultado = CONCAT(ciudadActual, ", ", resultado);
    END LOOP cicloOficinas;

    CLOSE cursorOficinas;
END //

DELIMITER ;

CALL getCiudadesOffices(@lista);
SELECT @lista;

/*10*/

delimiter // 
CREATE PROCEDURE insertCancelled(out cant int)
BEGIN
	declare hayFilas boolean;
    declare ordenCancelada varchar(45) default "";
    declare ordersCursor cursor for select ord.status from orders ord;
	declare continue handler for not found set hayFilas = 0;
    set cant = 0;
    open ordersCursor;
    ordersLoop:loop
		fetch ordersCursor into ordenCancelada;
        if hayFilas = 0 then
			leave ordersLoop;
		end if;
        if(ordenCancelada = "Cancelled") then
        set cant = cant + 1;
        end if;
        end loop ordersLoop;
        close ordersCursor;
end//
delimiter ;

call insertCancelled(@cant);
select @cant;

/*11*/
delimiter //
CREATE PROCEDURE alterCommentOrder(in idCl int)
BEGIN
	declare hayFilas boolean;
    declare completarCommentario text default "";
    declare totalOrden int;
    declare ordenCursor cursor for select ord.comments from orders ord;
    declare continue handler for not found set hayFilas = 0;
    
    SELECT sum(ordd.quantityOrdered * ordd.priceEach) into totalOrden from orderdetails ordd
    JOIN orders ord ON ord.orderNumber = ordd.orderNumber
    WHERE ord.customerNumber = idCl;
    
    open ordenCursor;
    ordenLoop:loop
		fetch ordenCursor into completarCommentario;
			if hayFilas = 0 then
				leave ordenLoop;
			end if;
            if completarCommentario = NULL then
				Update orders
					SET comments = concat("El total de la orden es", totalOrden)
					WHERE customerNumber = idCl;
			end if;
            end loop ordenLoop;
            close ordenCursor;
end // 
delimiter ;

drop procedure alterCommentOrder;

call alterCommentOrder(121);

/*13*/

DROP PROCEDURE IF EXISTS actualizarComision;

DELIMITER //
CREATE PROCEDURE actualizarComision()
BEGIN 
	DECLARE sig int DEFAULT 1;
	DECLARE v_comision int;
	DECLARE v_employee_number int;
	DECLARE v_sell_sum float;
	DECLARE sellsSum CURSOR FOR
		SELECT e.employeeNumber,SUM(o2.priceEach *o2.quantityOrdered ) FROM employees e 
		JOIN customers c ON c.salesRepEmployeeNumber = e.employeeNumber 
		JOIN orders o ON o.customerNumber = c.customerNumber 
		JOIN orderdetails o2 ON o2.orderNumber = o.orderNumber 
		GROUP BY e.employeeNumber;
	DECLARE CONTINUE handler FOR NOT FOUND SET sig = 0;
	OPEN sellsSum;
		bucle:LOOP
			FETCH sellsSum INTO v_employee_number,v_sell_sum;
			IF sig = 0 THEN
				LEAVE bucle;
			END IF;
			
			IF(v_sell_sum > 100000) THEN
				SET v_comision = 5;
			ELSEIF(v_sell_sum > 50000) THEN
				SET v_comision = 3;
			ELSE 
				SET v_comision = 0;
			END IF;
			
			UPDATE employees 
				SET comision = v_comision
				WHERE employeeNumber = v_employee_number;
		END LOOP;
	CLOSE sellsSum;
END

DELIMITER ;

CALL actualizarComision();