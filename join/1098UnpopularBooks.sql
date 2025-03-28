-- Write your PostgreSQL query statement below
with avail_books as (
    select 
    *
    from Books
    where available_from not between date '2019-06-23' - interval '1 month' and date '2019-06-23'
), 
copies_sold as (
    select
    a.book_id,
    a.name,
    sum(b.quantity) as copies_sold
    from avail_books as a 
    left join Orders b 
    on a.book_id = b.book_id
        and b.dispatch_date between date '2019-06-23' - interval '1 year' and date '2019-06-23'
    group by a.book_id, a.name
)
select 
book_id, name
from copies_sold
-- &&&&&&&&&&&&&&&&&
where copies_sold is null or copies_sold<10
-- When you write WHERE col = NULL, you're asking for rows where col equals an unknown value, which doesn't make sense because any comparison with NULL results in NULL (which is treated as false in a WHERE clause).

Write your PostgreSQL query statement below
with avail_books as (
    select 
    *
    from Books
    where available_from not between date '2019-06-23' - interval '1 month' and date '2019-06-23'
), 
copies_sold as (
    select
    a.book_id,
    a.name,
    -- &&&&&&&&&&&&&&&&&, no ifnull in postgres
    COALESCE(sum(b.quantity),0) as copies_sold
    from avail_books as a 
    left join Orders b 
    on a.book_id = b.book_id
        and b.dispatch_date between date '2019-06-23' - interval '1 year' and date '2019-06-23'
    group by a.book_id, a.name
)
select 
book_id, name
from copies_sold
where copies_sold<10



with avail_books as (
    select 
    *
    from Books
    where available_from not between date '2019-06-23' - interval '1 month' and date '2019-06-23'
), 
copies_sold as (
    select
    a.book_id,
    a.name,
    -- &&&&&&&&&&&&&&&&&, no if in postgres
    case when sum(b.quantity) is null then 0 else sum(b.quantity) end as copies_sold
    from avail_books as a 
    left join Orders b 
    on a.book_id = b.book_id
        and b.dispatch_date between date '2019-06-23' - interval '1 year' and date '2019-06-23'
    group by a.book_id, a.name
)
select 
book_id, name
from copies_sold
where copies_sold<10