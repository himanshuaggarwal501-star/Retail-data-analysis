Create Database Retail_Data
Use retail_data_project

select * from clean_merge_data

-- 1. Find the customer wise transaction amount 
select customer_id,sum(tran_amount) as Total_spent from clean_merge_data
group by customer_id
order by Total_spent desc

-- 2. Count of customers who give the response and who don't give the response 
select response,count(customer_id) as Total_count from clean_merge_data
group by response

-- 3. Find the number of transaction done by each customer?
select customer_id,count(customer_id) as Total_cnt from clean_merge_data
group by customer_id
order by count(customer_id) desc

---- TIME ANALYSIS ----

-- 4. Compare the transaction amount YOY. 
with year_sales as (
select year(trans_date) as year_date,sum(tran_amount) as revenue,
LAG(sum(tran_amount)) over(order by year(trans_date)) as previous_year_revenue
from clean_merge_data
group by year(trans_date)
),

YOY_amt_diff as (
select year_date,revenue,previous_year_revenue, (revenue-previous_year_revenue) as Yoy_diff, 
Cast(revenue-previous_year_revenue as float)/previous_year_revenue * 100.0 as percent_YOY
from year_sales
)

select * from YOY_amt_diff

-- 5. Compare the count of transaction YOY.

with prev_year as (
select YEAR(trans_date) as years , count(*) as current_count,
LAG(count(*)) over (order by year(trans_date)) as prev_year_count
from clean_merge_data
group by YEAR(trans_date)
),
count_diff as (
select *,CAST(current_count-prev_year_count as float) as count_difference,
cast(current_count-prev_year_count as float)/prev_year_count * 100 as YOY_percent_count from prev_year
)

select * from count_diff

-- 6. Compare the transaction amount MOM. 

With previous_month_amt as (
select MONTH(trans_date) as Months,sum(tran_amount) as current_month_amount,
LAG(sum(tran_amount)) Over (order by Month(trans_date)) as prev_month_amount
from clean_merge_data
group by MONTH(trans_date)
),
MOM_diff as (
select *,(current_month_amount-prev_month_amount) as MOM_difference,CAST(current_month_amount-prev_month_amount as float)/prev_month_amount * 100 as MOM_percentage
from previous_month_amt)

select * from MOM_diff 


-- 7. Compare the count of transaction MOM. 

with prev_month as (
select Month(trans_date) as Months , count(*) as current_count,
LAG(count(*)) over (order by Month(trans_date)) as prev_month_count
from clean_merge_data
group by Month(trans_date)

),

count_diff as (
select *,CAST(current_count-prev_month_count as float) as count_difference,
cast(current_count-prev_month_count as float)/prev_month_count * 100 as MOM_percent_count from prev_month
)

select * from count_diff

-- 8. Top 5 Customers according to there transaction amount.

select * from (
select customer_id,sum(tran_amount) as Total_spent,DENSE_RANK() over(order by sum(tran_amount) Desc) as rnk from clean_merge_data
group by customer_id) as t
where rnk <= 5
  


--- Q -- 9.     --- RFM ANALYSIS ---


with rfm_values as (
SELECT customer_id,DATEDIFF(DAY, MAX(trans_date) ,(SELECT MAX(trans_date) FROM clean_merge_data)) AS recency,
COUNT(*) AS frequency,SUM(tran_amount) AS monetary FROM clean_merge_data
GROUP BY customer_id),

rfm_scores AS (
SELECT customer_id,
        NTILE(5) OVER (ORDER BY recency ASC)  AS r_score,
        NTILE(5) OVER (ORDER BY frequency DESC) AS f_score,
        NTILE(5) OVER (ORDER BY monetary DESC)  AS m_score
    FROM rfm_values
)
SELECT
    customer_id,
    r_score,
    f_score,
    m_score,
    CONCAT(r_score, f_score, m_score) AS rfm_segment
FROM rfm_scores;  

-- Recency - last date of transaction 
-- Frequency - count of transaction
-- Monetary -- total amount of all transaction 

Create view rfm_summ1 as 
with rfm_base as (
select customer_id,DATEDIFF(Day,Max(trans_date),(Select Max(trans_date) from clean_merge_data)) as recency,
count(*) as frequency,sum(tran_amount) as monetary from clean_merge_data
group by customer_id),

rfm_score as (
select *,NTILE(5) over(order by recency desc) as r_score,NTILE(5) over(order by frequency asc) as f_score,
NTILE(5) over(order by monetary asc) as m_score from rfm_base)
SELECT *,CONCAT(r_score,f_score,m_score) as rfm_segment,
CASE
    WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'  -- This is the standard company wise segmentation in RFM
    WHEN r_score >= 3 AND f_score >= 3 THEN 'Loyal Customers'
    WHEN r_score <= 2 AND f_score >= 3 AND m_score >= 3 THEN 'At Risk'
    WHEN r_score <= 2 AND m_score >= 4 THEN 'Big Spenders Lost'
    WHEN r_score <= 2 AND f_score <= 2 THEN 'Churned'
    ELSE 'Medium Value'
END AS customer_segment
FROM rfm_score


select * from rfm_summ1


--- Q-10  Seasonality and day of week analysis:
    
    --- 10.1   Month wise Analysis 
    select Month(trans_date) as Months,sum(tran_amount) as Total_spent from clean_merge_data
    group by Month(trans_date)
    order by Months

    --- 10.2 Quarter wise analysis
    select DATEPART(QUARTER,trans_date) as Quarters,sum(tran_amount) as Total_spent from clean_merge_data
    group by DATEPART(QUARTER,trans_date)
    order by Quarters

    --- 10.3 Day of week analysis
    select DATENAME(Weekday,trans_date) as Day_name, sum(tran_amount) as Total_spent from clean_merge_data
    group by DATENAME(Weekday,trans_date)



-- Q - 11 Customer Lifetime Value (CLV) 
--  What it is: Instead of just looking at what they spent (Monetary), you calculate how long they have been with the brand.


select customer_id,DATEDIFF(Day,Min(trans_date),Max(trans_date)) as Duration_in_days,sum(tran_amount) as Total_spent from clean_merge_data
group by customer_id
order by Duration_in_days desc




-- Q - 12 Find the Average Transaction Value (ATV) for both response groups.

select response, AVG(tran_amount) as avg_transaction_value from clean_merge_data
group by response
order by AVG(tran_amount) desc


