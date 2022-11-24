# 1. 주문검색어 확인

SELECT search, COUNT(*) AS count_search
FROM banulstory.orders
WHERE search IS NOT NULL
GROUP BY search
ORDER BY COUNT(*) DESC;


# 2. 연령대별 주문검색어 확인
SELECT *
FROM 
  (SELECT c.ageband, o.search, COUNT(*) AS age_search_count
      , RANK() OVER (PARTITION BY c.ageband ORDER BY COUNT(*) DESC) AS RN
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
  WHERE count_search_ageband.RN < 11;



# 3. 회원등급별 주문검색어 TOP5
SELECT *
FROM 
  (SELECT c.membership, o.search, COUNT(*) AS membership_search_count
      , RANK() OVER (PARTITION BY c.membership ORDER BY COUNT(*) DESC) AS RN
  FROM banulstory.orders o
    LEFT JOIN banulstory.customers c ON o.id = c.id
  WHERE search IS NOT NULL AND membership IS NOT NULL
  AND search NOT IN ('바늘이야기', 'qksmfdldirl', '송영예의 바늘이야기', '바늘 이야기', '송영예의바늘이야기', '송영애의 바늘이야기', '바늘이야', '송영예바늘이야기', '송영애바늘이야기','송영예 바늘이야기')
  GROUP BY c.membership, o.search
  ORDER BY (
    CASE
      WHEN membership = '일반회원' THEN 1
      WHEN membership = 'VIP회원' THEN 2
      WHEN membership = 'VVIP회원' THEN 3
      WHEN membership = 'S-VVIP회원' THEN 4
      ELSE 5
    END
  ), 3 DESC) count_search_membership
  WHERE count_search_membership.RN < 11;

