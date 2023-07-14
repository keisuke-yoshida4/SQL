SELECT * FROM users WHERE age IN(12, 24, 36);

SELECT * FROM users WHERE birth_place NOT IN ("France", "Germany", "Italy");

SELECT * FROM customers WHERE id IN (SELECT customer_id FROM receipts);

SELECT * FROM users WHERE age > ALL(SELECT age FROM employees WHERE salary > 5000000);

SELECT * FROM employees;

SELECT * FROM employees WHERE department = " 営業部 " AND name LIKE "%田%"

SELECT * FROM employees WHERE department IN(" 営業部 ", " 開発部 ") ORDER BY department, salary;

SELECT * FROM users WHERE birth_day <= ALL(SELECT birth_day FROM customers WHERE id < 10 AND birth_day IS NOT NULL);

SELECT name, age, age+3 AS age_3 FROM users LIMIT 10;

SELECT NOW();

SELECT NOW(),name, age FROM users;

SELECT CURDATE();

SELECT DATE_FORMAT(NOW(), "%Y/%m/%d");

SELECT LENGTH("ABC");
SELECT LENGTH ("あいう");
SELECT CHAR_LENGTH("あいう");

SELECT name, CHAR_LENGTH(name) AS name_length FROM employees WHERE CHAR_LENGTH(name) <> CHAR_LENGTH(TRIM(name)); 

UPDATE employees 
SET name = TRIM(name)
WHERE CHARACTER_LENGTH(name) <> CHARACTER_LENGTH(TRIM(name)) ;

SELECT REPLACE(name, "Mrs","Ms") FROM users WHERE name LIKE "mrs%";

UPDATE users SET name = REPLACE(name, "Mrs","Ms") WHERE name LIKE "mrs%";

SELECT * FROM users WHERE name LIKE "Ms%";

SELECT ROUND(3.14, 1); 

SELECT RAND()*10;

SELECT POWER(3,4); 