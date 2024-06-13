WITH ordered_data AS (
    SELECT
        of.id,
        of.customer_name,
        -- Determine the first order date for the customer, ensuring it is not before '2022-01-01'
        CASE WHEN rp.first_order_date < '2022-01-01' THEN '2022-01-01' ELSE rp.first_order_date END as first_order_date,
        -- Get the previous order date for the customer, ordered by order_done_time
        LAG(of.order_done_time) OVER (PARTITION BY of.customer_name ORDER BY of.order_done_time) AS previous_order_date,
        -- Get the current order date
        of.order_done_time as order_date,
        -- Get the next order date for the customer, ordered by order_done_time
        LEAD(of.order_done_time) OVER (PARTITION BY of.customer_name ORDER BY of.order_done_time) AS next_order_date,
        -- Get the last order date for the customer
        MAX(of.order_done_time) OVER (PARTITION BY of.customer_name) AS last_order_date
    FROM
        order_funnel as of
    LEFT JOIN
        res_partner as rp on rp.id = of.customer_id
    WHERE
        of.order_done_time >= '2022-01-01' -- Only consider orders done on or after '2022-01-01'
        AND of.order_done_time >= rp.first_order_date -- Ensure the order is after the customer's first order date
),

gap_data AS (
    SELECT
        customer_name,
        first_order_date,
        last_order_date,
        previous_order_date,
        order_date,
        next_order_date,
        -- Calculate the gap between the current order date and the previous order date
        (order_date - COALESCE(previous_order_date, first_order_date)) AS gap_previous,
        -- Identify if the gap is more than 6 months, marking the start of a new period
        CASE WHEN (order_date - COALESCE(previous_order_date, first_order_date)) > INTERVAL '6 months' THEN 'NEW PERIOD' ELSE null END as period_info
    FROM
        ordered_data
),

periods_data AS (
    SELECT
        customer_name,
        previous_order_date,
        order_date,
        last_order_date,
        gap_previous,
        period_info,
        -- Calculate the running total of new periods for the customer, ordered by order date
        SUM(CASE WHEN period_info = 'NEW PERIOD' THEN 1 ELSE 0 END) OVER (PARTITION BY customer_name ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS period_index
    FROM
        gap_data
),

final_periods AS (
    SELECT
        customer_name,
        period_index,
        last_order_date,
        -- Get the maximum gap time within the period
        MAX(gap_previous) as break_time,
        -- Get the start date of the period
        MIN(order_date) as start_order_date,
        -- Get the end date of the period
        MAX(order_date) as end_order_date
    FROM
        periods_data
    GROUP BY customer_name, period_index, last_order_date
),

final_table AS (
	SELECT 
		customer_name, 
		period_index, 
		last_order_date, 
		CASE WHEN break_time < INTERVAL '6 months' THEN null ELSE break_time END as break_time, -- Filter out breaks less than 6 months
		start_order_date, 
		end_order_date, 
		(end_order_date - start_order_date) as active_period_time -- Calculate the duration of the active period
	FROM 
		final_periods
)

SELECT 
    customer_name, 
    period_index, 
    last_order_date, 
    EXTRACT(EPOCH FROM break_time) as break_time_seconds, -- Converts interval to seconds
    start_order_date, 
    end_order_date, 
    EXTRACT(EPOCH FROM (end_order_date - start_order_date)) as active_period_time_seconds -- Converts interval to seconds
FROM final_table
WHERE 
    customer_name = 'ANATRANS UAB'