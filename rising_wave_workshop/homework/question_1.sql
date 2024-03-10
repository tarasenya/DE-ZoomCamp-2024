CREATE MATERIALIZED VIEW zone_statistics_w_count AS 

WITH zone_trip_time AS (
SELECT taxi_zone_1.zone AS pick_up_zone, 
       taxi_zone_2.zone AS drop_off_zone, 
       trip_data.tpep_dropoff_datetime -trip_data.tpep_pickup_datetime 
       AS trip_time
FROM
trip_data
JOIN taxi_zone as taxi_zone_1
ON trip_data.PULocationID=taxi_zone_1.location_id
JOIN taxi_zone as taxi_zone_2
ON trip_data.DOLocationID = taxi_zone_2.location_id)

SELECT MAX(zone_trip_time.trip_time),
       MIN(zone_trip_time.trip_time),
       AVG(zone_trip_time.trip_time),
       COUNT(zone_trip_time.trip_time), 
       zone_trip_time.pick_up_zone, 
       zone_trip_time.drop_off_zone
FROM zone_trip_time       
GROUP BY zone_trip_time.pick_up_zone, zone_trip_time.drop_off_zone;       