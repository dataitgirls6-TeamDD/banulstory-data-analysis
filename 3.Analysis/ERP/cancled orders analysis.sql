/*전국 지역별 매출*/

/*지역별 매출 1위: 경기도*/
SELECT region1
    , SUM(total_price) AS sum_total_price
FROM (
  SELECT address  
    , REGEXP_SUBSTR(address, r"^(.+?) ") as region1 /*가장 큰 지역구분: 서울, 경기, ...*/
    , REGEXP_SUBSTR(address, '\\s[가-힣]+[시|군|구] ') as region2 /*그 다음 큰 지역구분: 시, 군, 구*/
    , total_price
  FROM `banulstory.banulstory.orders`
      ) AS region
GROUP BY region1
ORDER BY 2 DESC; 

/*경기도 내 매출 비교: 고양시가 1위*/
SELECT region2
    , SUM(total_price) AS sum_total_price
FROM (
  SELECT address  
    , REGEXP_SUBSTR(address, r"^(.+?) ") as region1 /*가장 큰 지역구분: 서울, 경기, ...*/
    , REGEXP_SUBSTR(address, '\\s[가-힣]+[시|군|구] ') as region2 /*그 다음 큰 지역구분: 시, 군, 구*/
    , total_price
  FROM `banulstory.banulstory.orders`
      ) AS region
WHERE region1 = "경기"
GROUP BY region2
ORDER BY 2 DESC; 