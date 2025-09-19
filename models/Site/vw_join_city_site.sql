{{ config(materialized='view') }}

SELECT
    s.*,
    c.ZONE       AS Zone
    --c.* except (CODE,CTNAME)
/*
    s.SLCODE     AS Site_Code,
    s.SHRTNAME   AS Store_Name,
    s.CTNAME     AS Store_City,
    s.ADDRESS    AS Store_Address,
    c.ZONE       AS Zone,
    c."CLASS"    AS Tier
*/
FROM {{ ref("vw_site2_stg") }} s
LEFT JOIN {{ ref("vw_site_stg") }} c
    ON s.CTNAME = c.CTNAME
   --AND s.CODE   = c.CODE


