-- Q1

select
lastName,
party,
votes
from ge
where yr = 2017 and constituency = 'S14000024'
order by votes desc

-- Q2

select
party,
votes,
rank() over (order by votes desc) as posn
from ge
where yr = 2017 and constituency = 'S14000024'
order by votes
