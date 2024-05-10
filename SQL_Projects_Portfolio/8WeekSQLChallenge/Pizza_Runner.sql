/* 
Skills used: 

*/

/* --------------------
   Case Study Questions
   --------------------*/
/*
   ------A. Pizza Metrics------
-- 1. How many pizzas were ordered?
-- 2. How many unique customer orders were made?
-- 3. How many successful orders were delivered by each runner?
-- 4. How many of each type of pizza was delivered?
-- 5. How many Vegetarian and Meatlovers were ordered by each customer?
-- 6. What was the maximum number of pizzas delivered in a single order?
-- 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
-- 8. How many pizzas were delivered that had both exclusions and extras?
-- 9. What was the total volume of pizzas ordered for each hour of the day?
-- 10. What was the volume of orders for each day of the week?

   ------B. Runner and Customer Experience------
-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
-- 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
-- 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
-- 4. What was the average distance travelled for each customer?
-- 5. What was the difference between the longest and shortest delivery times for all orders?
-- 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
-- 7. What is the successful delivery percentage for each runner?

   ------C. Ungredient Optimisation------
-- 1. What are the standard ingredients for each pizza?
-- 2. What was the most commonly added extra?
-- 3. What was the most common exclusion?
-- 4. Generate an order item for each record in the customers_orders table in the format of one of the following:
---- * Meat Lovers
---- * Meat Lovers - Exclude Beef
---- * Meat Lovers - Extra Bacon
---- * Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers
-- 5. Generate an alphabetically ordered comma separated ingredient list for each pizza order from the customer_orders table and add a 2x in front of any relevant ingredients
---- * For example: "Meat Lovers: 2xBacon, Beef, ... , Salami"
-- 6. What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?
   ------D. Pricing and Ratings------
-- 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
-- 2. What if there was an additional $1 charge for any pizza extras?
---- * Add cheese is $1 extra
-- 3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
-- 4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
---- * customer_id
---- * order_id
---- * runner_id
---- * rating
---- * order_time
---- * pickup_time
---- * Time between order and pickup
---- * Delivery duration
---- * Average speed
---- * Total number of pizzas
-- 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries?
   ------E. Bonus Questions------
-- 1. If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?
*/

----------- SOLUTION -----------
--- Investigating the data:
-- Clean up customer_orders by removing null values  and changing exclusions and extras into array
UPDATE pizza_runner.customer_orders
SET exclusions = CASE 
	WHEN exclusions = 'null' THEN ''
    ELSE exclusions
    END;
        
UPDATE pizza_runner.customer_orders
SET extras = CASE
    WHEN extras = 'null' THEN ''
    ELSE COALESCE(extras, '')
    END;

ALTER TABLE pizza_runner.customer_orders
ALTER COLUMN exclusions TYPE TEXT[] USING STRING_TO_ARRAY(exclusions,',');

ALTER TABLE pizza_runner.customer_orders
ALTER COLUMN extras TYPE TEXT[] USING STRING_TO_ARRAY(extras,',');

-- Clean up runner_orders by cleaning up null values and adjusting data types

-- Adjust data types and handle null values using CASE
ALTER TABLE pizza_runner.runner_orders
ALTER COLUMN pickup_time TYPE TIMESTAMP USING 
    CASE WHEN pickup_time = 'null' THEN NULL ELSE TO_TIMESTAMP(pickup_time, 'YYYY-MM-DD HH24:MI:SS') END,
ALTER COLUMN distance TYPE NUMERIC USING 
    CASE WHEN distance = 'null' THEN NULL ELSE REPLACE(distance, 'km', '')::NUMERIC END,
ALTER COLUMN duration TYPE NUMERIC USING 
    CASE WHEN duration = 'null' THEN NULL ELSE REPLACE(REPLACE(REPLACE(duration,'mins',''),'minutes',''),'minute','')::NUMERIC END,
ALTER COLUMN cancellation TYPE VARCHAR(23) USING 
    CASE WHEN cancellation = 'null' THEN NULL ELSE cancellation END;
-- SET A:

-- Total pizzas ordered:
SELECT COUNT(*) FROM pizza_runner.customer_orders;

-- Unique customer orders:
SELECT COUNT(DISTINCT(order_id)) FROM pizza_runner.customer_orders;

-- Succesfull delivery by each runner:
SELECT runner_id, COUNT(order_id) FROM pizza_runner.runner_orders
WHERE pickup_time IS NOT null
GROUP BY runner_id;

-- Total pizzas delivered:
SELECT pizza_name, COUNT(pizza_name) AS total_delivered FROM pizza_runner.pizza_names AS names
JOIN pizza_runner.customer_orders AS customer
ON names.pizza_id = customer.pizza_id
JOIN pizza_runner.runner_orders AS run_order
ON customer.order_id = run_order.order_id
WHERE pickup_time IS NOT null
GROUP BY pizza_name;

-- Total order by customers by pizza
SELECT customer_id,
    SUM(CASE WHEN customer.pizza_id = '1' THEN 1 ELSE 0 END) AS vegetarian_orders,
    SUM(CASE WHEN customer.pizza_id = '2' THEN 1 ELSE 0 END) AS meatlovers_orders
FROM pizza_runner.customer_orders AS customer
JOIN pizza_runner.pizza_names AS pizza 
  ON customer.pizza_id = pizza.pizza_id
JOIN pizza_runner.runner_orders AS orders 
  ON customer.order_id = orders.order_id
WHERE pickup_time IS NOT NULL
GROUP BY customer_id
ORDER BY customer_id;

-- Maximum number of pizzas in one delivery
SELECT MAX(count_order) AS max_pizzas_delivered FROM (SELECT customer.order_id AS order_id, COUNT(customer.order_id) AS count_order 
                              FROM pizza_runner.customer_orders AS customer
                              JOIN pizza_runner.runner_orders AS runner
                              ON customer.order_id = runner.order_id
                              WHERE pickup_time IS NOT NULL
GROUP BY customer.order_id) AS x

-- Total changes in pizza by customer
SELECT customer_id,
       SUM(CASE WHEN cardinality(exclusions) > 0 OR cardinality(extras) > 0 THEN 1 ELSE 0 END) AS changes_in_pizza,
       SUM(CASE WHEN cardinality(exclusions) = 0 AND cardinality(extras) = 0 THEN 1 ELSE 0 END) AS no_changes
FROM pizza_runner.customer_orders AS customer
JOIN pizza_runner.runner_orders AS runner
ON customer.order_id = runner.order_id
WHERE cancellation IS NULL
GROUP BY customer_id
ORDER BY customer_id;

-- Total changes in pizza in both exclusions and extras
SELECT SUM(CASE WHEN cardinality(exclusions) > 0 AND cardinality(extras) > 0 THEN 1 ELSE 0 END) AS changes_in_pizza
FROM pizza_runner.customer_orders AS customer
JOIN pizza_runner.runner_orders AS runner
ON customer.order_id = runner.order_id
WHERE cancellation IS NULL;

--Total volume of pizzas by hour
SELECT DATE_PART('hour', order_time) AS ord_time, COUNT(pizza_id) AS total_pizzas FROM pizza_runner.customer_orders AS customer
GROUP BY ord_time
ORDER BY ord_time;

--Total volume of pizzas for each day of the week
SELECT DATE_PART('dow', order_time) AS ord_time, COUNT(pizza_id) AS total_pizzas FROM pizza_runner.customer_orders AS customer
GROUP BY ord_time
ORDER BY ord_time;




