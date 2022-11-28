
# 인천 지역 주문당 평균 구매 금액 (구/군별)
    select state_sales.state as `state`, state_sales.city as `city`, avg(total_price) as `avg_per_state`
      from 
          (select split(cus.address, " " )[SAFE_OFFSET(0)] as state,
          split(cus.address, " " )[SAFE_OFFSET(1)] as city, order_id, total_price
          from `banulstory.orders` as ord inner join `banulstory.customers` as cus 
          on cus.id = ord.id
          group by cus.address, order_id, total_price
          order by order_id) state_sales
    where state ='인천' 
    group by state_sales.state, state_sales.city
    order by avg_per_state desc ;
    
# 경기 지역 주문당 평균 구매 금액 (시/군별)
    select state_sales.state as `state`, state_sales.city as `city`, avg(total_price) as `avg_per_state`
      from 
          (select split(cus.address, " " )[SAFE_OFFSET(0)] as state,
          split(cus.address, " " )[SAFE_OFFSET(1)] as city, order_id, total_price
          from `banulstory.orders` as ord inner join `banulstory.customers` as cus 
          on cus.id = ord.id
          group by cus.address, order_id, total_price
          order by order_id) state_sales
    where state ='경기' 
    group by state_sales.state, state_sales.city
    order by avg_per_state desc ;
    
# 서울 지역 주문당 평균 구매 금액 (구별)
    select state_sales.state as `state`, state_sales.city as `city`, avg(total_price) as `avg_per_state`
      from 
          (select split(cus.address, " " )[SAFE_OFFSET(0)] as state,
          split(cus.address, " " )[SAFE_OFFSET(1)] as city, order_id, total_price
          from `banulstory.orders` as ord inner join `banulstory.customers` as cus 
          on cus.id = ord.id
          group by cus.address, order_id, total_price
          order by order_id) state_sales
    where state ='서울' 
    group by state_sales.state, state_sales.city
    order by avg_per_state desc ;

# 전국 시도별 주문당 평균 매출액
    select state_sales.state, avg(total_price) as `avg_per_state`
      from 
        (select split(cus.address, " " )[SAFE_OFFSET(0)] as state, order_id, total_price
        from `banulstory.orders` as ord inner join `banulstory.customers` as cus 
        on cus.id = ord.id
        group by cus.address, order_id, total_price
        order by order_id) state_sales
    group by state_sales.state
    order by avg_per_state desc ;




