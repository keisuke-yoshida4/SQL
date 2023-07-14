SELECT * FROM users;

SHOW DATABASES;

USE day_4_9_db;

START TRANSACTION;

SHOW TABLES;

SELECT * FROM customers;

UPDATE customers SET age=43 WHERE id=1

ROLLBACK;

START TRANSACTION;

UPDATE customers SET age=42
WHERE name='河野　文典';

ROLLBACK;

DELETE FROM customers WHERE id=1;
COMMIT;

START TRANSACTION;

INSERT INTO customers VALUES(1, "田中一郎", 21, "1999-01-01");
SELECT * FROM customers;

COMMIT;

START TRANSACTION;

SELECT * FROM customers WHERE id=1 FOR SHARE;

ROLLBACK;

LOCK TABLE customers READ;
SELECT * FROM customers;
UPDATE customers SET age=42 WHERE id=1;

UNLOCK TABLES;

LOCK TABLE customers WRITE;
SELECT * FROM customers;
UPDATE customers SET age=42 WHERE id=1;
UNLOCK TABLES;
