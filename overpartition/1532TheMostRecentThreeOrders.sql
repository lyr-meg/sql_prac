-- Write your PostgreSQL query statement below
with ranked as (
    select
    a.*,
    b.name as customer_name,
    rank() over (partition by a.customer_id order by order_date desc) as order_rnk
    from Orders a left join Customers b
        on a.customer_id = b.customer_id
)
select
customer_name,
customer_id,
order_id,
order_date
from ranked
where order_rnk<=3
order by customer_name asc, customer_id asc, order_date desc