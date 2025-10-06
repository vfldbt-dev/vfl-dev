{{ config(materialized='view') }}

SELECT 
    item.icode,
    item.divisioncode,
    item.lev1grpname,
    item.sectioncode,
    item.lev2grpname,
    item.grpcode,
    item.barcode,
    item.grpname,
    rt.route,
    rt.routegrp,
    item.cname1,
    item.cname2,
    item.cname4,
    item.cname5,
    item.cname6,
    item.itemdesc2,
    item.itemdesc3,
    item.itemdesc4,
    item.itemdesc5,
    item.itemdesc6,
    item.udfstring02,
    item.udfstring03,
    item.udfstring05,
    item.udfstring07,
    item.udfstring09,
    item.udfstring10,
    item.udfstring20,
    invarticle.invattr1_code,
    invarticle.invattr1_name,
    invarticle.invattr4_code,
    invarticle.invattr4_name,
    item.mrp,
    item.costrate,
    finsl.slname AS partyname,

    -- compressed image URL
    '.Compressed/' || REPLACE(REPLACE(UPPER(item.cname1), '/', '_'), '.', '_')
    || ' ' || REPLACE(REPLACE(UPPER(item.cname2), '/', '_'), '.', '_') || '.JPG'
    AS image_url,

    -- original image URL
    '.Original/' || REPLACE(REPLACE(UPPER(item.cname1), '/', '_'), '.', '_')
    || ' ' || REPLACE(REPLACE(UPPER(item.cname2), '/', '_'), '.', '_') || '.JPG'
    AS image_url_original,

    COALESCE(item.ext, 'N') AS extinct,
    item.generated,
    item.last_changed

FROM {{ ref('v_item') }} item

JOIN {{ source('raw', 'invarticle') }} invarticle
    ON item.articlecode = invarticle.code

JOIN {{ source('raw', 'invgrp') }} invgrp
    ON invarticle.grpcode = invgrp.grpcode

LEFT JOIN {{ source('raw', 'finsl') }} finsl
    ON item.partycode = finsl.slcode

LEFT JOIN (
    SELECT icode, route, routegrp
    FROM (
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
    ) ranked
    WHERE rowrank = 1
) rt
    ON item.icode = rt.icode
