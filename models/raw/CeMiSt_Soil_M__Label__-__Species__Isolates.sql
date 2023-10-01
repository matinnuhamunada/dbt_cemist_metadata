-- models/cemist_soil_m__label__-__species__isolates.sql

WITH src_species_isolates AS (
    SELECT * FROM {{ source('cemist_warehouse', 'CeMiSt_Soil_M__Label__-__Species__Isolates') }}
),

stg_species_isolates AS (
    SELECT
        pid,
        sample_no_,
        genus,
        species,
        strain,
        additional_name,
        genotype,
        soil_community,
        cemist_plasmid_id,
        plasmid,
        abm,
        isolated_from,
        isolated_by,
        date,
        project_code,
        collection_number,
        created_by,
        storage_location__builing__room__freezer__shelf__,
        storage_temperature,
        responsible_pi,
        verification,
        notes
    FROM src_species_isolates
)

SELECT *
FROM stg_species_isolates
