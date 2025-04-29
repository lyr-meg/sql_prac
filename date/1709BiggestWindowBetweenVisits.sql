-- Write your PostgreSQL query statement below
with last_visit as (
    select user_id,
    '2021-01-01'::date - max(visit_date)::date as biggest_window
    from UserVisits
    group by user_id
), except_last as (
    select user_id,
    visit_date - lead(visit_date) over(partition by user_id order by visit_date desc) as biggest_window
    from UserVisits
), concat as (
    select * from last_visit
    union
    select * from except_last where biggest_window is not null
    -- NULL signifies an unknown value, and comparing anything to NULL using standard comparison operators (=, !=, <, >, etc.) results in NULL
)
select user_id,
max(biggest_window) as biggest_window
from concat
group by user_id
order by user_id asc
