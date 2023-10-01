-- models/cemist_soil_b__label__-__environmental__analysis.sql

WITH src_environmental_analysis AS (
    SELECT * FROM {{ source('cemist_warehouse', 'CeMiSt_Soil_B__Label__-__Environmental__analysis') }}
),

stg_environmental_analysis AS (
    SELECT
        pid,
        sample_no_,
        created_from_cemist_a_code,
        sample_type,
        description,
        projet_code,
        analysis_type_,
        date,
        storage_location__building__room__freezer__shelf_,
        storage_temperature,
        data_location,
        created_by,
        responsible_pi,
        organic_extraction_method,
        external_company,
        notes,
        other_identifiers
    FROM src_environmental_analysis
)

SELECT *
FROM stg_environmental_analysis
