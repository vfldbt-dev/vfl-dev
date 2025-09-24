{{ config(materialized='view') }}

/*
{{ config(
    materialized='incremental',
    incremental_strategy='append',
    database='demo_db',
    schema='public'
) }}
*/

SELECT * FROM 

{{ source('raw', 'invitem') }} 