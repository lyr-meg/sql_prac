-- Write your PostgreSQL query statement below
with product_most_recent as (
    select
    a.product_id,
    b.product_name,
    max(a.order_date) as date_most_recent
    from Orders a left join Products b
        on a.product_id = b.product_id
    group by a.product_id, b.product_name
)
select
a.product_name,
a.product_id,
b.order_id,
a.date_most_recent as order_date
from product_most_recent a left join Orders b
    on a.date_most_recent = b.order_date
    and a.product_id = b.product_id
order by product_name asc, order_id asc