{{
    config(
        materialized='view'
    )
}}

with tripdata as 
(
  select *,
  from {{ source('week_4_hw','external_fhv') }}
  where {{ dbt.date_trunc("year", "pickup_datetime") }}==2019
)
select
    -- identifiers
    {{ dbt.safe_cast("PUlocationID", api.Column.translate_type("integer")) }} as pickup_locationid,
    {{ dbt.safe_cast("DOlocationID", api.Column.translate_type("integer")) }} as dropoff_locationid,
    SR_Flag as sr_flag,
    Affiliated_base_number as affiliated_base_number,
    dispatching_base_num as dispatching_base_num,

    -- timestamps
    cast(pickup_datetime as timestamp) as pickup_datetime,
    cast(dropOff_datetime as timestamp) as dropoff_datetime,
    

from tripdata

-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}