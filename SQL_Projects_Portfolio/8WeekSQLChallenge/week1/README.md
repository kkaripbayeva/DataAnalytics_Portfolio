# Week 1: Case Study #1 - Danny's Diner

## Introduction

Danny seriously loves Japanese food, so in early 2021, he decided to embark on a risky venture and opened up a cute little restaurant that sells his three favorite foods: sushi, curry, and ramen.

Danny’s Diner is in need of assistance to help the restaurant stay afloat. The restaurant has captured some basic data from their first few months of operation but has no idea how to use this data to help run the business.

## Problem Statement

Danny wants to use the data to answer a few simple questions about his customers, especially regarding their visiting patterns, how much money they’ve spent, and which menu items are their favorites. Having this deeper connection with his customers will help him deliver a better and more personalized experience for his loyal customers.

He plans on using these insights to help him decide whether he should expand the existing customer loyalty program. Additionally, he needs help generating some basic datasets so his team can easily inspect the data without needing to use SQL.

Danny has provided a sample of his overall customer data due to privacy issues but hopes these examples are enough for fully functioning SQL queries to help him answer his questions!

## Datasets

Danny has shared three key datasets for this case study:

- **sales**
- **menu**
- **members**

### Entity Relationship Diagram

![Entity Relationship Diagram]([link-to-diagram](https://dbdiagram.io/d/608d07e4b29a09603d12edbd/?utm_source=dbdiagram_embed&utm_medium=bottom_open))

### Example Datasets

All datasets exist within the `dannys_diner` database schema.

#### Table 1: sales

The `sales` table captures all customer_id level purchases with corresponding order_date and product_id information for when and what menu items were ordered.

| customer_id | order_date | product_id |
|-------------|------------|------------|
| A           | 2021-01-01 | 1          |
| A           | 2021-01-01 | 2          |
| A           | 2021-01-07 | 2          |
| A           | 2021-01-10 | 3          |
| A           | 2021-01-11 | 3          |
| A           | 2021-01-11 | 3          |
| B           | 2021-01-01 | 2          |
| B           | 2021-01-02 | 2          |
| B           | 2021-01-04 | 1          |
| B           | 2021-01-11 | 1          |
| B           | 2021-01-16 | 3          |
| B           | 2021-02-01 | 3          |
| C           | 2021-01-01 | 3          |
| C           | 2021-01-01 | 3          |
| C           | 2021-01-07 | 3          |

#### Table 2: menu

The `menu` table maps the product_id to the actual product_name and price of each menu item.

| product_id | product_name | price |
|------------|---------------|-------|
| 1          | sushi         | 10    |
| 2          | curry         | 15    |
| 3          | ramen         | 12    |

#### Table 3: members

The `members` table captures the join_date when a customer_id joined the beta version of Danny’s Diner loyalty program.

| customer_id | join_date  |
|-------------|------------|
| A           | 2021-01-07 |
| B           | 2021-01-09 |

## Case Study Questions

Each of the following case study questions can be answered using a single SQL statement:

1. What is the total amount each customer spent at the restaurant?
2. How many days has each customer visited the restaurant?
3. What was the first item from the menu purchased by each customer?
4. What is the most purchased item on the menu and how many times was it purchased by all customers?
5. Which item was the most popular for each customer?
6. Which item was purchased first by the customer after they became a member?
7. Which item was purchased just before the customer became a member?
8. What is the total number of items and amount spent for each member before they became a member?
9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier, how many points would each customer have?
10. In the first week after a customer joins the program (including their join date), they earn 2x points on all items, not just sushi. How many points do customers A and B have at the end of January?

## Bonus Questions

### Join All The Things

Recreate the following table output using the available data:

| customer_id | order_date | product_name | price | member |
|-------------|------------|--------------|-------|--------|
| A           | 2021-01-01 | curry        | 15    | N      |
| A           | 2021-01-01 | sushi        | 10    | N      |
| A           | 2021-01-07 | curry        | 15    | Y      |
| A           | 2021-01-10 | ramen        | 12    | Y      |
| A           | 2021-01-11 | ramen        | 12    | Y      |
| A           | 2021-01-11 | ramen        | 12    | Y      |
| B           | 2021-01-01 | curry        | 15    | N      |
| B           | 2021-01-02 | curry        | 15    | N      |
| B           | 2021-01-04 | sushi        | 10    | N      |
| B           | 2021-01-11 | sushi        | 10    | Y      |
| B           | 2021-01-16 | ramen        | 12    | Y      |
| B           | 2021-02-01 | ramen        | 12    | Y      |
| C           | 2021-01-01 | ramen        | 12    | N      |
| C           | 2021-01-01 | ramen        | 12    | N      |
| C           | 2021-01-07 | ramen        | 12    | N      |

### Rank All The Things

Rank customer products, providing null ranking values for records when customers are not yet part of the loyalty program.

| customer_id | order_date | product_name | price | member | ranking |
|-------------|------------|--------------|-------|--------|---------|
| A           | 2021-01-01 | curry        | 15    | N      | null    |
| A           | 2021-01-01 | sushi        | 10    | N      | null    |
| A           | 2021-01-07 | curry        | 15    | Y      | 1       |
| A           | 2021-01-10 | ramen        | 12    | Y      | 2       |
| A           | 2021-01-11 | ramen        | 12    | Y      | 3       |
| A           | 2021-01-11 | ramen        | 12    | Y      | 3       |
| B           | 2021-01-01 | curry        | 15    | N      | null    |
| B           | 2021-01-02 | curry        | 15    | N      | null    |
| B           | 2021-01-04 | sushi        | 10    | N      | null    |
| B           | 2021-01-11 | sushi        | 10    | Y      | 1       |
| B           | 2021-01-16 | ramen        | 12    | Y      | 2       |
| B           | 2021-02-01 | ramen        | 12    | Y      | 3       |
| C           | 2021-01-01 | ramen        | 12    | N      | null    |
| C           | 2021-01-01 | ramen        | 12    | N      | null    |
| C           | 2021-01-07 | ramen        | 12    | N      | null    |

## Interactive SQL Session

You can use the embedded DB Fiddle below to easily access these example datasets. This interactive session has everything you need to start solving these questions using SQL.

[SQL Challenge(https://8weeksqlchallenge.com/case-study-1/)

---