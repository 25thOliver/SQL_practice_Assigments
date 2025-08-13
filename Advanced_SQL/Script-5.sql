-- Recursive Queries
-- Write a query to show each product's hierarchy level(root = level 0, children = 1, etc.) usint a recursive CTE
with recursive product_hierarchy as (
-- Anchor member
select p.product_id, p.product_name, p.parent_product_id, 0 as level
from products p 
where p.parent_product_id is null 

union all

-- Recursive member
select p.product_id, p.product_name, p.parent_product_id, level + 1
from products p 
inner join product_hierarchy ph on p.parent_product_id  = ph.product_id
)
select * from product_hierarchy;

-- Window Function - Aggregate Functions
--  Find each customer’s total sales and compare it to the overall average sales.
select ci.customer_id, ci.full_name,
sum(s.total_sales) as customer_total_sales,
avg(sum(s.total_sales)) over() as avg_sales_all_customers
from customer_info ci 
join sales s on s.customer_id = ci.customer_id 
group by ci.customer_id, ci.full_name;

-- Show each product’s total sales and the running total of sales ordered by product price.
select p.product_id, p.product_name, 
sum(s.total_sales) as product_total_sales,
sum(sum(s.total_sales)) over(order by p.price) as running_total_sales
from products p 
join sales s on p.product_id = s.product_id 
group by p.product_id, p.product_name, p.price 
order by p.price;


-- Rank customers based on their total sales (highest first)
select ci.customer_id, ci.full_name,
sum(s.total_sales) as customer_total_sales,
rank() over(order by sum(s.total_sales) desc) as sales_rank
from customer_info ci 
join sales s on ci.customer_id = s.customer_id 
group by ci.customer_id, ci.full_name;

-- Show the top-selling products in each location (partitioned by location).
select ci.location, p.product_name,
sum(s.total_sales) as total_sales_per_product,
rank() over(partition by ci.location order by sum(s.total_sales) desc) as rank_in_location
from sales s
join products p on s.product_id = p.product_id 
join customer_info ci on s.customer_id = ci.customer_id 
group by ci.location, p.product_name;


-- For each product sale, show the sale amount, and the average sales of the
-- previous and current row when ordered by sales_id.
select s.sales_id, p.product_name, s.total_sales,
avg(s.total_sales) over(
order by s.sales_id
rows between 1 preceding and current row
) as avg_prev_and_current
from sales s 
join products p on s.product_id = p.product_id 
order by s.sales_id;


-- Views

-- Create a view that shows each product’s name, price, and the customer who bought it.
create view product_customer_view as
select p.product_id, p.product_name, p.price, ci.full_name as customer_name
from products p 
join customer_info ci on p.customer_id = ci.customer_id;

-- usage
select * from product_customer_view;

-- Create a view that shows each customer’s total spending.
create view customer_total_spending as
select ci.customer_id, ci.full_name,
sum(s.total_sales) as total_spent
from customer_info ci 
join sales s on ci.customer_id = s.customer_id
group by ci.customer_id, ci.full_name;

-- usage
select * from customer_total_spending
order by total_spent desc;

-- Create a view to show products and their price category (Cheap, Moderate, Expensive).
create view product_price_category as 
select product_id, product_name, price,
case
	when price < 500 then 'Cheap'
	when price between 500 and 1500 then 'Moderate'
	else 'Expensive'
end as price_category
from products p;

-- usage
select * from product_price_category where price_category = 'Moderate';

-- Use the customer_total_spending view to create another view showing only 
-- customers who spent less than 500.

create view least_spenders as
select * from customer_total_spending
where total_spent < 500;

select * from least_spenders;








































