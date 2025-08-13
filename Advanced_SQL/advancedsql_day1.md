## Advanced SQL Techniques

### Recursive Queries

#### Product Hierarchy with Recursive CTE
```sql
-- Write a query to show each product's hierarchy level (root = level 0, children = 1, etc.) using a recursive CTE
WITH RECURSIVE product_hierarchy AS (
    -- Anchor member
    SELECT p.product_id, p.product_name, p.parent_product_id, 0 AS level
    FROM products p
    WHERE p.parent_product_id IS NULL

    UNION ALL

    -- Recursive member
    SELECT p.product_id, p.product_name, p.parent_product_id, level + 1
    FROM products p
    INNER JOIN product_hierarchy ph ON p.parent_product_id = ph.product_id
)
SELECT * FROM product_hierarchy;
```

### Window Functions

#### Customer Sales vs Overall Average
```sql
-- Find each customer's total sales and compare it to the overall average sales
SELECT ci.customer_id, ci.full_name,
    SUM(s.total_sales) AS customer_total_sales,
    AVG(SUM(s.total_sales)) OVER() AS avg_sales_all_customers
FROM customer_info ci
JOIN sales s ON s.customer_id = ci.customer_id
GROUP BY ci.customer_id, ci.full_name;
```

#### Running Total of Sales by Product Price
```sql
-- Show each product's total sales and the running total of sales ordered by product price
SELECT p.product_id, p.product_name,
    SUM(s.total_sales) AS product_total_sales,
    SUM(SUM(s.total_sales)) OVER(ORDER BY p.price) AS running_total_sales
FROM products p
JOIN sales s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name, p.price
ORDER BY p.price;
```

#### Customer Sales Ranking
```sql
-- Rank customers based on their total sales (highest first)
SELECT ci.customer_id, ci.full_name,
    SUM(s.total_sales) AS customer_total_sales,
    RANK() OVER(ORDER BY SUM(s.total_sales) DESC) AS sales_rank
FROM customer_info ci
JOIN sales s ON ci.customer_id = s.customer_id
GROUP BY ci.customer_id, ci.full_name;
```

#### Top Products by Location
```sql
-- Show the top-selling products in each location (partitioned by location)
SELECT ci.location, p.product_name,
    SUM(s.total_sales) AS total_sales_per_product,
    RANK() OVER(PARTITION BY ci.location ORDER BY SUM(s.total_sales) DESC) AS rank_in_location
FROM sales s
JOIN products p ON s.product_id = p.product_id
JOIN customer_info ci ON s.customer_id = ci.customer_id
GROUP BY ci.location, p.product_name;
```

#### Moving Average with Window Frames
```sql
-- For each product sale, show the sale amount, and the average sales of the
-- previous and current row when ordered by sales_id
SELECT s.sales_id, p.product_name, s.total_sales,
    AVG(s.total_sales) OVER(
        ORDER BY s.sales_id
        ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
    ) AS avg_prev_and_current
FROM sales s
JOIN products p ON s.product_id = p.product_id
ORDER BY s.sales_id;
```

## Database Views

### Creating Views for Data Abstraction

#### Product-Customer View
```sql
-- Create a view that shows each product's name, price, and the customer who bought it
CREATE VIEW product_customer_view AS
SELECT p.product_id, p.product_name, p.price, ci.full_name AS customer_name
FROM products p
JOIN customer_info ci ON p.customer_id = ci.customer_id;

-- Usage
SELECT * FROM product_customer_view;
```

#### Customer Total Spending View
```sql
-- Create a view that shows each customer's total spending
CREATE VIEW customer_total_spending AS
SELECT ci.customer_id, ci.full_name,
    SUM(s.total_sales) AS total_spent
FROM customer_info ci
JOIN sales s ON ci.customer_id = s.customer_id
GROUP BY ci.customer_id, ci.full_name;

-- Usage
SELECT * FROM customer_total_spending
ORDER BY total_spent DESC;
```

#### Product Price Category View
```sql
-- Create a view to show products and their price category (Cheap, Moderate, Expensive)
CREATE VIEW product_price_category AS
SELECT product_id, product_name, price,
CASE
    WHEN price < 500 THEN 'Cheap'
    WHEN price BETWEEN 500 AND 1500 THEN 'Moderate'
    ELSE 'Expensive'
END AS price_category
FROM products;

-- Usage
SELECT * FROM product_price_category WHERE price_category = 'Moderate';
```

#### Derived View from Existing View
```sql
-- Use the customer_total_spending view to create another view showing only
-- customers who spent less than 500
CREATE VIEW least_spenders AS
SELECT * FROM customer_total_spending
WHERE total_spent < 500;

-- Usage
SELECT * FROM least_spenders;
```

## Advanced Concepts Summary

### Recursive CTEs
- **Purpose**: Handle hierarchical data structures
- **Components**: Anchor member (base case) and recursive member
- **Use Cases**: Organizational charts, product categories, family trees

### Window Functions
- **OVER() Clause**: Defines the window for calculations
- **PARTITION BY**: Divides data into groups
- **ORDER BY**: Determines row ordering within partitions
- **Window Frames**: ROWS/RANGE BETWEEN for specific row ranges
- **Common Functions**: RANK(), ROW_NUMBER(), SUM(), AVG(), LAG(), LEAD()

### Database Views
- **Benefits**: Data abstraction, security, simplified queries
- **Types**: Simple views (single table), complex views (multiple tables)
- **Best Practices**: Use meaningful names, document purpose, consider performance
- **View Dependencies**: Views can be built on other views

### Performance Considerations
- **Indexing**: Critical for window function performance
- **View Materialization**: Consider materialized views for complex calculations
- **Query Optimization**: Use EXPLAIN to analyze execution plans