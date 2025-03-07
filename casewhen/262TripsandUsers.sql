-- Write your PostgreSQL query statement below
with trips_banned as (
    select
    *,
    u1.banned as client_banned,
    u2.banned as driver_banned
    from Trips t
    left join Users u1 on t.client_id = u1.users_id
    left join Users u2 on t.driver_id = u2.users_id
    where u1.banned != 'Yes' and u2.banned != 'Yes'
    and request_at >='2013-10-01' and request_at<='2013-10-03'
)
select
request_at as Day,
round(1-sum(case when status = 'completed' then 1.0 else 0 end)/count(distinct id),2) as "Cancellation Rate"
from trips_banned
group by request_at
having count(distinct id) >=1