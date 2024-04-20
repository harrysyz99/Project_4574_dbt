SELECT 
    COALESCE(items.SESSION_ID, orders.SESSION_ID) AS SESSION_ID,
    COALESCE(orders.ORDER_ID, 'No Order') AS ORDER_ID,
    items.ITEM_NAME,
    items.ITEM_VIEW_AT_TS,
    COALESCE(items.REMOVE_FROM_CART_QUANTITY, 0) AS REMOVE_FROM_CART_QUANTITY,
    COALESCE(items.ADD_TO_CART_QUANTITY, 0) AS ADD_TO_CART_QUANTITY,
    COALESCE(items.ADD_TO_CART_QUANTITY, 0) - COALESCE(items.REMOVE_FROM_CART_QUANTITY, 0) AS TOTAL_CART_QUANTITY

FROM {{ ref("base_snowflake_ITEM_VIEWS") }} AS items
FULL JOIN
    {{ ref("base_snowflake_ORDERS") }} AS orders 
ON items.SESSION_ID = orders.SESSION_ID

-- select 
--     items.SESSION_ID,
--     orders.ORDER_ID,
--     items.ITEM_VIEW_AT_TS,
--     items.REMOVE_FROM_CART_QUANTITY,
--     items.ADD_TO_CART_QUANTITY
    
-- from {{ ref("base_snowflake_ITEM_VIEWS") }} as items
-- full join
--     {{ ref("base_snowflake_ORDERS") }} as orders on items.SESSION_ID = orders.SESSION_ID