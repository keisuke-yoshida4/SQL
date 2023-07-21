SHOW DATABASES;

USE day_10_14_db;

SELECT * FROM employees;

UPDATE employees SET age = age+1 WHERE id=1;

SELECT * FROM employees;


UPDATE
    employees AS emp 
SET emp.age = emp.age+2
WHERE 
emp.department_id = (SELECT id FROM departments WHERE name = '営業部');


SELECT * FROM employees;

ALTER TABLE employees
ADD department_name VARCHAR(255);

UPDATE
employees AS emp
LEFT JOIN departments AS dt 
ON emp.department_id = dt.id
SET emp.department_name = COALESCE(dt.name, "不明");

SELECT * FROM employees;


SELECT * FROM stores;

ALTER TABLE stores
ADD all_sales INT;

SELECT * FROM stores;

SELECT * FROM items;

SELECT * FROM orders;

WITH tmp_sales AS(
    SELECT it.store_id, SUM(od.order_amount * od.order_price) AS summary
    FROM items AS it
    INNER JOIN orders AS od
    ON it.id = od.item_id
    GROUP BY it.store_id 
)
UPDATE stores AS st
INNER JOIN tmp_sales AS ts 
ON st.id = ts.store_id
SET st.all_sales = ts.summary

SELECT * FROM stores;


DELETE FROM employees 
WHERE department_id IN(
    SELECT id FROM departments WHERE name = "開発部"
);

SELECT * FROM employees;



SELECT * FROM customers;

SELECT * FROM orders;

CREATE TABLE customer_orders(
    name VARCHAR(255),
    order_date DATE,
    sales INT,
    total_sales INT
);

INSERT INTO customer_orders
SELECT 
    CONCAT(ct.last_name, ct.first_name), 
    od.order_date,
    od.order_amount * od.order_price,
    SUM(od.order_amount * od.order_price) OVER(PARTITION BY CONCAT(ct.last_name, ct.first_name) ORDER BY od.order_date)
FROM customers AS ct
INNER JOIN orders AS od 
ON ct.id = od.customer_id 

SELECT * FROM customer_orders





SHOW DATABASES;
CREATE DATABASE day_15_18_db;

USE day_15_18_db;

SHOW TABLES;

CREATE TABLE users(
    id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255) DEFAULT '' NOT NULL
);

INSERT INTO users(id) VALUES(1);

SELECT * FROM users;

CREATE TABLE users_2(
    id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255) NOT NULL,
    age INT DEFAULT 0
);

INSERT INTO users_2(id, first_name, last_name) VALUES(1, "Taro", "Yamada");

SELECT * FROM users_2;

INSERT INTO users_2 VALUES(2, "Jiro", "Suzuki", NULL);


CREATE TABLE login_users(
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE
);

INSERT INTO login_users VALUES(1, "Shingo", "abc@mail.com");
INSERT INTO login_users VALUES(2, "Shingo", "abc@mail.com");


CREATE  TABLE tmp_names(
    name VARCHAR(255) UNIQUE
);

INSERT INTO tmp_names VALUES("Taro");
INSERT INTO tmp_names VALUES(NULL);

SELECT * FROM tmp_names;


CREATE TABLE customers(
    id INT PRIMARY KEY,
    name VARCHAR(255),
    age INT CHECK(age >= 20)
);

INSERT INTO customers VALUES(1, 'Taro', 21);

CREATE TABLE students(
    id INT PRIMARY KEY,
    name VARCHAR(255),
    age INT, 
    gender CHAR(1),
    CONSTRAINT chk_students CHECK((age >= 15 AND age <= 20) AND(gender = "F" OR gender = "M")
);


INSERT INTO students VALUES(1, 'Taro', 18, 'M');

SELECT * FROM students;

SHOW TABLES;

DROP TABLE students;

CREATE TABLE schools(
    id INT PRIMARY KEY,
    name VARCHAR(255)
);


CREATE TABLE students(
    id INT PRIMARY KEY,
    name VARCHAR(255),
    age INT,
    school_id INT,
    FOREIGN KEY(school_id) REFERENCES schools(id)
);

INSERT INTO schools VALUES(1, '北高校')

INSERT INTO students VALUES(1, "Taro", 18, 1);

DESCRIBE students;

DROP TABLE students;


CREATE TABLE students(
    id INT PRIMARY KEY,
    name VARCHAR(255),
    age INT,
    school_id INT,
    FOREIGN KEY(school_id) REFERENCES schools(id)
    ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO students VALUES(1, "Taro", 18, 1);

SELECT * FROM students;

SELECT * FROM schools;
UPDATE schools SET id=3 WHERE id=1;

DELETE FROM schools;





CREATE TABLE students(
    id INT PRIMARY KEY,
    name VARCHAR(255),
    age INT,
    school_id INT,
    FOREIGN KEY(school_id) REFERENCES schools(id)
    ON DELETE SET NULL ON UPDATE SET NULL
);

SELECT * FROM schools;

INSERT INTO schools VALUES(3, "北高校");

INSERT INTO students VALUES(1, "Taro", 16, 3);

SELECT * FROM students;

UPDATE schools SET id=3 WHERE id=1;

UPDATE students SET school_id=3 WHERE school_id IS NULL;

SELECT * FROM schools;
DELETE FROM schools WHERE id=3;

DROP TABLE students;

CREATE TABLE students(
    id INT PRIMARY KEY,
    name VARCHAR(255),
    age INT,
    school_id INT,
    FOREIGN KEY(school_id) REFERENCES schools(id)
    ON DELETE SET DEFAULT ON UPDATE SET DEFAULT
);

SELECT * FROM schools;

INSERT INTO schools VALUES(1, "北高校");

INSERT INTO students VALUES(1, "Taro", 17, 1);

SELECT * FROM students;

UPDATE schools SET id=3 WHERE id=1;



SHOW TABLES;

SELECT * FROM customers;
DESCRIBE customers;

INSERT INTO customers(id, name) VALUES(3, NULL);
ALTER TABLE customers ADD CONSTRAINT check_age CHECK(age >= 20);

ALTER TABLE customers DROP PRIMARY KEY;

ALTER TABLE customers
ADD CONSTRAINT pk_customers PRIMARY KEY(id);

DESCRIBE students;

SHOW CREATE TABLE students;

ALTER TABLE students DROP CONSTRAINT students_ibfk_1;


ALTER TABLE students
ADD CONSTRAINT fk_schools_students
FOREIGN KEY(school_id) REFERENCES schools(id);


CREATE TABLE animals(
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主キーのID(INT型)です',
    name VARCHAR(50) NOT NULL COMMENT '動物の名前です'
);

SHOW FULL COLUMNS FROM animals;

INSERT INTO animals VALUES(NULL, "Dog");

SELECT * FROM animals;

INSERT INTO animals(name) VALUES('cat');

SELECT AUTO_INCREMENT FROM information_schema.tables WHERE TABLE_NAME='animals';

INSERT INTO animals VALUES(4, "Panda");

INSERT INTO animals VALUES(NULL, "Fish");

ALTER TABLE animals AUTO_INCREMENT = 100;

INSERT INTO animals VALUES(NULL, "Bird");

SELECT * FROM animals;

INSERT INTO animals(name)
SELECT "Snake"
UNION ALL
SELECT "Dino"
UNION ALL

INSERT INTO animals(name)
SELECT name FROM animals;

SELECT * FROM animals;
SELECT "Gibra";