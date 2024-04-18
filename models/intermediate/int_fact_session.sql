SELECT 
    items.SESSION_ID,
    items.ITEM_NAME,
    items.ITEM_VIEW_AT_TS,
    items.PRICE_PER_UNIT,
    (items.ADD_TO_CART_QUANTITY - items.REMOVE_FROM_CART_QUANTITY) AS TOTAL_CART_QUANTITY,

    orders.ORDER_ID,
    orders.ORDER_AT_TS,
    orders.STATE,
    CASE WHEN orders.ORDER_ID IS NOT NULL THEN TRUE ELSE FALSE END AS ORDER_PLACED,

    sessions.CLIENT_ID, 
    sessions.SESSION_AT_TS,
    sessions.OS,
    --sessions.IP,

    page.PAGE_NAME, 
    page.VIEW_AT_TS

FROM {{ref("base_snowflake_SESSIONS")}} as sessions
left JOIN {{ref("base_snowflake_ORDERS")}} as orders
    ON sessions.SESSION_ID = orders.SESSION_ID
left JOIN {{ref("base_snowflake_ITEM_VIEWS")}} as items 
    ON sessions.SESSION_ID = items.SESSION_ID
left JOIN {{ref('base_snowflake_PAGE_VIEWS')}} as page 
    ON sessions.SESSION_ID = page.SESSION_ID

group by SESSION_ID
-- Page name as array (Which)
-- item name as array (unique)
-- drop item_view_at_ts
-- drop price per unit
-- 