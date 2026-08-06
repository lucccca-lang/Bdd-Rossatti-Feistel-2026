/*6*/
SHOW MASTER STATUS;
SHOW BINLOG EVENTS in 'binlog.000300' LIMIT 10;

/*7*/
USE mysql;
SELECT * FROM performance_schema.error_log
order by LOGGED desc
LIMIT 20;