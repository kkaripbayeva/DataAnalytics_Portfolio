/* Skills used: 
-- SQL: Data retrieval, aggregation, and manipulation.
-- Data Analysis: Customer segmentation, descriptive analytics.
-- Loyalty Program Analysis: Calculating points, assessing program effectiveness.*/

/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?
-- 2. How many days has each customer visited the restaurant?
-- 3. What was the first item from the menu purchased by each customer?
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
-- 5. Which item was the most popular for each customer?
-- 6. Which item was purchased first by the customer after they became a member?
-- 7. Which item was purchased just before the customer became a member?
-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

-----------

-- 1. Total amount each customer spent at the restaurant:


SELECT customer_id, SUM(price) AS total_spent 
FROM dannys_diner.sales AS sales
JOIN dannys_diner.menu AS menu
ON sales.product_id = menu.product_id
GROUP BY customer_id
ORDER BY total_spent DESC;

-- 2. Total days customer visited the restaurant:

SELECT customer_id, COUNT(DISTINCT order_date) AS total_days FROM dannys_diner.sales
GROUP BY customer_id

-- 3. First items purchased by cutomer:

SELECT sales.customer_id AS customer_id, product_name FROM dannys_diner.sales AS sales
JOIN dannys_diner.menu AS menu
ON sales.product_id = menu.product_id
JOIN (SELECT customer_id, MIN(order_date) AS mdate
	FROM dannys_diner.sales 
	GROUP BY customer_id) AS min_date
ON sales.customer_id = min_date.customer_id
WHERE sales.order_date = min_date.mdate
ORDER by sales.customer_id

-- 4. Most purchased item:

SELECT product_name, COUNT(sales.product_id) AS total_purchased FROM dannys_diner.menu AS menu
JOIN dannys_diner.sales AS sales
ON menu.product_id = sales.product_id
GROUP BY product_name

-- 5. Most popular item:

SELECT rank_sales.customer_id, menu.product_name AS most_popular_item 
FROM (SELECT customer_id, product_id, RANK() OVER (PARTITION BY customer_id ORDER BY COUNT(*) DESC) AS ranking FROM dannys_diner.sales
      GROUP BY customer_id, product_id) AS rank_sales
JOIN dannys_diner.menu AS menu
ON rank_sales.product_id = menu.product_id AND rank_sales.ranking = 1
ORDER BY customer_id

-- 6. First item purchased after membership

SELECT ranked.customer_id, menu.product_name AS first_purchase 
FROM (SELECT sales.customer_id, sales.product_id, sales.order_date, RANK() OVER (PARTITION BY sales.customer_id ORDER BY sales.order_date) AS ranking
      FROM dannys_diner.sales sales
      JOIN dannys_diner.members members
      ON members.customer_id = sales.customer_id
      WHERE sales.order_date>=members.join_date) AS ranked
JOIN dannys_diner.menu menu
ON ranked.product_id = menu.product_id
WHERE ranking = 1

-- 7. Item purchased just before membershihp:
SELECT ranked.customer_id, menu.product_name AS last_purchase_before_membership
FROM (SELECT sales.customer_id, sales.product_id, sales.order_date, RANK() OVER (PARTITION BY sales.customer_id ORDER BY sales.order_date DESC) AS ranking
      FROM dannys_diner.sales sales
      JOIN dannys_diner.members members
      ON members.customer_id = sales.customer_id
      WHERE sales.order_date<members.join_date) AS ranked
JOIN dannys_diner.menu menu
ON ranked.product_id = menu.product_id
WHERE ranking = 1

-- 8. Total spent before membership
SELECT ranked.customer_id, COUNT(*) AS total_items,SUM(price) AS amount_spent 
FROM (SELECT sales.customer_id, sales.product_id, sales.order_date, RANK() OVER (PARTITION BY sales.customer_id ORDER BY sales.order_date DESC) AS ranking
      FROM dannys_diner.sales sales
      JOIN dannys_diner.members members
      ON members.customer_id = sales.customer_id
      WHERE sales.order_date<members.join_date) AS ranked
JOIN dannys_diner.menu menu
ON ranked.product_id = menu.product_id
GROUP BY ranked.customer_id

-- 9. Membership points:
SELECT ranked.customer_id, SUM(CASE 
                              WHEN menu.product_name = 'sushi' THEN 2*menu.price*10
                              ELSE menu.price*10
                              END) AS total_points
FROM (SELECT sales.customer_id, sales.product_id, sales.order_date
      FROM dannys_diner.sales sales
      JOIN dannys_diner.members members
      ON members.customer_id = sales.customer_id
      WHERE sales.order_date>=members.join_date) AS ranked
JOIN dannys_diner.menu menu
ON ranked.product_id = menu.product_id
GROUP BY ranked.customer_id
ORDER BY ranked.customer_id

-- 10. Total points in January
SELECT sales.customer_id, SUM(CASE
                              WHEN sales.order_date <= (members.join_date + INTERVAL '7 days') THEN 2 * menu.price * 10
                              WHEN menu.product_name = 'sushi' THEN 2 * menu.price * 10
                              ELSE menu.price * 10
                              END) AS total_points
FROM dannys_diner.sales sales
JOIN dannys_diner.members members 
ON members.customer_id = sales.customer_id
JOIN dannys_diner.menu menu 
ON sales.product_id = menu.product_id
WHERE sales.order_date >= members.join_date  -- Only consider purchases after joining
    AND EXTRACT(MONTH FROM sales.order_date) = 1  -- Only consider January
GROUP BY sales.customer_id;

-- Bonus Questions

-- Join All The Things

SELECT sales.customer_id AS customer_id, order_date, product_name, price, CASE WHEN order_date >= join_date THEN 'Y' ELSE 'N' END AS member 
FROM dannys_diner.sales AS sales
JOIN dannys_diner.menu AS menu
ON sales.product_id = menu.product_id
FULL JOIN dannys_diner.members AS members
ON sales.customer_id = members.customer_id
ORDER BY customer_id, order_date

-- Rank All The Things

WITH full_join AS (SELECT sales.customer_id AS customer_id, order_date, product_name, price, CASE WHEN order_date >= join_date THEN 'Y' ELSE 'N' END AS member 
FROM dannys_diner.sales AS sales
JOIN dannys_diner.menu AS menu
ON sales.product_id = menu.product_id
FULL JOIN dannys_diner.members AS members
ON sales.customer_id = members.customer_id)
SELECT customer_id, order_date, product_name, price, member, CASE WHEN member = 'Y' THEN RANK() OVER (PARTITION BY customer_id ORDER BY order_date) ELSE NULL END AS ranking
FROM full_join
ORDER BY customer_id, order_date


/* How this can answer business problems or help a business out:

-- Danny can draw several conclusions that can help him make informed decisions for Danny's Diner:

---- Customer Spending Behavior:
Danny can identify high-spending customers and tailor special promotions or loyalty rewards to retain their business. 
He can also analyze spending trends to optimize menu offerings and pricing strategies.

---- Customer Visitation Patterns:
Understanding how frequently customers visit the restaurant allows Danny to gauge customer loyalty and satisfaction. 
He can identify loyal customers and incentivize repeat visits through targeted marketing campaigns or loyalty programs.

---- Customer Preferences:
By analyzing the first items purchased by each customer and the most purchased items overall, Danny can gain insights 
into customer preferences. This information can guide menu planning and help Danny optimize his offerings to cater to 
popular tastes.

---- Effectiveness of Membership and Loyalty Programs:
Danny can assess the impact of the existing membership and loyalty programs by analyzing pre- and post-membership 
spending behavior. This analysis can help him determine whether to expand the programs or adjust their features to 
better meet customer needs.

---- Promotional Effectiveness:
Analyzing the total points earned by customers, especially during promotional periods, allows Danny to evaluate the 
effectiveness of marketing initiatives. He can identify which promotions drive the most engagement and adjust future 
marketing strategies accordingly.

*/
