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
order by party

-- Q3

select yr, party, votes,
rank() over (partition by yr order by votes desc) as posn
from ge
where constituency = 'S14000021'
order by party, yr

-- Q4

select
party,
constituency,
votes,
rank() over (partition by constituency order by votes desc) as posn
from ge
where constituency between 'S14000021' and 'S14000026'
and yr = 2017
order by constituency, posn desc


-- Q5

with ranks as (select
party,
constituency,
votes,
rank() over (partition by constituency order by votes desc) as posn
from ge
where constituency between 'S14000021' and 'S14000026'
and yr = 2017
order by constituency, posn desc)
select *
from ranks where posn = 1

-- Q6

with ranks as (select
party,
constituency,
votes,
rank() over (partition by constituency order by votes desc) as posn
from ge
where constituency like 'S%'
and yr = 2017
order by constituency, posn desc)
select party,
count(*) as seats
from ranks
where posn = 1
group by party
order by party
