{{ config(
    materialized='table',
) }}


SELECT
    CMPCODE,
    CNNAME,
    CODE,
    CTNAME,
    CUS_DISTANCE,
    CUS_GROUP,
    DIST,
    EXT,
    ISD,
    STD,
    STNAME,
    ZONE
--FROM vflpoc.raw.admcity;
from {{ source('raw', 'admcity') }}
