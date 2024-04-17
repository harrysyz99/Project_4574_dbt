select 
    orders.ORDER_ID,
    orders.ORDER_AT_TS,
    orders.SHIPPING_COST,
    orders.TAX_RATE,
    orders.PAYMENT_METHOD,
    orders.STATE,
    returns.IS_REFUNDED,
    returns.RETURNED_AT

from {{ ref("base_snowflake_ORDERS") }} as orders 

left join
    {{ ref("base_goolge_drive_RETURNS") }} as returns on returns.order_id = orders.order_id
