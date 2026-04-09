/*1*/

delimiter//
create function pagada(int idC) returns boolean deterministic
begin
	declare completo boolean;
    delcare pagoActual float;
    select sum(p.monto) into pagoActual
    from pago p
    where p.compra_id = idC
    
    if(pagoActual = (select c.precio from compra c
			where c.id = idC) then
            set completo = true;
            
	else 
    set completo = false;
    end if;
    return completo;
    
end//
delimiter;

select pagado(1);


/*2*/
delimiter//
create function comisionE {int idE) returns float deterministic
begin
	declare totalMes float;
    declare comision float;
    
    if exists(select e.dni from empleado e
		where e.dni = idE and e.fecha_ingreso > year(now()) - interval 5 year) then
        
select sum(c.precio) into totalMes from compra c
	where c.empleado_dni = idE
    group by  c.empleado_dni;
    set comision = totalMes . 0,05;
    
    else if exists(select e.dni from empleado e
		where e.dni = idE and e.fecha.ingreso between Year(now()) - interval
        5 year and Year(now()) - interval 10) then
        
	select sum(c.precio) into totalMes from compra c
		where c.empleado_dni = idE
        group by c.empleado_dni;
        
        set comision = totalMes . 0,07;
        
        else if exists (select e.dni from empleado e
			where e.dni = idE) then
            
	select sum(c.precio) into totalMes from empleado e
		where c.empleado_dni = idE
        group by c.empleado_dni;
        
        set comision = totalMes . 0,1;
        
	end if;
    end if;
    end if;
    
    return comision
    end//
    delimiter ;
    select comision(1);
    
/*3*/

delimiter//
create function ventaAuto (int model, int mes) returns int deterministic
begin
	declare cant int declare 0
    
    select count(a.patente) into cant from auto a
    join compra c on a.patente = c.auto_patente
    where month(c.fecha) = mes and a.modelo_id = model
    return cant;
    
end//
delimiter;

select ventaAuto (3,9);

/*1 vista*/

create view Resumen_todas_las_ventas as select
	c.dni;
    c.mail;
    co.fecha;
    a.patente;
    m.marca;
    a.color;
    estapaga(co.id) as pagada from compra co
		inner join cliente c on co.cliente_dni = c.dni
        inner join auto a on co.auto_patente = a.patente
        inner join modelo m on a.modelo_id = m.id;