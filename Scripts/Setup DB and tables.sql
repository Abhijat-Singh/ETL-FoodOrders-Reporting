create database Reporting

use Reporting
go

/***************Master tables**************/

--Create Apps Table
create table Apps(
app_id int primary key identity(1,1),
[app_name] varchar(100),
app_created_date datetime default(getdate()),
app_active bit default(1)
)

select * from Apps with(nolock)
insert into Apps ([app_name]) values('Zomato')


--Create Customers Table
create table Customers(
customer_id int primary key identity(1,1),
customer_contact varchar(10) unique not null,
customer_fname varchar(50),
customer_lname varchar(50),
customer_email varchar(100),
customer_created_date datetime default(getdate()),
customer_active bit default(1)
)

select * from Customers with(nolock)
insert into Customers (customer_contact,customer_fname,customer_lname,customer_email) values('9818699975','Test','001','test@cust.com')
insert into Customers (customer_contact,customer_fname,customer_lname,customer_email) values('9818699976','Test','002','test2@cust.com')


--Create Restaurants Table
create table Restaurants(
restaurant_id int primary key identity(1,1),
restaurant_contact bigint unique not null,
restaurant_name varchar(100),
restaurant_email varchar(100),
restaurant_created_date datetime default(getdate()),
restaurant_active bit default(1)
)

select * from Restaurants with(nolock)
insert into Restaurants (restaurant_contact,restaurant_name,restaurant_email) values(99999,'Test Restaurant1','test@rest.com')


--Create Dishes Table
create table Dishes(
dish_id int primary key identity(1,1),
dish_name varchar(100)
)

select * from Dishes with(nolock)
insert into Dishes values('Dish 1')


--Create Report_Type Table
create table Report_Type(
report_type_id int primary key identity(1,1),
report_type_name varchar(100)
)

select * from Report_Type with(nolock)
insert into Report_Type values('General Report')
insert into Report_Type values('Filtered Report : App Name')



/***************Child tables**************/

--Create Orders Table
create table Orders(
order_id int primary key identity(1,1),
order_customer_id int foreign key references Customers(customer_id),
order_app_id int foreign key references Apps(app_id),
order_restaurant_id int foreign key references Restaurants(restaurant_id),
order_dish_id int foreign key references Dishes(dish_id),
order_date datetime default(getdate())
)

select * from Orders with(nolock)
insert into Orders (order_customer_id,order_app_id,order_restaurant_id,order_dish_id) values(1,1,1,1)
insert into Orders (order_customer_id,order_app_id,order_restaurant_id,order_dish_id) values(2,1,1,1)


select o.order_id,concat(c.customer_fname,' ',c.customer_lname) [Customer Name],c.customer_email,a.[app_name],r.restaurant_name,d.dish_name,cast(o.order_date as date) order_date 
from Orders o with(nolock)
inner join Customers c with(nolock)
on c.customer_id=o.order_customer_id
inner join Apps a with(nolock)
on a.app_id=o.order_app_id
inner join Restaurants r with(nolock)
on r.restaurant_id=o.order_restaurant_id
inner join Dishes d with(nolock)
on d.dish_id=o.order_dish_id


--Create AppRestaurant Table
create table AppRestaurant(
ar_id int primary key identity(1,1),
ar_app_id int foreign key references Apps(app_id),
ar_restaurant_id int foreign key references Restaurants(restaurant_id),
ar_rest_registered_date datetime default(getdate())
)

select * from AppRestaurant with(nolock)
insert into AppRestaurant (ar_app_id,ar_restaurant_id) values(1,1)



--Create RestaurantDish Table
create table RestaurantDish(
rd_id int primary key identity(1,1),
rd_restaurant_id int foreign key references Restaurants(restaurant_id),
rd_dish_id int foreign key references Dishes(dish_id),
)

select * from RestaurantDish with(nolock)
insert into RestaurantDish (rd_restaurant_id,rd_dish_id) values(1,1)


--Create Report_Request Table
create table Report_Request(
request_id int primary key identity(1,1),
requester_id int,
requester_name varchar(100),
report_type_id int foreign key references Report_Type(report_type_id),
requested_date datetime default(getdate()),
isReportGenerated bit default(0),
report_generated_date datetime
)

select * from Report_Request with(nolock)
insert into Report_Request (requester_id,requester_name,report_type_id) values(4,'Test name',1)
insert into Report_Request (requester_id,requester_name,report_type_id) values(5,'Test name2',1)
insert into Report_Request (requester_id,requester_name,report_type_id) values(1,'Test name1',2)

select * from Report_Request rr with(nolock)
inner join Report_Type rt with(nolock)
on rt.report_type_id=rr.report_type_id

SELECT request_id,requester_id, requester_name, report_type_id, requested_date
FROM     Report_Request WITH (nolock)
order by request_id asc
