CREATE DATABASE salesdb;
USE salesdb;

CREATE TABLE salesmarts (
    invoice_id VARCHAR(50),
    branch VARCHAR(10),
    city VARCHAR(50),
    customer_type VARCHAR(100),
    gender VARCHAR(30),
    product_line VARCHAR(100),
    unit_price DECIMAL(10,2),
    quantity INT,
    VAT DECIMAL(6,5),
    total DECIMAL(20,5),
    date DATETIME,
    time TIME,
    payment VARCHAR(200),
    cogs DECIMAL(10,6),
    gross_margin_pct DECIMAL(11,9),
    gross_income DECIMAL(20,7),
    rating DECIMAL(4,2)
);


select * from salesmarts;





/*---------------FEATURE ENGINEERING------------*/


/*--TIME _OF_DAY*/
select 
time,
( CASE 
     WHEN 'time'BETWEEN "00:00:00" AND "12:00:00" THEN "morning"
     WHEN 'time'BETWEEN "12:01:00" AND "16:00:00" THEN "afternoon"
     ELSE "evening"
     END
     )
     AS time_of_date


from salesdb.salesmarts;

ALTER TABLE salesmarts ADD COLUMN time_of_day VARCHAR(20);

SET SQL_SAFE_UPDATES=0;
UPDATE salesmarts
set time_of_day = 
( CASE 
         WHEN 'time'BETWEEN "00:00:00" AND "12:00:00" THEN "morning"
         WHEN 'time'BETWEEN "12:01:00" AND "16:00:00" THEN "afternoon"
         ELSE "evening"
	END
     );
select * from salesmarts;


/*-----DAY NAME*/--------
SELECT 
     date
FROM salesmarts; 


SELECT 
    date,
    DAYNAME(date) AS day_name
FROM salesmarts;

ALTER TABLE salesmarts ADD COLUMN day_name VARCHAR(50);  

SET SQL_SAFE_UPDATES=0;
UPDATE salesmarts
SET day_name=DAYNAME(date); 

select * from salesmarts;


/*----month_name----*/
SELECT 
     date,
     MONTHNAME(date)
FROM salesmarts;     


ALTER TABLE salesmarts ADD COLUMN month_name VARCHAR(20);

set SQL_SAFE_UPDATES=0;
UPDATE salesmarts
SET month_name=MONTHNAME(date);

SELECT * FROM salesmarts;

/*------------GENERIC QUESTIONS------*/
/* ----How many unique cities does the data have?*/
SELECT 
    DISTINCT city
from salesmarts;  

/*---IN which city is each barnch?----*/
SELECT 
    DISTINCT branch
from salesmarts; 


SELECT 
    DISTINCT city,branch
from salesmarts; 

/*--------------------------------product--------------------*/
/* -- How many unique product lines does the data have?-----*/
SELECT 
     count(DISTINCT product_line)
FROM salesmarts;  

/*---What is the most common payment method?---*/
SELECT
     payment_method, 
     COUNT(payment_method) AS cnt
FROM salesmarts
GROUP BY payment_method
ORDER BY cnt DESC;


/*--What is the most selling product line?---*/
SELECT
	 product_line,
     COUNT(product_line) AS cnt
FROM salesmarts
GROUP BY product_line
ORDER BY cnt DESC;

/*----What is the total revenue by month---?*/
SELECT 
     month_name AS month,
     SUM(total) AS total_revenue
FROM salesmarts
GROUP BY month_name
ORDER BY total_revenue DESC;     
  
  /*--What month had the largest COGS?---*/
SELECT
       month_name AS month,
       SUM(cogs) AS cogs
FROM salesmarts
GROUP BY month_name
ORDER BY cogs DESC;       
   
/*--WHAT PRODUCT LINE HAD THE LARGEST REVENUE?---*/
SELECT 
     product_line,
     SUM(total) AS total_revenue
FROM salesmarts
GROUP BY product_line
ORDER BY total_revenue DESC;    


/*--WHAT IS THE CITY WITH THE LARGEST REVENUE?-----*/
SELECT 
     branch,
	 city,
     SUM(total) AS total_revenue
FROM salesmarts
GROUP BY city,branch
ORDER BY total_revenue DESC; 

/*---WHAT PRODUCT LINE HAD THE LARGEST VAT?--*/
SELECT 
     product_line,
     AVG(VAT)AS avg_tax
FROM salesmarts
GROUP BY product_line
order by avg_tax DESC;

/*--WHICH COUNTRY SOLD MORE PRODUCT THAN AVERAGE PRODUCT SOLD?---*/
SELECT 
     branch,
     SUM(quantity) AS qty
FROM salesmarts
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) from salesmarts);  

/*---WHAT IS THE MOST COMMON PRODUCT LINE BY GENDER?---*/
SELECT 
     gender,
     product_line,
     COUNT(gender) AS total_cnt
FROM salesmarts
GROUP BY gender,product_line
ORDER BY total_cnt DESC; 

/*--WHAT IS THE AVERAGE RATING OF EACH PRODUCT LINE?---*/
SELECT 
      AVG(rating) AS avg_rating,
      product_line
FROM salesmarts
GROUP BY product_line
ORDER BY avg_rating DESC;  


                    /*------------------SALES------------*/  
/*---NUmber of sales made in each time of the day per weekday----*/
SELECT
      time_of_day,
      COUNT(*) AS total_sales
FROM salesmarts
WHERE day_name="monday"
GROUP BY time_of_day
ORDER by total_sales DESC;  


/*----Which of the customer types brings the most revenue? -----*/
SELECT
      customer_type,
      SUM(total) AS total_rev
FROM salesmarts
GROUP BY customer_type
ORDER by total_rev DESC;  

/*---Which city has the largest tax percent/VAT ?----*/
SELECT 
     city,
     avg(VAT) AS VAT
FROM salesmarts
GROUP BY city
ORDER BY VAT DESC;

/*---Which customer type pays the most in VAT?----*/
SELECT 
      customer_type,
      AVG(VAT) as VAT
from salesmarts
GROUP BY customer_type
ORDER BY VAT desc;    


                  /*---------CUSTOMERS-----------*/  
/*----How many unique customer types does the data have?----*/
SELECT 
      DISTINCT customer_type
FROM salesmarts;      
     
     
/*----How many unique paymnet methods does the data have?----*/
SELECT 
     DISTINCT payment_method
FROM salesmarts;   


/*----Which customer type buys the most?-----*/
SELECT
      customer_type,
      COUNT(*) AS cstm_cnt
FROM salesmarts
GROUP BY customer_type;  


/*-------What is the gender of most of the customers?-----*/
SELECT 
      gender,
      COUNT(*) as gender_cnt
FROM salesmarts
GROUP BY gender
ORDER BY gender_cnt DESC; 


/*----What is the gender distribution per branch ?------*/   
SELECT 
      gender,
      count(*)as gender_cnt
FROM salesmarts
WHERE branch='B'
GROUP BY gender
ORDER by gender_cnt DESC;      
  
  
 /* ----What time of the day do customers give most ratings?-----*/
SELECT 
       time_of_day,
       AVG(rating) AS avg_rating
FROM salesmarts
GROUP BY time_of_day
ORDER BY  avg_rating DESC;  

/*---What time of the day customers give most ratings per barnch?------*/
SELECT 
       time_of_day,
       AVG(rating) AS avg_rating
FROM salesmarts
where branch="A"
GROUP BY time_of_day
ORDER BY avg_rating DESC; 


/*----Which day of the week has the best avg ratings ?------*/
SELECT
     day_name,
     AVG(rating) AS avg_rating
FROM salesmarts
GROUP BY day_name
ORDER BY avg_rating DESC;  


/*---which day of the week has the best average ratings per branch?----*/
SELECT 
     day_name,
     AVG(rating) AS avg_rating
FROM salesmarts
WHERE branch="A"
GROUP BY day_name
ORDER BY avg_rating DESC;     

     
       
     
 



    








    
    
    
    
    
    
    
    
