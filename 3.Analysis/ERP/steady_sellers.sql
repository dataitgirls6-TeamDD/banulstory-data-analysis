-- 1. 스마트스토어 디자이너 패키지 스테디셀러
select distinct rs.product_name, count(*) counting
from `banulstory.banulstory.review_scored` rs
where rs.category ='디자이너 패키지'
group by product_name
order by counting desc

-- 2. 온라인몰
-- 카테고리 칼럼명 변경
-- ALTER TABLE banulstory.category RENAME COLUMN string_field_0 TO category;
-- ALTER TABLE banulstory.category RENAME COLUMN string_field_1 TO category_group;

-- 카테고리 확인
SELECT *
FROM `banulstory.banulstory.category`
;
-- 특정 카테고리만 뽑기
SELECT category
FROM `banulstory.banulstory.category`
WHERE category_group IN ('패키지모음', '도서패키지')
;
-- 전체 기간 동안 카테고리 별 상품 주문량 = 스테디셀러
-- 1) 실
SELECT product_name
      , COUNT(order_id) AS order_cnt
FROM `banulstory.banulstory.orders`
WHERE category IN (SELECT category
                    FROM `banulstory.banulstory.category`
                    WHERE category_group = '실') -- 카테고리 이름이 '실'인 것만
AND order_status NOT LIKE '입금후%' -- '입금후취소완료-환불완료','입금후취소요청-구매자' 제외
GROUP BY product_name
ORDER BY order_cnt DESC
LIMIT 10
;
-- 2) 패키지(패키지모음, 도서패키지)
SELECT product_name
      , COUNT(order_id) AS order_cnt
FROM `banulstory.banulstory.orders`
WHERE category IN (SELECT category
                    FROM `banulstory.banulstory.category`
                    WHERE category_group IN ('패키지모음', '도서패키지')) -- 카테고리가 '패키지'인 것만
AND order_status NOT LIKE '입금후%' -- '입금후취소완료-환불완료','입금후취소요청-구매자' 제외
GROUP BY product_name
ORDER BY order_cnt DESC
LIMIT 10
;
-- 3) 부자재
SELECT product_name
      , COUNT(order_id) AS order_cnt
FROM `banulstory.banulstory.orders`
WHERE category IN (SELECT category
                    FROM `banulstory.banulstory.category`
                    WHERE category_group = '부자재') -- 카테고리가 '부자재'를 포함하는 것만
AND order_status NOT LIKE '입금후%' -- '입금후취소완료-환불완료','입금후취소요청-구매자' 제외
GROUP BY product_name
ORDER BY order_cnt DESC
LIMIT 10
;
-- 4) 바늘
SELECT product_name
      , COUNT(order_id) AS order_cnt
FROM `banulstory.banulstory.orders`
WHERE category = '120' -- 카테고리가 '바늘'인 것만
AND order_status NOT LIKE '입금후%' -- '입금후취소완료-환불완료','입금후취소요청-구매자' 제외
GROUP BY product_name
ORDER BY order_cnt DESC
LIMIT 10
;

-- 5) 단추
SELECT product_name
      , COUNT(order_id) AS order_cnt
FROM `banulstory.banulstory.orders`
WHERE category = '122' -- 카테고리가 '단추'인 것만
AND order_status NOT LIKE '입금후%' -- '입금후취소완료-환불완료','입금후취소요청-구매자' 제외
GROUP BY product_name
ORDER BY order_cnt DESC
LIMIT 10