/*계절 별 많이 팔리는 상품*/
--패키지만 뽑는 임시테이블
WITH 
Package AS(
  SELECT *
  FROM `banulstory.orders`A
  LEFT JOIN `banulstory.category`B
  ON A.category = B.category
  WHERE category_group LIKE '%패키지%' AND total_price>0
)
-- 봄 시즌 
SELECT product_name, COUNT(product_name)
FROM Package
WHERE EXTRACT(MONTH from order_date) = 3
  OR EXTRACT(MONTH from order_date) = 4
  OR EXTRACT(MONTH from order_date) = 5
GROUP BY 1
ORDER BY 2 DESC;

WITH 
Package AS(
  SELECT *
  FROM `banulstory.orders`A
  LEFT JOIN `banulstory.category`B
  ON A.category = B.category
  WHERE category_group LIKE '%패키지%' AND total_price>0
)
-- 여름 시즌 
SELECT product_name, COUNT(product_name)
FROM Package
WHERE EXTRACT(MONTH from order_date) = 6
  OR EXTRACT(MONTH from order_date) = 7
  OR EXTRACT(MONTH from order_date) = 8
GROUP BY 1
ORDER BY 2 DESC;

WITH 
Package AS(
  SELECT *
  FROM `banulstory.orders`A
  LEFT JOIN `banulstory.category`B
  ON A.category = B.category
  WHERE category_group LIKE '%패키지%' AND total_price>0
)
-- 가을 시즌 
SELECT product_name, COUNT(product_name)
FROM Package
WHERE EXTRACT(MONTH from order_date) = 9
  OR EXTRACT(MONTH from order_date) = 10
  OR EXTRACT(MONTH from order_date) = 11
GROUP BY 1
ORDER BY 2 DESC;


WITH 
Package AS(
  SELECT *
  FROM `banulstory.orders`A
  LEFT JOIN `banulstory.category`B
  ON A.category = B.category
  WHERE category_group LIKE '%패키지%' AND total_price>0
)
-- 겨울 시즌 
SELECT product_name, COUNT(product_name)
FROM Package
WHERE EXTRACT(MONTH from order_date) = 12
  OR EXTRACT(MONTH from order_date) = 1
  OR EXTRACT(MONTH from order_date) = 2
GROUP BY 1
ORDER BY 2 DESC;