Use classicmodels;


-- 1 --
DELIMITER //
create procedure compras ( IN idcliente INT, IN idproducto text, IN cant int, in fechaenvio date)
begin
start transaction;
update products set quantityInStock = quantityInStock - cant
where productCode = idproducto;
if ( select quantityInStock from products p where productCode = idproducto) < 0 then
rollback;
signal sqlstate '45000' set message_text = 'Error, stock insuficiente';
end if;
commit;
end //
DELIMITER ;

drop procedure compras;
call compras ( 12, '510_1678', 1000,date(now()));


-- 2 --



 
