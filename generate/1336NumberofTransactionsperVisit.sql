-- Write your PostgreSQL query statement below
with joined as (
    select
    a.*,
    b.transaction_date
    from Visits a left join Transactions b
        on a.visit_date = b.transaction_date and a.user_id = b.user_id
),
num_transactions as (
    select 
    user_id,
    visit_date,
    count(transaction_date) as num_transactions 
    from joined
    group by user_id, visit_date
)
select
b.transactions_count,
count(user_id) as visits_count
from num_transactions a
right join 
    (select generate_series(0, (select max(num_transactions) from num_transactions)) as transactions_count) b
    on a.num_transactions = b.transactions_count
group by b.transactions_count
order by b.transactions_count
