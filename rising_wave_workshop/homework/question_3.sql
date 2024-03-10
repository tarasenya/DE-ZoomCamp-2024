WITH latest_pickup_time as (SELECT MAX(tpep_pickup_datetime) as latest_time FROM trip_data)

SELECT COUNT(*) as count_pickups, taxi_zone.zone
FROM latest_pickup_time, trip_data
JOIN taxi_zone
ON trip_data.PULocationID=taxi_zone.location_id
WHERE trip_data.tpep_pickup_datetime > latest_pickup_time.latest_time-INTERVAL '17' HOUR
GROUP BY taxi_zone.zone
ORDER BY count_pickups DESC
LIMIT 10;