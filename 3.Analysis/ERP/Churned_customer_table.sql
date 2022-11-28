--이탈률
SELECT id, MAX(order_date) MX_ORDER
FROM `banulstory.banulstory.orders`
GROUP BY 1;

-- 이탈률(이탈을 90일로 봤을 때)
SELECT CASE WHEN DIFF >= 90 THEN 'CHURN' ELSE 'NON-CHURN' END CHURN_TYPE,
COUNT(DISTINCT id) N_CUS
FROM
(SELECT id,
MX_ORDER,
DATE_DIFF("2022-11-03",DATE (MX_ORDER), DAY) DIFF
FROM
(SELECT id,
MAX(order_date) MX_ORDER
FROM `banulstory.orders`
GROUP BY 1) BASE) BASE
GROUP BY 1
;

--고객 별 churn table 생성
CREATE TABLE banulstory.CHURN_LIST AS
SELECT CASE WHEN DIFF >= 90 THEN 'CHURN' ELSE 'NON-CHURN' END CHURN_TYPE,
id
FROM
(SELECT id,
MX_ORDER,
'2022-11-03' END_POINT,
DATE_DIFF(DATE '2022-11-03',DATE (MX_ORDER), DAY) DIFF
FROM
(SELECT id,
MAX(order_date) MX_ORDER
FROM `banulstory.orders`
GROUP
BY 1) BASE) BASE
;

--이탈과 카테고리 비교
SELECT B.CHURN_TYPE,
C.category_group,
COUNT(DISTINCT A.id) BU
FROM banulstory.orders A
LEFT
JOIN `banulstory.category` C
ON A.category = C.category
LEFT
JOIN banulstory.CHURN_LIST B
ON B.id = A.id
GROUP
BY 1,2
ORDER
BY 1,3 DESC
;