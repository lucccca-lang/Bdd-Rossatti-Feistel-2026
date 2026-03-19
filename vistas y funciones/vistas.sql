use classicmodels;

/*6*/
create view noPagos as select c.customerName from customers c 
where c.customerNumber not in (select p.customerNumber from payments p);

/*10*/
create view ayp as select c.customerName, c.phone, c.addressLine1, c.addressLine2 from customers c
where c.customerNumber in (select p.customerNumber from payments p
where p.paymentDate = current_date() - interval 2 year and p.amount > 30000);

/*11*/
create view entregaAlterada as select o.orderNumber from orders o
where o.status = "Cancelled" or o.status = "Resolved";
/*13*/
create view mas as select pj2
from (select sum(od.quantityOrdered) as tot, o.customerNumber as pj2 from orderdetails od
join orders o on od.orderNumber = o.orderNumber
group by pj2
order by tot desc
limit 1)as lucc;