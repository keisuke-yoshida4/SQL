SHOW TABLES;

SELECT * FROM new_students
UNION
SELECT * FROM students
ORDER BY id;

SELECT * FROM new_students
UNION ALL
SELECT * FROM students
ORDER BY id;

SELECT * FROM students WHERE id < 10
UNION ALL 
SELECT * FROM new_students WHERE id >250;

SELECT * FROM customers WHERE name IS NULL; 

SELECT COUNT(*) FROM customers;
SELECT COUNT(name) FROM customers;
SELECT COUNT(name) FROM customers WHERE id>80;

SELECT MAX(age),MIN(age) FROM users WHERE birth_place ='日本';

SELECT SUM(salary) FROM employees;

SELECT * FROM employees;
SELECT AVG(salary) FROM employees;

CREATE TABLE tmp_count(
 num INT
);

SHOW TABLES;

INSERT INTO tmp_count VALUES(1);
INSERT INTO tmp_count VALUES(2);
INSERT INTO tmp_count VALUES(3);
INSERT INTO tmp_count VALUES(NULL);

SELECT * FROM tmp_count; 

SELECT AVG(COALESCE (num, 0)) FROM tmp_count;