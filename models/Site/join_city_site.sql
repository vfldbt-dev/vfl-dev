{{ config(materialized='table') }}

SELECT 
    s.SLCODE as Site_Code,
    s.SHRTNAME as Store_Name,
    s.CTNAME as Store_City,
    s.ADDRESS as Store_Address,
    c.ZONE as Zone,
    --c."CLASS" as Tier
FROM {{ ref("site_stg") }} s
JOIN {{ ref("site2_stg") }} c
    ON s.CMPCODE = c.CMPCODE
   --AND s.CODE = c.CODE

