SHOW DATABASES;

USE day_4_9_db;

SELECT DATABASE();

SHOW TABLES;

SELECT * FROM customers;

SELECT name, age FROM customers 
  WHERE age >= 28 AND age <= 40 AND name LIKE '%子'
  ORDER BY age DESC
  LIMIT 5;
 
SELECT * FROM receipts ORDER BY id DESC LIMIT 10;

describe receipts;

INSERT INTO receipts
 VALUES(301, 100, 'Store X', 10000);

DELETE FROM receipts WHERE id = 301; 

SELECT * FROM prefectures;

DELETE FROM prefectures WHERE name IS NULL OR name = '';

SELECT *, age+1 FROM customers WHERE id BETWEEN 20 AND 50;

UPDATE customers SET age=age+1 WHERE id BETWEEN 20 AND 50;

SELECT *, CEILING(RAND()*5)  FROM students WHERE class_no = 6;

UPDATE students SET class_no = CEILING(RAND()*5) WHERE class_no = 6;

SELECT * FROM students
WHERE height < ALL (SELECT height+10 FROM students WHERE class_no IN (3,4))
AND class_no = 1;

SELECT *,TRIM(department) FROM employees;

UPDATE employees SET department = TRIM(department); 

SELECT *,ROUND(salary*0.9) FROM employees WHERE salary >= 5000000;

SELECT *,ROUND(salary*1.1) FROM employees WHERE salary < 5000000;

SELECT *,
CASE 
	WHEN salary >= 5000000 THEN ROUND(salary*0.9)
	WHEN salary < 5000000 THEN ROUND(salary*1.1)
END AS new_salary
FROM employees;

UPDATE employees
SET salary = CASE 
	WHEN salary >= 5000000 THEN ROUND(salary*0.9)
	WHEN salary < 5000000 THEN ROUND(salary*1.1)
END;


SELECT *,CURDATE() FROM customers ORDER BY id DESC;

INSERT INTO customers VALUES(101, "名無権兵衛", 0, CURDATE());

SELECT * FROM customers;

ALTER TABLE customers ADD name_length INT;

SELECT *, CHAR_LENGTH(name) FROM customers;

UPDATE customers SET name_length = CHARACTER_LENGTH(name); 


SELECT * FROM tests_score;

ALTER TABLE tests_score ADD score INT;

SELECT *,
CASE 
  WHEN COALESCE(test_score_1, test_score_2, test_score_3) >= 900
  THEN FLOOR(COALESCE(test_score_1, test_score_2, test_score_3)*1.2)
  WHEN COALESCE(test_score_1, test_score_2, test_score_3) <= 600
  THEN CEILING(COALESCE(test_score_1, test_score_2, test_score_3)*0.8)
  ELSE COALESCE(test_score_1, test_score_2, test_score_3)
END AS results
FROM tests_score;

UPDATE tests_score
SET score = CASE 
  WHEN COALESCE(test_score_1, test_score_2, test_score_3) >= 900
  THEN FLOOR(COALESCE(test_score_1, test_score_2, test_score_3)*1.2)
  WHEN COALESCE(test_score_1, test_score_2, test_score_3) <= 600
  THEN CEILING(COALESCE(test_score_1, test_score_2, test_score_3)*0.8)
  ELSE COALESCE(test_score_1, test_score_2, test_score_3)
END;


SELECT DISTINCT department from employees;

SELECT * FROM employees
ORDER BY
CASE department
WHEN "マーケティング部" THEN 1
WHEN "研究部" THEN 2
WHEN "開発部" THEN 3
WHEN "総務部" THEN 4
WHEN "営業部" THEN 5
WHEN "経理部" THEN 6
END;
