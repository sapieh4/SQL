SElECT hre.name as employee, q.* FROM (

SELECT 
		declarant_employee_id,
		declarant_department_id,
		id,
		take_to_process_timestamp,
		order_done_time,
		LEAD(take_to_process_timestamp) OVER (PARTITION BY declarant_employee_id ORDER BY take_to_process_timestamp) AS next_order_start,
		LEAD(id) OVER (PARTITION BY declarant_employee_id ORDER BY id) AS next_order_id,
		(LEAD(take_to_process_timestamp) OVER (PARTITION BY declarant_employee_id ORDER BY take_to_process_timestamp) - order_done_time) AS time_to_next_order
	FROM 
		order_funnel
	WHERE take_to_process_timestamp >= '2024-01-01'

	ORDER BY 
		declarant_employee_id, 
		id
) as q	

left join public.res_users as ru on q.declarant_employee_id = ru.id
left join public.hr_employee as hre on ru.id = hre.user_id
left join hr_department as hrd on q.declarant_department_id = hrd.id

where order_done_time < next_order_start and time_to_next_order < '01:00:00' and hrd.name like '%T1%' and order_done_time is not null