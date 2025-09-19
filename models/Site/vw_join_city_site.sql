{{ config(materialized='view') }}


SELECT
s.*,c.*
/* 
    s.SLCODE as Site_Code,
    s.SHRTNAME as Store_Name,
    s.CTNAME as Store_City,
    s.ADDRESS as Store_Address,
    c.ZONE as Zone,
    --c."CLASS" as Tier
*/
FROM {{ ref("vw_site_stg") }} c
right JOIN {{ ref("vw_site2_stg") }} s
    ON s.CTNAME = c.CTNAME
   --AND s.CODE = c.CODE

