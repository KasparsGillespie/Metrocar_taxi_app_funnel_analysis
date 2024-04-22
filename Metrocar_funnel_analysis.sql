/*
TASK:
Create a comprehensive funnel dataset comprising seven steps, including funnel name, 
platform, age range, and download date. 
Organize the data in a tabular format for easy analysis and integration into analytical tools.
*/
WITH user_counts AS (
	-- Funnel step 0 - Downloads
	SELECT
    	0 AS funnel_step,
    	'downloads' AS funnel_name,
    	platform,
    	age_range,
    	DATE(download_ts) AS download_date,
    	COUNT(DISTINCT download_ts) AS user_count,
    	NULL::text AS ride_count
	FROM metrocar
	GROUP BY funnel_step, funnel_name, platform, age_range, download_date

	UNION ALL

	-- Funnel step 1 - Signups
	SELECT
    	1 AS funnel_step,
    	'signups' AS funnel_name,
    	platform,
    	age_range,
    	DATE(download_ts) AS download_date,
    	COUNT(DISTINCT user_id) AS user_count,
    	NULL::text AS ride_count
	FROM metrocar
	WHERE signup_ts IS NOT NULL
	GROUP BY funnel_step, funnel_name, platform, age_range, download_date

	UNION ALL

	-- Funnel step 2 - Ride Requested
	SELECT
    	2 AS funnel_step,
    	'ride_requested' AS funnel_name,
    	platform,
    	age_range,
    	DATE(download_ts) AS download_date,
    	COUNT(DISTINCT user_id) AS user_count,
    	COUNT(DISTINCT ride_id)::text AS ride_count
	FROM metrocar
	WHERE request_ts IS NOT NULL
	GROUP BY funnel_step, funnel_name, platform, age_range, download_date

	UNION ALL

	-- Funnel step 3 - Driver Acceptance
	SELECT
    	3 AS funnel_step,
    	'driver_acceptance' AS funnel_name,
    	platform,
    	age_range,
    	DATE(download_ts) AS download_date,
    	COUNT(DISTINCT user_id) AS user_count,
    	COUNT(DISTINCT ride_id)::text AS ride_count
	FROM metrocar
	WHERE accept_ts IS NOT NULL
	GROUP BY funnel_step, funnel_name, platform, age_range, download_date

	UNION ALL

	-- Funnel step 4 - Completed Rides
	SELECT
    	4 AS funnel_step,
    	'completed_rides' AS funnel_name,
    	platform,
    	age_range,
    	DATE(download_ts) AS download_date,
    	COUNT(DISTINCT user_id) AS user_count,
    	COUNT(DISTINCT ride_id)::text AS ride_count
	FROM metrocar
	WHERE dropoff_ts IS NOT NULL
	GROUP BY funnel_step, funnel_name, platform, age_range, download_date

	UNION ALL

	-- Funnel step 5 - Payment
	SELECT
    	5 AS funnel_step,
    	'payment' AS funnel_name,
    	platform,
    	age_range,
    	DATE(download_ts) AS download_date,
    	COUNT(DISTINCT user_id)  AS user_count,
    	COUNT(DISTINCT ride_id)::text AS ride_count
	FROM metrocar
	WHERE charge_status = 'Approved'
	GROUP BY funnel_step, funnel_name, platform, age_range, download_date

	UNION ALL

	-- Funnel step 6 - Review
	SELECT
    	6 AS funnel_step,
    	'review' AS funnel_name,
    	platform,
    	age_range,
    	DATE(download_ts) AS download_date,
    	COUNT(DISTINCT user_id) AS user_count,
    	COUNT(DISTINCT review_id)::text AS ride_count
	FROM metrocar
	WHERE review_id IS NOT NULL
	GROUP BY funnel_step, funnel_name, platform, age_range, download_date
)
SELECT
	funnel_step,
	funnel_name,
	platform,
	age_range,
	download_date,
	user_count,
	ride_count
FROM user_counts
ORDER BY funnel_step, funnel_name, platform, age_range, download_date;









