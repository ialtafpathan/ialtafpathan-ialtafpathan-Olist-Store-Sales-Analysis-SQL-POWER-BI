/*													 SHIPPING & PAYMENTS                                                            */ 
-- 1) Average shipping time in days 
select  round(avg(datediff(order_delivered_customer_date, order_approved_at)),2) as avg_days 
from orders;

-- 2) year wise shipping time in days
SELECT  
    YEAR(order_purchase_timestamp) AS years,
    ROUND(AVG(DATEDIFF(order_delivered_customer_date,
                    order_approved_at)),
            2) AS avg_days
   FROM
    orders
GROUP BY years;

-- 3) most popular payment mehtod
SELECT 
    payment_type, COUNT(payment_value) AS no_of_payments
FROM
    payments
GROUP BY payment_type
ORDER BY no_of_payments DESC;

-- 4) Order status 
with cte as(select order_status,
count(order_status) as no_of_orders
from orders
where order_status is not null
group by order_status)
select 
order_status,
concat(round((no_of_orders/sum(no_of_orders) over())*100,2),"%") as percentage
from cte;

-- 5) delivry Status
alter table orders 
add column delivery_status varchar(20);
UPDATE orders 
SET 
    delivery_status = CASE
        WHEN
            order_delivered_customer_date IS NULL
                OR order_estimated_delivery_date IS NULL
        THEN
            'NA'
        WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN 'on time'
        WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 'Late'
    END;
 
 with cte as (select delivery_status, count(delivery_status)as delivery_count 
 from orders 
 group by delivery_status)
 
 select delivery_status, 
     concat(round( (delivery_count/sum(delivery_count) over())*100,2),"%")   as percentage
        from cte
        group by delivery_status
        order by percentage desc;
        
-- 6) avg price vs  shipping cost per category 
SELECT 
    *
FROM
    order_items;
SELECT 
    p.category_name_english,
    ROUND(AVG(price), 2) AS avg_price,
    ROUND(AVG(freight_value), 2) AS avg_shipping_cost
FROM
    products p
        JOIN
    order_items oi ON p.product_id = oi.product_id
GROUP BY p.category_name_english
ORDER BY avg_price DESC;

-- Top 5 states with most avg time for shpping 
SELECT 
    c.states,
    ROUND(AVG(DATEDIFF(order_delivered_customer_date,
                    order_approved_at)),
            2) AS avg_days
FROM
    orders o
        JOIN
    customers c ON o.customer_id = c.customer_id
GROUP BY c.states
ORDER BY avg_days DESC
LIMIT 5;

-- top 5 states with less shipping time
SELECT 
    c.states,
    ROUND(AVG(DATEDIFF(order_delivered_customer_date,
                    order_approved_at)),
            2) AS avg_days
FROM
    orders o
        JOIN
    customers c ON o.customer_id = c.customer_id
GROUP BY c.states
ORDER BY avg_days ASC
LIMIT 5;



 
        
	

 
 


