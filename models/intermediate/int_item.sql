select items.session_id
from {{ ref("base_snowflake_ITEM_VIEWS") }} as items
full join
    {{ ref("base_snowflake_ORDERS") }} as orders on items.session_id = orders.session_id
full join
    {{ ref("base_snowflake_PAGE_VIEWS") }} as page on page.session_id = items.session_id
