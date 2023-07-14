SELECT age, COUNT(*), MAX(birth_day), MIN(birth_day)  FROM users
WHERE birth_place ='日本'
GROUP BY age
ORDER BY COUNT(*) ;

SELECT department, SUM(salary), FLOOR(AVG(salary)), MIN(salary) FROM employees
WHERE age > 40
GROUP BY department;



SELECT
  CASE
    WHEN birth_place = '日本' THEN '日本人'
    ELSE 'その他'
  END AS '国籍',
  COUNT(*),
  MAX(age)
FROM users
GROUP BY
  CASE
    WHEN birth_place = '日本' THEN '日本人'
    ELSE 'その他'
  END;

