select
    _FIVETRAN_ID,
	SESSION_ID,
	VIEW_AT,
	PAGE_NAME,
	_FIVETRAN_DELETED,
	_FIVETRAN_SYNCED

from {{ source('Snowflake', 'PAGE_VIEWS') }}