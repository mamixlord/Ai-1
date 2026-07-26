-- Returns one row per required table, followed by catalog and ledger trigger checks.
SELECT t.table_name,t.engine,t.table_collation
FROM information_schema.tables t
WHERE t.table_schema=DATABASE()
ORDER BY t.table_name;

SELECT p.slug,COUNT(pl.id) AS plan_count
FROM products p LEFT JOIN plans pl ON pl.product_id=p.id
GROUP BY p.id,p.slug ORDER BY p.slug;

SELECT trigger_name,event_manipulation,event_object_table
FROM information_schema.triggers
WHERE trigger_schema=DATABASE() AND event_object_table='credit_ledger'
ORDER BY trigger_name;

SELECT @@version AS mysql_version,@@character_set_database AS database_charset,
       @@collation_database AS database_collation;
