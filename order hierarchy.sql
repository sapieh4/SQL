with
 
 
RECURSIVE hr as 
	(SELECT id , parent_id , order_type, stage_id , 0 AS level
	 FROM 
			(select id, parent_id, order_type, stage_id  from order_funnel
			where 
			 create_date >= '2024-03-01'
			and 
			order_type <> 'duplicate' 
			 --and stage_id <> 7
			 --and 
			 --and name in ('KG003210505', 'KG003110305' , 'KG003214705') --, 'KH004234705', 'KG001100205', 'KG001147205') 
			 --and id in ( 847178 , 846955, 844032, 839807, 840758, 840773 , 522187, 522554, 522628 )
			order by id) as example
 
	 
	 UNION ALL
	 select hr.id, e.parent_id,  hr.order_type,  hr.level + 1, hr.stage_id
	 from 
			(select id, parent_id, order_type, stage_id from order_funnel
			where order_type <> 'duplicate'
			order by id) as e
	 join hr on hr.parent_id = e.id

	)

select 
final_pairs.start_id, of_start.create_date as start_time, of_start.name as start_order_name , 
final_pairs.end_id, of_end.order_done_time as end_time, of_end.name as end_order_name
from 
(
	select start_id,  max(end_id) as end_id from
		(
		select 
		orders_pairs.start_id, 
		orders_pairs.end_id, of_end.stage_id as end_stage

		from
			( 
			select id as end_id, MIN(CASE WHEN parent_id is null THEN id ELSE parent_id END) as start_id from hr group by 1
			) as orders_pairs

		left join order_funnel as of_end on of_end.id = orders_pairs.end_id 
		where of_end.stage_id in (4,5,6) 
		order by 1

	 ) as order_pairs2
	group by 1
) as final_pairs
left join order_funnel as of_start on of_start.id = final_pairs.start_id 
left join order_funnel as of_end on of_end.id = final_pairs.end_id  
