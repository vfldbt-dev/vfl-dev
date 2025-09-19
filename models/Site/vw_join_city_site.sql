{{ config(materialized='view') }}

SELECT
    s.*,
    {{ select_with_alias("c", {
        "CODE": "CITY_CODE",
        "CTNAME": "CITY_NAME",
        "CLASS": "CITY_CLASS"
    }) }}
FROM {{ source('raw', 'admsite') }} s
LEFT JOIN {{ source('raw', 'admcity') }} c
    ON s.CTNAME = c.CTNAME
