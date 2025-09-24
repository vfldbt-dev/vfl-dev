{{ config(materialized='view') }}

WITH item_base AS (
    SELECT
        CASE
            WHEN i.item_name IS NOT NULL THEN i.item_name
            ELSE CONCAT_WS(' ', i.cname1, i.cname2, i.cname3, i.cname4, i.cname5, i.cname6)
        END AS item,
        i.shrtname,
        i.cmpcode,
        i.icode,
        i.partycode,
        i.partyname,
        i.unitname,
        i.rate,
        g.grpname,
        g.grpcode,
        g.lev1grpname,
        g.lev2grpname,
        g.parcode AS sectioncode,
        s.parcode AS divisioncode,
        i.taxcode,
        f.taxname AS itemtaxgroupname,
        i.cname1,
        i.ccode1,
        i.cname2,
        i.ccode2,
        i.cname3,
        i.ccode3,
        i.cname4,
        i.ccode4,
        i.cname5,
        i.ccode5,
        i.cname6,
        i.ccode6,
        i.mrp,
        i.charge,
        i.barrq,
        i.barunit,
        i.stkplancode,
        i.rem,
        i.ext,
        i.generated,
        i.last_changed,
        i.stockindate,
        i.considerinorder,
        i.considerasfree,
        i.barcode,
        i.listed_mrp,
        i.expiry_date,
        g.cat1infamily,
        g.cat2infamily,
        g.cat3infamily,
        g.cat4infamily,
        g.cat5infamily,
        g.cat6infamily,
        g.attr1prompt,
        g.attr2prompt,
        g.attr3prompt,
        g.attr4prompt,
        g.attr5prompt,
        g.attr6prompt,
        a.cat1prompt,
        a.cat2prompt,
        a.cat3prompt,
        a.cat4prompt,
        a.cat5prompt,
        a.cat6prompt,
        i.desc1 AS itemdesc1,
        i.desc2 AS itemdesc2,
        i.desc3 AS itemdesc3,
        i.desc4 AS itemdesc4,
        i.desc5 AS itemdesc5,
        i.desc6 AS itemdesc6,
        g.ageing_appl,
        g.costing_method,
        i.noninventory,
        i.costrate,
        i.wsp,
        i.invarticle_code AS articlecode,
        a.name AS articlename,
        a.invmmrule_code,
        a.invattr1_name,
        a.invattr1_code,
        a.invattr2_name,
        a.invattr2_code,
        a.invattr3_name,
        a.invattr3_code,
        a.invattr4_name,
        a.invattr4_code,
        a.invattr5_name,
        a.invattr5_code,
        a.invattr6_name,
        a.invattr6_code,
        a.mrp AS article_mrp,
        a.mrprangefrom AS article_mrprangefrom,
        a.mrprangeto AS article_mrprangeto,
        CASE 
            WHEN i.grccode IS NULL THEN 'Not a Consignment Item'
            ELSE 'Consignment Item'
        END AS consignment_item,
        i.isservice,
        i.pos_multiprice_action,
        CASE i.pos_multiprice_action
            WHEN 'P' THEN 'Popup'
            WHEN 'L' THEN 'Last Price'
            WHEN 'N' THEN 'Not Applicable'
        END AS pos_multiprice_actiondisplay,
        i.service_days,
        i.negative_stock_alert,
        CASE i.negative_stock_alert
            WHEN 'I' THEN 'Ignore'
            WHEN 'W' THEN 'Warning'
            WHEN 'S' THEN 'Stop'
            WHEN 'P' THEN 'Profile'
        END AS negative_stock_alertdisplay
        -- Add remaining columns following same pattern
    FROM {{ ref('invitem') }} i
    LEFT JOIN {{ ref('invarticle') }} a ON i.invarticle_code = a.code
    LEFT JOIN {{ ref('invgrp') }} g ON a.grpcode = g.grpcode
    LEFT JOIN {{ ref('prdroutemain') }} r ON i.routecode = r.code
    LEFT JOIN {{ ref('invgrp') }} s ON g.parcode = s.grpcode
    LEFT JOIN {{ ref('invgrp') }} d ON s.parcode = d.grpcode
    LEFT JOIN {{ ref('fintaxmain') }} f ON i.taxcode = f.taxcode
    LEFT JOIN {{ ref('invhsnsacmain') }} b ON i.invhsnsacmain_code = b.code
    LEFT JOIN {{ ref('fingl') }} gl ON i.glcode = gl.glcode
    LEFT JOIN {{ ref('prdcostsheethead') }} pch ON i.costsheet_code = pch.code
    LEFT JOIN {{ ref('finsl') }} sl ON i.slcode = sl.slcode
)

SELECT * FROM item_base