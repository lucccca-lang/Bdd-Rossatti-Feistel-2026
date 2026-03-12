select count(*), j.pais from Jugadores j
GROUP BY j.pais;


select et.Equipos_id from Equipos_has_torneo et
where et.Equipos_id IN (select count(et2.torneo_id) as cant from Equipos_has_torneo et2
group by et2.Equipos_id
having cant > 0);

/*11*/
select count(t.id) as cant, v.nombre from torneo t
join videojuegos v on v.id = t.videojuegos_id
group by v.id
order by cant desc
limit 1;

/*13*/
update torneo t
set t.premio = t.premio * 2
where t.id IN (select count (eht.equipos_id) as cant 
from (select count(eht2.Equipos_id) as cantt, eht2.Torneos_id as tid from equipos_has_torneo eht2
group by tid
having cantt < 2);

/*14*/
update
set
where
