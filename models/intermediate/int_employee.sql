select 
joint.EMPLOYEE_ID,
NAME,
HIRE_DATE,
QUIT_DATE,
TITLE,
ANNUAL_SALARY,
CITY,
ADDRESS

from {{ref('base_google_drive_HR_JOIN')}} as joint
full join {{ref('base_goolge_drive_HR_QUITS')}} as quit
on quit.EMPLOYEE_ID = joint.EMPLOYEE_ID
