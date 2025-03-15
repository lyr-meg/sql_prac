-- Write your PostgreSQL query statement below
with c_avg_salary as (
    select
    to_char(pay_date, 'YYYY-MM') as pay_month,
    avg(amount) as c_avg_salary
    from Salary
    group by to_char(pay_date, 'YYYY-MM')
),
d_avg_salary as (
    select
    to_char(pay_date, 'YYYY-MM') as pay_month,
    b.department_id,
    avg(amount) as d_avg_salary
    from Salary as a left join Employee as b
        on a.employee_id = b.employee_id
    group by to_char(pay_date, 'YYYY-MM'), b.department_id
)
select
a.pay_month,
a.department_id,
case when a.d_avg_salary > b.c_avg_salary then 'higher'
    when a.d_avg_salary < b.c_avg_salary then 'lower'
    else 'same' end as comparison
from d_avg_salary as a left join c_avg_salary as b
on a.pay_month = b.pay_month
order by a.pay_month, a.department_id