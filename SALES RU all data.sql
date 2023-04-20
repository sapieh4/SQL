select 
    rp.id , rp.name, rp.company_name_original,
	rp.is_active,
	rp.street,
	rp.street2,
	rp.zip,
	rp.city,
    public.res_country.name as country,	
    rp.reg_code,
    rp.vat,
	rp.website,
	rc_phone.phone_code as country_phone_code, 
    rp.phone , 
    rc_mobile.phone_code as country_mobile_code, 
    rp.mobile,
	rp.email,
	
	public.res_partner_group.name as group,
	rp.company_type,
	rp.target_segment,
	rp.customs_carrier,
	public.customer_status.name as customer_status,
	rc1.name as sales_dep,
    public.hr_employee.name as Manager,
	bs.name as stage,
    rp.block_id,
    rp.blacklist_id,   
	c.name as category,
	payer.name as payer,
	
	
	
	bcl.registration_date,
	bcl.years_on_the_market,
	bcl.employees_qty,
	bcl.qty_of_trucks_owned,
	bcl.customs_carrier,
	bcl.other_countries_subsidiaries_divisions_qty,
	bcl.last_year_turnover_qty,
	bcl.last_year_profit_qty,
	bcl.member_of_association_qty,
	bcl.legal_actual_addresses,
	bcl.entities_arrears,
	bcl.cases_in_court,
	bcl.standart_pay_form,
	bcl.standart_currency,
	bcl.standart_pay_term,
	bcl.standart_default_interest,
	bcl.standart_fine_late,
	bcl.standart_fine,
	bcl.standart_limit_invoicing,
	bcl.standart_original_send,
	bcl."requested_credit_limit_EUR",
	bcl.requested_pay_form,
	bcl.requested_currency,
	bcl.requested_pay_term,
	bcl.requested_default_interest,
	bcl.requested_fine_late,
	bcl.requested_fine,
	bcl.requested_limit_invoicing,
	bcl.requested_original_send,
	bcl."approved_credit_limit_EUR",
	bcl.approved_pay_form,
	bcl.approved_currency,
	bcl.approved_pay_term,
	bcl.approved_default_interest,
	bcl.approved_fine_late,
	bcl.approved_fine,
	bcl.approved_limit_invoicing,
	bcl.approved_original_send
 


     
    from public.res_partner as rp
	left join public.res_company as rc1 on rp.sales_department_id = rc1.id
	left join public.res_company as rc2 on rp.our_company_id = rc2.id
	left join public.res_country on rp.country_id = public.res_country.id
	left join public.customer_status on rp.customer_status_id = public.customer_status.id
	left join public.res_partner_group on rp.partner_group_id = public.res_partner_group.id
	left join public.res_users on rp.account_manager_id = public.res_users.id
	left join public.hr_employee on public.res_users.id = public.hr_employee.user_id
	left join res_country as rc_phone on phone_country_id = rc_phone.id
	left join res_country as rc_mobile on mobile_country_id = rc_mobile.id
	left join bunasta_stage as bs on rp.stage_id = bs.id
	left join bunasta_credit_limit as bcl on rp.current_credit_limit_id = bcl.id
	left join category as c on rp.partner_category_id = c.id
	left join (select id, name from res_partner) as payer on rp.bill_payer_id = payer.id
	
	where rp.company_type = 'company' and rc1.name = 'Bunasta RU'