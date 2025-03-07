with paired_start_stop as (
select 
*,
lag(status_time) over (partition by server_id order by status_time asc) as paired_status_time_start
from server_utilization),
server_uptime_days as (
select
*,
extract(epoch from (status_time - paired_status_time_start))/60/(60*24) as up_days
from paired_start_stop
where session_status = 'stop')
select round(sum(up_days),0) as total_uptime_days
from server_uptime_days

-- https://datalemur.com/questions/total-utilization-time