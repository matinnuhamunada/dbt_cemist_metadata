-- models/cemist_soil_e__label__-__compounds.sql

WITH src_compounds AS (
    SELECT * FROM {{ source('cemist_warehouse', 'CeMiSt_Soil_E__Label__-__Compounds') }}
),

stg_compounds AS (
    SELECT
        pid,
        sample_no_,
        compound_item_name_or_lab_book_code,
        from_species,
        solvent,
        quantity_,
        source_sample_code,
        date,
        project_code,
        created_by,
        storage_location__building__room__freezer__shelf_,
        storage_temperature,
        commercial_source,
        cas_number,
        smiles,
        notes
    FROM src_compounds
)

SELECT *
FROM stg_compounds
