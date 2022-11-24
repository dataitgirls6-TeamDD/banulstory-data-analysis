# 바늘이야기 회원 비율
SELECT membership
      , COUNT(*) AS count
      , ROUND(COUNT(*)/ (SELECT COUNT(*) FROM `banulstory.banulstory.customers` WHERE membership IS NOT NULL AND membership !='0')*100, 2) AS percent
FROM `banulstory.banulstory.customers` c
WHERE membership IS NOT NULL AND membership !='0'
GROUP BY membership
ORDER BY  (
    CASE
      WHEN membership = '일반회원' THEN 1
      WHEN membership = 'VIP회원' THEN 2
      WHEN membership = 'VVIP회원' THEN 3
      WHEN membership = 'S-VVIP회원' THEN 4
      ELSE 5
    END
  ), 3 DESC

# 바늘이야기 회원등급별 총 구매비율
SELECT membership
    , SUM(total_price) AS count
    , ROUND((SUM(total_price) / (SELECT SUM(total_price)
                            FROM `banulstory.banulstory.customers` c
                            LEFT JOIN `banulstory.banulstory.orders` o ON c.id = o.id
                            WHERE total_price >0 AND membership IS NOT NULL))*100, 2) AS percent
FROM `banulstory.banulstory.customers` c
  LEFT JOIN `banulstory.banulstory.orders` o ON c.id = o.id
WHERE total_price >0
AND membership IS NOT NULL
GROUP BY membership
ORDER BY   (
    CASE
      WHEN membership = '일반회원' THEN 1
      WHEN membership = 'VIP회원' THEN 2
      WHEN membership = 'VVIP회원' THEN 3
      WHEN membership = 'S-VVIP회원' THEN 4
      ELSE 5
    END
  ), 3 DESC

# 바늘이야기 회원등급별 평균 구매비율
WITH
sale_table AS(
  SELECT DISTINCT order_id, id, total_price, order_date
  FROM `banulstory.orders`
  WHERE total_price>0
)
SELECT membership
    , SUM(total_price) SALE
    , COUNT(order_id) N_PURCHASER
    , SUM(total_price)/COUNT(DISTINCT order_id) ARPPU
FROM sale_table s
  LEFT JOIN `banulstory.banulstory.customers` c ON s.id = c.id
WHERE membership IS NOT NULL
GROUP BY 1
ORDER BY (
    CASE
      WHEN membership = '일반회원' THEN 1
      WHEN membership = 'VIP회원' THEN 2
      WHEN membership = 'VVIP회원' THEN 3
      WHEN membership = 'S-VVIP회원' THEN 4
      ELSE 5
    END
  ), 3 DESC;

