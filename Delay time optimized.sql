/*
Query takes all delays from order. We take all rows with reason_logging = 'Exiting Delay' because delay_set_times are sometimes duplicated.
After that we are finding next min id with reason_logging = 'Set Delay' to count times between delays which means work time.
We need to take also row with reason_logging = 'Changing the Stage' which means start of working and from that id we are looking for next set_delay_time. 
It is the first timestamp os setting delay and we need that for counting work time from the begging to first delay.
*/

select ofl.id, ofl.order_funnel_id,ofl.stage_id, ofl.reason_logging,  
ofl.click_user_id as user_end_delay, ofl.delay_exit_time,
ofl1.delay_set_time as next_delay, ofl1.click_user_id as user_start_delay, ofl1.id

from order_funnel_logging as ofl

--it could be few set_delay timestamps so we need take exiting_delay timestamp and join max last id with set_delay timestmap  

	left join lateral
		(
			select s_ofl.order_funnel_id, s_ofl.delay_set_time, s_ofl.delay_exit_time, s_ofl.click_user_id , s_ofl.id
			from  order_funnel_logging as s_ofl 
			where id = (select min(id) from order_funnel_logging where order_funnel_id = ofl.order_funnel_id and id > ofl.id and reason_logging = 'Set Delay' and stage_id = 2) 
			
		) 
	as ofl1 on ofl.order_funnel_id = ofl1.order_funnel_id
	
where ---ofl.order_funnel_id = 667420 and 

(ofl.reason_logging = 'Exiting Delay' or ofl.reason_logging = 'Changing the Stage' )

and ofl.stage_id=2 --needed delays only from in checking status 

and ofl.id > (select MIN(id) from order_funnel_logging where date_in_stage > '2023-07-31' )

order by ofl.id limit 10000
