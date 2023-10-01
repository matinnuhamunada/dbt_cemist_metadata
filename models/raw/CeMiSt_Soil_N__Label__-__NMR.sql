-- models/cemist_soil_n__label__-__nmr.sql

WITH src_nmr AS (
    SELECT * FROM {{ source('cemist_warehouse', 'CeMiSt_Soil_N__Label__-__NMR') }}
),

stg_nmr AS (
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
        notes,
        compound_number_is_thesis_,
        previously_known_,
        public_name
    FROM src_nmr
)

SELECT *
FROM stg_nmr
