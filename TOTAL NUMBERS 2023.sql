select 



EXTRACT(YEAR  FROM of.create_date) as Year,
EXTRACT(MONTH  FROM of.create_date) as Month,
COUNT(DISTINCT of.name) as Total_Orders,
SUM(wofi.total_price) as Total_Turnover,
COUNT(of.name)


from public.order_funnel as of

left join public.funnel_work_order as wo on of.id = wo.order_funnel_id
left join public.work_order_for_invoice as wofi on wo.id = wofi.work_order_id

where (of.create_date >= '2023-01-01' and of.create_date < '2023-12-31') 



and wo.is_cancel_work_order = false

and (wofi.total_price <> 0 or wofi.total_price <> NULL)

and wo.id IS NOT NULL

GROUP BY EXTRACT(YEAR  FROM of.create_date), EXTRACT(MONTH  FROM of.create_date) 

