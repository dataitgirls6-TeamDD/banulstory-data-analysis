# order_id 중복제거한 상태에서 2021 신규회원수 구하기
WITH
sale_table AS(
  SELECT DISTINCT order_id
        , cnt_orders
        , DATE(order_date) AS order_date
  FROM `banulstory.orders`
)
SELECT order_date, COUNT(*) AS new_customers_2021
FROM sale_table
WHERE order_date BETWEEN '2021-04-01' AND '2021-10-31'
AND cnt_orders = 0
GROUP BY order_date
ORDER BY 1

# order_id 중복제거한 상태에서 2022 신규회원수 구하기
WITH
sale_table AS(
  SELECT DISTINCT order_id
        , cnt_orders
        , DATE(order_date) AS order_date
  FROM `banulstory.orders`
)
SELECT order_date, COUNT(*) AS new_customers_2022
FROM sale_table
WHERE order_date BETWEEN '2022-04-01' AND '2022-10-31'
AND cnt_orders = 0
GROUP BY order_date
ORDER BY 1

-- SELECT *
-- FROM `banulstory.orders`
-- WHERE order_status NOT IN ('입금후 취소완료-환불완료','반품완료-환불완료','반품완료-환불전','입금후 취소완료','입금후 취소완료-환불접수','입금후 취소완료-환불전','배송전교환 취소완료-환불완료','반품완료','반품요청-구매자','반품완료-환불접수','')


SELECT DISTINCT order_status
FROM `banulstory.orders`

