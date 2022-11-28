# 주문 금액대별 매출 차지 비중; 특정 금액대의 주문으로 거둔 매출액이 전체 매출에서 차지하는 비율
select ord.total_price_range as `total_price_range` , round(sum(ord.total_price)/
(select sum(t.sales) from
(select  total_price as `sales` from `banulstory.orders` group by order_id, total_price) t)*100,1) as`rate_per_total_price`
from 
    (SELECT o.order_id, 
            case
                
                when o.total_price>= 0 AND o.total_price <10000 then '10000_under'
                when o.total_price>= 10000 AND o.total_price <30000 then '10_30s'
                when o.total_price>= 30000 AND o.total_price <50000 then '30_50s'
                when o.total_price>= 50000 AND o.total_price <70000 then '50_70s'
                when o.total_price>= 70000 AND o.total_price <100000 then '70_10s'
                when o.total_price>= 100000 AND o.total_price <300000 then '100_300s'
                when o.total_price>= 300000 AND o.total_price <500000 then '300_500s'
                when o.total_price>= 500000 then '500000_over'
              
            end as `total_price_range`, o.total_price
           
    FROM `banulstory.orders` as `o`
    group by o.order_id,  o.total_price) as `ord`
group by total_price_range
order by rate_per_total_price desc; 

# 가격대별 상품 분포
select t.price_range, round(count(*)/(select count(*) from `banulstory.product`)*100,1) as`rate_per_price`
from 
  (SELECT case
              when p.price>= 0 AND p.price <10000 then '10000_under'
              when p.price>= 10000 AND p.price <20000 then '10000s'
              when p.price>= 20000 AND p.price <30000 then '20000s'
              when p.price>= 30000 AND p.price <40000 then '30000s'
              when p.price>= 40000 AND p.price <50000 then '40000s'
              when p.price>= 50000 AND p.price <60000 then '50000s'
              when p.price>= 60000 AND p.price <70000 then '60000s'
              when p.price>= 70000 AND p.price <80000 then '70000s'
              when p.price>= 80000 AND p.price <90000 then '80000s'
              when p.price>= 90000 AND p.price <100000 then '90000s'
              when p.price>= 100000 then '100000_over'
            
          end as `price_range` 
  FROM `banulstory.product` as `p`) as `t`
group by t.price_range

# 상품 가격대별 매출 차지 비중; 특정 가격대의 상품으로 거둔 매출액이 전체 매출에서 차지하는 비율
select temp.price_per_one `price_per_one`, 
 sum(amount) as  `rate_price_per_one`  
    from 
    (select product_name,order_id, amount,qty,
            case
                  when amount/qty>= 0 AND amount/qty <10000 then '10000_under'
                  when amount/qty>= 10000 AND amount/qty <20000 then '10000s'
                  when amount/qty>= 20000 AND amount/qty <30000 then '20000s'
                  when amount/qty>= 30000 AND amount/qty <40000 then '30000s'
                  when amount/qty>= 40000 AND amount/qty <50000 then '40000s'
                  when amount/qty>= 50000 AND amount/qty <60000 then '50000s'
                  when amount/qty>= 60000 AND amount/qty <70000 then '60000s'
                  when amount/qty>= 70000 AND amount/qty <80000 then '70000s'
                  when amount/qty>= 80000 AND amount/qty <90000 then '80000s'
                  when amount/qty>= 90000 AND amount/qty <100000 then '90000s'
                  when amount/qty>= 100000 then '100000_over'
                
              end as `price_per_one`
    from `banulstory.orders`
    where amount > 0) temp
    group by temp.price_per_one
    order by rate_price_per_one;