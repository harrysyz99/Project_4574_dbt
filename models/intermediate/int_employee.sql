SELECT 
    COALESCE(joint.EMPLOYEE_ID, quit.EMPLOYEE_ID) AS EMPLOYEE_ID,
    COALESCE(joint.NAME, 'Unknown Name') AS NAME,
    COALESCE(joint.HIRE_DATE, '1900-01-01') AS HIRE_DATE, 
    COALESCE(quit.QUIT_DATE, '9999-12-31') AS QUIT_DATE, 
    COALESCE(joint.TITLE, 'No Title') AS TITLE,
    COALESCE(joint.ANNUAL_SALARY, 0) AS ANNUAL_SALARY,  
    COALESCE(joint.CITY, 'Unknown City') AS CITY,
    COALESCE(joint.ADDRESS, 'No Address Available') AS ADDRESS

FROM {{ref('base_google_drive_HR_JOIN')}} AS joint
FULL JOIN {{ref('base_goolge_drive_HR_QUITS')}} AS quit
ON quit.EMPLOYEE_ID = joint.EMPLOYEE_ID
