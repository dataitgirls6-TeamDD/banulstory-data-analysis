# 연령대 비율 확인
SELECT ageband
    , COUNT(*) AS count
    , ROUND(COUNT(*) / (SELECT COUNT(*) 
                        FROM `banulstory.banulstory.customers`
                        WHERE ageband IS NOT NULL
                        AND membership = '일반회원')*100, 2) AS percent
FROM `banulstory.banulstory.customers`
WHERE ageband IS NOT NULL
AND membership = '일반회원'
GROUP BY ageband
ORDER BY 3 DESC

# 20-24가 주로 구매하는 제품_패키지
SELECT *
FROM 
  (SELECT c.ageband, o.product_name, COUNT(*) AS ageband_count
      , RANK() OVER (PARTITION BY c.ageband ORDER BY COUNT(*) DESC) AS RN
  FROM banulstory.orders o
    LEFT JOIN banulstory.customers c ON o.id = c.id
    LEFT JOIN banulstory.category cate ON o.category = cate.category
  WHERE total_price > 0
  AND category_group LIKE '%패키지%'
  AND membership = '일반회원'
  GROUP BY c.ageband, o.product_name
  ORDER BY 3 DESC) count_ageband_product
WHERE count_ageband_product.RN < 16
AND ageband = '20-24'
ORDER BY ageband, 3 DESC;

# 25-29가 주로 구매하는 제품_패키지
SELECT *
FROM 
  (SELECT c.ageband, o.product_name, COUNT(*) AS ageband_count
      , RANK() OVER (PARTITION BY c.ageband ORDER BY COUNT(*) DESC) AS RN
  FROM banulstory.orders o
    LEFT JOIN banulstory.customers c ON o.id = c.id
    LEFT JOIN banulstory.category cate ON o.category = cate.category
  WHERE total_price > 0
  AND category_group LIKE '%패키지%'
  AND membership = '일반회원'
  GROUP BY c.ageband, o.product_name
  ORDER BY 3 DESC) count_ageband_product
WHERE count_ageband_product.RN < 16
AND ageband = '25-29'
ORDER BY ageband, 3 DESC;

# 30-34가 주로 구매하는 제품_패키지
SELECT *
FROM 
  (SELECT c.ageband, o.product_name, COUNT(*) AS ageband_count
      , RANK() OVER (PARTITION BY c.ageband ORDER BY COUNT(*) DESC) AS RN
  FROM banulstory.orders o
    LEFT JOIN banulstory.customers c ON o.id = c.id
    LEFT JOIN banulstory.category cate ON o.category = cate.category
  WHERE total_price > 0
  AND category_group LIKE '%패키지%'
  AND membership = '일반회원'
  GROUP BY c.ageband, o.product_name
  ORDER BY 3 DESC) count_ageband_product
WHERE count_ageband_product.RN < 16
AND ageband = '30-34'
ORDER BY ageband, 3 DESC;


# 20-24가 주로 구매하는 제품_실
SELECT *
FROM 
  (SELECT c.ageband, o.product_name, COUNT(*) AS ageband_count
      , RANK() OVER (PARTITION BY c.ageband ORDER BY COUNT(*) DESC) AS RN
  FROM banulstory.orders o
    LEFT JOIN banulstory.customers c ON o.id = c.id
    LEFT JOIN banulstory.category cate ON o.category = cate.category
  WHERE total_price > 0
  AND category_group LIKE '%실%'
  AND membership = '일반회원'
  GROUP BY c.ageband, o.product_name
  ORDER BY 3 DESC) count_ageband_product
WHERE count_ageband_product.RN < 16
AND ageband = '20-24'
ORDER BY ageband, 3 DESC;

# 25-29가 주로 구매하는 제품_실
SELECT *
FROM 
  (SELECT c.ageband, o.product_name, COUNT(*) AS ageband_count
      , RANK() OVER (PARTITION BY c.ageband ORDER BY COUNT(*) DESC) AS RN
  FROM banulstory.orders o
    LEFT JOIN banulstory.customers c ON o.id = c.id
    LEFT JOIN banulstory.category cate ON o.category = cate.category
  WHERE total_price > 0
  AND category_group LIKE '%실%'
  AND membership = '일반회원'
  GROUP BY c.ageband, o.product_name
  ORDER BY 3 DESC) count_ageband_product
WHERE count_ageband_product.RN < 16
AND ageband = '25-29'
ORDER BY ageband, 3 DESC;

# 30-34가 주로 구매하는 제품_실
SELECT *
FROM 
  (SELECT c.ageband, o.product_name, COUNT(*) AS ageband_count
      , RANK() OVER (PARTITION BY c.ageband ORDER BY COUNT(*) DESC) AS RN
  FROM banulstory.orders o
    LEFT JOIN banulstory.customers c ON o.id = c.id
    LEFT JOIN banulstory.category cate ON o.category = cate.category
  WHERE total_price > 0
  AND category_group LIKE '%실%'
  AND membership = '일반회원'
  GROUP BY c.ageband, o.product_name
  ORDER BY 3 DESC) count_ageband_product
WHERE count_ageband_product.RN < 16
AND ageband = '30-34'
ORDER BY ageband, 3 DESC;

# 연령별 구매요일, 구매시간 TOP5
SELECT *
FROM (
  SELECT ageband, weekday, timerange, COUNT(*) AS count
      , RANK() OVER (PARTITION BY ageband ORDER BY COUNT(*) DESC) AS RN
  FROM (
    SELECT *
    FROM (
      SELECT id, weekday, timerange
      FROM banulstory.orders
      WHERE total_price > 0
    ) week_time
      INNER JOIN banulstory.customers customer ON week_time.id = customer.id
  ) a
  WHERE weekday IS NOT NULL
  AND ageband IS NOT NULL
  AND membership = '일반회원'
  GROUP BY ageband, weekday, timerange
  ORDER BY 1, 4 DESC
) rank_a
WHERE rank_a.RN < 6
AND ageband IN ('20-24','25-29','30-34');


# 20-24 유입 검색어
SELECT *
FROM 
  (SELECT c.ageband, o.search, COUNT(*) AS ageband_search_count
      , RANK() OVER (PARTITION BY c.ageband ORDER BY COUNT(*) DESC) AS RN
  FROM banulstory.orders o
    LEFT JOIN banulstory.customers c ON o.id = c.id
  WHERE search IS NOT NULL AND ageband IS NOT NULL
  AND total_price > 0
  AND search NOT IN ('바늘이야기', 'qksmfdldirl', '송영예의 바늘이야기', '바늘 이야기', '송영예의바늘이야기', '송영애의 바늘이야기', '바늘이야', '송영예바늘이야기', '송영애바늘이야기','송영예 바늘이야기')
  GROUP BY c.ageband, o.search
  ORDER BY 1, 3 DESC) count_search_membership
  WHERE count_search_membership.RN < 11
  AND ageband = '20-24';

# 25-29 유입 검색어
SELECT *
FROM 
  (SELECT c.ageband, o.search, COUNT(*) AS ageband_search_count
      , RANK() OVER (PARTITION BY c.ageband ORDER BY COUNT(*) DESC) AS RN
  FROM banulstory.orders o
    LEFT JOIN banulstory.customers c ON o.id = c.id
  WHERE search IS NOT NULL AND ageband IS NOT NULL
  AND total_price > 0
  AND search NOT IN ('바늘이야기', 'qksmfdldirl', '송영예의 바늘이야기', '바늘 이야기', '송영예의바늘이야기', '송영애의 바늘이야기', '바늘이야', '송영예바늘이야기', '송영애바늘이야기','송영예 바늘이야기')
  GROUP BY c.ageband, o.search
  ORDER BY 1, 3 DESC) count_search_membership
  WHERE count_search_membership.RN < 11
  AND ageband = '25-29';

# 30-34 유입 검색어
SELECT *
FROM 
  (SELECT c.ageband, o.search, COUNT(*) AS ageband_search_count
      , RANK() OVER (PARTITION BY c.ageband ORDER BY COUNT(*) DESC) AS RN
  FROM banulstory.orders o
    LEFT JOIN banulstory.customers c ON o.id = c.id
  WHERE search IS NOT NULL AND ageband IS NOT NULL
  AND total_price > 0
  AND search NOT IN ('바늘이야기', 'qksmfdldirl', '송영예의 바늘이야기', '바늘 이야기', '송영예의바늘이야기', '송영애의 바늘이야기', '바늘이야', '송영예바늘이야기', '송영애바늘이야기','송영예 바늘이야기')
  GROUP BY c.ageband, o.search
  ORDER BY 1, 3 DESC) count_search_membership
  WHERE count_search_membership.RN < 11
  AND ageband = '30-34';