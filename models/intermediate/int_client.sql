WITH ranked AS (
    SELECT 
        sessions.SESSION_ID, 
        sessions.CLIENT_ID, 
        orders.CLIENT_NAME,
        orders.SHIPPING_ADDRESS,
        orders.STATE,
        sessions.IP,
        sessions.OS,
        sessions.SESSION_AT_TS,
        orders.ORDER_AT_TS,
        orders.PAYMENT_INFO,
        orders.PHONE,
        ROW_NUMBER() OVER(PARTITION BY sessions.CLIENT_ID ORDER BY orders.ORDER_AT_TS DESC) AS row_n
    FROM {{ref("base_snowflake_SESSIONS")}} as sessions
        right JOIN {{ref("base_snowflake_ORDERS")}} as orders
        ON sessions.SESSION_ID = orders.SESSION_ID
)

SELECT 
    SESSION_ID, 
    CLIENT_ID, 
    CLIENT_NAME,
    SHIPPING_ADDRESS,
    STATE,
    IP,
    OS,
    SESSION_AT_TS,
    ORDER_AT_TS,
    PAYMENT_INFO,
    PHONE

FROM ranked
WHERE row_n = 1