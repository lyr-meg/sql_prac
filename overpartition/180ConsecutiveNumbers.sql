-- Write your PostgreSQL query statement below
with Logs2 as (select
*,
lag(num) over (order by id asc) as previous_num,
lead(num) over (order by id asc) as next_num
from Logs)
select
distinct
num as "ConsecutiveNums"
from Logs2 
where num = previous_num and previous_num = next_num
