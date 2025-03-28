# Write your MySQL query statement below
with friends as (
    select
    *
    from RequestAccepted

    union

    select
    accepter_id as requester_id,
    requester_id as accepeter_id,
    accept_date
    from RequestAccepted
),
count_friends as (
    select 
    requester_id as id,
    count(distinct accepter_id) as num
    from friends
    group by requester_id)
select id, num
from count_friends order by num desc limit 1
