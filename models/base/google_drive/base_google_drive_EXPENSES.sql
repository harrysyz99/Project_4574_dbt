SELECT 
    _FILE,
    _LINE, 
    _MODIFIED,
    _FIVETRAN_SYNCED, 
    CAST(DATE AS DATETIME) AS DATE_TIME, 
    EXPENSE_TYPE, 
    CAST(
            CASE 
                WHEN SUBSTR(EXPENSE_AMOUNT, 1, 1) = '$' THEN REPLACE(EXPENSE_AMOUNT, '$ ', '') 
                ELSE EXPENSE_AMOUNT 
            END 
        AS NUMERIC) AS EXPENSE_AMOUNT
FROM {{ source('google_drive', 'EXPENSES') }}