import pandas as pd
from kafka import KafkaProducer
import json
import time

server = 'localhost:9092'

columns_to_use = ['lpep_pickup_datetime', 'lpep_dropoff_datetime', 'PULocationID',
                  'DOLocationID', 'passenger_count', 'trip_distance', 'tip_amount']


df = pd.read_csv('data/green_tripdata_2019-10.csv.gz', usecols=columns_to_use)

def json_serializer(data):
    return json.dumps(data).encode('utf-8')

producer = KafkaProducer(bootstrap_servers=[server], value_serializer=json_serializer)

green_trips_topic = 'green-trips'

if __name__ == '__main__':
    time_0 = time.time()

    for row in df.itertuples(index=False):
        row_dict = {col :getattr(row, col) for col in row._fields}
        print(row_dict)
        producer.send(green_trips_topic, value=row_dict)    
        time.sleep(0.05)

    producer.flush()

    time_1 = time.time()

    print(f'it took {(time_1-time_0):.1f} seconds')