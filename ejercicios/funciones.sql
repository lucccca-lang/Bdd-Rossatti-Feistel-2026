use classicmodels;

/*1*/
delimiter //
create function ordenesSegunEstado (fechaInicio date, fechaFin date, estado text) returns int deterministic
begin
declare cantOrdenes int default 0;
select count(*) into cantOrdenes from orders where status = estado and orderDate between 
fechaInicio and fechaFin;
return cantOrdenes;
end//
delimiter ;
select ordenesSegunEstado("2023-10-10", current_date(), "Cancelled");

/*3*/
delimiter //
create function CiudadDeEmpleado (numeroCliente int) returns text deterministic
begin
	declare nombreCiudad text;
		select city into  nombreCiudad from offices
        where officeCode = (select  officeCode from employees
        where  employeeNumber = (select salesRepEmployeeNumber from customers
        where customerNumber = numeroCliente));
    
    return nombreCiudad;
end //
delimiter ;

drop function CiudadDeEmpleado;

/*7*/
delimiter //
create function Beneficio (nroDeOrden int, nroDeProducto text) returns int deterministic
begin
	declare beneficio int default 0;
		select ja.priceEach - ja.buyPrice into beneficio from(
        select p.buyPrice, od.priceEach from products p
        join orderdetails od on p.productCode = od.productCode
        where nroDeOrden = od.orderNumber and nroDeProducto = p.productCode) as ja;
        
     
    return beneficio;
end //
delimiter ;

select Beneficio (10100, "S10_1678");

drop function Beneficio;


/*10*/
delimiter //
create function ventaBaja (codigoProducto text) returns float deterministic
begin
	declare promedio float;
    declare cantMenos int;
    declare total int;
    
    select count(p.productCode) into cantMenos from products p
    join orderdetails ord on ord.productCode = p.productCode
    where p.MRSP > ord.priceEach;
    
    select count(p.productCode) into total from products p;
    
    set promedio = cantMenos / total;
    return promedio;
    
    end // 
    delimiter;
    
    