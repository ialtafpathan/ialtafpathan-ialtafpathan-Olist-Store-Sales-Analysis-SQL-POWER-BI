/*  									CUSTOMERS & SELLERS ANALYSIS                                       */  
-- Number of unique customer by state Top 10 States
SELECT 
    states,
    COUNT(DISTINCT customer_unique_id) AS No_of_customers
FROM
    customers
GROUP BY states
ORDER BY No_of_customers DESC
LIMIT 10;

-- Top 10 product categories most ordered by customers 
with cte as (select * 
from customers
join orders using(customer_id)
join order_items using(order_id)
join products USING(product_id)) 

select category_name_english,
       sum(order_item_id) AS units
       from cte
       group by category_name_english
       order by units desc
       limit 10;

-- Top 5 sellers who sold most products
SELECT 
    seller_id, COUNT(order_id) AS Total_orders
FROM
    order_items
GROUP BY seller_id
ORDER BY total_orders DESC
LIMIT 5;

-- Bottom 5 sellers who sold less products 
SELECT 
    seller_id, COUNT(order_id) AS Total_orders
FROM
    order_items
GROUP BY seller_id
ORDER BY total_orders ASC
LIMIT 5;


-- Average customer order price by state
with cte as (select c.customer_id, states, (order_item_id*price+freight_value) as total_price
from customers c join orders od 
on c.customer_id = od.customer_id
join order_items oi 
on od.order_id = oi.order_id)
select 
states,
 concat(round(avg(total_price),2),"$") as avg_price
 from cte
 group by c.states
 order by avg_price desc
 limit 5;

--  How many percents of the customer base do the top ten cities account for?
with cte as(select 
    customer_city,
  count(customer_unique_id) as no_customers
  from customers
  group by customer_city
  ORDER BY no_customers DESC)
  
select
   customer_city,
   no_customers,
  concat(round(no_customers/sum(no_customers) over() * 100,2) ,"%") as percentage_customer_base,
  concat(round(sum( no_customers) over(order by no_customers desc )/sum( no_customers) over()*100,2),"%") as running_total_percentage
from cte 
ORDER BY no_customers DESC
LIMIT 10;

-- How many percents of the seller base do the top ten cities account for?
with cte as (select 
Seller_city,
count(distinct seller_id) as no_selller
 from sellers
 group by seller_city
 order by no_selller desc
 )
 select 
Seller_city,
no_selller,
concat( round(no_selller/sum(no_selller) over()*100,2),"%") as percentage_seller_base,
concat( round( sum(no_selller) over(order by no_selller desc) / sum(no_selller) over()*100,2),"%") as running_total_percentage
from cte
group by Seller_city
limit 10;

-- Frequency credit card payment by customers state 
SELECT 
    states, payment_type, COUNT(*) AS counts
FROM
    payments p
        JOIN
    orders od ON p.order_id = od.order_id
        JOIN
    customers c ON od.customer_id = c.customer_id
WHERE
    payment_type = 'credit_card'
GROUP BY states , payment_type
ORDER BY counts DESC
LIMIT 10;
  

   -- avg product rating by catogory  
    SELECT 
    p.category_name_english,
    ROUND(AVG(rv.review_score), 2) AS ratting
FROM
    products p
        JOIN
    order_items oi ON p.product_id = oi.product_id
        JOIN
    reviews rv ON oi.order_id = rv.order_id
GROUP BY p.category_name_english
ORDER BY ratting DESC
LIMIT 10;
   
-- Most popular payment methods 
SELECT 
    payment_type, COUNT(*) AS Total_payments
FROM
    payments
GROUP BY payment_type;
 
   

