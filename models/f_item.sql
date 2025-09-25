{{ config(materialized='view') }}

WITH rt AS (
    SELECT 
        rgd.icode,
        rm.name AS route,
        rg.grpname AS routegrp
    FROM {{ source('raw', 'prdroutemain') }} rm
    JOIN {{ source('raw', 'prdroutegrpdet') }} rgd
        ON rm.code = rgd.routecode
    JOIN {{ source('raw', 'prdroutegrp') }} rg
        ON rgd.routegrp_code = rg.code
    QUALIFY DENSE_RANK() OVER (
        PARTITION BY rgd.icode 
        ORDER BY rgd.eff_date DESC, rgd.routecode, rgd.routegrp_code DESC
    ) = 1
)

SELECT 
    item.icode,
    item.divisioncode,
    item.lev1grpname,
    item.sectioncode,
    item.lev2grpname,
    item.grpcode,
    item.grpname,
    rt.route,
    rt.routegrp,
    item.cname1,
    item.cname2,
    item.cname4,
    item.cname5,
    item.cname6,
    item.desc2,
    item.desc3,
    item.desc4,
    item.desc5,
    item.desc6,
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

    -- Compressed image URL
    '.Compressed/' 
    || REPLACE(REPLACE(UPPER(item.cname1), '/', '_'), '.', '_')
    || ' ' || REPLACE(REPLACE(UPPER(item.cname2), '/', '_'), '.', '_') || '.JPG'
    AS image_url,

    -- Original image URL
    '.Original/' 
    || REPLACE(REPLACE(UPPER(item.cname1), '/', '_'), '.', '_')
    || ' ' || REPLACE(REPLACE(UPPER(item.cname2), '/', '_'), '.', '_') || '.JPG'
    AS image_url_original,

    COALESCE(item.ext, 'N') AS extinct,
    item.generated,
    item.last_changed,

    -- Extra fields from v_item.sql
    item.item,
    item.shrtname,
    item.cmpcode,
    item.partycode,
    item.partyname AS party_name_full,
    item.unitname,
    item.rate,
    item.grpname AS item_grpname,
    item.lev1grpname AS grp_lev1,
    item.lev2grpname AS grp_lev2,
    item.parcode AS grp_parcode,
    item.sectioncode AS grp_sectioncode,
    item.divisioncode AS grp_divisioncode,
    item.taxcode,
    item.itemtaxgroupname,
    item.cname3,
    item.ccode1,
    item.ccode2,
    item.ccode3,
    item.ccode4,
    item.ccode5,
    item.ccode6,
    item.charge,
    item.barrq,
    item.barunit,
    item.stkplancode,
    item.rem,
    item.generated,
    item.stockindate,
    item.considerinorder,
    item.considerasfree,
    item.barcode,
    item.listed_mrp,
    item.expiry_date,
    item.ageing_appl,
    item.costing_method,
    item.noninventory,
    item.wsp,
    item.articlecode,
    item.articlename,
    item.invmmrule_code,
    item.invattr2_name,
    item.invattr2_code,
    item.invattr3_name,
    item.invattr3_code,
    item.invattr5_name,
    item.invattr5_code,
    item.invattr6_name,
    item.invattr6_code,
    item.article_mrp,
    item.article_mrprangefrom,
    item.article_mrprangeto,
    item.consignment_item,
    item.isservice,
    item.pos_multiprice_action,
    item.pos_multiprice_actiondisplay,
    item.service_days,
    item.negative_stock_alert,
    item.negative_stock_alertdisplay,
    item.grp_rem,
    item.ismetal,
    item.item_name,
    item.price_terms,
    item.price_basis,
    item.invmetal_code,
    item.net_weight,
    item.grs_weight,
    item.job_cost_basis,
    item.job_cost_amt,
    item.other_chg,
    item.part_qty,
    item.certificate_no,
    item.d_count,
    item.d_size,
    item.d_weight,
    item.d_value,
    item.d_desc,
    item.c_count,
    item.c_weight,
    item.c_value,
    item.c_desc,
    item.o_count,
    item.o_weight,
    item.o_value,
    item.o_desc,
    item.routecode,
    item.material_type,
    item.disp_material_type,
    CURRENT_TIMESTAMP AS upload_time

FROM {{ ref('v_item') }} AS item
LEFT JOIN {{ source('raw', 'invarticle') }} AS invarticle
    ON item.articlecode = invarticle.code
LEFT JOIN {{ source('raw', 'invgrp') }} AS invgrp
    ON invarticle.grpcode = invgrp.grpcode
LEFT JOIN {{ source('raw', 'finsl') }} AS finsl
    ON item.partycode = finsl.slcode
LEFT JOIN rt
    ON item.icode = rt.icode
