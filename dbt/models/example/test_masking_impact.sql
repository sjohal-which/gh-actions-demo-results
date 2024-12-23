{{ config(materialized='table') }}

SELECT id, name AS masked_name
FROM {{ ref('test_masking')}}
