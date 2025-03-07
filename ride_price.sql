-- where and when rides take place, charge customers, and pay drivers the right amount.
-- To do this, we collect latitude and longitude coordinates from the GPS on the driver’s
-- phone every few seconds for the duration of the ride, then use a pricing table to determine a final route and cost.

-- ride_locations
-- +---------------+---------+
-- | ride_id | varchar | - ride that location data is part of
-- | ts | float | - time in seconds since 1/1/1970 ..
-- | lat | float | - latitudinal coordinate
-- | lng | float | - longitudinal coordinate
-- +---------------+---------+

-- Use the following as the rate card to pay drivers (prices are in USD)
-- 'costPerMile': 1.35
-- 'costPerMinute': 0.27
-- 'costMinimum': 5
-- 'pickupCharge': 2.25

-- Q1. Which ride_id took the most amount of time?

select ride_id,
ROUND((MAX(ts) - MIN(ts)) / 60, 2) as duration
from ride_locations
group by ride_id
order by duration desc
limit 1;

-- Q2. Assuming that the GPS information is perfectly accurate, how would you accurately calculate the price we should pay to the driver for each ride
-- simple formula that calculates the price we should pay to the driver for each ride: (costPerMile * distance) + (costPerMinute * duration) + costMinimum + pickupCharge
-- very simple formula to calculate Mile using lat and lng: sqrt((lat2 - lat1)^2 + (lng2 - lng1)^2) * 69

with ride_duration as (
    select ride_id,
    max(ts) - min(ts) as duration
    from ride_locations
    group by ride_id
),
ride_distance_temp as (
    select ride_id,
    ts,
    lat,
    lng,
    lag(lat) over (partition by ride_id order by ts asc) as prev_lat,
    lag(lng) over (partition by ride_id order by ts asc) as pre_lng,
    sqrt((lat - prev_lat)^2 + (lng - pre_lng)^2) * 69 as miles
    from ride_locations
),
ride_distance as (
    select ride_id,
    sum(miles) as miles
    from ride_distance_temp
    group by ride_id
)
select a.ride_id,
    a.miles,
    b.duration,
    (1.35 * a.miles) + (0.27 * b.duration) + 5 + 2.25 as price
    from ride_distance a
    join ride_duration b
    on a.ride_id = b.ride_id










    WITH gps_data_with_lags AS (
       SELECT
           ride_id,
           ts,
           lat,
           lng,
           LAG(ts) OVER(PARTITION BY ride_id ORDER BY ts) AS prev_ts,
           LAG(lat) OVER(PARTITION BY ride_id ORDER BY ts) AS prev_lat,
           LAG(lng) OVER(PARTITION BY ride_id ORDER BY ts) AS prev_lng
       FROM your_table_name
   ),
   distance_and_time_calculation AS (
       SELECT
           ride_id,
           -- Calculate distance in miles using the Haversine formula
           IF(prev_lat IS NOT NULL AND prev_lng IS NOT NULL,
              3959 * 2 * ASIN(SQRT(POWER(SIN(RADIANS(lat - prev_lat)), 2) +
              COS(RADIANS(lat)) * COS(RADIANS(prev_lat)) * POWER(SIN(RADIANS(lng - prev_lng)), 2))),
              0) AS distance_in_miles,
           -- Calculate time difference in minutes
           IF(prev_ts IS NOT NULL,
              (ts - prev_ts) / 60,
              0) AS time_in_minutes
       FROM gps_data_with_lags
   ),
   total_distance_and_time AS (
       SELECT
           ride_id,
           SUM(distance_in_miles) AS total_miles,
           SUM(time_in_minutes) AS total_minutes
       FROM distance_and_time_calculation
       WHERE distance_in_miles > 0
       GROUP BY ride_id
   ),
   payment_calculation AS (
       SELECT
           ride_id,
           total_miles,
           total_minutes,
           GREATEST(5, 2.25 + (total_miles * 1.35) + (total_minutes * 0.27)) AS total_payment
       FROM total_distance_and_time
   )

   SELECT
       ride_id,
       total_miles,
       total_minutes,
       total_payment
   FROM payment_calculation
   ORDER BY total_payment DESC;
