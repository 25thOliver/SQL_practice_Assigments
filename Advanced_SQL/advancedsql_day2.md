## Stored Procedures and Advanced Query Techniques

### Stored Procedures

#### Creating a Stored Procedure for Customer Sales
```sql
-- Create a procedure that returns the total sales for a given customer_id
CREATE PROCEDURE GetTotalSalesByCustomer(IN cust_id INT)
BEGIN
    SELECT ci.full_name, SUM(s.total_sales) AS total_sales_amount
    FROM sales s
    JOIN customer_info ci ON s.customer_id = ci.customer_id
    WHERE s.customer_id = cust_id
    GROUP BY ci.full_name;
END;

-- Usage
CALL GetTotalSalesByCustomer(45);

-- Drop procedure if needed
DROP PROCEDURE GetTotalSalesByCustomer;
```

**Stored Procedure Benefits:**
- **Reusability**: Write once, use multiple times
- **Performance**: Pre-compiled execution plans
- **Security**: Controlled data access through parameters
- **Maintenance**: Centralized business logic

### Common Table Expressions (CTEs)

#### Single CTE - Finding High-Value Customers
```sql
-- Find customers whose total sales exceed 500
WITH customer_totals AS (
    SELECT s.customer_id, SUM(s.total_sales) AS total_sales
    FROM sales s
    GROUP BY s.customer_id 
)
SELECT ci.full_name, ct.total_sales
FROM customer_totals ct
JOIN customer_info ci ON ct.customer_id = ci.customer_id 
WHERE ct.total_sales > 500;
```

**Single CTE Explanation:**
- **Purpose**: Simplifies complex queries by breaking them into readable parts
- **Scope**: CTE exists only for the duration of the query
- **Readability**: Makes complex logic more understandable
- **Reusability**: Can reference the CTE multiple times in the main query

#### Multiple CTEs - Top Customers with Product Analysis
```sql
-- Find the top 10 customers by total sales, along with the most expensive product they purchased
WITH customer_totals AS (
    SELECT s.customer_id, SUM(s.total_sales) AS total_sales
    FROM sales s 
    GROUP BY s.customer_id 
),
max_price_per_customer AS (
    SELECT p.customer_id, MAX(p.price) AS max_price
    FROM products p 
    GROUP BY p.customer_id 
)
SELECT ci.full_name, ct.total_sales, mp.max_price
FROM customer_totals ct
JOIN max_price_per_customer mp ON ct.customer_id = mp.customer_id 
JOIN customer_info ci ON ct.customer_id = ci.customer_id 
ORDER BY ct.total_sales DESC
LIMIT 10;
```

**Multiple CTEs Explanation:**
- **Modularity**: Each CTE handles a specific calculation
- **Sequential Definition**: CTEs are defined in order and can reference previous ones
- **Complex Analysis**: Enables sophisticated multi-step analysis
- **Performance**: Often more efficient than nested subqueries

### Subqueries

#### Nested Subquery - Above-Average Customers
```sql
-- Get all customers whose total sales are above average sales of all customers
SELECT ci.full_name, SUM(s.total_sales) AS total_sales
FROM sales s
JOIN customer_info ci ON s.customer_id = ci.customer_id 
GROUP BY ci.full_name 
HAVING total_sales > (
    SELECT AVG(total_sales)
    FROM (
        SELECT SUM(total_sales) AS total_sales
        FROM sales 
        GROUP BY customer_id 
    ) sub
);
```

**Subquery Breakdown:**
1. **Inner Subquery**: `SELECT SUM(total_sales) FROM sales GROUP BY customer_id`
   - Calculates total sales per customer
2. **Outer Subquery**: `SELECT AVG(total_sales) FROM (...) sub`
   - Calculates average of all customer totals
3. **Main Query**: Filters customers above this average using HAVING clause

## Advanced Query Concepts Summary

### Stored Procedures
- **Definition**: Pre-compiled SQL code stored in the database
- **Parameters**: IN, OUT, INOUT for data flow control
- **Benefits**: Performance, security, code reuse, centralized logic
- **Use Cases**: Complex business logic, data validation, batch processing

### Common Table Expressions (CTEs)
- **Syntax**: `WITH cte_name AS (query) SELECT...`
- **Types**: 
  - **Non-recursive**: Standard temporary result sets
  - **Recursive**: For hierarchical data processing
- **Advantages**: Improved readability, better organization, temporary result storage
- **Limitations**: Cannot be indexed, exist only during query execution

### Subqueries
- **Types**:
  - **Scalar**: Returns single value
  - **Column**: Returns single column
  - **Row**: Returns single row
  - **Table**: Returns multiple rows and columns
- **Locations**: SELECT, FROM, WHERE, HAVING clauses
- **Performance**: Can be slower than JOINs but more readable for complex logic

### Query Optimization Tips
- **CTEs vs Subqueries**: CTEs often more readable, subqueries sometimes faster
- **Indexing**: Critical for subquery performance
- **EXISTS vs IN**: EXISTS often performs better for large datasets
- **Stored Procedures**: Best for frequently executed complex operations

### Best Practices
- **Naming**: Use descriptive names for CTEs and procedures
- **Documentation**: Comment complex logic and business rules
- **Testing**: Validate results with smaller datasets first
- **Performance**: Monitor execution plans and optimize accordingly