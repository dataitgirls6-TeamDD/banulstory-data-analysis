-- 대시보드용_연령대별 쿼리
-- 1) 요일별 시간대별 주문량
SELECT weekday, ageband
      , timerange
      , COUNT(*) AS product_count
FROM (
  SELECT *
  FROM (
    SELECT id, weekday, timerange
    FROM banulstory.orders
    WHERE total_price > 0
  ) week_time
    INNER JOIN banulstory.customers customer ON week_time.id = customer.id
) a
WHERE weekday IS NOT NULL AND ageband IS NOT NULL
GROUP BY weekday, ageband, timerange
ORDER BY (
  CASE
    WHEN weekday = '월' THEN 1
    WHEN weekday = '화' THEN 2
    WHEN weekday = '수' THEN 3
    WHEN weekday = '목' THEN 4
    WHEN weekday = '금' THEN 5
    WHEN weekday = '토' THEN 6
    WHEN weekday = '일' THEN 7
    ELSE 8
  END
), 2, 4 DESC;

-- 1-2) 주문시간 Top 5
SELECT *
FROM (
  SELECT ageband, weekday, timerange, COUNT(*) AS product_count
      , RANK() OVER (PARTITION BY ageband ORDER BY COUNT(*) DESC) AS RN
  FROM (
    SELECT *
    FROM (
      SELECT id, weekday, timerange
      FROM banulstory.orders
    ) week_time
      INNER JOIN banulstory.customers customer ON week_time.id = customer.id
  ) a
  WHERE weekday IS NOT NULL AND ageband IS NOT NULL
  GROUP BY ageband, weekday, timerange
  ORDER BY 1, 4 DESC
) rank_a
WHERE rank_a.RN < 6;
 
-- 2) 유입 검색어 Top 5
SELECT *
FROM 
  (SELECT c.ageband, o.search, COUNT(*) AS age_search_count
      , DENSE_RANK() OVER (PARTITION BY c.ageband ORDER BY COUNT(*) DESC) AS RN
  FROM banulstory.orders o
    LEFT JOIN banulstory.customers c ON o.id = c.id
  WHERE search IS NOT NULL
  AND search NOT IN ('바늘이야기', 'qksmfdldirl', '송영예의 바늘이야기', '바늘 이야기', '송영예의바늘이야기', '송영애의 바늘이야기', '바늘이야', '송영예바늘이야기', '송영애바늘이야기','송영예 바늘이야기')
  GROUP BY c.ageband, o.search
  ORDER BY (
    CASE
      WHEN ageband = '13-18' THEN 1
      WHEN ageband = '20-24' THEN 2
      WHEN ageband = '25-29' THEN 3
      WHEN ageband = '30-34' THEN 4
      WHEN ageband = '35-39' THEN 5
      WHEN ageband = '40-44' THEN 6
      WHEN ageband = '45-49' THEN 7
      WHEN ageband = '50-54' THEN 8
      WHEN ageband = '55-59' THEN 9
      WHEN ageband = '60-64' THEN 10
      WHEN ageband = '65-69' THEN 11
      WHEN ageband = '70-74' THEN 12
      WHEN ageband = '75-79' THEN 13
      WHEN ageband = '80-84' THEN 14
      ELSE 15
    END
  ), 3 DESC) count_search_ageband
  WHERE count_search_ageband.RN < 6;

-- 3) 구매제품 Top 5
SELECT *
FROM 
  (SELECT c.ageband, o.product_name, COUNT(*) AS ageband_count
      , DENSE_RANK() OVER (PARTITION BY c.ageband ORDER BY COUNT(*) DESC) AS RN
  FROM banulstory.orders o
    LEFT JOIN banulstory.customers c ON o.id = c.id
    LEFT JOIN banulstory.category cate ON o.category = cate.category
  WHERE search IS NOT NULL AND membership IS NOT NULL
  AND o.total_price > 0
  AND cate.category_group IN ('실', '패키지모음', '도서패키지')
  GROUP BY c.ageband, o.product_name
  ORDER BY 3 DESC) count_ageband_product
  WHERE count_ageband_product.RN < 6
  AND ageband IS NOT NULL
  ORDER BY ageband;