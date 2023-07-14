SHOW DATABASES;
USE my_db;
SELECT DATABASE();
CREATE TABLE students(
  id INT PRiMARY KEY, 
  name CHAR(10)
);

DESCRIBE students;

# CHAR型は末尾のスペースが削除される
INSERT INTO students VALUES(1, "ABCDEF  ")

SELECT * FROM students;

ALTER TABLE students MODIFY name VARCHAR(10);

INSERT INTO students VALUES(2,"ABCDEF  ");

SELECT * FROM students;

# name,nameの文字数を表示
SELECT name,CHAR_LENGTH(name) FROM students; 