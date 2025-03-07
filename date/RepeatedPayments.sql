SELECT
count(*) as payment_count
FROM transactions a
inner JOIN transactions b
ON a.merchant_id = b.merchant_id
and a.credit_card_id = b.credit_card_id
and a.amount = b.amount
and a.transaction_id < b.transaction_id
and EXTRACT(epoch from (a.transaction_timestamp - b.transaction_timestamp))/60 >= -10;

-- https://datalemur.com/questions/repeated-payments