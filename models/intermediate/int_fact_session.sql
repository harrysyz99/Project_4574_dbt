-- SELECT 
--     items.SESSION_ID,
--     items.ITEM_NAME,
--     items.ITEM_VIEW_AT_TS,
--     items.PRICE_PER_UNIT,
--     (items.ADD_TO_CART_QUANTITY - items.REMOVE_FROM_CART_QUANTITY) AS TOTAL_CART_QUANTITY,
--     GROUP_CONCAT(PAGE_NAME)

--     orders.ORDER_ID,
--     orders.ORDER_AT_TS,
--     orders.STATE,
--     CASE WHEN orders.ORDER_ID IS NOT NULL THEN TRUE ELSE FALSE END AS ORDER_PLACED,

--     sessions.CLIENT_ID, 
--     sessions.SESSION_AT_TS,
--     sessions.OS,
--     --sessions.IP,

--     page.PAGE_NAME, 
--     page.VIEW_AT_TS

-- FROM {{ref("base_snowflake_SESSIONS")}} as sessions
-- left JOIN {{ref("base_snowflake_ORDERS")}} as orders
--     ON sessions.SESSION_ID = orders.SESSION_ID
-- left JOIN {{ref("base_snowflake_ITEM_VIEWS")}} as items 
--     ON sessions.SESSION_ID = items.SESSION_ID
-- left JOIN {{ref('base_snowflake_PAGE_VIEWS')}} as page 
--     ON sessions.SESSION_ID = page.SESSION_ID

-- group by sessions.SESSION_ID
-- -- Page name as array (Which)
-- -- item name as array (unique)
-- -- drop item_view_at_ts
-- -- drop price per unit
-- -- 

-- SELECT 
--     s.SESSION_ID,
--     ARRAY_AGG(DISTINCT i.ITEM_NAME) AS ITEM_NAMES,
--     COUNT(DISTINCT i.ITEM_NAME) AS DISTINCT_ITEMS_COUNT,
--     SUM(i.ADD_TO_CART_QUANTITY - i.REMOVE_FROM_CART_QUANTITY) AS TOTAL_CART_QUANTITY,
--     ARRAY_AGG(DISTINCT p.PAGE_NAME) AS PAGE_NAMES,
--     -- MAX(o.ORDER_ID) AS ORDER_ID,
--     MAX(o.ORDER_AT_TS) AS ORDER_AT_TS,
--     ARRAY_AGG(DISTINCT o.STATE) AS ORDER_STATES,
--     MAX(CASE WHEN o.ORDER_ID IS NOT NULL THEN TRUE ELSE FALSE END) AS ORDER_PLACED,
--     ARRAY_AGG(DISTINCT s.CLIENT_ID) AS CLIENT_IDS, 
--     MAX(s.SESSION_AT_TS) AS SESSION_AT_TS,
--     ARRAY_AGG(DISTINCT s.OS) AS OPERATING_SYSTEMS

-- FROM {{ref("base_snowflake_SESSIONS")}} AS s
-- LEFT JOIN {{ref("base_snowflake_ORDERS")}} AS o ON s.SESSION_ID = o.SESSION_ID
-- LEFT JOIN {{ref("base_snowflake_ITEM_VIEWS")}} AS i ON s.SESSION_ID = i.SESSION_ID
-- LEFT JOIN {{ref('base_snowflake_PAGE_VIEWS')}} AS p ON s.SESSION_ID = p.SESSION_ID

-- GROUP BY s.SESSION_ID

SELECT 
    s.SESSION_ID,
    ARRAY_AGG(DISTINCT COALESCE(i.ITEM_NAME, 'No Item')) AS ITEM_NAMES,
    COUNT(DISTINCT i.ITEM_NAME) AS DISTINCT_ITEMS_COUNT,
    COALESCE(SUM(i.ADD_TO_CART_QUANTITY - i.REMOVE_FROM_CART_QUANTITY), 0) AS TOTAL_CART_QUANTITY,
    ARRAY_AGG(DISTINCT COALESCE(p.PAGE_NAME, 'No Page')) AS PAGE_NAMES,
    COALESCE(MAX(o.ORDER_AT_TS), '1900-01-01 00:00:00') AS ORDER_AT_TS,  -- Placeholder date
    ARRAY_AGG(DISTINCT COALESCE(o.STATE, 'No Order State')) AS ORDER_STATES,
    MAX(CASE WHEN o.ORDER_ID IS NOT NULL THEN TRUE ELSE FALSE END) AS ORDER_PLACED,
    ARRAY_AGG(DISTINCT COALESCE(s.CLIENT_ID, 'No Client ID')) AS CLIENT_IDS, 
    MAX(s.SESSION_AT_TS) AS SESSION_AT_TS,
    ARRAY_AGG(DISTINCT COALESCE(s.OS, 'Unknown OS')) AS OPERATING_SYSTEMS

FROM {{ref("base_snowflake_SESSIONS")}} AS s
LEFT JOIN {{ref("base_snowflake_ORDERS")}} AS o ON s.SESSION_ID = o.SESSION_ID
LEFT JOIN {{ref("base_snowflake_ITEM_VIEWS")}} AS i ON s.SESSION_ID = i.SESSION_ID
LEFT JOIN {{ref('base_snowflake_PAGE_VIEWS')}} AS p ON s.SESSION_ID = p.SESSION_ID

GROUP BY s.SESSION_ID
