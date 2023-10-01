/*1) Write a query to get the sum of impressions by day.*/
USE sql_assessment;

SELECT cast(date AS date) AS DATE,SUM(impressions) AS total_impressions
FROM marketing_data
GROUP BY 1
ORDER BY 2 DESC; /*order by total impressions*/

/* 2) Write a query to get the top three revenue-generating states in order of best to worst. 
How much revenue did the third best state generate?*/

SELECT state, SUM(revenue) AS total_revenue_from_website
FROM website_revenue
GROUP BY state
ORDER BY SUM(revenue) DESC
LIMIT 3 ;
/* The third best state generates $37577 */

/* 3) Write a query that shows total cost, impressions, clicks, and revenue of each campaign. 
Make sure to include the campaign name in the output.*/
WITH cleaned_web_data AS (
SELECT campaign_id, SUM(revenue) AS Revenue
FROM website_revenue
GROUP BY 1
)
SELECT c.name,
m.campaign_id, 
SUM(m.cost) AS total_cost, 
SUM(m.impressions) AS total_impressions,
SUM(m.clicks) AS total_clicks,
w.revenue AS total_revenue
FROM marketing_data m
LEFT JOIN cleaned_web_data w USING(campaign_id)
LEFT JOIN campaign_info c ON m.campaign_id = c.id
GROUP BY 1,2,6
ORDER BY sum(m.impressions) DESC;

/* 4) Write a query to get the number of conversions of Campaign 5 by state. 
Which state generated the most conversions for this campaign?*/

SELECT geo,sum(conversions) AS total_conversions
FROM marketing_data m
INNER JOIN campaign_info c ON m.campaign_id = c.id
WHERE c.name = "Campaign5"
GROUP BY geo
ORDER BY sum(conversions) DESC;
/*Georgia generated the most conversions for the campaign 5 */

/* 5) In your opinion, which campaign was the most efficient, and why? */

WITH cleaned_web_data AS (
SELECT campaign_id, SUM(revenue) AS Revenue
FROM website_revenue
GROUP BY 1
),
Aggregate_by_campaign AS(
SELECT c.name,
m.campaign_id, 
w.revenue AS total_revenue,
SUM(m.cost) AS total_cost, 
SUM(m.impressions) AS total_impressions,
SUM(m.clicks) AS total_clicks,
SUM(m.conversions) AS total_conversions
FROM marketing_data m
LEFT JOIN cleaned_web_data w USING(campaign_id)
LEFT JOIN campaign_info c ON m.campaign_id = c.id
GROUP BY 1,2,3
)
/* CPM (cost per mile) , CPA(cost per action) *, CTR, CPC, CR, ROI , ROAS*/
SELECT name, 
(total_cost/total_impressions) *1000 AS CPM,
(total_cost/total_clicks) AS CPC, 
(total_cost/total_conversions)AS CPConv,
(total_clicks/total_impressions) AS CTR,
(total_conversions/total_clicks) AS CR,
total_revenue/total_cost AS ROAS
FROM Aggregate_by_campaign
ORDER BY 2 ASC;

 /* In my opinion, in terms of which campaign is the most efficient, it depends on what was the goal of each campaign (such as whether 
 it is an awareness-content campaign or conversion-driven campaign). My definition of success in this case would be the campaign that 
 has low cost at the same time has high revenue.
 
 Campaign 4 was the most efficient because it has the lowest cost per mile and cost per action, however, 
 it has the second highest Return on Ads Spending. For every 1000 impressions gained, we only cost 83.56 for Campaign 4 
 whereas other campaigns are way more costly. Also, for every conversion, Campaign 4 only cost $0.42. With the lowest cost, 
 for every $1 ad spending in Campaign 4, it has a revenue return of $61, which is the second highest in the five campaigns.
 */

/* Bonus Question 6) Write a query that showcases the best day of the week 
(e.g., Sunday, Monday, Tuesday, etc.) to run ads. */

SELECT DAYNAME(date) AS day_of_week, 
SUM(impressions) AS total_impressions, 
SUM(conversions) AS total_conversions, 
SUM(clicks) AS total_clicks,
ROUND(SUM(cost),3) AS total_cost,
ROUND((SUM(cost)/SUM(impressions)),3) *1000 AS CPM,
ROUND(SUM(cost)/SUM(conversions),3) AS CPConv
FROM marketing_data m
GROUP BY 1
ORDER BY 2 DESC;

SELECT DAYNAME(date) AS day_of_week,
COUNT(DAYNAME(date)) AS Frequency_of_day,
SUM(revenue) AS total_revenue,
SUM(revenue)/COUNT(DAYNAME(date)) AS revenue_per_day
FROM website_revenue
GROUP BY 1
ORDER BY 4 DESC;

/*Considering both marketing data like impressions and clicks and also revenue, Friday would be the best day of the week to run ads
as it has the highest impressions, conversions and total clicks with an average revenue. From advertiser's point of view, 
impressions, clicks and conversions are the most effective metrics.*/














