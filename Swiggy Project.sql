-- sql project 
drop database project;
create database project;
create table  project.swiggy
(id int,
cust_id varchar(20),
order_id int,
partner_code int,
outlet varchar(20),
bill_amount int,
order_date date,
comments varchar(30));

insert into project.swiggy
values
(1,"SW1005",700,50,"KFC",753,"2021-10-10","DOOR_LOCKED"),
(2,"SW1006",710,59,"PIZZA_HUT",1496,"2021-09-01","IN-TIME-DELIVERY"),
(3,"SW1005",720,59,"DOMINOS",990,"2021-12-10",null),
(4,"SW1005",707,50,"PIZZA_HUT",2475,"2021-12-10",null),
(5,"SW1006",770,59,"KFC",1250,"2021-11-17",null),
(6,"SW1020",1000,119,"PIZZA_HUT",1400,"2021-11-18","IN-TIME-DELIVERY"),
(7,"SW2035",1079,135,"DOMINOS",1750,"2021-11-19",null),
(8,"SW1020",1083,59,"KFC",1250,"2021-11-20",null),
(11,'sw1020',1100,150,'PIZZA_HUT',1950,"2021-12-24",'LATE_DELIVERY'),
(9,'SW2035',1095,119,'PIZZA_HUT',1270,"2021-11-21",'LATE_DELIVERY'),
(10,'SW1005',729,135,'KFC',1000,"2021-09-10",'DELIVERED'),
(1,'SW1005',700,50,'KFC',753,"2021-10-10",'DOOR_LOCKED'),
(2,'SW1006',710,59,'PIZZA_HUT',1496,"2021-09-01",'IN-TIME-DELIVERY'),
(3,'SW1005',720,59,'DOMINOS',990,"2021-12-10",NULL),
(4,'SW1005',707,50,'PIZZA_HUT',2475,"2021-12-11",NULL);

/*find count of duplicate rows in the swiggy table*/ 
Select id,count(id) from project.swiggy
Group by id
Having count(id)>1
Order by count(id) desc;

 /*-----------------Remove Duplicate records --------------------/ /How would you delete duplicate records from the table*/
/*create a new table by taking uniques record from original table*/ 
Create table project.swiggy1
As
Select Distinct * from project.swiggy;
-- Step 2:
/*Delete the original table*/ 
DROP table project.swiggy;

/*Step3:
Rename the new table to original table name*/ 
Rename table project.swiggy1 to project.swiggy;

/*print records from row number 4 to 9*/
 Select * from project.swiggy
limit 3,6;

/*Find the latest order placed by customers.*/
with latest_order as
(select cust_id, outlet, order_date,
row_number() over(partition by cust_id order by order_date desc) as latest_ord_dt
from project.swiggy) select cust_id, outlet, order_date from latest_order where latest_ord_dt = 1;

/*Print order_id, partner_code, order_date, comment (No issues in place of null else comment)*/
 Select order_id, partner_code,order_date,
(case
when comments is null then 'No issues'
else comments end) as comments from project.swiggy;

/*Print outlet wise order count, cumulative order count, total bill_amount, cumulative bill_amount*/

with cte as 
(
select outlet,count(outlet) as out_cnt,sum(bill_amount) as bill_amt from project.swiggy
group by outlet)
select outlet,out_cnt,sum(out_cnt) over (order by out_cnt),
 bill_amt,sum(bill_amt) over (order by bill_amt) as cum_amt
from cte ;

/*Print cust_id wise, Outlet wise 'total number of orders' */
Select cust_id,
sum(if(outlet='KFC',1,0)) KFC,
sum(if(outlet='Dominos',1,0)) Dominos, 
sum(if(outlet='Pizza hut',1,0)) Pizza_hut
from project.swiggy group by 1;

/*Create a cross tab cust_id wise outlet wise total bill amount */
Select cust_id,
sum(if(outlet='KFC',bill_amount,0)) KFC, sum(if(outlet='Dominos',bill_amount,0)) Dominos, sum(if(outlet='Pizza hut',bill_amount,0)) Pizza_hut
from project.swiggy group by 1;
Select * from project.swiggy;
