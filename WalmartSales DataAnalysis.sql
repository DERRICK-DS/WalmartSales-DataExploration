SELECT * FROM walmartsalesdata.sales;

-- ---------------------------------------------------------------------------------
-- -------------------------FEATURE ENGINEERING-------------------------------------

-- time_of_day

SELECT 
time,
(CASE
	 WHEN time >= "00:00:00" AND time < "12:00:00" THEN "Morning"
     WHEN time > "12:00:00" AND time < "17:00:00" THEN "Afternoon"
     ELSE "Evening"
END) as time_of_day
FROM sales; 

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
    CASE
	   WHEN time >= "00:00:00" AND time < "12:00:00" THEN "Morning"
	   WHEN time > "12:00:00" AND time < "17:00:00" THEN "Afternoon"
       ELSE "Evening"
	END
); 
-- day_name

SELECT 
      date,
      dayname(date) 
FROM sales;

ALTER TABLE sales ADD COLUMN day_of_week VARCHAR(20);

UPDATE sales
SET day_of_week = dayname(date) ;

-- month_name 

SELECT 
	 date,
     monthname(date) as month_name
FROM sales;

ALTER TABLE sales ADD month_name VARCHAR(10);

UPDATE sales
SET month_name = monthname(date);

-- ----------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------
-- ----------------------------------GENERIC-----------------------------------------

-- How many unique cities does the data have?

SELECT 
    distinct city
FROM sales;

SELECT 
    distinct branch
FROM sales;

SELECT 
    distinct city, branch
FROM sales;

-- -----------------------------------------------------------------------------------
-- --------------------------------PRODUCTS-------------------------------------------

-- How many unique product lines does the data have?

SELECT
    DISTINCT product_line
FROM sales;

-- What is the most common payment method?

SELECT 
     payment_method,
     sum(total) as cnt
FROM sales
GROUP BY payment_method
ORDER BY 2;

SELECT 
     payment_method,
     COUNT(payment_method) as sum
FROM sales
GROUP BY payment_method
ORDER BY 2;

-- What is the most popular product line?

SELECT 
	product_line,
    count(product_line) as popular_pl
FROM sales
group by product_line
order by popular_pl DESC ;

-- What is the total revenue by month

SELECT 
	month_name,
    SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY 2 DESC;

-- What month had the largest COGS?

SELECT
     month_name,
     SUM(cogs)
FROM sales
GROUP BY month_name
order by 2;

-- What product line had the largest revenue

SELECT
     product_line,
     SUM(total)
FROM sales
GROUP BY product_line
ORDER BY 2 DESC;

-- What is the city with largest revenue.

SELECT
     city,
     sum(total)
FROM sales
GROUP BY city
ORDER BY 2;

-- What product line had the largest VAT.

SELECT
     product_line,
     AVG(VAT)
FROM sales
GROUP BY product_line
order by 2 DESC;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales


SELECT
     product_line,
     SUM(total) as Rev_per_pline
FROM sales
GROUP BY product_line
ORDER BY 2 DESC;

WITH Rev_per_pline_cte as
(
SELECT
     product_line,
     SUM(total) as Rev_per_pline
FROM sales
GROUP BY product_line
ORDER BY 2 DESC
)
SELECT
      product_line,
      Rev_per_pline,
CASE
     WHEN Rev_per_pline < (SELECT AVG(Rev_per_pline) FROM Rev_per_pline_cte) THEN 'BAD'
     WHEN Rev_per_pline > (SELECT AVG(Rev_per_pline) FROM Rev_per_pline_cte) THEN 'GOOD'
     ELSE 'NULL'
END as Rating
FROM Rev_per_pline_cte;

-- Which branch sold more products than average product sold?

SELECT
	 branch,
     SUM(quantity)
FROM sales
GROUP BY branch
order by 2 DESC;

WITH BranchSales as(
SELECT
	 branch,
     SUM(quantity) as TotalQuantity
FROM sales
GROUP BY branch
order by 2 DESC
)
SELECT
	 branch,
     TotalQuantity,
CASE
    WHEN TotalQuantity > (SELECT AVG(TotalQuantity) FROM BranchSales) THEN 'AboveAverage'
    ELSE 'BelowAverage'
    END as sales_status
FROM BranchSales;

-- What is the Average rating of each product line?

SELECT
	  product_line,
      AVG(rating)
FROM sales
GROUP BY product_line
order by 2 DESC;

-- ----------------------------------------------------------------------------------
-- ----------------------------------SALES-------------------------------------------

-- Number of sales made in each time of the day per weekday. 

SELECT
	  SUM(quantity),
      day_of_week
FROM sales
GROUP BY day_of_week
ORDER BY 1;

-- Which of the customer types brings the most revenue?

SELECT
	  customer_type,
      SUM(total)
FROM sales
GROUP BY customer_type;

--  Which city has the largest tax percent/ VAT (**Value Added Tax**)?
	 
SELECT
      city,
      AVG(VAT)
FROM sales
GROUP BY city;

-- Which customer type pays the most in VAT?

SELECT
     customer_type,
     AVG(VAT)
FROM sales
GROUP BY customer_type;

-- -----------------------------------------------------------------------------------
-- ----------------------------CUSTOMER----------------------------------------------

-- How many unique customer types does the data have?

SELECT
	DISTINCT customer_type
FROM SALES;

-- How many unique payment methods does the data have?

SELECT
	DISTINCT payment_method
FROM SALES;

-- What is the most common customer type\Which customer type buys the most?

SELECT
	  customer_type,
     COUNT(*)
FROM SALES
GROUP BY customer_type;

-- What is the gender of most of the customers?

SELECT
     gender,
	 COUNT(*)
FROM sales
GROUP BY gender;

-- What is the gender distribution per branch?

SELECT
     gender,
	 branch,
     count(*)
FROM sales
GROUP BY gender, branch
order by 2 ;

-- Which time of the day do customers give most ratings?

SELECT
     COUNT(rating),
     time_of_day
FROM sales
GROUP BY time_of_day;

-- Which time of the day do customers give most ratings per branch?

SELECT
     COUNT(rating),
     time_of_day,
     branch
FROM sales
GROUP BY time_of_day,branch
order by 3;

--  Which day fo the week has the best avg ratings?

SELECT
     AVG(rating),
     day_of_week
FROM sales
GROUP BY day_of_week;

-- Which day of the week has the best average ratings per branch?

SELECT
     AVG(rating),
     day_of_week,
     branch
FROM sales
GROUP BY day_of_week,branch
order by 3


	 



















