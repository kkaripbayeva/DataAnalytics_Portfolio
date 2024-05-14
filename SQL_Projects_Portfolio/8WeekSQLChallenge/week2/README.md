# Pizza Runner Case Study README

## Introduction

Welcome to the Pizza Runner case study, part of the 8-Week SQL Challenge! This case study will take you through various scenarios related to Danny's new pizza delivery business, Pizza Runner. You will be working with different datasets to answer key business questions and optimize operations.

## Available Data

Danny has provided an entity relationship diagram and the following tables in the `pizza_runner` database schema:

- **runners**:
    - `runner_id`
    - `registration_date`

- **customer_orders**:
    - `order_id`
    - `customer_id`
    - `pizza_id`
    - `exclusions`
    - `extras`
    - `order_time`

- **runner_orders**:
    - `order_id`
    - `runner_id`
    - `pickup_time`
    - `distance`
    - `duration`
    - `cancellation`

- **pizza_names**:
    - `pizza_id`
    - `pizza_name`

- **pizza_recipes**:
    - `pizza_id`
    - `toppings`

- **pizza_toppings**:
    - `topping_id`
    - `topping_name`

## Entity Relationship Diagram

![Entity Relationship Diagram]([URL_TO_DIAGRAM](https://dbdiagram.io/d/5f3e085ccf48a141ff558487/?utm_source=dbdiagram_embed&utm_medium=bottom_open))

## Case Study Questions

The case study is divided into several focus areas:

### A. Pizza Metrics
1. **How many pizzas were ordered?**
2. **How many unique customer orders were made?**
3. **How many successful orders were delivered by each runner?**
4. **How many of each type of pizza was delivered?**
5. **How many Vegetarian and Meat Lovers were ordered by each customer?**
6. **What was the maximum number of pizzas delivered in a single order?**
7. **For each customer, how many delivered pizzas had at least 1 change and how many had no changes?**
8. **How many pizzas were delivered that had both exclusions and extras?**
9. **What was the total volume of pizzas ordered for each hour of the day?**
10. **What was the volume of orders for each day of the week?**

### B. Runner and Customer Experience
1. **How many runners signed up for each 1 week period?**
2. **What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?**
3. **Is there any relationship between the number of pizzas and how long the order takes to prepare?**
4. **What was the average distance travelled for each customer?**
5. **What was the difference between the longest and shortest delivery times for all orders?**
6. **What was the average speed for each runner for each delivery and do you notice any trend for these values?**
7. **What is the successful delivery percentage for each runner?**

### C. Ingredient Optimization
1. **What are the standard ingredients for each pizza?**
2. **What was the most commonly added extra?**
3. **What was the most common exclusion?**
4. **Generate an order item for each record in the customer_orders table in the specified format.**
5. **Generate an alphabetically ordered comma-separated ingredient list for each pizza order with a 2x prefix for certain ingredients.**
6. **What is the total quantity of each ingredient used in all delivered pizzas sorted by most frequent first?**

### D. Pricing and Ratings
1. **How much money has Pizza Runner made so far with no delivery fees?**
2. **How much money has Pizza Runner made with an additional $1 charge for any pizza extras?**
3. **How would you design a table for customer ratings of runners?**
4. **Join the newly generated ratings table with existing information for successful deliveries.**
5. **Calculate Pizza Runner's remaining money after delivery costs.**

### E. Bonus Questions
1. **How would adding a new pizza type impact the existing data design? Write an INSERT statement for a new pizza.**

## Steps to Get Started

1. **Explore the Data**: Before diving into the questions, thoroughly explore the provided datasets. Check for null values and data types, especially in the `customer_orders` and `runner_orders` tables.

2. **Write SQL Queries**: Answer each question using a single SQL statement where possible. Use common table expressions (CTEs) and window functions to simplify complex queries.

3. **Analyze Results**: Interpret the results of your queries to provide meaningful insights that can help optimize Pizza Runner’s operations.

### Conclusion
This case study provides a comprehensive set of questions that will help you understand various aspects of Pizza Runner’s operations. By answering these questions, you will help Danny optimize his pizza delivery business and make data-driven decisions.

Happy querying!
