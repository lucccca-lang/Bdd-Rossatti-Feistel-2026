USE classicmodels;


create table customers_audit (
IdAudit int auto_increment not null primary key,
Operacion char(6),`User` int,Last_date_modified datetime,`customername` varchar(50) not null );


/*1a*/
delimiter //

create trigger customers_audit_insert
after insert on customers
for each row
begin
	insert into customers_audit
	values(null,'insert',current_user(),now(),new.customerNumber,new.customerName);
end//

delimiter ;

/*3*/

DELIMITER //

CREATE TRIGGER before_delete_product
BEFORE DELETE ON products
FOR EACH ROW
BEGIN
    DECLARE total INT;

    SELECT COUNT(*)
    INTO total
    FROM orderdetails od
    INNER JOIN orders o ON o.orderNumber = od.orderNumber
    WHERE od.productCode = OLD.productCode
      AND o.orderDate >= DATE_SUB(CURDATE(), INTERVAL 2 MONTH);

    IF total > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error, tiene órdenes asociadas';
    END IF;

END //

DELIMITER ;