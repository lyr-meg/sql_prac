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

-- Q9
with new_shift as (select
Shift_date,
Shift_type,
Manager as role
from Shift
union all
select
Shift_date,
Shift_type,
Operator as role
from Shift
union all
select
Shift_date,
Shift_type,
Engineer1 as role
from Shift
union all
select
Shift_date,
Shift_type,
Engineer2 as role
from Shift)
select
Shift_date,
Shift_type,
COUNT(DISTINCT role) as cw
from new_shift
group by Shift_date,
Shift_type

-- Q10
select
Issue.Call_date,
Staff.First_name,
Staff.Last_name
from Caller
inner join Issue on Caller.Caller_id = Issue.Caller_id
inner join Staff on Issue.Taken_by = Staff.Staff_code
where Caller.First_name="Harry"
order by Call_date desc
limit 1

-- Q11
with Issue_new as (select
date_format(Call_date, "%Y-%m-%d %H") as Call_date_full,
date_format(Call_date, "%Y-%m-%d") as Call_date_day,
date_format(Call_date, "%H") as Call_date_hour,
Call_ref
from Issue),
Issue_new2 as (
select
Issue_new.*,
if(Call_date_hour<12, "Early", "Late") as Shift_type
from Issue_new),
Shift_new as (
select
date_format(Shift_date, '%Y-%m-%d') as Shift_date_day,
Shift_type,
Manager
from Shift)
select
Manager,
Call_date_full as Hr,
count(*) as cc
from Issue_new2 a left join Shift_new b
on a.Call_date_day = b.Shift_date_day
and a.Shift_type = b.Shift_type
group by Manager, Hr

-- Q12
WITH temp1 AS (
    SELECT
        COUNT(DISTINCT Call_ref) AS num_calls,
        COUNT(DISTINCT Caller_id) * 0.2 AS num_top20pcg_callers
    FROM Issue
),
temp2 AS (
    SELECT
        Caller_id,
        COUNT(DISTINCT Call_ref) AS caller_num_calls
    FROM Issue
    GROUP BY Caller_id
),
temp3 AS (
    SELECT
        *,
        ROW_NUMBER() OVER (ORDER BY caller_num_calls DESC) AS row_num
    FROM temp2
)
SELECT
    ROUND(SUM(CASE WHEN temp3.row_num <= temp1.num_top20pcg_callers THEN temp3.caller_num_calls ELSE 0 END) / MAX(temp1.num_calls)*100,4) AS t20pc
FROM
    temp3
CROSS JOIN
    temp1;


-- Q13
with alljoined as (
select
a.Call_date,
a.Call_ref,
b.Caller_id,
c.Company_ref,
c.Company_name
from Issue a left join Caller b
on a.Caller_id = b.Caller_id
left join Customer c
on b.Company_ref = c.Company_ref),
an_customers as (
select
Company_ref
from alljoined
where ((date_format(Call_date, "%H") = 13)
or (date_format(Call_date, "%H") = 19))
and date_format(Call_date, "%i") >=55)
select
Company_name,
count(distinct Call_ref) as abna
from alljoined
where Company_ref not in (select Company_ref from an_customers)
group by Company_name
order by abna desc
limit 1

-- Q14
with alljoined as (select
c.Company_name,
count(distinct a.Caller_id) as issue_count
from Issue a left join Caller b
on a.Caller_id = b.Caller_id
left join Customer c
on b.Company_ref = c.Company_ref
where EXTRACT(YEAR FROM a.Call_date)=2017
and EXTRACT(MONTH FROM a.Call_date)=8
and EXTRACT(DAY FROM a.Call_date)=13
group by c.company_name),
company_callers as (select
a.Company_name,
count(distinct b.Caller_id) as caller_count
from Customer a left join Caller b
on a.Company_ref = b.Company_ref
group by a.Company_name)
select
alljoined.Company_name as company_name,
company_callers.caller_count,
alljoined.issue_count
from alljoined inner join company_callers
on alljoined.Company_name = company_callers.Company_name
and alljoined.issue_count = company_callers.caller_count

-- Q15
with Issues_updated as (select
a.*,
b.Call_date as next_call_date
from Issue a left join Issue b
on a.Call_ref = b.Call_ref-1
and a.Taken_by = b.Taken_by),
filter as (
select * from Issues_updated
where TIMESTAMPDIFF(MINUTE, Call_date, next_call_date) <= 10
order by Call_ref asc, Call_date asc),
create_group as (
select
Call_ref, Call_date, next_call_date, Taken_by,
Call_ref - ROW_NUMBER() OVER (ORDER BY Call_ref) AS grp
from filter)
select grp,
max(Taken_by) as Taken_by,
count(*)+1 as calls,
min(Call_date) as first_call,
max(next_call_date) as last_call
from create_group
group by grp
order by calls desc
limit 1
