-- models/cemist_soil_c__label__-__co-cultures__analysis.sql

WITH src_co_cultures_analysis AS (
    SELECT * FROM {{ source('cemist_warehouse', 'CeMiSt_Soil_C__Label__-__Co-Cultures__analysis') }}
),

stg_co_cultures_analysis AS (
    SELECT
        pid,
        sample_no_,
        species_1,
        species_1_code,
        species_2,
        _species_2_code_,
        medium__only_included_on_hplc_label_,
        date,
        project_code,
        storage_location__building__room__freezer__shelf_,
        storage_temperature,
        analysis_type,
        created_by,
        responsible_pi,
        data_location,
        time__not_included_on_any_label_,
        extraction_method__not_included_on_any_label_,
        solvent,
        species_3,
        species_3_collection_number,
        notes
    FROM src_co_cultures_analysis
)

SELECT *
FROM stg_co_cultures_analysis
