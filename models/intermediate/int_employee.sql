select 
joint.EMPLOYEE_ID,
HIRE_DATE,
NAME,
CITY,
ADDRESS,
TITLE,
ANNUAL_SALARY,
QUIT_DATE
from {{ref('base_google_drive_HR_JOIN')}} as joint
join {{ref('base_goolge_drive_HR_QUITS')}} as quit
on quit.EMPLOYEE_ID = joint.EMPLOYEE_ID
