{{config(materialized='table')}}

SELECT 
s.SLCODE as Site_Code,
s.SHRTNAME as Store_Name,
s.CTNAME as Store_City,
s.ADDRESS as Store_Address,

c.ZONE as Zone,
c."class" as Tier

from {{ref("site_stg")}} s
join {{ref("site2_stg")}} c
on s.CMPCODE=c.CMPCODE
and s.CODE=c.CODE
