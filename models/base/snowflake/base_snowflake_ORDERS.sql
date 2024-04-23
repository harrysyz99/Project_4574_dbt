-- select
--     _FIVETRAN_ID,
--     STATE,
--     SESSION_ID,
--     CAST(REPLACE(SHIPPING_COST, 'USD ', '') AS NUMERIC) AS SHIPPING_COST,
--     PAYMENT_METHOD,
--     PHONE,
--     TAX_RATE,
--     CLIENT_NAME,
--     ORDER_AT AS ORDER_AT_TS,
--     ORDER_ID,
--     SHIPPING_ADDRESS,
--     PAYMENT_INFO,
--     _FIVETRAN_DELETED,
--     _FIVETRAN_SYNCED AS _FIVETRAN_SYNCED_T

-- FROM {{ source('Snowflake', 'ORDERS') }}

WITH RankedSessions AS (
    SELECT
        _FIVETRAN_ID,
        STATE,
        SESSION_ID,
        CAST(REPLACE(SHIPPING_COST, 'USD ', '') AS NUMERIC) AS SHIPPING_COST,
        PAYMENT_METHOD,
        PHONE,
        TAX_RATE,
        CLIENT_NAME,
        ORDER_AT AS ORDER_AT_TS,
        ORDER_ID,
        SHIPPING_ADDRESS,
        PAYMENT_INFO,
        _FIVETRAN_DELETED,
        _FIVETRAN_SYNCED AS _FIVETRAN_SYNCED_T,
        ROW_NUMBER() OVER (PARTITION BY ORDER_ID ORDER BY SESSION_ID DESC) AS ro -- Adjust ORDER BY if a different column defines "latest"
    FROM {{ source('Snowflake', 'ORDERS') }}
)
SELECT
    _FIVETRAN_ID,
    STATE,
    SESSION_ID,
    SHIPPING_COST,
    PAYMENT_METHOD,
    PHONE,
    TAX_RATE,
    CLIENT_NAME,
    ORDER_AT_TS,
    ORDER_ID,
    SHIPPING_ADDRESS,
    PAYMENT_INFO,
    _FIVETRAN_DELETED,
    _FIVETRAN_SYNCED_T
FROM RankedSessions
WHERE ro = 1