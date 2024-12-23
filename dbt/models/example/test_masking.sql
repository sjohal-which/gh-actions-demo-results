{{ config(materialized='table') }}

WITH source_data AS (
  (SELECT 1 AS id, 'Alice' AS name) UNION ALL
  (SELECT 2 AS id, 'Bob' AS name) UNION ALL
  (SELECT 3 AS id, 'Charlie' AS name)
)
SELECT id, CAST(name AS VARCHAR(255)) AS name
FROM source_data
