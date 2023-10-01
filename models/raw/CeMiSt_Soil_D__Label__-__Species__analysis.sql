-- models/cemist_soil_d__label__-__species__analysis.sql

WITH src_species_analysis AS (
    SELECT * FROM {{ source('cemist_warehouse', 'CeMiSt_Soil_D__Label__-__Species__analysis') }}
),

stg_species_analysis AS (
    SELECT
        pid,
        sample_no_,
        genus,
        species,
        mcem_number,
        media__only_included_on_hplc_label_,
        analysis_type,
        date,
        project_code,
        created_by,
        data_location,
        storage_location__room__building__freezer__shelf_,
        storage_temperature,
        extraction_method__only_included_on_hplc_label_,
        suspended_in,
        growth_time,
        responsible_pi,
        other_sample_identifiers,
        notes
    FROM src_species_analysis
)

SELECT *
FROM stg_species_analysis
