select  DISTINCT (of.first_driver_phone) , offi.border_crossing_id

from  order_funnel_for_invoice as offi

left join order_funnel as of on offi.order_id = of.id
left join public.product_template as ptmp on offi.product_tmp_id = ptmp.id
left join public.bunasta_direction_group as dg on ptmp.direction_id = dg.id


where offi.border_crossing_id IN
	(select bc.id from public.border_crossing as bc

	left join bunasta_direction as bd on bc.direction_id = bd.id

	where bd.name like '%GB%')


and of.create_date > '2022-08-01'


and of.first_driver_phone IS NOT NULL 

--ORDER BY of.create_date DESC