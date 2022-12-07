-- 최종 쿼리

  -- 
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