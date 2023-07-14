SELECT DATABASE();
USE my_db;
SHOW TABLES;


CREATE TABLE peaple(
  id INT PRIMARY KEY,
  name VARCHAR(50),
  birth_day DATE DEFAULT "1990-01-01"
  );
  
INSERT INTO peaple VALUES(1,"Taro", "2001-01-01");

SELECT * FROM peaple;

INSERT INTO peaple(id,name) VALUES(2,"Jiro");

INSERT INTO peaple(id,name) Values(3,'Saburo');

INSERT INTO peaple VALUES(4, 'John''s son', '2021-01-01')

ALTER TABLE peaple RENAME TO people;