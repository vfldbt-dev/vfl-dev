{{ config(materialized='view') }}

FROM {{ ref('v_item') }} AS item
