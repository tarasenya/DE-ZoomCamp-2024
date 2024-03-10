CREATE MATERIALIZED VIEW zone_of_the_latest_dropoff_time AS (
WITH latest_dropoff_time as (SELECT MAX(tpep_dropoff_datetime) as latest_time FROM trip_data)
SELECT latest_dropoff_time.latest_time, taxi_zone.zone
FROM latest_dropoff_time, trip_data
JOIN taxi_zone
ON trip_data.DOLocationID=taxi_zone.location_id
WHERE trip_data.tpep_dropoff_datetime=latest_dropoff_time.latest_time);
