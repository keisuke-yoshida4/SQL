SELECT DATABASE();

DESCRIBE customers;

SELECT * FROM customers WHERE name IS NULL;

SELECT * FROM customers WHERE name IS NOT NULL;

SELECT * FROM prefectures;

SELECT * FROM prefectures WHERE name IS NULL;

SELECT * FROM prefectures WHERE name = '';

SELECT * FROM users WHERE age BETWEEN 5 AND 10;

SELECT * FROM users WHERE age NOT BETWEEN 5 AND 10;

SELECT * FROM users WHERE name LIKE "村%";

SELECT * FROM users WHERE name LIKE "%ed%";

