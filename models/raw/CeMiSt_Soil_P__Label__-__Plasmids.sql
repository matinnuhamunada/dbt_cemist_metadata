-- models/cemist_soil_p__label__-__plasmids.sql

WITH src_plasmids AS (
    SELECT * FROM {{ source('cemist_warehouse', 'CeMiSt_Soil_P__Label__-__Plasmids') }}
),

stg_plasmids AS (
    SELECT
        pid,
        cemistplasmid_id,
        plasmid_name,
        project_plasmid_id,
        replicon,
        content,
        selection_marker_e__coli_,
        date,
        project_code,
        added_by,
        responsible_pi_,
        verification,
        storagebacterial_host__species_id_,
        plasmid_map_location,
        notes
    FROM src_plasmids
)

SELECT *
FROM stg_plasmids
