# 일반회원 중에서는 실 구매율이 가장 높음
WITH order_customer AS (
  SELECT *
  FROM `banulstory.banulstory.orders` o
    LEFT JOIN `banulstory.banulstory.customers` c ON o.id = c.id
    LEFT JOIN `banulstory.banulstory.category` cate ON o.category = cate.category
  WHERE c.membership = '일반회원'
  AND total_price > 0
  AND cate.category_group IS NOT NULL
)
SELECT category_group
      , COUNT(*) AS count
      , ROUND((COUNT(*) / (SELECT COUNT(*) FROM order_customer)*100), 2) AS percent
FROM order_customer
GROUP BY category_group
ORDER BY 2 DESC

# 일반회원 중에 30-34가 가장 비율높음(19%), 그다음이 25-29(17%)
SELECT ageband, COUNT(*) AS count
    , (ROUND((COUNT(*) / (SELECT COUNT(*) FROM banulstory.customers WHERE membership = '일반회원' AND ageband IS NOT NULL))*100, 2)) AS percent
FROM `banulstory.banulstory.customers`
WHERE membership = '일반회원'
AND ageband IS NOT NULL
GROUP BY ageband
ORDER BY 2 DESC

# 일반회원의 연령대별 구매비율 > 30-34세가 가장 높음 > 우리의 고정타겟은 30-34세가 될 수 있음
WITH customer_price AS (
  SELECT *
  FROM `banulstory.banulstory.orders` o
    LEFT JOIN `banulstory.banulstory.customers` c ON o.id = c.id
  WHERE membership = '일반회원'
  AND ageband IS NOT NULL
  AND total_price > 0
)
SELECT ageband
    , SUM(total_price) AS sum_of_total_price
    , ROUND((SUM(total_price) / (SELECT SUM(total_price) FROM customer_price))*100, 2) AS percent_of_total_price
FROM customer_price
GROUP BY ageband
ORDER BY 2 DESC