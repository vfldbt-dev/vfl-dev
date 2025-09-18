{{ config(
    materialized='view',
) }}

SELECT *
/*
    CODE,
    NAME,
    SLCODE,
    CMPCODE,
    SHRTNAME,
    ADDRESS,
    CTNAME
    */
--FROM vflpoc.raw.admcity;
from {{ source('raw', 'admsite') }}
