WITH src_environmental_samples AS (
    SELECT * FROM {{ source('cemist_warehouse', 'CeMiSt_Soil_A__Label__-__Environmental__Samples') }}
),

stg_environmental_samples AS (
    SELECT
        pid,
        sample_no_,
        sample_type,
        location,
        gps,
        additional_name,
        description,
        collection_date,
        project_code,
        storage_location__builing__room__freezer__shelf__box_,
        storage_temperature,
        responsible_pi,
        data_added_by,
        soil_temperature,
        airtemperature,
        ph,
        carbon_content,
        nitrogen_content,
        phosphorous_content,
        trace_metal_content,
        soil_type,
        collection_tempetature,
        collection_humidity,
        depth__cm_,
        land_use,
        altitude,
        vegitation,
        notes
    FROM src_environmental_samples
)

SELECT *
    FROM stg_environmental_samples
