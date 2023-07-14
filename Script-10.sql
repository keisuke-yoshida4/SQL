USE day_4_9_db;

SELECT DATABASE();

SHOW TABLES;

SELECT IF (10 > 20, "A", "B");

SELECT * FROM users ;

SELECT *, IF (birth_place="日本","日本人","その他") AS "国籍" FROM users ;

SELECT * FROM students ;

SELECT *, IF (class_no=6 AND height > 170,'6組の170cm以上の人', 'その他') FROM students;

SELECT * FROM users;

SELECT name, IF(name LIKE "%田%", "名前に田を含む", "その他") AS name_check FROM users;