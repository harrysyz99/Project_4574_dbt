WITH RankedReturns AS (
    SELECT
        _FILE,
        _LINE,
        _MODIFIED AS _MODIFIED_TS,
        _FIVETRAN_SYNCED AS _FIVETRAN_SYNCED_TS,
        RETURNED_AT,
        ORDER_ID,
        CAST(IS_REFUNDED AS BOOLEAN) AS IS_REFUNDED,
        ROW_NUMBER() OVER (PARTITION BY ORDER_ID ORDER BY RETURNED_AT DESC) AS rn  -- Ranking returns by date
    FROM {{ source('google_drive', 'RETURNS') }}
)
SELECT
    _FILE,
    _LINE,
    _MODIFIED_TS,
    _FIVETRAN_SYNCED_TS,
    RETURNED_AT,
    ORDER_ID,
    IS_REFUNDED
FROM RankedReturns
WHERE rn = 1 

-- SELECT
--     _FILE,
--     _LINE,
--     _MODIFIED AS _MODIFIED_TS,
--     _FIVETRAN_SYNCED AS _FIVETRAN_SYNCED_TS,
--     RETURNED_AT,
--     ORDER_ID,
--     CAST(IS_REFUNDED AS BOOLEAN) AS IS_REFUNDED
-- FROM {{ source('google_drive', 'RETURNS') }}
