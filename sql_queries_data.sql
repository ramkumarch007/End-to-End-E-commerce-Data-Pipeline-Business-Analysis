create database ecommerce_db;
use ecommerce_db;

-- create products
create table products (
product_id int primary key,
title varchar(200),
category varchar(100),
price float,
discount_percentage float,
rating float,
stock int,
warranty_information varchar(50),
return_policy varchar(50));

-- create orders
create table orders(
customer_id int,
product_id int,
product_name varchar(200),
price float,
quantity int,
total float,
discount_percentage float,
discounted_total float,
order_id int primary key);

-- create customers
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    age INT,
    gender VARCHAR(20),
    email VARCHAR(255),
    phone VARCHAR(50),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100)
);

select * from orders;
select * from customers; 
select * from products;

-- REVENUE & BUSINESS HEALTH
-- Q.What is the total revenue and discounted revenue?
select round(sum(total),2) as Total_Revenue,round(sum(discounted_total),2) as Discounted_Revenue from orders;

-- Q.What percentage of revenue is lost due to discounts?
select round(((sum(total)-sum(discounted_total))/nullif(sum(total),0))*100,2) as Loss_percent from orders;

-- Q.Which products generate the highest revenue?
select p.title, round(sum(o.total),2) as total_revenue,
rank() over(order by sum(o.total) desc) as rank_position  from orders o
join products p
on o.product_id = p.product_id
group by p.title;

-- PRODUCT PERFORMANCE
-- Q.Which products are selling the most (quantity)?
select p.title, sum(o.quantity) as total_quantites_sold,
rank() over(order by sum(o.quantity) desc) as rank_position  from orders o
join products as p
on o.product_id = p.product_id
group by p.title;

-- Q.Which products are selling the least (quantity)?
select p.title, sum(o.quantity) as total_quantites_sold from orders o
join products as p
on o.product_id = p.product_id
group by p.title
having total_quantites_sold = (
select min(total_sold) from (select sum(quantity) as total_sold from orders
group by product_id) as subproducts);

-- Q.Which products have high stock but low sales?
select p.product_id,p.title, p.stock,coalesce(sum(o.quantity),0) as quantities_sold, (p.stock -coalesce(sum(o.quantity),0)) as  remaining from orders o
join products p
on o.product_id = p.product_id
group by p.product_id,p.stock,p.title
order by remaining desc
limit 10;

-- Q.Top Product per Category?
select * from (
select p.category,p.title,round(sum(o.total),2) as revenue,
rank() over( partition by p.category order by sum(o.total) desc) as rnk
from orders o
join products p on o.product_id = p.product_id
group by p.category,p.title) t
where rnk = 1;

-- Q.Which categories are performing best in terms of revenue?
select p.category, round(sum(o.total),2) as total_revenue, round(sum(o.discounted_total),2) as discounted_revenue
from orders o
join products p
on o.product_id = p.product_id
group by p.category
order by discounted_revenue desc
limit 10;

-- Q.Do higher-rated products actually sell more?
select p.title,p.rating, round(sum(o.total),2) as total_sold from products p
join orders o 
on p.product_id = o.product_id
group by p.title,p.rating
order by total_sold desc;

-- PRICING & DISCOUNT STRATEGY
-- Q.Which products have the highest discounts?
select title,discount_percentage from products
order by discount_percentage desc
limit 5;

-- Q.Do products with higher discounts sell more?
select p.title, p.discount_percentage,round(sum(o.quantity),2) as total_quantity_sold
from products p
join orders o on p.product_id = o.product_id
group by p.title,p.discount_percentage
order by p.discount_percentage desc;

-- Q.What is the average discount per category?
select category, round(avg(discount_percentage),2) average_discount from products
group by category;

-- CUSTOMER ANALYSIS
-- Q.Who are the top 10 customers by total spending?
select c.customer_id,c.first_name, round(sum(o.total),2) as total_sales,
dense_rank() over(order by round(sum(o.total),2) desc) as customer_rank from customers as c
join orders as o
on c.customer_id = o.customer_id
group by c.customer_id,c.first_name;

-- Q.Which cities generate the most revenue?
select c.city, round(sum(o.total),2) as total_sales from customers as c
join orders as o
on c.customer_id = o.customer_id
group by c.city
order by total_sales desc
limit 5;

-- Q.What is the average spending per customer?
select c.customer_id,c.first_name, round(avg(o.total),2) as average_sales from customers as c
join orders as o
on c.customer_id = o.customer_id
group by c.customer_id,c.first_name
order by average_sales desc;

-- Q.Are male vs female customers spending differently?
select c.gender, round(sum(o.total),2) as total_sales from customers c
join orders o
on c.customer_id = o.customer_id
group by c.gender;

-- ORDER BEHAVIOR
-- Q.What is the average order value?
select round(avg(total),2) as avg_order_value from orders;

-- Q.What is the average quantity per order?
select round(avg(quantity),2) as avg_quantity_sold from orders;

-- Q.Which products are frequently bought in higher quantities?
select product_name, sum(quantity) as most_sold from orders
group by product_name
order by most_sold desc
limit 10;

-- Q.Which customers buy the most diverse set of products?
select c.customer_id,c.first_name,count(*) as no_of_items_bought from orders o
join customers c
on o.customer_id = c.customer_id
group by c.customer_id,c.first_name
order by no_of_items_bought desc;

-- Q.Which products generate high revenue but have low ratings?
select p.title,p.rating, round(sum(o.total),2) as total_revenue
from products p 
join orders o on p.product_id = o.product_id
group by p.title, p.rating
having p.rating < 3
order by total_revenue desc;

-- Q.Which products have good ratings but low sales?
select p.title,p.rating, coalesce(sum(o.quantity),0) as total_quantity_sold
from products p 
join orders o on p.product_id = o.product_id
group by p.title, p.rating
having p.rating > 4
order by total_quantity_sold;

