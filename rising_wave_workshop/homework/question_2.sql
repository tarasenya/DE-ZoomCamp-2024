WITH max_trip_time AS 
(SELECT MAX(avg) max_time FROM zone_statistics_w_count)

SELECT * FROM 
zone_statistics_w_count, max_trip_time
WHERE zone_statistics_w_count.avg=max_trip_time.max_time;