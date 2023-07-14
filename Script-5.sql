USE my_db;
SHOW TABLES;

SELECT * FROM people; 

SELECT name,id,birth_day FROM people;

SELECT id AS "番号", name AS "名前" FROM people;

SELECT * FROM people WHERE id<3;
SELECT * FROM people WHERE name='Taro';

UPDATE people SET birth_day="1900-01-01" WHERE id=3

DELETE FROM people WHERE id>4;

ALTER TABLE people ADD age INT AFTER name;

DESCRIBE people;

UPDATE people SET age=25 WHERE id<5

UPDATE people SET age=20 WHERE id=2

UPDATE people SET age=18 WHERE name="Saburo"

SELECT * FROM people;

SELECT * FROM people ORDER BY age;

SELECT * FROM people ORDER BY age DESC;

SELECT * FROM people ORDER BY birth_day DESC, name;

SELECT DISTINCT birth_day FROM people ORDER BY birth_day;

SELECT  DISTINCT name,birth_day FROM people;

SELECT * FROM people LIMIT 3;

SELECT * FROM people LIMIT 3, 2;
SELECT * FROM people LIMIT 4 OFFSET 2;
