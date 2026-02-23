create database inventory_management;
use inventory_management;
create table warehouse(
	warehouse_id int primary key auto_increment,
    warehouse_name varchar(100),
    location varchar(100)
);
create table products(
	product_id int primary key auto_increment,
    product_name varchar(100),
    sku varchar(50) unique,
    price decimal(10,2)
);
create table warehouse_stock(
	warehouse_id int,
    product_id int,
    quantity int,
    primary key (warehouse_id, product_id),
    foreign key (warehouse_id) references warehouse(warehouse_id),
    foreign key (product_id) references products(product_id)
);
create table orders(
	order_id int primary key auto_increment,
    customer_name varchar(100),
    order_date datetime,
    warehouse_id int,
    status enum('PLACED', 'CANCELLED', 'COMPLETED'),
    foreign key (warehouse_id) references warehouse(warehouse_id)
);
create table order_items(
	order_id int,
    product_id int,
    quantity int,
    price decimal(10,2),
    primary key (order_id, product_id),
    foreign key (order_id) references orders(order_id),
    foreign key (product_id) references products(product_id)
);
insert into warehouse(warehouse_name, location) values
('North Logistics Hub', 'Chicago'),
('South Distribution Center', 'Atlanta'),
('West Coast Depot', 'Los Angeles'),
('East Coast Storage', 'New York');
select *  from warehouse;
insert into products(product_name, sku, price) values
('Laptop 14 Inch', 'LAP-14IN', 65000.00),
('Wireless Mouse', 'MOU-WRL', 799.00),
('Mechanical Keyboard', 'KEY-MECH', 3499.00),
('LED Monitor 24 Inch', 'MON-24IN', 12500.00),
('External Hard Drive 1TB', 'HDD-1TB', 2999.00),
('USB-C Charging Adapter', 'USB-C-ADP', 1499.00),
('Ergonomic Office Chair', 'CHR-ERGO', 8500.00),
('Dual Band WiFi Router', 'RTR-DB-WIFI', 2899.00);
insert into warehouse_stock(warehouse_id, product_id, quantity) values
(1, 1, 200),(1, 2, 180),(1, 3, 185),(1, 4, 200),
(1, 5, 200),(1, 6, 180),(1, 7, 185),(1, 8, 200),
(2, 1, 100),(2, 2, 130),(2, 3, 145),(2, 4, 150),
(2, 5, 220),(2, 6, 190),(2, 7, 175),(2, 8, 160),
(3, 1, 130),(3, 2, 150),(3, 3, 165),(3, 4, 120),
(3, 5, 190),(3, 6, 120),(3, 7, 155),(3, 8, 210),
(4, 1, 135),(4, 2, 110),(4, 3, 125),(4, 4, 130),
(4, 5, 150),(4, 6, 140),(4, 7, 115),(4, 8, 140);
select * from warehouse;
select * from products;
select * from warehouse_stock;
select * from orders;
select * from order_items;
alter table orders
add column total_amount decimal(10,2) default 0; 
ALTER TABLE order_items
ADD unit_price DECIMAL(10,2) after quantity;
ALTER TABLE order_items
RENAME COLUMN price TO total_price;