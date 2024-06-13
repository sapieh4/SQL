
select  wo.name,

wo.id, wo.codes_qty, wo.initial_reports_qty, total_cmr_qty, wo.duration, wo.state, wo.employee_id,

of.name as order, hrd.name as department, fwowti.name as type, dg.name as border_dir, of.customs_code, bc.display_name as Border_crossing,
stages.duration as stage_3_to_4_order_duration

from funnel_work_order as wo

left join order_funnel as of on of.id = wo.order_funnel_id
left join border_crossing as bc on of.border_crossing_id = bc.id
left join bunasta_direction as dg on dg.id = bc.direction_id
left join hr_department as hrd on of.department_id = hrd.id
left join funnel_work_order_warranty_type_item as fwowti on fwowti.id = wo.warranty_type_item_id

left join (select kl.id_of_record::int, MIN(kl.create_date) as start , MAX(kl.create_date) as end, 

			MAX(kl.create_date) - MIN(kl.create_date) as duration

			from public.kpi_logs as kl

			where field_name = 'Stages' and (kl.new_value = '3' or kl.new_value = '4')

			group by id_of_record) as stages on stages.id_of_record = of.id 


where

hrd.name like '%T1%'
and
of.stage_id between 4 AND 6 


AND ( of.create_date > '2023-06-30' and of.create_date < '2023-08-01')

--AND of.name = 'KH003837707'




