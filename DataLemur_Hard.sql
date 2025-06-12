-- Maximize Prime Item Inventory

with sc as(
select 
item_type,
sum(square_footage) as total_sqrt,
count(*) as item_count
from inventory
group by item_type),
max_prime as (
select 
item_type,
Floor(500000/total_sqrt)*item_count as batch_item_count,
500000 - Floor(500000/total_sqrt)*total_sqrt as remained_sqrt
from sc
where item_type = 'prime_eligible'
),
max_nonprime as (
select 
item_type,
FLOOR((select remained_sqrt from max_prime)/total_sqrt)*item_count as batch_item_count
from sc
where item_type = 'not_prime'
)
select item_type, batch_item_count as item_count from max_prime
UNION ALL
select item_type, batch_item_count as item_count from max_nonprime

-- Median Google Search Frequency

with acc as (
SELECT 
*,
sum(num_users) over (order by searches ASC) as acc_users
FROM search_frequency 
order by searches asc
),
median_count as (
select 
sum(num_users)/2 as floor_count,
sum(num_users)/2+1 as ceiling_count
from search_frequency
)
select
round(avg(searches),1) as median 
from acc
where acc_users >= (select floor_count from median_count)
and acc_users <= (select ceiling_count from median_count)

-- 14 7 8, 14/2 = 7
-- 13 7, 13/2 = 6.5 7.5

with cte as (
SELECT *,SUM(num_users) OVER(ORDER BY searches) as running_sum 
, sum(num_users) over () usersum
FROM search_frequency 
)
select round(sum(searches)*1.0/2,1)
from cte
where usersum/2.0 between (running_sum - num_users) and running_sum;

with searches as (
select searches
from search_frequency
group by 
searches,
GENERATE_SERIES(1, num_users))
select round(PERCENTILE_CONT(0.5) within group (order by searches asc)::decimal,1) as median
from searches