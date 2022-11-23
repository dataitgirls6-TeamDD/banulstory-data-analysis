-- 대시보드용_오버뷰 쿼리
-- 1) Sale
WITH
d_orders AS(
  SELECT DISTINCT(order_id), total_price, order_date
  FROM `banulstory.orders`
  WHERE total_price>0
)
SELECT *
FROM d_orders;

SUM(total_price)

-- 2) ARPPU(연도별 인당 평균 결제 금액)
WITH
sale_table AS(
  SELECT DISTINCT order_id, total_price, order_date
  FROM `banulstory.orders`
  WHERE total_price>0
)
SELECT SUM(total_price)/COUNT(DISTINCT order_id) ARPPU
FROM sale_table;

-- 3) ATV
SUM(amount)/COUNT(qty)

-- 4) 월별 매출
WITH
d_orders AS(
  SELECT DISTINCT(order_id), total_price, order_date
  FROM `banulstory.orders`
  WHERE total_price>0
)
SELECT *
FROM d_orders;