select items.SESSION_ID,items.PRICE_PER_UNIT,sessions.CLIENT_ID
from {{ref("base_snowflake_ITEM_VIEWS")}} as items 
full join {{ref("base_snowflake_SESSIONS")}} as sessions
on items.SESSION_ID = sessions.SESSION_ID
full join {{ref("base_snowflake_ORDERS")}} as orders
on items.SESSION_ID = orders.SESSION_ID
full join {{ref('base_snowflake_PAGE_VIEWS')}} as page 
on page.SESSION_ID = items.SESSION_ID

