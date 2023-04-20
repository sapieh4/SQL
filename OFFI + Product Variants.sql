select 
offi.id, offi.product_tmp_id, offi.product_short_name, offi.quantity, offi.price, offi.total_price, offi.work_order_for_invoice_id, offi.order_id,
wofi.product_id, product_variants.slug, product_variants.variant, of.create_date
from 

public.order_funnel_for_invoice as offi
left join work_order_for_invoice as wofi on offi.work_order_for_invoice_id =  wofi.id
left join public.order_funnel as of on offi.order_id = of.id
left join (
			select pp.id, pp.slug, string_agg(pav.name , ' - ') as variant --pp.product_tmpl_id, pp.combination_indices, pvc.product_template_attribute_value_id, ptav.* , pav.* 
			from 
			public.product_product as pp
			LEFT JOIN public.product_variant_combination as pvc on pp.id = pvc.product_product_id
			left join public.product_template_attribute_value as ptav  on pvc.product_template_attribute_value_id = ptav.id
			left join public.product_attribute_value as pav on ptav.product_attribute_value_id = pav.id
			group by pp.id, pp.slug
		) as product_variants on wofi.product_id = product_variants.id

where offi.total_price <> 0 and of.create_date >= '2022-11-01'

