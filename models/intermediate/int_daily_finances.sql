SELECT expenses.EXPENSE_TYPE
FROM {{ ref("base_google_drive_EXPENSES") }} AS expenses 
JOIN {{ ref("int_fact_order") }} AS forder 
ON CAST(forder.ORDER_AT_TS AS DATE) = CAST(expenses.date_time AS DATE)
