USE day_10_14_db;

SHOW TABLES;

SELECT * FROM employees;

SELECT *, AVG(age) OVER(), COUNT(*) OVER()
FROM employees;

SELECT *, AVG(age) OVER(PARTITION BY department_id) AS avg_age, COUNT(*) OVER(PARTITION BY department_id) AS count_department
FROM employees;

SELECT DISTINCT CONCAT(COUNT(*) OVER(PARTITION BY FLOOR(age/10)), "人") AS age_count, FLOOR(age/10) * 10
FROM employees;

SELECT *, SUM(order_amount*order_price) OVER(PARTITION BY DATE_FORMAT(order_date, '%Y/%m')) AS "月毎に集計"
FROM orders;

SELECT *,
COUNT(*) OVER(ORDER BY age) AS tmp_count
FROM
employees;

SELECT *, SUM(order_price) OVER(ORDER BY order_date DESC) FROM orders;

SELECT
FLOOR(age/10),
COUNT(*) OVER(ORDER BY FLOOR(age/10))
FROM employees;

SELECT *,
MIN(age)OVER(PARTITION BY department_id ORDER BY age) AS count_value
FROM employees;

SELECT 
*,
MAX(sa.payment) OVER(PARTITION BY sa.paid_date ORDER BY emp.id)
FROM employees AS emp
INNER JOIN salaries AS sa
ON emp.id = sa.employee_id ;

SELECT *,
SUM(order_price * order_amount) 
OVER(ORDER BY order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
FROM orders; 

WITH daily_summary AS(
SELECT order_date,
SUM(order_price * order_amount) AS sale
FROM orders
GROUP BY order_date
)
SELECT 
  *,
  AVG(sale) OVER(ORDER BY order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
FROM
 daily_summary; 


SELECT
*,
ROW_NUMBER() OVER(ORDER BY age) AS row_num,
RANK() OVER(ORDER BY age) AS row_rank,
DENSE_RANK() OVER(ORDER BY age) AS row_dens
FROM employees;


SELECT 
age,
RANK() OVER(ORDER BY age) AS row_rank,
COUNT(*) OVER() AS cnt, 
PERCENT_RANK() OVER(ORDER BY age) AS p_age,
CUME_DIST() OVER(ORDER BY age) AS c_age
FROM employees;


SELECT 
age,
LAG(age) OVER(ORDER BY age),
LAG(age, 3, 0) OVER(ORDER BY age),
LEAD(age) OVER(ORDER BY age),
LEAD(age, 2, 0) OVER(ORDER BY age)
FROM customers;

SELECT 
*,
FIRST_VALUE(first_name) OVER(PARTITION BY department_id ORDER BY age),
LAST_VALUE (first_name) OVER(PARTITION BY department_id ORDER BY age RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM employees;


SELECT 
* FROM 
(SELECT 
age,
NTILE(10) OVER(ORDER BY age) AS ntile_value
FROM employees) AS tmp
WHERE
tmp.ntile_value = 8;