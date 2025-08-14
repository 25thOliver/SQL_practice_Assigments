-- Stored Procedures
-- Create a procedure that returns the total sales for a given customer_id
create procedure GetTotalSalesByCustomer(in cust_id int)
begin
	select ci.full_name, sum(s.total_sales) as total_sales_amount
	from sales s
	join customer_info ci on s.customer_id = ci.customer_id
	where s.customer_id = cust_id
	group by ci.full_name;
end;

drop procedure GetTotalSalesByCustomer;

-- usage
call GetTotalSalesByCustomer(45);


-- Single CTE (Common Table Expression)
-- Find customers whose total sales exceed 500
with customer_totals as (
	select s.customer_id, sum(s.total_sales) as total_sales
	from sales s
	group by s.customer_id 
)
select ci.full_name, ct.total_sales
from customer_totals ct
join customer_info ci on ct.customer_id = ci.customer_id 
where ct.total_sales > 500;



-- Multiple CTEs
-- Find the top 10 customers by total sales, along with the most expensive product they purchased
with customer_totals as (
	select s.customer_id, sum(s.total_sales) as total_sales
	from sales s 
	group by s.customer_id 
),
max_price_per_customer as (
	select p.customer_id, max(p.price) as max_price
	from products p 
	group by p.customer_id 
)
select ci.full_name, ct.total_sales, mp.max_price
from customer_totals ct
join max_price_per_customer mp on ct.customer_id = mp.customer_id 
join customer_info ci on ct.customer_id = ci.customer_id 
order by ct.total_sales desc
LIMIT 10;


-- Subquery
-- Get all customers whose total sales are above average sales of all customers.
select ci.full_name, sum(s.total_sales) as total_sales
from sales s
join customer_info ci on s.customer_id = ci.customer_id 
group by ci.full_name 
having total_sales > (
select avg(total_sales )
	from (
		select sum(total_sales ) as total_sales
		from sales 
		group by customer_id 
	) sub
);
