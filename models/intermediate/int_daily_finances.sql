-- Assuming you use SQL Server
WITH DateSeries AS (
    SELECT CAST('2024-01-01' AS DATE) AS DateValue
    UNION ALL
    SELECT DATEADD(day, 1, DateValue)
    FROM DateSeries
    WHERE DateValue < '2024-04-30'
),
OrderSummary AS (
    SELECT 
        CAST(ORDER_AT_TS AS DATE) AS ORDER_DATE,
        SUM(INCOME) AS TOTAL_ORDER_INCOME
    FROM {{ ref("int_fact_order") }}
    GROUP BY CAST(ORDER_AT_TS AS DATE)
),
ExpenseSummary AS (
    SELECT 
        CAST(DATE_TIME AS DATE) AS EXPENSE_DATE,
        SUM(EXPENSE_AMOUNT) AS TOTAL_EXPENSES
    FROM {{ ref("base_google_drive_EXPENSES") }}
    GROUP BY CAST(DATE_TIME AS DATE)
)

SELECT 
    CAST(ds.DateValue as DATE) AS ORDER_DATE,
    COALESCE(os.TOTAL_ORDER_INCOME, 0) AS TOTAL_ORDER_INCOME,
    COALESCE(es.TOTAL_EXPENSES, 0) AS TOTAL_EXPENSES,
    COALESCE(os.TOTAL_ORDER_INCOME, 0) - COALESCE(es.TOTAL_EXPENSES, 0) AS NET_INCOME
FROM DateSeries ds
full JOIN OrderSummary os ON os.ORDER_DATE = ds.DateValue
full JOIN ExpenseSummary es ON es.EXPENSE_DATE = ds.DateValue
-- OPTION (MAXRECURSION 366) -- This allows the recursion to generate dates for a year
ORDER BY ds.DateValue
