-- Input:
-- Numbers table:
-- +-----+-----------+
-- | num | frequency |
-- +-----+-----------+
-- | 0   | 7         |
-- | 1   | 1         |
-- | 2   | 3         |
-- | 3   | 1         |
-- +-----+-----------+
-- Output:
-- +--------+
-- | median |
-- +--------+
-- | 0.0    |
-- +--------+
-- Explanation:
-- If we decompress the Numbers table, we will get [0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3], so the median is (0 + 0) / 2 = 0.

-- find median numbers and then return the num in between the median
-- over without partition and smart intervals between rolling freq and freq

with t as (select num,
    frequency,
    sum(frequency) over (order by num asc) as rolling_freq,
    sum(frequency) over ()/2.0 as median
    from Numbers)
select round(avg(num)*1.0,1) as median
from t
where median between rolling_freq-frequency and rolling_freq


-- 7-7 7, 8-1 8, 11-3 11, 12-1, 12, median is 6, 7
-- 3-3 3, 5-2 5, 7-2 7, median is 7/2=3.5
-- 3-3 3, 6-3 6, median is 3 4
