-- models/cemist_soil_s__label__-__sequences.sql

WITH src_sequences AS (
    SELECT * FROM {{ source('cemist_warehouse', 'CeMiSt_Soil_S__Label__-__Sequences') }}
),

stg_sequences AS (
    SELECT
        pid,
        extract_no_,
        strain,
        genus,
        species,
        source_code,
        sequence_type__genome__metagenome_,
        description,
        date,
        project_code,
        added_by,
        responsible_pi_,
        sequencing_responsible__company,
        original_file_name_and_new_if_renamed,
        data_format,
        technology_used_for_sequencing__machine_number,
        filenames_of_any_related_quality_reports,
        notes,
        metadata_pathway
    FROM src_sequences
)

SELECT *
FROM stg_sequences
