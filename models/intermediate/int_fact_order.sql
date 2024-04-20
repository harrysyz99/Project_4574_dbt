-- select 
--     orders.ORDER_ID,
--     orders.SESSION_ID,
--     orders.ORDER_AT_TS,
--     orders.SHIPPING_COST,
--     orders.TAX_RATE,
--     orders.PAYMENT_METHOD,
--     orders.STATE,
--     returns.RETURNED_AT,
--     returns.IS_REFUNDED,
--     SUM(i.PRICE_PER_UNIT*(i.ADD_TO_CART_QUANTITY - i.REMOVE_FROM_CART_QUANTITY) AS INCOME
--     -- SUM()
    

-- from {{ ref("base_snowflake_ORDERS") }} as orders 

-- left join
--     {{ ref("base_goolge_drive_RETURNS") }} as returns on returns.order_id = orders.order_id
-- LEFT join
--     {{ ref("base_snowflake_ITEM_VIEWS")}} as i on i.SESSION_ID = orders.SESSION_ID
-- Group BY ORDER_ID


-- SELECT 
--     o.ORDER_ID,
--     MAX(o.SESSION_ID) AS SESSION_ID,
--     MAX(o.ORDER_AT_TS) AS ORDER_AT_TS,
--     MAX(o.SHIPPING_COST) AS SHIPPING_COST,
--     MAX(o.TAX_RATE) AS TAX_RATE,
--     MAX(o.PAYMENT_METHOD) AS PAYMENT_METHOD,
--     MAX(o.STATE) AS STATE,
--     MAX(r.RETURNED_AT) AS RETURNED_AT,
--     MAX(r.IS_REFUNDED) AS IS_REFUNDED,
--     SUM(i.PRICE_PER_UNIT * (i.ADD_TO_CART_QUANTITY - i.REMOVE_FROM_CART_QUANTITY)) AS INCOME

-- FROM {{ ref("base_snowflake_ORDERS") }} AS o

-- LEFT JOIN {{ ref("base_goolge_drive_RETURNS") }} AS r ON r.ORDER_ID = o.ORDER_ID
-- LEFT JOIN {{ ref("base_snowflake_ITEM_VIEWS") }} AS i ON i.SESSION_ID = o.SESSION_ID

-- GROUP BY o.ORDER_ID


SELECT 
    o.ORDER_ID,
    COUNT(o.SESSION_ID) AS SESSION_IDs,
    COALESCE(MAX(DATE(o.ORDER_AT_TS)), '1900-01-01') AS ORDER_DATE,
    COALESCE(MAX(o.SHIPPING_COST), 0) AS SHIPPING_COST,
    COALESCE(MAX(o.TAX_RATE), 0) AS TAX_RATE,
    COALESCE(MAX(o.PAYMENT_METHOD), 'Not Available') AS PAYMENT_METHOD,
    COALESCE(MAX(o.STATE), 'Unknown State') AS STATE,
    COALESCE(MAX(r.RETURNED_AT), '1900-01-01') AS RETURNED_AT,
    COALESCE(MAX(r.IS_REFUNDED), FALSE) AS IS_REFUNDED,
    COALESCE(SUM(i.PRICE_PER_UNIT * (i.ADD_TO_CART_QUANTITY - i.REMOVE_FROM_CART_QUANTITY)), 0) AS INCOME,
    CASE WHEN MAX(r.IS_REFUNDED) = TRUE THEN 
        COALESCE(SUM(i.PRICE_PER_UNIT * (i.ADD_TO_CART_QUANTITY - i.REMOVE_FROM_CART_QUANTITY)), 0) 
    ELSE 0 END AS RETURN_AMOUNT
FROM {{ ref("base_snowflake_ORDERS") }} AS o
FULL JOIN {{ ref("base_goolge_drive_RETURNS") }} AS r ON r.ORDER_ID = o.ORDER_ID
FULL JOIN {{ ref("base_snowflake_ITEM_VIEWS") }} AS i ON i.SESSION_ID = o.SESSION_ID
-- where o.ORDER_ID = 'o7775232'
GROUP BY o.ORDER_ID
HAVING MAX(DATE(o.ORDER_AT_TS)) IS NOT NULL 










