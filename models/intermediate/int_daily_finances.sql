WITH AllDates AS (
    SELECT CAST(ORDER_DATE AS DATE) AS REPORT_DATE
    FROM {{ ref("int_fact_order") }}
    UNION
    SELECT CAST(RETURNED_AT AS DATE)
    FROM {{ ref("int_fact_order") }}
    UNION
    SELECT CAST(DATE_TIME AS DATE)
    FROM {{ ref("base_google_drive_EXPENSES") }}
),
OrderSummary AS (
    SELECT 
        ORDER_DATE,
        SUM(INCOME) AS TOTAL_ORDER_INCOME,
        SUM(SHIPPING_COST) AS TOTAL_SHIPPING_COST
    FROM {{ ref("int_fact_order") }}
    GROUP BY ORDER_DATE
),
RefundSummary AS (
    SELECT 
        CAST(RETURNED_AT AS DATE) AS REFUND_DATE,
        SUM(RETURN_AMOUNT) AS TOTAL_REFUNDED
    FROM {{ ref("int_fact_order") }}
    GROUP BY CAST(RETURNED_AT AS DATE)
),
ExpenseSummary AS (
    SELECT 
        CAST(DATE_TIME AS DATE) AS EXPENSE_DATE,
        SUM(EXPENSE_AMOUNT) AS TOTAL_EXPENSES,
        SUM(CASE WHEN EXPENSE_TYPE = 'warehouse' THEN EXPENSE_AMOUNT ELSE 0 END) AS WAREHOUSE_EXPENSE,
        SUM(CASE WHEN EXPENSE_TYPE = 'hr' THEN EXPENSE_AMOUNT ELSE 0 END) AS HR_EXPENSE,
        SUM(CASE WHEN EXPENSE_TYPE = 'tech tool' THEN EXPENSE_AMOUNT ELSE 0 END) AS TECH_TOOL_EXPENSE,
        SUM(CASE WHEN EXPENSE_TYPE = 'other' THEN EXPENSE_AMOUNT ELSE 0 END) AS OTHER_EXPENSE
    FROM {{ ref("base_google_drive_EXPENSES") }}
    GROUP BY CAST(DATE_TIME AS DATE)
)

SELECT 
    ad.REPORT_DATE,
    COALESCE(os.TOTAL_ORDER_INCOME, 0) AS TOTAL_ORDER_INCOME,
    COALESCE(rs.TOTAL_REFUNDED, 0) AS TOTAL_REFUNDED,
    COALESCE(es.TOTAL_EXPENSES, 0) AS TOTAL_EXPENSES,
    (COALESCE(os.TOTAL_ORDER_INCOME, 0) - COALESCE(es.TOTAL_EXPENSES, 0) - COALESCE(rs.TOTAL_REFUNDED, 0)) AS NET_INCOME,
    COALESCE(es.WAREHOUSE_EXPENSE, 0) AS WAREHOUSE_EXPENSE,
    COALESCE(es.HR_EXPENSE, 0) AS HR_EXPENSE,
    COALESCE(es.TECH_TOOL_EXPENSE, 0) AS TECH_TOOL_EXPENSE,
    COALESCE(es.OTHER_EXPENSE, 0) AS OTHER_EXPENSE,
    COALESCE(os.TOTAL_SHIPPING_COST,0) AS TOTAL_SHIPPING_COST,
FROM AllDates ad
LEFT JOIN OrderSummary os ON os.ORDER_DATE = ad.REPORT_DATE
LEFT JOIN RefundSummary rs ON rs.REFUND_DATE = ad.REPORT_DATE
LEFT JOIN ExpenseSummary es ON es.EXPENSE_DATE = ad.REPORT_DATE
ORDER BY ad.REPORT_DATE
