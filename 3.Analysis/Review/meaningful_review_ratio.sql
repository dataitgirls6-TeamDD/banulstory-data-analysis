
# 상품(디자이너 패키지)과 각자 가지고 있는 리뷰 수 대비 유의미한 리뷰의 수, 전체 리뷰수
select  r.product_id, r.product_name, sum(r.label)/count(*) as sumR, count(*) as counting
from `banulstory.banulstory.review_scored` r
where r.category='디자이너 패키지' 
group by r.product_id, r.product_name
order by sumR desc, counting desc;

# 상품(실)과 각자 가지고 있는 리뷰 수 대비 유의미한 리뷰의 수, 전체 리뷰수
select  r.product_id, r.product_name, sum(r.label)/count(*) as sumR, count(*) as counting
from `banulstory.banulstory.review_scored` r
where r.category='실' 
group by r.product_id, r.product_name
order by sumR desc, counting desc;

-- ==================================================================

# 상품(실)과 각자 가지고 있는 리뷰 수 대비 유의미한 리뷰의 수, 전체 리뷰수, 평균 logpoint
select  r.product_id, r.product_name, sum(r.label)/count(*) as sumR, count(*) as counting, SUM(logpoint) as sum_logpoint
from `banulstory.banulstory.review_scored` r
where r.category='실' 
group by r.product_id, r.product_name
order by sum_logpoint desc;

# 상품(디자이너 패키지)과 각자 가지고 있는 리뷰 수 대비 유의미한 리뷰의 수, 전체 리뷰수, logpoint합
WITH cnt_limit AS 
(
  select  r.product_id
    , r.product_name
    -- , sum(r.label)/count(*) as sumR
    , sum(r.label) as sumR_label
    , count(*) as counting
    , SUM(logpoint)as sum_logpoint
  from `banulstory.banulstory.review_scored` r
  where r.category='디자이너 패키지'
  group by r.product_id, r.product_name
  order by sum_logpoint desc
)

SELECT *
FROM cnt_limit
WHERE counting >= 5;

