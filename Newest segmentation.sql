select  *

from 

public.partner_segmentation_line as p1

where partner_id = 17200 and create_date = (select MAX(create_date) from public.partner_segmentation_line as p2 where p2.partner_id = p1.partner_id)

