from pandas import DataFrame
import re
import logging

if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test

if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import data_loader

logging.getLogger().setLevel(logging.INFO)

@transformer
def execute_transformer_action(df: DataFrame, *args, **kwargs) -> DataFrame:
    """
    Execute Transformer Action: ActionType.FILTER

    Docs: https://docs.mage.ai/guides/transformer-blocks#filter
    """
    df_filtered = df[(df.passenger_count>0)&(df.trip_distance>0)]
    logging.info(f'len df {len(df)}, len df_filtered {len(df_filtered)}')
    df_filtered['lpep_pickup_date'] = df_filtered['lpep_pickup_datetime'].dt.date
    
    df_filtered_columns_camel_case = [re.sub('(.)([A-Z][a-z]+)', r'\1_\2', name) for name in df_filtered.columns]
    df_filtered_columns_camel_case = [re.sub('([a-z0-9])([A-Z])', r'\1_\2', name).lower() for name in df_filtered_columns_camel_case]

    logging.info(f'We changed {set(df_filtered_columns_camel_case)-set(df_filtered.columns)} columns')
    df_filtered.columns = df_filtered_columns_camel_case
    logging.info(f'Vendors ids are {df_filtered.vendor_id.unique()}')
    return df_filtered


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert all(output.passenger_count>0)&all(output.trip_distance>0)&(len(output[~output.vendor_id.isin([1,2])])==0) is not None, 'The output is undefined'
