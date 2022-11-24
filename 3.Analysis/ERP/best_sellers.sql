-- 카테고리별 베스트셀러 - 2022년 상반기(22.1.1 ~ 22.6.30)
-- 1) 실
WITH order_date_year AS (
      SELECT *
      FROM `banulstory.banulstory.orders`
      WHERE payment_date BETWEEN '2022-01-01 00:00:00' AND '2022-06-30 23:59:59' 
)

SELECT product_name
      , COUNT(order_id) AS order_cnt
FROM order_date_year
WHERE category IN (SELECT category
                    FROM `banulstory.banulstory.category`
                    WHERE category_group = '실') -- 카테고리 이름이 '실'인 것만
AND order_status NOT LIKE '입금후%' -- '입금후취소완료-환불완료','입금후취소요청-구매자' 제외
GROUP BY product_name
ORDER BY order_cnt DESC
LIMIT 10

-- 2) 패키지(패키지모음, 도서패키지)
WITH order_date_year AS (
      SELECT *
      FROM `banulstory.banulstory.orders`
      WHERE payment_date BETWEEN '2022-01-01 00:00:00' AND '2022-06-30 23:59:59' 
)

SELECT product_name
      , COUNT(order_id) AS order_cnt
FROM order_date_year
WHERE category IN (SELECT category
                    FROM `banulstory.banulstory.category`
                    WHERE category_group IN ('패키지모음', '도서패키지')) -- 카테고리가 '패키지'인 것만
AND order_status NOT LIKE '입금후%' -- '입금후취소완료-환불완료','입금후취소요청-구매자' 제외
GROUP BY product_name
ORDER BY order_cnt DESC
LIMIT 10

-- 3) 부자재
WITH order_date_year AS (
      SELECT *
      FROM `banulstory.banulstory.orders`
      WHERE payment_date BETWEEN '2022-01-01 00:00:00' AND '2022-06-30 23:59:59' 
)

SELECT product_name
      , COUNT(order_id) AS order_cnt
FROM order_date_year
WHERE category IN (SELECT category
                    FROM `banulstory.banulstory.category`
                    WHERE category_group = '부자재') -- 카테고리가 '부자재'를 포함하는 것만
AND order_status NOT LIKE '입금후%' -- '입금후취소완료-환불완료','입금후취소요청-구매자' 제외
GROUP BY product_name
ORDER BY order_cnt DESC
LIMIT 10

-- 4) 단추
WITH order_date_year AS (
      SELECT *
      FROM `banulstory.banulstory.orders`
      WHERE payment_date BETWEEN '2022-01-01 00:00:00' AND '2022-06-30 23:59:59' 
)

SELECT product_name
      , COUNT(order_id) AS order_cnt
FROM order_date_year
WHERE category = '122' -- 카테고리가 '단추'인 것만
AND order_status NOT LIKE '입금후%' -- '입금후취소완료-환불완료','입금후취소요청-구매자' 제외
GROUP BY product_name
ORDER BY order_cnt DESC
LIMIT 10