
-- Total Revenue 
SELECT 
    ROUND(SUM(p.payment_value), 0)
FROM
    payments p
        JOIN
    orders od ON p.order_id = od.order_id
WHERE
    od.order_status <> 'canceled'
        AND od.order_delivered_customer_date IS NOT NULL;
SELECT 
    CONCAT(ROUND(SUM(payment_value) / 1000000, 2),
            'M') ' Total Revenue'
FROM
    payments;

-- Total Profit 
SELECT 
    CONCAT(ROUND((sales.total_sales - profit.total_costs) / 1000000,
                    2),
            'M')'Profit'
FROM
    (SELECT 
        SUM(payment_value) AS total_sales
    FROM
        payments) AS Sales,
    (SELECT 
        SUM(price) AS total_costs
    FROM
        order_items) AS profit;
    
-- Total Orders     

SELECT 
    CONCAT(ROUND(COUNT(order_id) / 1000, 2), 'K')'No of Orders'
FROM
    orders;    

-- Total Customers 
SELECT 
    CONCAT(ROUND(COUNT(DISTINCT customer_unique_id) / 1000,
                    2),
            'K')'Total Customers'
FROM
    customers;

-- Average Order Per Customers

SELECT 
    ROUND(COUNT(od.order_id) / COUNT(DISTINCT c.customer_unique_id),
            2)'Average Order Per Customers'
            
FROM
    orders od
        JOIN
    customers c ON od.customer_id = c.customer_id;

	-- Average Order Value

	SELECT 
		CONCAT(ROUND(SUM(p.payment_value) / COUNT(od.order_id),
						2),
				'$') 'Average Order Value'
	FROM
		payments p
			JOIN
		orders od ON p.order_id = od.order_id;
 
 -- No Of Canclled Orders 
SELECT 
    COUNT(order_id) AS 'Cancled Orders'
FROM
    orders
WHERE
    order_status = 'canceled';
 
-- No of Canceled order %  
SELECT 
    CONCAT(ROUND((COUNT(CASE
                        WHEN order_status = 'canceled' THEN 1
                    END) / COUNT(*)) * 100,
                    2),
            '%') 'canceled orders %'
FROM
    orders; 
-- No of Deliverd orders 
SELECT 
    COUNT(order_id) 'Delivered Orders'
FROM
    orders
WHERE
    order_status = 'delivered';
    
 
 -- Deliverd order % 
SELECT 
    CONCAT(ROUND((COUNT(CASE
                        WHEN order_status = 'delivered' THEN 1
                    END) / COUNT(*)) * 100,
                    2),
            '%') AS deliverd
FROM
    orders;
 
 -- No Of Seller 
SELECT 
    COUNT(DISTINCT seller_id) 'Total Sellers'
FROM
    sellers;

-- Averge order per slller 
SELECT 
    ROUND(COUNT(oi.order_id) / COUNT(DISTINCT s.seller_id),
            2) 'AVO/Sellers'
FROM
    order_items oi
        JOIN
    sellers s ON oi.seller_id = s.seller_id;

 -- freght Charges 
 SELECT 
    CONCAT(ROUND(SUM(freight_value) / 1000000, 2),
            'M') AS Freight_charges
FROM
    order_items;
 
 -- avg Customers rating  
SELECT
   ROUND(AVG(rv.review_score), 1) AS avg_review
FROM
   orders oo
JOIN 
   reviews rv ON oo.order_id = rv.order_id
WHERE
   order_status <> 'canceled'
   AND order_delivered_customer_date IS NOT NULL;