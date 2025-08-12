--Table 1 Customers--
create table customer_info (
customer_id int primary key,
full_name varchar(50),
location varchar(30)
);

--Table 2 Products--
create table products (
product_id int primary key,
product_name varchar(50),
price float
);

--Table 3 Sales--
create table sales (
sales_id int primary key,
sales_date date,
product_id int,
customer_id int,
quantity int,
total_sales float,
foreign key (customer_id) references customer_info(customer_id),
foreign key (product_id) references products(product_id)
);

--Insert Customers--
insert into customer_info (customer_id, full_name , location) 
values
(1, 'Che Namwamba', 'Port Victoria'),
(2, 'Ogutu Olonyi', 'Bumala'),
(3, 'Polo Kimani', 'Kihungiro'),
(4, 'Mary J', 'Wangige'),
(5, 'Wambui Njanja', 'Gikambura');

select * from customer_info ci;


--Insert Products--
insert into products (product_id, product_name, price)
values
(1, 'Laptop', 20000),
(2, 'Wireless mouse', 1500),
(3, 'Laptop charger', 4000),
(4, 'External hard drive', 7500),
(5, 'USB-C hub', 2500);

select * from products p;

--Insert Sales--
insert into sales (sales_id, sales_date, product_id, customer_id, quantity, total_sales)
values 
(1, '2025-08-01', 1, 1, 1, 20000),
(2, '2025-08-02', 2, 2, 1, 1500),
(3, '2025-08-03', 3, 3, 1, 4000),
(4, '2025-08-04', 4, 1, 2, 15000),
(5, '2025-08-04', 5, 2, 1, 2500),
(6, '2025-08-05', 2, 4, 3, 4500);

select * from sales s;


--Analysis Queries
--1. Customers and their purchases
select ci.full_name, p.product_name, s.quantity, s.total_sales
from sales s 
join customer_info ci on s.customer_id = ci.customer_id
join products p on s.product_id = p.product_id 
order by ci.full_name;

--2. Total sales per customer
select ci.full_name, sum(s.total_sales) as total_spent
from sales s 
join customer_info ci on s.customer_id = ci.customer_id 
group by ci.full_name 
order by total_spent desc;

--3. Best selling product by total revenue
select p.product_name , sum(s.total_sales) as revenue
from sales s  
join products p on s.product_id = p.product_id 
group by p.product_name
order by revenue desc
limit 1;

--4. Customers with no purchase
select ci.full_name
from customer_info ci 
left join sales s on ci.customer_id = s.customer_id 
where s.customer_id is null;
























