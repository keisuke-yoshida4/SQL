USE day_10_14_db;

SHOW tables;

-- employeesテーブルとcustomersテーブルの両方からそれぞれidが10より小さいレコードを取り出し、first_name,last_nameを取り出し、行方向に連結、連結時の重複は削除
SELECT
first_name,
last_name,
age
FROM employees
where id < 10
UNION
SELECT
first_name,
last_name,
age
FROM customers
where id < 10;


-- departmentテーブルのnameカラムが営業部の人の月収の最大値、最小値、平均値、合計値
SELECT name, MAX(payment), MIN(payment), AVG(payment), SUM(payment)
FROM salaries AS sa
INNER JOIN employees AS emp
ON sa.employee_id = emp.id 
INNER JOIN departments AS dt
ON emp.department_id = dt.id
WHERE dt.name = '営業部'


-- classesテーブルのidが、5よりも小さいレコードとそれ以外のレコードを履修している生徒の数
SELECT
    CASE WHEN c.id < 5 THEN 'Less than 5' ELSE 'Greater than or equal to 5' END AS class_category,
    COUNT(DISTINCT e.student_id) AS student_count
FROM enrollments e
JOIN students s ON e.student_id = s.id
JOIN classes c ON e.class_id = c.id
GROUP BY CASE WHEN c.id < 5 THEN 'Less than 5' ELSE 'Greater than or equal to 5' END;

SELECT
CASE WHEN cls.id < 5 THEN 'クラス1' ELSE 'クラス2' END AS 'クラス分類',
COUNT(std.id) 
FROM classes AS cls
INNER JOIN enrollments AS enr
ON cls.id = enr.class_id
INNER JOIN students AS std
ON enr.student_id = std.id
GROUP BY
CASE WHEN cls.id < 5 THEN 'クラス1' ELSE 'クラス2'
END;


-- ageが40より小さい従業員で月収の平均値が7,000,000より大きい人の月収の合計値と平均値
SELECT employees.id, employees.first_name, employees.last_name, employees.age, salaries.total_payment, salaries.average_payment
FROM employees
INNER JOIN (
    SELECT employee_id, SUM(payment) AS total_payment, AVG(payment) AS average_payment
    FROM salaries
    GROUP BY employee_id
) salaries ON employees.id = salaries.employee_id
WHERE age < 40 AND average_payment > 7000000;

SELECT emp.id, SUM(sa.payment), AVG(sa.payment)
FROM employees AS emp
  INNER JOIN salaries AS sa
  ON emp.id = sa.employee_id
WHERE emp.age < 40
GROUP BY emp.id
HAVING AVG(sa.payment) > 7000000 


-- customer毎にorder_amountの合計値を計算
SELECT *, 
    (SELECT SUM(order_amount) FROM orders WHERE customer_id = customers.id) AS total_order_amount
FROM customers;


-- レコード数のカウント
SELECT CONCAT(c.first_name, ' ', c.last_name) AS full_name, COUNT(*) AS record_count
FROM (
    SELECT * FROM customers WHERE last_name LIKE '%田%') AS c
    INNER JOIN (SELECT * FROM orders WHERE order_date >= '2020-12-01') AS o 
    ON c.id = o.customer_id
    INNER JOIN items
    ON o.item_id = items.id
    INNER JOIN (SELECT * FROM stores WHERE name = '山田商店') AS s 
    ON s.id = items.store_id
    GROUP BY full_name;



-- paymentが9,000,000よりも大きいものが存在するレコードを、employeesテーブルから取り出す
SELECT e.id, e.first_name, e.last_name, e.age
FROM employees e
WHERE EXISTS (
  SELECT 1 
  FROM salaries s 
  WHERE e.id = s.employee_id AND s.payment > 9000000
);

SELECT e.id, e.first_name, e.last_name, e.age
FROM employees e
WHERE e.id IN (
  SELECT s.employee_id 
  FROM salaries s 
  WHERE s.payment > 9000000
);

SELECT DISTINCT e.*
FROM employees e
INNER JOIN salaries s ON e.id = s.employee_id
WHERE s.payment > 9000000;
	



-- employeesテーブルからsalariesテーブルと紐付けできないレコードを取り出す。
SELECT * 
FROM employees
WHERE id NOT IN(SELECT employee_id FROM salaries);

SELECT * FROM employees AS emp
LEFT JOIN salaries AS sa
ON emp.id = sa.employee_id
WHERE sa.id IS NULL;

SELECT * FROM employees AS emp
WHERE NOT EXISTS(
  SELECT 1
  FROM salaries AS sa
  WHERE sa.employee_id = emp.id
);


-- employeesテーブルとcustomersテーブルのage同士を比較します
-- customersテーブルの最小age, 平均age, 最大ageとemployeesテーブルのageを比較して、
-- employeesテーブルのageが、最小age未満のものは最小未満、最小age以上で平均age未満のものは平均未満、
-- 平均age以上で最大age未満のものは最大未満、それ以外はその他と表示します
-- WITH句を用いて記述します
WITH customers_age AS(
  SELECT MAX(age) AS max_age, MIN(age) AS min_age, AVG(age) AS avg_age
  FROM customers
)
SELECT
 *,
 CASE 
 	WHEN emp.age < ca.min_age THEN '最小未満'
 	WHEN emp.age < ca.avg_age THEN '平均未満'
 	WHEN emp.age < ca.max_age THEN '最大未満'
 	ELSE 'その他'
 END AS 'customersとの比較'
FROM employees AS emp
CROSS JOIN customers_age AS ca;


-- customersテーブルからageが50よりも大きいレコードを取り出して、ordersテーブルと連結します。
-- customersテーブルのidに対して、ordersテーブルのorder_amount*order_priceのorder_date毎の合計値。
-- 合計値の7日間平均値、合計値の15日平均値、合計値の30日平均値を計算します。
-- 7日間平均、15日平均値、30日平均値が計算できない区間(対象よりも前の日付のデータが十分にない区間)は、空白を表示
WITH tmp_customers AS(
  SELECT * FROM customers
  WHERE age > 50),
tmp_customers_orders AS(
  SELECT 
    tc.id, od.order_date, SUM(od.order_amount * od.order_price) AS payment,
    ROW_NUMBER() OVER(PARTITION BY tc.id ORDER BY od.order_date) AS row_num
  FROM tmp_customers AS tc
  INNER JOIN orders AS od 
  ON tc.id = od.customer_id
  GROUP BY tc.id, od.order_date 
)
SELECT id, order_date, payment,
CASE 
	WHEN row_num < 7 THEN ''
	ELSE AVG(payment) OVER(PARTITION BY id ORDER BY order_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) 
END AS '7日間平均',
CASE 
	WHEN row_num < 15 THEN ''
	ELSE AVG(payment) OVER(PARTITION BY id ORDER BY order_date ROWS BETWEEN 14 PRECEDING AND CURRENT ROW) 
END AS '15日間平均',
CASE
	WHEN row_num < 30 THEN ''
	ELSE AVG(payment) OVER(PARTITION BY id ORDER BY order_date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) 
END AS '30日間平均'
FROM tmp_customers_orders;

