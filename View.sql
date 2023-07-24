USE day_10_14_db;

SHOW TABLES;


CREATE VIEW stores_items_view AS
SELECT st.name AS store_name, it.name AS item_name FROM stores AS st
INNER JOIN items AS it
ON it.store_id = st.id; 

SELECT * FROM stores_items_view;


SHOW TABLES;

SELECT * FROM INFORMATION_SCHEMA.VIEWS WHERE TABLE_SCHEMA="day_10_14_db";

SELECT * FROM stores_items_view ORDER BY store_name;

SELECT store_name, COUNT(*) FROM stores_items_view GROUP BY store_name ORDER BY store_name;

ALTER VIEW stores_items_view AS
SELECT st.id AS store_id, it.id AS item_id, st.name AS store_name, it.name AS item_name FROM stores AS st
INNER JOIN items AS it
ON it.store_id = st.id;

SELECT * FROM stores_items_view;

RENAME TABLE stores_items_view TO new_stores_items_view;

