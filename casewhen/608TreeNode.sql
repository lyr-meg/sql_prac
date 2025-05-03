# Write your MySQL query statement below
with leaf as (
    select
    a.*,
    b.id as child_nodes
    from Tree as a left join Tree as b
        on a.id = b.p_id
)
select
distinct
id,
case when p_id is null then 'Root'
    when child_nodes is null then 'Leaf'
    else 'Inner' end as 'type'
 from leaf