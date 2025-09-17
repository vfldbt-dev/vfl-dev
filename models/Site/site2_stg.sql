{{ config(
    materialized='table',
) }}


SELECT
    CTNAME,
    STORE_SIZE

--FROM vflpoc.raw.admcity;
from {{ source('raw', 'admsite') }}
