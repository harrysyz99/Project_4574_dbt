SELECT 
    _FILE,
	_LINE,
	_MODIFIED,
	_FIVETRAN_SYNCED,
	EMPLOYEE_ID,
	REPLACE(hire_date, 'day ', '') as hire_date,
	NAME,
	CITY,
	ADDRESS,
	TITLE,
	CAST(ANNUAL_SALARY AS NUMERIC) as ANNUAL_SALARY,
FROM {{ source('google_drive', 'HR_JOINS') }}