-- 일반회원의 첫구매 아이템

  WITH T1 as (SELECT id
  FROM `banulstory.banulstory.orders`
  WHERE id is not null
  )

  -- 2개 이상 구매한 고객의 첫 구매 (사은품, 부자재 제외)
  T2 as(SELECT o.id, product_id, product_name, DATE(order_date) as order_date
  FROM `banulstory.banulstory.orders` as o
  JOIN T1 ON T1.id = o.id
  WHERE category != '999' and category != '12E' and category != '121' and category != '510' and category != '920' -- 사은품, 부자재 제외

  )

  -- SELECT id, SPLIT(product_id, '-')[OFFSET (0)] as prod_id,product_name, order_date  FROM T2 ORDER BY id;

  -- 첫 구매에 초보자 제품을 구매한 사람 중 재구매가 이뤄진 사람 
  -- SELECT SPLIT(product_id, '-')[OFFSET (0)] as prod_id, product_name, count(distinct order_date) as order_cnt, count(*) as cnt_
  -- FROM T2
  -- GROUP BY 1,2
  -- HAVING order_cnt >= 2 AND
  -- prod_id != 'M3464759' AND prod_id != 'M10339374'
  -- ORDER BY order_cnt DESC;

  SELECT SPLIT(product_id, '-')[OFFSET (0)] as prod_id, product_name, count(*) as cnt_
  FROM T2
  GROUP BY 1,2
  ORDER BY cnt_ DESC;

-- 초보자 패키지 상품을 처음으로 구매한 일반회원 분석
-- 초보자 패키지 상품의 product id 찾기
SELECT product_id, product_name 
FROM `banulstory.banulstory.product`
WHERE product_name LIKE '울리울리%' OR 
product_name LIKE '코튼10%' 
GROUP BY 1,2;


SELECT id -- subquery의 A 테이블에서 id
FROM (SELECT id, product_name, count(*) as cnt
FROM `banulstory.banulstory.orders`
WHERE id is not null
AND product_id LIKE 'M3464759%' OR -- 울리울리 키치 브이넥 조끼
product_id LIKE 'M10339374%' -- 코튼10 미니 스퀘어 가방
GROUP BY 1,2
HAVING cnt <= 304) A -- null 제외해도 잡히는 null의 cnt 개수가 305개
;

WITH T AS(
  SELECT id
  FROM (SELECT id, product_name, count(*) as cnt
  FROM `banulstory.banulstory.orders`
  WHERE id is not null
  AND product_id LIKE 'M3464759%' OR -- 울리울리 키치 브이넥 조끼
  product_id LIKE 'M10339374%' -- 코튼10 미니 스퀘어 가방
  GROUP BY 1,2
  HAVING cnt <= 304) A) -- null 제외해도 잡히는 null의 cnt 개수가 305개


SELECT o.id, product_id, product_name, order_date
FROM `banulstory.banulstory.orders` as o
JOIN T ON T.id = o.id
WHERE category != '999'
AND category IN ('101', '650', '450', '118', '230', '530') -- 그 사람이 구매한 패키지
AND order_date IN (SELECT min(order_date)
    FROM `banulstory.orders`
    WHERE product_id LIKE 'M3464759%' OR -- 울리울리 키치 브이넥 조끼
    product_id LIKE 'M10339374%'
    GROUP BY id) -- 코튼10 미니 스퀘어 가방
ORDER BY 1,4,3
;

-- 검증 쿼리
SELECT id, product_name, min(order_date)
FROM `banulstory.orders`
WHERE id = 'aaron0506'
GROUP BY 1,2;

-- count distinct가 2 이상인 것
WITH T1 AS(
  SELECT id
  FROM (SELECT id, product_name, count(*) as cnt
  FROM `banulstory.banulstory.orders`
  WHERE id is not null
  AND product_id LIKE 'M3464759%' OR -- 울리울리 키치 브이넥 조끼
  product_id LIKE 'M10339374%' -- 코튼10 미니 스퀘어 가방
  GROUP BY 1,2
  HAVING cnt <= 304) A) -- null 제외해도 잡히는 null의 cnt 개수가 305개

,T2 AS(SELECT o.id, product_id, product_name, order_date
FROM `banulstory.banulstory.orders` as o
JOIN T1 ON T1.id = o.id
WHERE category != '999'
AND category IN ('101', '650', '450', '118', '230', '530') -- 그 사람이 구매한 패키지
AND order_date IN (SELECT min(order_date) -- 첫 구매가 아래 아이템인 사람
    FROM `banulstory.orders`
    WHERE product_id LIKE 'M3464759%' OR -- 울리울리 키치 브이넥 조끼
    product_id LIKE 'M10339374%' -- 코튼10 미니 스퀘어 가방
    GROUP BY id)
ORDER BY 1,4,3)

-- 첫 구매가 위 상품인 고객이 재구매 한 케이스
SELECT id, product_id, product_name, count(distinct order_date) as cnt_
FROM T2
GROUP BY 1,2,3
HAVING cnt_ >= 2
;

-- 첫 구매 카테고리가 아래 상품인 고객 중 서로 다른 order_date를 갖는 케이스
WITH T1 AS(
  SELECT id
  FROM (SELECT id, product_name, count(distinct DATE(order_date)) as cnt
  FROM `banulstory.banulstory.orders`
  WHERE id is not null
  AND product_id LIKE 'M3464759%' OR -- 울리울리 키치 브이넥 조끼
  product_id LIKE 'M10339374%' -- 코튼10 미니 스퀘어 가방
  GROUP BY 1,2
  HAVING cnt >= 2) A) -- 서로 다른 구매일

,T2 AS
(SELECT o.id, product_id, product_name, order_date
FROM `banulstory.banulstory.orders` as o
JOIN T1 ON T1.id = o.id
WHERE category != '999' -- 사은품 제외
AND order_date IN (SELECT min(order_date) -- 첫 구매가 아래 아이템인 사람
    FROM `banulstory.orders`
    WHERE product_id LIKE 'M3464759%' OR -- 울리울리 키치 브이넥 조끼
    product_id LIKE 'M10339374%' -- 코튼10 미니 스퀘어 가방
    GROUP BY id)
ORDER BY 1,4,3)

-- 첫 구매가 위 상품인 고객이 재구매 한 케이스
SELECT id, product_id, product_name
FROM T2
GROUP BY 1,2,3
HAVING cnt >= 2;

-- 쿼리 검증 (아래 상품을 구매한 사람 중 서로 다른 구매일을 가지는 고객)
SELECT id, cnt
FROM (SELECT id, count(distinct DATE(order_date)) as cnt
FROM `banulstory.banulstory.orders`
WHERE id is not null
AND product_id LIKE 'M3464759%' OR -- 울리울리 키치 브이넥 조끼
product_id LIKE 'M10339374%' -- 코튼10 미니 스퀘어 가방
GROUP BY 1
HAVING cnt >= 2
AND id is not null);



-- 조끼와 가방 패키지를 구매한 사람 중 다른 날짜 포함하여 2회 이상 구매한 고객
WITH T1 as (SELECT id, cnt
FROM (SELECT id, count(distinct DATE(order_date)) as cnt
FROM `banulstory.banulstory.orders`
WHERE id is not null
AND product_id LIKE 'M3464759%' OR -- 울리울리 키치 브이넥 조끼
product_id LIKE 'M10339374%' -- 코튼10 미니 스퀘어 가방
GROUP BY 1
HAVING cnt >= 2
AND id is not null)),

-- 2회 이상 구매한 고객의 첫 구매가 아래 아이템인 사람
T2 as(SELECT o.id, product_id, product_name, DATE(order_date) as order_date
FROM `banulstory.banulstory.orders` as o
JOIN T1 ON T1.id = o.id
WHERE category != '999' -- 사은품 제외
AND order_date IN (SELECT min(order_date) -- 첫 구매가 아래 아이템인 사람
    FROM `banulstory.orders`
    WHERE product_id LIKE 'M3464759%' OR -- 울리울리 키치 브이넥 조끼
    product_id LIKE 'M10339374%' -- 코튼10 미니 스퀘어 가방
    GROUP BY id)
ORDER BY id, order_date)

SELECT SPLIT(product_id, '-')[OFFSET (0)] as prod_id, product_name
FROM T2
GROUP BY 1,2
HAVING prod_id != 'M3464759' OR prod_id != 'M10339374';


-- 최종 쿼리

  -- 조끼와 가방 패키지를 구매한 사람의 id
  WITH T1 as (SELECT id
  FROM `banulstory.banulstory.orders`
  WHERE id is not null
  AND product_id LIKE 'M3464759%' OR  -- 울리울리 키치 브이넥 조끼
      product_id LIKE 'M10339374%' -- 코튼10 미니 스퀘어 가방
  ),

  -- 2개 이상 구매한 고객의 첫 구매가 아래 아이템인 사람
  T2 as(SELECT o.id, product_id, product_name, DATE(order_date) as order_date
  FROM `banulstory.banulstory.orders` as o
  JOIN T1 ON T1.id = o.id
  WHERE category != '999' -- 사은품 제외
  AND order_date IN (SELECT min(order_date) -- 첫 구매가 아래 아이템인 사람
      FROM `banulstory.orders`
      WHERE product_id LIKE 'M3464759%' OR -- 울리울리 키치 브이넥 조끼
      product_id LIKE 'M10339374%' -- 코튼10 미니 스퀘어 가방
      GROUP BY id)
  )

  -- SELECT id, SPLIT(product_id, '-')[OFFSET (0)] as prod_id,product_name, order_date  FROM T2 ORDER BY id;

  -- 첫 구매에 초보자 제품을 구매한 사람 중 재구매가 이뤄진 사람 
  -- SELECT SPLIT(product_id, '-')[OFFSET (0)] as prod_id, product_name, count(distinct order_date) as order_cnt, count(*) as cnt_
  -- FROM T2
  -- GROUP BY 1,2
  -- HAVING order_cnt >= 2 AND
  -- prod_id != 'M3464759' AND prod_id != 'M10339374'
  -- ORDER BY order_cnt DESC;

  SELECT SPLIT(product_id, '-')[OFFSET (0)] as prod_id, product_name, count(*) as cnt_
  FROM T2
  GROUP BY 1,2
  HAVING prod_id != 'M3464759' AND prod_id != 'M10339374' -- 코튼10이랑 울리울리 빼기
  ORDER BY cnt_ DESC;

-- 일반회원 재구매가 많이 이뤄진 상품 top 15

SELECT product_name, count(product_name) as cnt_
FROM (SELECT o.id,product_name, COUNT(DATE(order_date)) as order_cnt
FROM `banulstory.orders` as o
JOIN `banulstory.category`as c ON o.category = c.category
JOIN `banulstory.customers` as cust ON o.id = cust.id
WHERE o.id is not null 
AND c.category_group = '실' or c.category_group LIKE '%패키지%'
AND membership = '일반회원'
GROUP BY 1,2
HAVING order_cnt >= 2) A
GROUP BY 1
ORDER BY cnt_ desc
LIMIT 15;