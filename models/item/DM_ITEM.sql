{{ config(
    materialized='view',
    schema='staging'
) }}

WITH route_ranked AS (
    SELECT
        rgd.icode,
        rm.name AS route,
        rg.grpname AS routegrp,
        DENSE_RANK() OVER (
            PARTITION BY rgd.icode
            ORDER BY rgd.eff_date DESC, rgd.routecode, rgd.routegrp_code DESC
        ) AS rowrank
    FROM {{ source('raw', 'prdroutemain') }} rm
    JOIN {{ source('raw', 'prdroutegrpdet') }} rgd
        ON rm.code = rgd.routecode
    JOIN {{ source('raw', 'prdroutegrp') }} rg
        ON rgd.routegrp_code = rg.code
),
route_final AS (
    SELECT icode, route, routegrp
    FROM route_ranked
    WHERE rowrank = 1
)

SELECT
    i.icode,
    i.divisioncode,
    i.lev1grpname,
    i.sectioncode,
    i.lev2grpname,
    i.grpcode,
    i.grpname,
    rt.route,
    rt.routegrp,
    i.cname1,
    i.cname2,
    i.cname4,
    i.cname5,
    i.cname6,
    i.desc2,
    i.desc3,
    i.desc4,
    i.desc5,
    i.desc6,
    i.udfstring02,
    i.udfstring03,
    i.udfstring05,
    i.udfstring07,
    i.udfstring09,
    i.udfstring10,
    i.udfstring20,
    a.invattr1_code,
    a.invattr1_name,
    a.invattr4_code,
    a.invattr4_name,
    i.mrp,
    i.costrate,
    s.slname AS partyname,
    CONCAT(
        '.Compressed/',
        REPLACE(REPLACE(UPPER(i.cname1), '/', '_'), '.', '_'),
        ' ',
        REPLACE(REPLACE(UPPER(i.cname2), '/', '_'), '.', '_'),
        '.JPG'
    ) AS image_url,
    CONCAT(
        '.Original/',
        REPLACE(REPLACE(UPPER(i.cname1), '/', '_'), '.', '_'),
        ' ',
        REPLACE(REPLACE(UPPER(i.cname2), '/', '_'), '.', '_'),
        '.JPG'
    ) AS image_url_original,
    COALESCE(i.ext, 'N') AS extinct,
    i.generated,
    i.last_changed

FROM {{ ref('v_item') }} i
JOIN {{ source('raw', 'invarticle') }} a
    ON i.articlecode = a.code
JOIN {{ source('raw', 'invgrp') }} g
    ON a.grpcode = g.grpcode
LEFT JOIN {{ source('raw', 'finsl') }} s
    ON i.partycode = s.slcode
LEFT JOIN route_final rt
    ON i.icode = rt.icode
