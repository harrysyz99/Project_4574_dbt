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


SELECT 
    o.ORDER_ID,
    MAX(o.SESSION_ID) AS SESSION_ID,
    MAX(o.ORDER_AT_TS) AS ORDER_AT_TS,
    MAX(o.SHIPPING_COST) AS SHIPPING_COST,
    MAX(o.TAX_RATE) AS TAX_RATE,
    MAX(o.PAYMENT_METHOD) AS PAYMENT_METHOD,
    MAX(o.STATE) AS STATE,
    MAX(r.RETURNED_AT) AS RETURNED_AT,
    MAX(r.IS_REFUNDED) AS IS_REFUNDED,
    SUM(i.PRICE_PER_UNIT * (i.ADD_TO_CART_QUANTITY - i.REMOVE_FROM_CART_QUANTITY)) AS INCOME

FROM {{ ref("base_snowflake_ORDERS") }} AS o

LEFT JOIN {{ ref("base_goolge_drive_RETURNS") }} AS r ON r.ORDER_ID = o.ORDER_ID
LEFT JOIN {{ ref("base_snowflake_ITEM_VIEWS") }} AS i ON i.SESSION_ID = o.SESSION_ID

GROUP BY o.ORDER_ID

