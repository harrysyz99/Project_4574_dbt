select items.ITEM_NAME,items.SESSION_ID,items.PRICE_PER_UNIT,orders.ORDER_AT_TS
from {{ ref("base_snowflake_ITEM_VIEWS") }} as items
full join
    {{ ref("base_snowflake_ORDERS") }} as orders on items.session_id = orders.session_id
full join
    {{ ref("base_goolge_drive_RETURNS") }} as returns on returns.order_id = orders.order_id
