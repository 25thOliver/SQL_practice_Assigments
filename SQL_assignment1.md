# Customer Purchases & Sales Analytics Database

### Goal:
Create a small database to track customers, products, and sales.  
Then, run queries to answer common business questions such as:
- Who bought what?
- How much did each customer spend?
- Which product generated the highest total sales?
- Who hasn’t purchased anything yet?

---
## Create database
```sql
CREATE DATABASE de_class;

## Create a schema
CREATE SCHEMA customers;

## Create Tables
We will create three tables:

- customer_info → Stores customer details.

- products → Stores product catalog details.

- sales → Records individual purchases.
![Creating tables](create_tables.png)

## Insert Sample Data
- Insert customer records
![Inserted customers records](insert_customers.png)

- Insert product records
![Inserted products records](insert_products.png)

Insert sales record
![Inserted sales records](insert_sales.png)

## Run Queries and View Results

1. Who bought what?
![Which customers have made purchases, and what products did they buy?](q1.png)

2. How much did each customer spend?
![What is the total sales amount per customer?](q2.png)

3. Which products generate the most revenue?
![Which product generated the highest total sales?](q3.png)

4. Who hasn’t purchased anything yet?
![Are there any customers who haven't bought any products?](q4.png)

Entities:

- customer_info → Stores customer details.

- products → Stores product catalog details.

- sales → Records individual purchases.