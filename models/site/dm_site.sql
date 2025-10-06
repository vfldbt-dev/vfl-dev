{{ config(materialized='view') }}

SELECT
    {{ apply_aliases('dm_site') }}
FROM (
    SELECT
        SITE.CODE,
        NVL(SITE.PSITE_INITIAL, 'NA') AS PSITE_INITIAL,
        SITE.NAME,
        NVL(SITE.REPORTNAME, 'NA') AS REPORTNAME,
        SITE.SITETYPE,
        SITE.INSTALLATION_TYPE,
        SITE.CTNAME,
        SITE.STORE_SIZE,
        SITE.STORE_STARTDT,
        SITE.STORE_CLOSEDT,
        SITE.RPH1,
        SITE.FAX,
        SITE.UDFSTRING01,
        SITE.UDFSTRING04,
        SITE.UDFSTRING10,
        SITE.UDFSTRING15,
        SITE.UDFSTRING29,
        SITE.UDFSTRING31,
        SITE.UDFSTRING32,
        SITE.UDFSTRING33,
        SITE.UDFSTRING34,
        SITE.UDFSTRING38,
        SITE.UDFSTRING39,

        -- AGE logic
        CASE
            WHEN SITE.STORE_CLOSEDT IS NOT NULL
                 AND UPPER(NVL(UDFSTRING15, 'NA')) = 'CLOSED'
                THEN 'CLOSED'
            WHEN SITE.STORE_STARTDT BETWEEN TO_DATE('01-APR-' || TO_CHAR(ADD_MONTHS(CURRENT_DATE, -3), 'YYYY'))
                                       AND CURRENT_DATE
                THEN 'NEW'
            WHEN SITE.STORE_STARTDT BETWEEN TO_DATE('01-APR-' || TO_CHAR(ADD_MONTHS(CURRENT_DATE, -15), 'YYYY'))
                                       AND TO_DATE('31-MAR-' || TO_CHAR(ADD_MONTHS(CURRENT_DATE, -3), 'YYYY'))
                THEN 'ANNUALISED'
            WHEN SITE.STORE_STARTDT < TO_DATE('01-APR-' || TO_CHAR(ADD_MONTHS(CURRENT_DATE, -3) - 1, 'YYYY'))
                THEN 'L2L'
            ELSE 'NA'
        END AS AGE,

        CITY.STNAME,
        CITY.CNNAME,

        -- Zone logic
        CASE
            WHEN UPPER(NVL(CITY.ZONE, 'NA')) = 'CENTRAL'          THEN 'WEST'
            WHEN UPPER(NVL(CITY.STNAME, 'NA')) = 'ANDHRA PRADESH' THEN 'SOUTH 2'
            WHEN UPPER(NVL(CITY.STNAME, 'NA')) = 'TELANGANA'     THEN 'SOUTH 2'
            WHEN UPPER(NVL(CITY.STNAME, 'NA')) = 'KARNATAKA'     THEN 'SOUTH 1'
            WHEN UPPER(NVL(CITY.STNAME, 'NA')) = 'KERALA'        THEN 'SOUTH 1'
            WHEN UPPER(NVL(CITY.STNAME, 'NA')) = 'PUDUCHERRY'    THEN 'SOUTH 1'
            WHEN UPPER(NVL(CITY.STNAME, 'NA')) = 'TAMIL NADU'    THEN 'SOUTH 1'
            ELSE UPPER(NVL(CITY.ZONE, 'NA'))
        END AS ZONE,

        CITY.CLASS,
        SITE.DATAVERSION,
        CURRENT_TIMESTAMP AS UPLOAD_TIME

    FROM {{ source('raw', 'admsite') }} SITE
    LEFT JOIN {{ source('raw', 'admcity') }} CITY
        ON SITE.CTNAME = CITY.CTNAME
) base
