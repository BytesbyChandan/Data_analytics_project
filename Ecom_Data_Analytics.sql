create database ecommerce_project;
use ecommerce_project;

create table customers(
	customer_id int primary key,
    customer_name varchar(100),
    city varchar(50),
    state varchar(50),
    age int
);

desc customers;

create table products(
	product_id int primary key,
    product_name varchar(100),
    category varchar(50),
    price decimal(10,2)
);

desc products;

create table orders(
	order_id int primary key,
    customer_id int,
    product_id int,
    order_date date,
    quantity int,
    unit_price decimal(10,2),
    discount_price decimal(10,2),
    order_status varchar(20),
    total_amount decimal(12,2),
    
    constraint fk_order_products
		foreign key(product_id) 
		references products(product_id),
        
    constraint fk_order_customers    
		foreign key(customer_id) 
		references customers(customer_id)
);

desc orders;

Select * from customers;
Select * from Products;
Select * from orders;

drop table if exists orders;

-- total revenue 
Select sum(total_amount) as 'total revenue'
from orders;

-- total revenue per product
Select 
	p.product_name, sum(o.total_amount) as per_product_revenue
from 
	products as p
join 
	orders as o
on 
	p.product_id = o.product_id
group by p.product_name
order by per_product_revenue desc;

-- a person who spent most
Select c.customer_id, c.customer_name, round(sum(o.total_amount)) as most_spent_cust
from customers as c
join orders as o
on c.customer_id = o.customer_id
group by c.customer_id, c.customer_name
order by most_spent_cust desc;

-- category generates high revenue
Select p.product_id, p.category, round(max(o.total_amount)) as highest_cat_rev
from products as p
join orders as o
on p.product_id = o.product_id
group by p.product_id, p.category
order by highest_cat_rev desc;

-- customer that never placed an order
Select customer_id from customers
where customer_id not in
(Select customer_id from orders);

-- average order values
Select order_id, round(avg(total_amount) over(partition by order_id)) as avg_order_value
from orders;

-- highest sales month
Select month(order_date) as Month, round(max(total_amount)) as maximum_sale 
from orders
group by month(order_date)
order by maximum_sale desc;

-- products never been ordered
Select product_id from products
where product_id not in
(Select product_id from orders);

-- customer spending greater than the avg customer spending
Select o1.customer_id
from orders as o1
where o1.total_amount>
(Select round(avg(o2.total_amount)) as avg_spending 
from orders as o2)
group by o1.customer_id;

-- highest selling product in each category
































