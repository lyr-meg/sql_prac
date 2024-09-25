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

-- Q5s
select
Shift_date,
Shift_type,
First_name,
Last_name
from Shift left join Staff
on Shift.Manager = Staff.Staff_code
order by Shift_date asc, Shift_type asc
