/* 결제취소를 한 상품들*/

--사은품(999)를 제외하고, total_price=0(결제 취소된 제품들)인 칼럼들
WITH
X AS(
SELECT *
FROM `banulstory.orders`
WHERE total_price=0 AND category != "999"
) --총 148861행

--결제 취소한 주문건들의 회원 나이대
SELECT ageband, COUNT(ageband) count
FROM X
LEFT JOIN `banulstory.customers`B
ON X.id = B.id
GROUP BY 1
ORDER BY 2 DESC;

--결제 취소한 주문 상품들
WITH
X AS(
SELECT *
FROM `banulstory.orders`
WHERE total_price=0 AND category != "999"
) --총 148861행
SELECT product_name, COUNT(product_name) count
FROM X
GROUP BY 1
ORDER BY 2 DESC;

--결제취소한 시간대
WITH
X AS(
SELECT *
FROM `banulstory.orders`
WHERE total_price=0 AND category != "999"
) --총 148861행
SELECT EXTRACT(TIME FROM order_date), COUNT(EXTRACT(TIME FROM order_date))
FROM X
GROUP BY 1
ORDER BY 2 DESC;
