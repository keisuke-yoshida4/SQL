USE day_10_14_db;

SHOW tables;


-- バインド変数
SET @customer_id = 6;
SELECT * FROM customers WHERE id = @customer_id;

SHOW DATABASES;

CREATE DATABASE day_19_21_db;

USE day_19_21_db;

SHOW TABLES;

-- 統計情報の確認
SELECT * FROM mysql.innodb_table_stats WHERE database_name = 'day_19_21_db';

SELECT * FROM prefectures;

INSERT INTO prefectures VALUES('48', '不明');

DELETE FROM prefectures WHERE prefecture_code = "48" AND name = "不明"

-- 統計情報の手動更新
ANALYZE TABLE prefectures;

SELECT * FROM customers;



-- 実行計画を表示
EXPLAIN SELECT * FROM customers;

EXPLAIN ANALYZE SELECT * FROM customers;
/*
-> Limit: 200 row(s)  (cost=52615 rows=200) (actual time=5.57..5.69 rows=200 loops=1)
    -> Table scan on customers  (cost=52615 rows=496462) (actual time=0.0628..0.16 rows=200 loops=1)
*/

EXPLAIN ANALYZE SELECT * FROM customers WHERE id<10;
/*
 -> Limit: 200 row(s)  (cost=2.82 rows=9) (actual time=0.0198..0.0335 rows=9 loops=1)
    -> Filter: (customers.id < 10)  (cost=2.82 rows=9) (actual time=0.0191..0.0319 rows=9 loops=1)
        -> Index range scan on customers using PRIMARY over (id < 10)  (cost=2.82 rows=9) (actual time=0.0174..0.0291 rows=9 loops=1)
 */


EXPLAIN ANALYZE SELECT * FROM customers AS ct
INNER JOIN prefectures AS pr
ON ct.prefecture_code = pr.prefecture_code;
/*
-> Limit: 200 row(s)  (cost=226377 rows=200) (actual time=0.0629..0.403 rows=200 loops=1)
    -> Nested loop inner join  (cost=226377 rows=496462) (actual time=0.062..0.385 rows=200 loops=1)
        -> Filter: (ct.prefecture_code is not null)  (cost=52615 rows=496462) (actual time=0.0519..0.173 rows=200 loops=1)
            -> Table scan on ct  (cost=52615 rows=496462) (actual time=0.0511..0.153 rows=200 loops=1)
        -> Single-row index lookup on pr using PRIMARY (prefecture_code=ct.prefecture_code)  (cost=0.25 rows=1) (actual time=778e-6..822e-6 rows=1 loops=200)
*/

SELECT * FROM customers;

EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name='Olivia';
/*
-> Limit: 200 row(s)  (cost=52615 rows=200) (actual time=0.582..406 rows=200 loops=1)
    -> Filter: (customers.first_name = 'Olivia')  (cost=52615 rows=49646) (actual time=0.558..406 rows=200 loops=1)
        -> Table scan on customers  (cost=52615 rows=496462) (actual time=0.0862..382 rows=192550 loops=1)
*/

-- first_nameにINDEX追加
CREATE INDEX idx_customers_first_name ON customers(first_name);

EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name="Olivia";
/*
-> Limit: 200 row(s)  (cost=282 rows=200) (actual time=1.72..3.31 rows=200 loops=1)
    -> Index lookup on customers using idx_customers_first_name (first_name='Olivia')  (cost=282 rows=503) (actual time=1.72..3.28 rows=200 loops=1)
*/

CREATE INDEX idx_customers_age ON customers(age);

EXPLAIN ANALYZE SELECT * FROM customers WHERE age=41;

DROP INDEX idx_customers_first_name ON customers;
DROP INDEX idx_customers_age ON customers;

CREATE INDEX idx_customers_first_name_age ON customers(first_name,age);

EXPLAIN ANALYZE SELECT * FROM customers WHERE first_name="Olivia" AND age=42;
/*
-> Limit: 200 row(s)  (cost=5.47 rows=10) (actual time=0.164..0.17 rows=10 loops=1)
    -> Index lookup on customers using idx_customers_first_name_age (first_name='Olivia', age=42)  (cost=5.47 rows=10) (actual time=0.164..0.168 rows=10 loops=1)
*/


-- ORDER BY,GROUP BY:処理時間に時間がかかる、実行の前にWHEREで絞り込む
DROP INDEX idx_customers_first_name_age ON customers;

EXPLAIN ANALYZE SELECT * FROM customers ORDER BY first_name;
/*
 -> Limit: 200 row(s)  (cost=50975 rows=200) (actual time=536..536 rows=200 loops=1)
    -> Sort: customers.first_name, limit input to 200 row(s) per chunk  (cost=50975 rows=496462) (actual time=530..530 rows=200 loops=1)
        -> Table scan on customers  (cost=50975 rows=496462) (actual time=0.28..354 rows=500000 loops=1)
*/

CREATE INDEX idx_customers_first_name ON customers(first_name);

-- INDEXあり
EXPLAIN ANALYZE SELECT /*+ INDEX(customers)*/ * FROM customers ORDER BY first_name;
/*
-> Limit: 200 row(s)  (cost=0.308 rows=200) (actual time=0.323..0.88 rows=200 loops=1)
    -> Index scan on customers using idx_customers_first_name  (cost=0.308 rows=200) (actual time=0.322..0.858 rows=200 loops=1)
*/


EXPLAIN ANALYZE SELECT * FROM prefectures AS pr
INNER JOIN customers AS ct 
ON pr.prefecture_code = ct.prefecture_code AND pr.name = "北海道";
/*
 -> Limit: 200 row(s)  (cost=224153 rows=200) (actual time=0.107..17.4 rows=200 loops=1)
    -> Nested loop inner join  (cost=224153 rows=49646) (actual time=0.106..17.4 rows=200 loops=1)
        -> Filter: (ct.prefecture_code is not null)  (cost=50391 rows=496462) (actual time=0.0722..6.07 rows=8583 loops=1)
            -> Table scan on ct  (cost=50391 rows=496462) (actual time=0.0715..5.16 rows=8583 loops=1)
        -> Filter: (pr.`name` = '北海道')  (cost=0.25 rows=0.1) (actual time=0.00117..0.00117 rows=0.0233 loops=8583)
            -> Single-row index lookup on pr using PRIMARY (prefecture_code=ct.prefecture_code)  (cost=0.25 rows=1) (actual time=810e-6..855e-6 rows=1 loops=8583)
 */

CREATE INDEX idx_customers_prefecture_code ON customers(prefecture_code);
/*
 -> Limit: 200 row(s)  (cost=16492 rows=200) (actual time=1.27..1.99 rows=200 loops=1)
    -> Nested loop inner join  (cost=16492 rows=59830) (actual time=1.27..1.97 rows=200 loops=1)
        -> Filter: (pr.`name` = '北海道')  (cost=4.95 rows=4.7) (actual time=0.0742..0.0742 rows=1 loops=1)
            -> Table scan on pr  (cost=4.95 rows=47) (actual time=0.0697..0.0697 rows=1 loops=1)
        -> Index lookup on ct using idx_customers_prefecture_code (prefecture_code=pr.prefecture_code)  (cost=2506 rows=12730) (actual time=1.17..1.85 rows=200 loops=1)
 */

DROP INDEX idx_customers_prefecture_code ON customers;


-- MAX,MINはINDEXを利用
EXPLAIN ANALYZE SELECT MAX(age),MIN(age),AVG(age),SUM(age) FROM customers;
/*
-> Limit: 200 row(s)  (cost=100037 rows=1) (actual time=278..278 rows=1 loops=1)
    -> Aggregate: max(customers.age), min(customers.age), avg(customers.age), sum(customers.age)  (cost=100037 rows=1) (actual time=278..278 rows=1 loops=1)
        -> Table scan on customers  (cost=50391 rows=496462) (actual time=0.15..179 rows=500000 loops=1)
*/

-- DISTINCTではなく、EXIST
-- UNIONよりUNION ALL


SHOW INDEX FROM customers;

DROP INDEX idx_customers_first_name ON customers;

SELECT * FROM customers WHERE 
prefecture_code IN(SELECT prefecture_code FROM prefectures WHERE name="東京都")
OR
prefecture_code IN(SELECT prefecture_code FROM prefectures WHERE name="大阪府");

-- 無駄な処理を1つに
SELECT * FROM customers WHERE prefecture_code IN(SELECT prefecture_code FROM prefectures WHERE name IN("東京都","大阪府"));


SHOW TABLES;

EXPLAIN ANALYZE
SELECT sales_history.*, sales_summary.sales_daily_amount
FROM sales_history
LEFT JOIN
(SELECT sales_day, SUM(sales_amount) AS sales_daily_amount
FROM sales_history 
WHERE sales_day 
BETWEEN '2016-01-01' AND '2016-12-31' 
GROUP BY sales_day) AS sales_summary
ON sales_history.sales_day = sales_summary.sales_day
WHERE sales_history.sales_day BETWEEN '2016-01-01' AND '2016-12-31';
/*
-> Limit: 200 row(s)  (cost=945218 rows=0) (actual time=1504..1505 rows=200 loops=1)
    -> Nested loop left join  (cost=945218 rows=0) (actual time=1504..1505 rows=200 loops=1)
        -> Filter: (sales_history.sales_day between '2016-01-01' and '2016-12-31')  (cost=252282 rows=277172) (actual time=0.0617..0.957 rows=200 loops=1)
            -> Table scan on sales_history  (cost=252282 rows=2.49e+6) (actual time=0.0584..0.542 rows=1569 loops=1)
        -> Index lookup on sales_summary using <auto_key0> (sales_day=sales_history.sales_day)  (cost=0.25..2.5 rows=10) (actual time=7.52..7.52 rows=1 loops=200)
            -> Materialize  (cost=0..0 rows=0) (actual time=1504..1504 rows=336 loops=1)
                -> Table scan on <temporary>  (actual time=1503..1504 rows=336 loops=1)
                    -> Aggregate using temporary table  (actual time=1503..1503 rows=336 loops=1)
                        -> Filter: (sales_history.sales_day between '2016-01-01' and '2016-12-31')  (cost=252282 rows=277172) (actual time=0.172..1351 rows=312844 loops=1)
                            -> Table scan on sales_history  (cost=252282 rows=2.49e+6) (actual time=0.17..660 rows=2.5e+6 loops=1)
*/

EXPLAIN ANALYZE
SELECT sh.*, SUM(sh.sales_amount) OVER(PARTITION BY sh.sales_day)
FROM sales_history AS sh
WHERE sh.sales_day BETWEEN '2016-01-01' AND '2016-12-31';
/*
 -> Limit: 200 row(s)  (actual time=1723..1723 rows=200 loops=1)
    -> Window aggregate with buffering: sum(sales_history.sales_amount) OVER (PARTITION BY sh.sales_day )   (actual time=1723..1723 rows=200 loops=1)
        -> Sort: sh.sales_day  (cost=252282 rows=2.49e+6) (actual time=1720..1720 rows=982 loops=1)
            -> Filter: (sh.sales_day between '2016-01-01' and '2016-12-31')  (cost=252282 rows=2.49e+6) (actual time=0.196..1584 rows=312844 loops=1)
                -> Table scan on sh  (cost=252282 rows=2.49e+6) (actual time=0.193..901 rows=2.5e+6 loops=1)
*/


CREATE TABLE tmp(
    id INT PRIMARY KEY,
    name VARCHAR(50)
);


INSERT INTO tmp VALUES
(1, "A"),
(2, "B"),
(3, "C");

SELECT * FROM tmp;

-- 時間のかかる処理は夜間帯とかに実行しておく。テーブルを作成する等しておく。
CREATE TABLE customer_summary AS
SELECT ct.id, SUM(sh.sales_amount) FROM customers AS ct
INNER JOIN sales_history AS sh
ON ct.id = sh.customer_id
GROUP BY ct.id;

SELECT * FROM customer_summary;




-- 問題点：カラムに対して関数を用いているためインデックスを利用できない
SELECT * FROM sales_summary
WHERE YEAR(sales_date) = "2021" AND MONTH(sales_date) = "12";

-- 改善点：関数を使わずに、同じ意味の構文にする
SELECT * FROM sales_summary
WHERE sales_date BETWEEN "2021-12-01"
AND "2021-12-31";



-- 問題点：カラムに対して関数RTRIMを用いているためインデックスを利用できない(RTRIMは文字列の右側の空白を削除する関数)
SELECT * FROM sales_history
WHERE RTRIM(name) = "product_a";

-- 改善案：LIKEの前方一致を用いた検索を用いて絞り込みを行い、その後RTRIMの検索をする
SELECT * 
FROM 
(SELECT * FROM products WHERE name LIKE "product_a%") AS tmp
WHERE RTRIM(name) = "product_a";



-- 問題点：副問合せを2回実行していて、絞り込みも同じになっている
SELECT * FROM users
WHERE first_name IN(SELECT first_name FROM employees WHERE age < 30)
AND 
last_name IN(SELECT last_name FROM employees WHERE age < 30)

-- 改善点：副問合せを1回にして複数カラムに対する絞り込みをする
SELECT * FROM users
WHERE (first_name, last_name) IN(SELECT first_name, last_name FROM employees WHERE age < 30)