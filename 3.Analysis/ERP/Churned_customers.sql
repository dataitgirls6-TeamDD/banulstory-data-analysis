# 첫 구매날짜에 이탈한 고객 테이블
-- CREATE TEMP TABLE one_order.banulstory AS
--   select id, count(id) AS count_id
--   from (SELECT id, DATE(order_date)
--       FROM `banulstory.banulstory.orders`
--       WHERE id IS NOT NULL
--       GROUP BY id, DATE(order_date)
--       HAVING COUNT(id) = 1
--       ORDER BY 1, 2)
--   group by id
--   having count(id) = 1
--   ORDER BY 1

# 첫 구매에서 이탈한 고객의 상위 주문제품
WITH one_order AS (
  SELECT id
  FROM (
    SELECT order_id, id, DATE(order_date)
    FROM `banulstory.banulstory.orders`
    WHERE id IS NOT NULL
    AND total_price > 0
    GROUP BY order_id, id, order_date
    ORDER BY 2, 3
  )
  GROUP BY id
  HAVING COUNT(id) = 1
  ORDER BY 1
)
SELECT product_name
    , COUNT(*) AS count
    , RANK() OVER (ORDER BY COUNT(*) DESC) AS RN
FROM `banulstory.banulstory.orders` o
  LEFT JOIN `banulstory.banulstory.category` cate ON o.category = cate.category
WHERE id IN (SELECT id FROM one_order)
AND category_group IN ('실', '도서패키지', '패키지모음')
GROUP BY product_name
ORDER BY 2 DESC
LIMIT 50;

# 위 결과를 일반회원의 상위 주문제품과 비교
SELECT product_name
      , COUNT(*) AS count
      , RANK() OVER (ORDER BY COUNT(*) DESC) AS RN
FROM `banulstory.banulstory.orders` o
  LEFT JOIN `banulstory.banulstory.customers` c ON o.id = c.id
  LEFT JOIN `banulstory.banulstory.category` cate ON o.category = cate.category
WHERE membership = '일반회원'
AND total_price > 0
AND category_group IN ('실', '도서패키지', '패키지모음')
GROUP BY product_name
ORDER BY 2 DESC
LIMIT 50;

# 재구매 고객 중 첫구매
# 이탈한 고객의 연령대 특성
WITH one_order AS (
  SELECT id, COUNT(id)
  FROM (
    SELECT order_id, id, DATE(order_date)
    FROM `banulstory.banulstory.orders`
    WHERE id IS NOT NULL
    GROUP BY order_id, id, order_date
    ORDER BY 2, 3
  )
  GROUP BY id
  HAVING COUNT(id) = 1
  ORDER BY 1
)
SELECT ageband
    , COUNT(*) AS count
    , ROUND((COUNT(*) / (SELECT COUNT(*) FROM `banulstory.banulstory.customers`
                          WHERE id IN (SELECT id FROM one_order) AND ageband IS NOT NULL))*100, 2) AS percent
FROM `banulstory.banulstory.customers`
WHERE id IN (SELECT id FROM one_order)
AND ageband IS NOT NULL
GROUP BY ageband
ORDER BY 2 DESC


# 전체의 각 연령대 중 이탈고객 비율
WITH one_order AS (
  SELECT id, COUNT(id)
  FROM (
    select order_id, id, DATE(order_date)
    from `banulstory.banulstory.orders`
    WHERE id IS NOT NULL
    group by order_id, id, order_date
    order by 2, 3
  )
  GROUP BY id
  HAVING COUNT(id) = 1
  ORDER BY 1
)
SELECT ageband, COUNT(*) AS count
    , ROUND((COUNT(*) / (SELECT COUNT(*) FROM `banulstory.banulstory.customers`
                          WHERE id IN (SELECT id FROM one_order) AND ageband IS NOT NULL))*100, 2) AS percent
FROM `banulstory.banulstory.customers`
WHERE id IN (SELECT id FROM one_order)
AND ageband IS NOT NULL
GROUP BY ageband
ORDER BY 1


SELECT ageband, COUNT(*) AS total_count
FROM `banulstory.banulstory.customers`
WHERE ageband IS NOT NULL
GROUP BY ageband
ORDER BY 1