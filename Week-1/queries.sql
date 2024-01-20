--- Question 3
SELECT COUNT(*) FROM public.green_taxi
WHERE lpep_pickup_datetime >=TO_TIMESTAMP(
    '2019-09-18 00:00:00',
    'YYYY-MM-DD HH24:MI:SS'
) AND lpep_dropoff_datetime <= TO_TIMESTAMP(
    '2019-09-18 23:59:59',
    'YYYY-MM-DD HH24:MI:SS'
)

--- Question 4
SELECT DATE(lpep_pickup_datetime) FROM public.green_taxi
WHERE trip_distance = (SELECT MAX(trip_distance) FROM green_taxi)

--- Question 5
SELECT SUM(green_taxi.total_amount) as sum_total_amount, zone_lookup."Borough"
FROM public.green_taxi INNER JOIN zone_lookup
ON green_taxi."PULocationID"=zone_lookup."LocationID"
WHERE DATE(green_taxi.lpep_pickup_datetime)='2019-09-18'::date
GROUP BY zone_lookup."Borough"
HAVING SUM(green_taxi.total_amount) >=50000
ORDER BY SUM(green_taxi.total_amount) DESC

--- Question 6
WITH tips AS (SELECT tip_amount, "DOLocationID"  FROM public.green_taxi
INNER JOIN zone_lookup
ON green_taxi."PULocationID"=zone_lookup."LocationID"
WHERE EXTRACT('month' from DATE(lpep_pickup_datetime) ) = 9 
and EXTRACT('year' from DATE("lpep_pickup_datetime"))=2019
and zone_lookup."Zone"='Astoria')

SELECT MAX(tip_amount), "Zone"
FROM tips
INNER JOIN zone_lookup
ON tips."DOLocationID"=zone_lookup."LocationID"
GROUP BY zone_lookup."Zone"
ORDER BY MAX(tip_amount) DESC