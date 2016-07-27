SELECT re.report_gid
,re.report_job_number
,re.email_address
,COALESCE((SELECT 'Y'
FROM report_log rl
WHERE rl.job_number = re.report_job_number
),'N')															report_sent
,re.schedule
,re.email_subject
,re.email_body
,re.email_host
,re.domain_name
,re.insert_user
,TO_CHAR(re.insert_date,'YYYY-MM-DD HH24:MI')				INSERT_DATE

FROM report_email re

WHERE TRUNC(re.insert_date) >= TO_DATE(:P_DATE,:P_DATE_TIME_FORMAT)

AND 1 = 
(CASE WHEN :P_SHOW_DELIVERED = 'YES' THEN
(SELECT 1
FROM report_log rl
WHERE rl.job_number = re.report_job_number
)
ELSE 1 END
)



ORDER BY re.insert_date DESC