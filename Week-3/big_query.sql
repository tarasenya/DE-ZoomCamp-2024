-- Set up: 
CREATE OR REPLACE EXTERNAL TABLE green.external_green_tripdata
OPTIONS(
  format = 'PARQUET',
  uris = ['gs://ny_green_taxi/green/green_tripdata_2022-*.parquet']
);

CREATE OR REPLACE TABLE green.green_tripdata_non_partitioned AS
SELECT * FROM `green.external_green_tripdata`;

-- What is count of records for the 2022 Green Taxi Data?
SELECT COUNT(*) FROM `dataengineeringzoomcamp-409819.green.green_tripdata_non_partitioned`;

--What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?

SELECT COUNT(DISTINCT(PULocationID)) FROM `dataengineeringzoomcamp-409819.green.green_tripdata_non_partitioned`;
SELECT COUNT(DISTINCT(PULocationID)) FROM `dataengineeringzoomcamp-409819.green.external_green_tripdata`;

-- How many records have a fare_amount of 0?

SELECT COUNT(*) FROM `dataengineeringzoomcamp-409819.green.green_tripdata_non_partitioned`
WHERE fare_amount=0;

-- Creating partiotioned-clustered table: partition by lpep_pickup_datetime,  cluster on PUlocationID
CREATE OR REPLACE TABLE green.green_tripdata_partitioned_clustered
PARTITION BY DATE(lpep_pickup_datetime)
CLUSTER BY PULocationID AS
SELECT * FROM green.external_green_tripdata;

-- Write a query to retrieve the distinct PULocationID between lpep_pickup_datetime 06/01/2022 and 06/30/2022 (inclusive)
SELECT DISTINCT(PULocationID) FROM green.green_tripdata_non_partitioned
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' AND '2022-06-30';

SELECT DISTINCT(PULocationID) FROM green.green_tripdata_partitioned_clustered
WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' AND '2022-06-30';