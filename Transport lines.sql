select rp1.name as partner_id, plate_number , rp2.name as payer, CASE WHEN rp1.name = rp2.name THEN True ELSE False END  AS partner_equal_payer

from 

public.partner_transport_line as ptl

left join res_partner as rp1 on ptl.partner_id = rp1.id
left join res_partner as rp2 on ptl.payer_id = rp2.id

where partner_id in (select rp1.id 
						from res_partner as rp1
						left join public.res_company as rc on rp1.sales_department_id = rc.id 
						where rc.name = 'Bunasta RU' )


limit 100