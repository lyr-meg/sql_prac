-- Write your PostgreSQL query statement below
with aa as (
    select
    *,
    row_number() over(partition by continent order by name) as rn
    from student
)
select
a1.name as "America",
a2.name as "Asia",
a3.name as "Europe"
from aa as a1
    left join aa as a2 on a1.rn = a2.rn and a2.continent='Asia'
    left join aa as a3 on a1.rn = a3.rn and a3.continent='Europe'
where a1.continent = 'America'