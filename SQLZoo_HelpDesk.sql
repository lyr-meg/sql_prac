-- easy questions
--
-- Q1

select call_date,
Detail
from Issue
where Detail like "%index%" and Detail like "%Oracle%"

-- Q2
select a.Call_date,
b.First_name,
b.Last_name
from Issue a inner join Caller b
on a.Caller_id = b.Caller_id
where First_name = "Samantha"
and Last_name = "Hall"
and Call_date like "%2017-08-14%"

-- Q3
select Status,
count(distinct call_ref) as Volume
from Issue
group by Status

-- Q4
select
count(distinct Call_ref) as mlcc
from Issue left join
Staff on Issue.Assigned_to = Staff.Staff_code
left join Level on Staff.Level_code = Level.Level_code
where Level.Manager = "Y"

-- Q5
select
Shift_date,
Shift_type,
First_name,
Last_name
from Shift left join Staff
on Shift.Manager = Staff.Staff_code
order by Shift_date asc, Shift_type asc

-- Q6
select
Customer.Company_name,
count(distinct Call_ref) as cc
from Issue
left join Caller on Issue.Caller_id = Caller.Caller_id
left join Customer on Caller.Company_ref = Customer.Company_ref
group by Customer.Company_name
having cc>18

-- Q7
select First_name,
Last_name from Caller
where Caller_id not in (select distinct Caller_id from Issue)


-- Q8
with company_calls as (select
Customer.Company_name,
Customer.Contact_id,
count(distinct Call_ref) as nc
from Customer
inner join Caller on Customer.Company_ref = Caller.Company_ref
left join Issue on Issue.Caller_id = Caller.Caller_id
group by Customer.Company_ref
having nc<5)
select
Company_name,
Caller.First_name,
Caller.Last_name,
nc
from company_calls left join Caller
on company_calls.Contact_id = Caller.Caller_id
