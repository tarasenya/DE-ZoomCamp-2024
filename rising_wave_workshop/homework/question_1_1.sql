WITH max_trip_time AS 
(SELECT MAX(avg) max_time FROM zone_statistics)

SELECT * FROM 
zone_statistics, max_trip_time
WHERE zone_statistics.avg=max_trip_time.max_time;