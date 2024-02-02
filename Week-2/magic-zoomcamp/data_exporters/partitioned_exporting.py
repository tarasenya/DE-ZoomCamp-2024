import pyarrow as pa
import pyarrow.parquet as pq
import os

os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = r'/home/src/personal-gcp.json'
bucket_name = 'ny_green_taxi'
project_id = 'dataengineeringzoomcamp-409819'

table_name = 'green_nyc_taxi_data'

root_path=f'{bucket_name}/{table_name}'

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter


@data_exporter
def export_data(data, *args, **kwargs):
    """
    Exports data to some source.

    Args:
        data: The output from the upstream parent block
        args: The output from any additional upstream blocks (if applicable)

    Output (optional):
        Optionally return any object and it'll be logged and
        displayed when inspecting the block run.
    """
    table = pa.Table.from_pandas(data)

    gcs = pa.fs.GcsFileSystem()

    pq.write_to_dataset(table, root_path=root_path, partition_cols=['lpep_pickup_date'],
    filesystem=gcs)