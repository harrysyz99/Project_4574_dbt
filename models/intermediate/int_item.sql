select 
    items.SESSION_ID,
    orders.ORDER_ID,
    items.ITEM_VIEW_AT_TS,
    items.REMOVE_FROM_CART_QUANTITY,
    items.ADD_TO_CART_QUANTITY
    
from {{ ref("base_snowflake_ITEM_VIEWS") }} as items
full join
    {{ ref("base_snowflake_ORDERS") }} as orders on items.SESSION_ID = orders.SESSION_ID

