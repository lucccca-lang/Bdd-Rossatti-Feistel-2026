/*1*/
CREATE USER 'analistaStock'@'localhost' IDENTIFIED BY RANDOM PASSWORD;
CREATE USER 'gestorProducto'@'localhost' IDENTIFIED BY RANDOM PASSWORD;
CREATE USER 'usuarioProducto'@'localhost' IDENTIFIED BY RANDOM PASSWORD;
CREATE USER 'desarrollo'@'localhost' IDENTIFIED BY RANDOM PASSWORD;
CREATE USER 'admin'@'localhost' IDENTIFIED BY RANDOM PASSWORD;

SELECT * FROM mysql.`user` u 


/*2*/

-- rol 1
CREATE ROLE stocker;

GRANT EXECUTE  ON PROCEDURE update_stock TO stocker;
GRANT EXECUTE  ON PROCEDURE update_prices TO stocker;
GRANT EXECUTE  ON PROCEDURE update_pedidos_price TO stocker;
GRANT SELECT ON stocks.* TO stocker;

-- rol 2
CREATE  ROLE orderer;

GRANT EXECUTE ON PROCEDURE borrarOrden TO orderer
GRANT EXECUTE  ON PROCEDURE borrarLineaProductos TO stocker;
GRANT EXECUTE  ON PROCEDURE actualizarComentarios TO stocker;

GRANT SELECT ON stocks.orderDetails TO orderer;
GRANT SELECT ON stocks.orders TO orderer;

-- rol 3
CREATE  ROLE lector;

GRANT SELECT ON stocks.* TO lector;
GRANT SELECT ON classicmodels.* TO lector;
GRANT EXECUTE  ON PROCEDURE stocks.* TO lector;
GRANT EXECUTE  ON PROCEDURE classicmodels.* TO lector;

-- rol 4


CREATE  ROLE bia;

GRANT CREATE ROUTINE, TRIGGER, INDEX, EVENT ON stocks.* TO bia;
GRANT UPDATE ROUTINE, TRIGGER, INDEX, EVENT ON stocks.* TO bia;
GRANT DELETE ROUTINE, TRIGGER, INDEX, EVENT ON stocks.* TO bia;


GRANT CREATE ROUTINE, TRIGGER, INDEX, EVENT ON classicmodels.* TO bia;
GRANT UPDATE ROUTINE, TRIGGER, INDEX, EVENT ON classicmodels.* TO bia;
GRANT DELETE ROUTINE, TRIGGER, INDEX, EVENT ON classicmodels.* TO bia;

GRANT SELECT ON stocks.* TO bia;
GRANT SELECT ON classicmodels.* TO bia;

-- rol 5

CREATE  ROLE admin;
GRANT ALL PRIVILEGES ON stocks.* TO admin;
GRANT ALL PRIVILEGES ON classicmodels.* TO admin;

/*3*/



GRANT 'lector' TO 'analistaStock'@'localhost';
GRANT 'stocker' to 'gestorProducto'@'localhost';
GRANT 'stocker' to 'usuarioProducto'@'localhost';
GRANT 'bia' to 'desarrollo'@'localhost';

GRANT 'admin' to 'desarrollo'@'localhost';