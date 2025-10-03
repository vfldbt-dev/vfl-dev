{{ config(materialized='view') }}

SELECT
    CASE
        WHEN i.item_name IS NOT NULL THEN i.item_name
        ELSE SUBSTR(
            i.cname1 || ' ' || i.cname2 || ' ' || i.cname3 || ' ' || i.cname4 || ' ' || i.cname5 || ' ' || i.cname6,
            1, 500
        )
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
    g.parcode,
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
    END AS negative_stock_alertdisplay,
    g.rem AS grp_rem,
    i.ismetal,
    i.item_name,
    i.price_terms,
    i.price_basis,
    i.invmetal_code,
    i.net_weight,
    i.grs_weight,
    i.job_cost_basis,
    i.job_cost_amt,
    i.other_chg,
    i.part_qty,
    i.certificate_no,
    CASE WHEN COALESCE(i.d_count, 0) = 0 THEN NULL ELSE i.d_count END AS d_count,
    i.d_size,
    i.d_weight,
    i.d_value,
    i.d_desc,
    CASE WHEN COALESCE(i.c_count, 0) = 0 THEN NULL ELSE i.c_count END AS c_count,
    i.c_weight,
    i.c_value,
    i.c_desc,
    CASE WHEN COALESCE(i.o_count, 0) = 0 THEN NULL ELSE i.o_count END AS o_count,
    i.o_weight,
    i.o_value,
    i.o_desc,
    i.routecode,
    r.name AS routeid,
    i.material_type,
    CASE i.material_type
        WHEN 'F' THEN 'Finished Good'
        WHEN 'S' THEN 'Semi Finished Good'
        WHEN 'R' THEN 'Raw Material'
    END AS disp_material_type,
    i.desc1,
    i.desc2,
    i.desc3,
    i.desc4,
    i.desc5,
    i.desc6,
    i.num1,
    i.num2,
    i.num3,
    g.img_convention,
    g.seq AS department_seq,
    s.seq AS section_seq,
    i.num1 AS itemnum1,
    i.num2 AS itemnum2,
    i.num3 AS itemnum3,
    i.autoqtypopup,
    CASE i.autoqtypopup
        WHEN 'Y' THEN 'Yes'
        WHEN 'N' THEN 'No'
    END AS autoqtypopupdisplay,
    i.allow_price_modification,
    CASE i.allow_price_modification
        WHEN 'Y' THEN 'Yes'
        WHEN 'N' THEN 'No'
    END AS allow_price_modificationdisp,
    i.price_change_limit,
    g.rem AS departmentalias,
    s.rem AS sectionalias,
    d.rem AS divisionalias,
    i.pos_return_behavior AS posreturnbehaviour,
    CASE i.pos_return_behavior
        WHEN 'R' THEN 'Only against bill'
        WHEN 'P' THEN 'Based on user policy'
        WHEN 'A' THEN 'Always'
        WHEN 'N' THEN 'Do not allow'
    END AS posreturnbehaviourdisplay,
    i.search_string,
    i.udfstring01, i.udfstring02, i.udfstring03, i.udfstring04, i.udfstring05,
    i.udfstring06, i.udfstring07, i.udfstring08, i.udfstring09, i.udfstring10,
    i.udfstring11, i.udfstring12, i.udfstring13, i.udfstring14, i.udfstring15,
    i.udfstring16, i.udfstring17, i.udfstring18, i.udfstring19, i.udfstring20,
    i.udfstring21, i.udfstring22, i.udfstring23, i.udfstring24, i.udfstring25,
    i.udfstring26, i.udfstring27, i.udfstring28, i.udfstring29, i.udfstring30,
    i.udfstring31, i.udfstring32, i.udfstring33, i.udfstring34, i.udfstring35,
    i.udfstring36, i.udfstring37, i.udfstring38, i.udfstring39, i.udfstring40,
    i.udfnum01, i.udfnum02, i.udfnum03, i.udfnum04, i.udfnum05,
    i.udfnum06, i.udfnum07, i.udfnum08, i.udfnum09, i.udfnum10,
    i.udfdate01, i.udfdate02, i.udfdate03, i.udfdate04, i.udfdate05,
    b.hsn_sac_code,
    b.govt_identifier,
    i.invhsnsacmain_code,
    i.isprice_excludes_tax,
    i.glcode,
    i.slcode,
    gst_itc_appl,
    gl.costapp AS gl_cc_appl,
    i.costsheet_code AS costsheetcode,
    pch.id AS costsheetid,
    gl.glname AS glname,
    sl.slname AS slname,
    i.item_management_mode,
    CASE i.item_management_mode
        WHEN 'I' THEN 'Item wise'
        WHEN 'B' THEN 'Batch wise'
        WHEN 'S' THEN 'Serial wise'
    END AS item_management_mode_display,
    i.validity_mode,
    CASE i.validity_mode
        WHEN 'D' THEN 'Days'
        WHEN 'M' THEN 'Months'
        WHEN 'Y' THEN 'Years'
        WHEN 'N' THEN 'None'
    END AS validity_mode_display,
    i.validity_period,
    i.price_management,
    CASE i.price_management
        WHEN 'I' THEN 'Item'
        WHEN 'B' THEN 'Batch'
    END AS price_management_display,
    i.manage_expiry,
    CASE WHEN i.manage_expiry = 'Y' THEN 'Yes' ELSE 'No' END AS manage_expiry_display,
    i.pos_batch_selection_mode,
    CASE i.pos_batch_selection_mode
        WHEN 'A' THEN 'Auto'
        WHEN 'M' THEN 'Manual'
    END AS pos_batch_selctn_mode_display,
    COALESCE(g.iscreatebatchdocumentwise, 'N') AS iscreatebatchdocumentwise,
    g.doccode AS batchcreation_doc_code
FROM {{ source('raw', 'invitem') }} i
LEFT JOIN {{ source('raw', 'invarticle') }} a ON i.invarticle_code = a.code
LEFT JOIN {{ source('raw', 'invgrp') }} g ON a.grpcode = g.grpcode
LEFT JOIN {{ source('raw', 'prdroutemain') }} r ON i.routecode = r.code
LEFT JOIN {{ source('raw', 'invgrp') }} s ON g.parcode = s.grpcode
LEFT JOIN {{ source('raw', 'invgrp') }} d ON s.parcode = d.grpcode
LEFT JOIN {{ source('raw', 'fintaxmain') }} f ON i.taxcode = f.taxcode
LEFT JOIN {{ source('raw', 'fingl') }} gl ON i.GLCODE = gl.GLCODE
LEFT JOIN {{ source('raw', 'finsl') }} sl ON i.slcode = sl.SLCODE
LEFT JOIN {{ source('raw', 'invhsnsacmain') }} b ON i.invhsnsacmain_code = b.code
LEFT JOIN {{ source('raw', 'prdcostsheethead') }} pch ON i.costsheet_code = pch.CODE;
