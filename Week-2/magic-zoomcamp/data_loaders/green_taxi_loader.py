import io
import pandas as pd
import logging
import requests
if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test

URL = 'https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/'

@data_loader
def load_data_from_api(*args, **kwargs):
    """
    Template for loading data from API
    """
    
    taxi_dtypes = {
                    'VendorID': pd.Int64Dtype(),
                    'passenger_count': pd.Int64Dtype(),
                    'trip_distance': float,
                    'RatecodeID':pd.Int64Dtype(),
                    'store_and_fwd_flag':str,
                    'PULocationID':pd.Int64Dtype(),
                    'DOLocationID':pd.Int64Dtype(),
                    'payment_type': pd.Int64Dtype(),
                    'fare_amount': float,
                    'extra':float,
                    'mta_tax':float,
                    'tip_amount':float,
                    'tolls_amount':float,
                    'improvement_surcharge':float,
                    'total_amount':float,
                    'congestion_surcharge':float
                }

    # native date parsing 
    parse_dates = ['lpep_pickup_datetime', 'lpep_dropoff_datetime']
    green_taxi_data = pd.DataFrame()

    for k in [10, 11, 12]:
        _url = f'{URL}green_tripdata_2020-{k}.csv.gz'
        print(_url)
        green_taxi_data = pd.concat([green_taxi_data, pd.read_csv(_url, sep=',', 
        compression='gzip', dtype=taxi_dtypes, parse_dates=parse_dates)])
    
    logging.info(f'Shape - {green_taxi_data.shape}')
    return green_taxi_data


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
