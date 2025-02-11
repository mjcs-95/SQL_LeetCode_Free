/*1757. Recyclable and Low Fat Products*/
SELECT product_id
FROM Products
WHERE low_fats = 'Y'
  AND recyclable = 'Y';

/*584. Find Customer Referee*/
SELECT C.name
FROM Customer AS C
WHERE referee_id <> 2
  OR referee_id IS NULL;

/*595. Big Countries*/
SELECT W.name,
       W.population,
       W.area
FROM World AS W
WHERE W.area >= 3000000
  OR W.population >= 25000000;

/*1148. Article Views I*/
SELECT DISTINCT author_id AS id
FROM VIEWS
WHERE author_id = viewer_id
ORDER BY author_id ASC;

/*1683. Invalid Tweets*/
SELECT tweet_id
FROM Tweets
WHERE LEN(content) > 15;

/*1378. Replace Employee ID With The Unique Identifier*/
SELECT EUI.unique_id,
       E.name
FROM EmployeeUNI AS EUI
RIGHT JOIN Employees AS E ON E.id = EUI.id;

/*1068. Product Sales Analysis I*/
SELECT Product.product_name,
       Sales.year,
       Sales.price
FROM Sales
LEFT JOIN Product ON Sales.product_id = Product.product_id OPTION (MAXDOP 64);

/*1581. Customer Who Visited but Did Not Make Any Transactions*/
SELECT V.customer_id,
       COUNT(*) AS count_no_trans
FROM Visits AS V
LEFT JOIN Transactions AS T ON V.visit_id = T.visit_id
WHERE T.transaction_id IS NULL
GROUP BY V.customer_id;

/*197. Rising Temperature*/
SELECT T.id AS Id
FROM
  (SELECT id,
          recordDate,
          temperature,
          LAG(temperature) OVER (
                                 ORDER BY recordDate) AS prev_temperature,
          LAG(recordDate) OVER (
                                ORDER BY recordDate) AS prev_day
   FROM Weather) AS T
WHERE T.temperature > T.prev_temperature
  AND ABS(DATEDIFF(DAY, recordDate, prev_day)) = 1;

/*Activity Processing Time*/
SELECT a1.machine_id,
       ROUND(AVG(a2.timestamp - a1.timestamp), 3) AS processing_time
FROM Activity AS a1
JOIN Activity AS a2 ON a1.machine_id = a2.machine_id
AND a1.process_id = a2.process_id
WHERE a1.activity_type = 'start'
  AND a2.activity_type = 'end'
GROUP BY a1.machine_id;

/*577. Employee Bonus*/
SELECT E.name,
       B.bonus
FROM Employee AS E
LEFT JOIN Bonus AS B ON E.empId = B.empId
WHERE B.bonus < 1000
  OR B.bonus IS NULL;

/*1280. Students and Examinations*/
SELECT S.student_id,
       S.student_name,
       SU.subject_name,
       COUNT(E.student_id) AS attended_exams
FROM Students AS S
CROSS JOIN Subjects AS SU
LEFT JOIN Examinations AS E ON S.student_id = E.student_id
AND SU.subject_name = E.subject_name
GROUP BY S.student_id,
         S.student_name,
         SU.subject_name
ORDER BY S.student_id,
         SU.subject_name;

/*570. Managers with at Least 5 Direct Reports*/
SELECT E.name
FROM Employee AS E
JOIN
  (SELECT managerId
   FROM Employee
   GROUP BY managerId
   HAVING COUNT(*) >= 5) AS M ON M.managerId = E.id;

/*1934. Confirmation Rate*/
SELECT S.user_id,
       ROUND(CASE
                 WHEN COUNT(C.user_id) = 0 THEN 0
                 ELSE SUM(CASE
                              WHEN C.action = 'confirmed' THEN 1
                              ELSE 0
                          END) * 1.0 / COUNT(C.user_id)
             END, 2) AS confirmation_rate
FROM Signups AS S
LEFT JOIN Confirmations AS C ON S.user_id = C.user_id
GROUP BY S.user_id;

/* 620. Not Boring Movies */
SELECT *
FROM Cinema
WHERE id % 2 = 1
  AND description <> 'boring'
ORDER BY rating DESC;

/* 1251. Average Selling Price */
SELECT P.product_id,
       ISNULL(ROUND(SUM(U.units * P.price) / SUM(U.units * 1.0), 2), 0.00) AS average_price
FROM Prices AS P
LEFT JOIN UnitsSold AS U ON U.product_id = P.product_id
AND U.purchase_date BETWEEN P.start_date AND P.end_date
GROUP BY P.product_id;

/* 1075. Project Employees I */
SELECT P.project_id,
       ROUND(AVG(1.0 * experience_years), 2) AS average_years
FROM Project AS P
JOIN Employee AS E ON P.employee_id = E.employee_id
GROUP BY P.project_id;

/* 1633. Percentage of Users Attended a Contest */
SELECT contest_id,
       ROUND(100.0 * COUNT(DISTINCT user_id) /
               (SELECT COUNT(user_id)
                FROM Users), 2) AS percentage
FROM Register AS R
GROUP BY contest_id
ORDER BY percentage DESC,
         contest_id ASC;

/* 1211. Queries Quality and Percentage */
SELECT query_name,
       ROUND(AVG(1.0 * rating / POSITION), 2) AS quality,
       ROUND(SUM(CASE
                     WHEN rating < 3 THEN 100.0
                     ELSE 0.0
                 END) / COUNT(*), 2) AS poor_query_percentage /* ROUND(SUM(IIF(rating < 3, 100.0, 0.0)) / COUNT(*), 2) AS poor_query_percentage */
FROM Queries
GROUP BY /*1193. Monthly Transactions I */
SELECT SUBSTRING(CAST(trans_date AS CHAR(10)), 1, 7) AS MONTH,
       country,
       count(*) AS trans_count,
       SUM(CASE
               WHEN state = 'approved' THEN 1
               ELSE 0
           END) AS approved_count,
       SUM(amount) AS trans_total_amount,
       SUM(CASE
               WHEN state = 'approved' THEN amount
               ELSE 0
           END) AS approved_total_amount
FROM Transactions
GROUP BY country,
         SUBSTRING(CAST(trans_date AS CHAR(10)), 1, 7) /* 1174. Immediate Food Delivery II */ WITH FirstOrders AS
  (SELECT customer_id,
          MIN(order_date) AS first_order_date
   FROM Delivery
   GROUP BY customer_id)
SELECT round(sum(CASE
                     WHEN order_date = customer_pref_delivery_date THEN 100.0
                     ELSE 0.0
                 END) / count(*), 2) AS immediate_percentage
FROM Delivery D
INNER JOIN FirstOrders FO ON FO.customer_id = D.customer_id
AND FO.first_order_date = D.order_date /*V2 T-SQL specific*/
SELECT round(sum(iif(D.order_date = D.customer_pref_delivery_date, 100.0, 0.0)) / count(*), 2) AS immediate_percentage
FROM
  (SELECT *,
          row_number() OVER (PARTITION BY customer_id
                             ORDER BY order_date) AS order_pos
   FROM Delivery) AS D
WHERE order_pos = 1;

/* 2356. Number of Unique Subjects Taught by Each Teacher */
SELECT teacher_id,
       count(DISTINCT subject_id) AS cnt
FROM Teacher
GROUP BY teacher_id /*1141. User Activity for the Past 30 Days I */
SELECT activity_date AS DAY,
       count(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date BETWEEN DATEADD(DAY, -30, '2019-07-28') AND '2019-07-28'
GROUP BY activity_date /* 550. Game Play Analysis IV */
SELECT round(count(*)*1.0 /
               (SELECT count(DISTINCT player_id) AS total
                FROM Activity), 2) AS fraction
FROM Activity AS A
JOIN
  (SELECT player_id,
          Min(event_date) AS first_logging
   FROM Activity
   GROUP BY player_id) AS F ON F.player_id = A.player_id
AND A.event_date = dateadd(DAY, 1, F.first_logging) /* 1070. Product Sales Analysis III */
SELECT S.product_id,
       S.year AS first_year,
       S.quantity,
       S.price
FROM Sales AS S
INNER JOIN
  (SELECT S2.product_id,
          min(S2.year) AS first_year
   FROM Sales AS S2
   GROUP BY product_id) AS S2 ON S2.product_id = S.product_id
AND S.year = S2.first_year /*596. Classes More Than 5 Students*/
SELECT CLASS
FROM Courses
GROUP BY CLASS
HAVING count(*) > 4 /*1729. Find Followers Count*/
SELECT user_id,
       count(*) AS followers_count
FROM Followers
GROUP BY user_id /*619. Biggest Single Number */
SELECT max(N.num) AS num
FROM
  (SELECT num AS num
   FROM MyNumbers
   GROUP BY num
   HAVING count(*) = 1) AS N /*Better logic, but more time for some reason*/
SELECT
  (SELECT TOP 1 num
   FROM MyNumbers
   GROUP BY num
   HAVING COUNT(*) = 1
   ORDER BY num DESC) AS num;

/*1045. Customers Who Bought All Products*/
SELECT customer_id
FROM Customer
GROUP BY customer_id
HAVING count(DISTINCT product_key) =
  (SELECT count(*)
   FROM Product) WITH Managers AS
  (SELECT reports_to AS id,
          count(*) AS reports_count,
          round(avg(age*1.0), 0) AS average_age
   FROM Employees
   GROUP BY reports_to) /*1731. The Number of Employees Which Report to Each Employee */
SELECT employee_id,
       name,
       M.reports_count,
       M.average_age
FROM Employees AS E
JOIN Managers AS M ON M.id = E.employee_id /*1789. Primary Department for Each Employee*/
SELECT employee_id,
       department_id
FROM Employee
WHERE primary_flag = 'Y'
  OR employee_id IN
    (SELECT employee_id
     FROM Employee
     GROUP BY employee_id
     HAVING count(*) = 1)/*v2 with partition*/
  SELECT employee_id,
         department_id
  FROM
    (SELECT *,
            row_number() OVER (PARTITION BY employee_id
                               ORDER BY primary_flag DESC) AS rowNum
     FROM Employee) AS E WHERE E.rowNum = 1 /* 610. Triangle Judgement */
  SELECT *,
         CASE
             WHEN (x + y) > z
                  AND (x + z) > y
                  AND (y + z) > x THEN 'Yes'
             ELSE 'No'
         END AS triangle
  FROM Triangle /*1164. Product Price at a Given Date */
  SELECT P.product_id,
         isnull(P.new_price, 10) AS price
  FROM
    (SELECT *,
            row_number() OVER (PARTITION BY product_id
                               ORDER BY change_date DESC) AS rowNum
     FROM Products
     WHERE change_date <= '2019-08-16') AS P WHERE rowNum=1
UNION
SELECT product_id,
       10
FROM Products
GROUP BY product_id
HAVING min(change_date) > '2019-08-16' /* 1204. Last Person to Fit in the Bus */
SELECT top 1 person_name
FROM
  (SELECT person_name,
          turn,
          sum(weight) OVER (
                            ORDER BY turn ASC) AS cumulative_weight
   FROM Queue) AS Weighted
WHERE cumulative_weight <= 1000
ORDER BY turn DESC /* 1907. Count Salary Categories */
SELECT 'Low Salary' AS category,
       sum(CASE
               WHEN (income < 20000) THEN 1
               ELSE 0
           END) AS accounts_count
FROM Accounts
UNION
SELECT 'Average Salary' AS category,
       sum(CASE
               WHEN (income >= 20000
                     AND income <= 50000) THEN 1
               ELSE 0
           END) AS accounts_count
FROM Accounts
UNION
SELECT 'High Salary' AS category,
       sum(CASE
               WHEN (income > 50000) THEN 1
               ELSE 0
           END) AS accounts_count
FROM Accounts /*V2*/ WITH SalaryCategories AS
  (SELECT 'Low Salary' AS category
   UNION ALL SELECT 'Average Salary'
   UNION ALL SELECT 'High Salary'),
                          SalaryCounts AS
  (SELECT category,
          COUNT(*) AS accounts_count
   FROM
     (SELECT CASE
                 WHEN income < 20000 THEN 'Low Salary'
                 WHEN income BETWEEN 20000 AND 50000 THEN 'Average Salary'
                 WHEN income > 50000 THEN 'High Salary'
             END AS category
      FROM Accounts) AS Salary
   GROUP BY category)
SELECT sc.category,
       coalesce(scnt.accounts_count, 0) AS accounts_count
FROM SalaryCategories AS sc
LEFT JOIN SalaryCounts AS scnt ON sc.category = scnt.category;

/*1667. Fix Names in a Table*/
SELECT user_id,
       concat(upper(substring(name, 1, 1)), lower(substring(name, 2, len(name)-1))) AS name
FROM Users /*1527. Patients With a Condition*/
SELECT *
FROM Patients
WHERE conditions like '% DIAB1%'
  OR conditions like 'DIAB1%' /*196. Delete Duplicate Emails */
  DELETE
  FROM Person WHERE id NOT IN
    (SELECT min(id)
     FROM Person
     GROUP BY email )/*v2*/ WITH cte AS
    (SELECT *,
            rank() OVER (PARTITION BY email
                         ORDER BY id ASC) AS ranking
     FROM Person)
  DELETE
  FROM cte WHERE ranking > 1 /*176. Second Highest Salary */
  SELECT DISTINCT MAX(salary) SecondHighestSalary
  FROM Employee WHERE salary <
    (SELECT Max(salary)
     FROM Employee);

/*v2*/
SELECT
  (SELECT TOP 1 salary
   FROM Employee
   WHERE salary <
       (SELECT MAX(salary)
        FROM Employee)
   ORDER BY salary DESC) AS SecondHighestSalary;

/*1327. List the Products Ordered in a Period */
select P.product_name, O.unit
from Products as P
inner join (
    select product_id, sum(unit) as unit
    from Orders
    where left(order_date,7) = '2020-02' 
    group by product_id
    having sum(unit) >= 100
) as O
on P.product_id = O.product_id
/*v2*/
select P.product_name, sum(O.unit) as unit
from Products as P
inner join Orders as O
on P.product_id = O.product_id
where left(order_date,7) = '2020-02' 
group by P.product_name
having sum(unit) >= 100

/*1517. Find Users With Valid E-Mails*/
select *
from Users
where mail like '[A-Za-z]%@leetcode.com'
and mail not like '%[^0-9a-zA-Z_.-]%@leetcode.com'
/*v2*/
select *
from Users
where right(mail,13) = '@leetcode.com'
and left(mail,1) like '[A-Za-z]'
and left(mail, len(mail)-13) not like '%[^0-9a-zA-Z_.-]%'

/* 1484. Group Sold Products By The Date */
with A as (
    select distinct sell_date, product 
    from activities
)
select A.sell_date, count(distinct product) as num_sold, STRING_AGG(product, ',') WITHIN GROUP (ORDER BY product) as products
from A
group by A.sell_date
order by A.sell_date


/* 1978. Employees Whose Manager Left the Company */
select employee_id 
from Employees
where salary < 30000 and  manager_id not in(
    select employee_id
    from Employees
)
order by employee_id

/* 185. Department Top Three Salaries */
with Ranked as (
    select *, dense_rank() over (partition by departmentId order by salary desc) as ranking
    from Employee
)
select D.name as Department, E.name as Employee, E.salary as Salary
from Ranked as E
left join Department as D
on D.id = E.departmentId
where E.ranking < 4 

/* 585. Investments in 2016 */
with FinalLocations(lat,lon) as (
    select lat,lon
    from Insurance
    group by lat,lon
    having count(*) = 1
)
select round(sum(tiv_2016) , 2) as tiv_2016
from Insurance as I
where exists (
    select FL.lat, FL.lon
    from FinalLocations as FL
    where FL.lat = I.lat and FL.lon = I.lon
) and I.tiv_2015 in (    
    select tiv_2015 
    from insurance
    group by tiv_2015
    having count(*) > 1
)

/*V2*/
with cte as (
    select 
        pid, 
        tiv_2015, 
        tiv_2016,
        concat(lat, lon) as location,
        count(pid) over (partition by concat(lat, lon)) as same_city_count,
        count(pid) over (partition by tiv_2015) as same_tiv_2015
    from Insurance
)
select round(sum(tiv_2016) , 2) as tiv_2016
from cte
where same_tiv_2015 > 1 and same_city_count = 1

/* 602. Friend Requests II: Who Has the Most Friends */
with Friends as(
    select requester_id as id, count(*) as friends
    from RequestAccepted
    group by requester_id

    union all

    select accepter_id as id, count(*) as friends
    from RequestAccepted
    group by accepter_id        
)

select top 1 id, sum(friends) as num
from Friends 
group by id
order by sum(friends) desc


/* 1341. Movie Rating */
select results
from (
    select top 1 U.name as results
    from Users as U
    join MovieRating as MR
    on U.user_id = MR.user_id   
    group by MR.user_id, U.name
    order by count(*) desc, U.name asc
) as R
union all
select results
from (
    select top 1 M.title as results  
    from Movies as M
    join MovieRating as R
    on M.movie_id = R.movie_id
    where left(created_at, 7) = '2020-02'
    group by R.movie_id, M.title
    order by avg(rating*1.0) desc, M.title asc
) as R2

/*1321. Restaurant Growth */
with Daily as (
    select 
        visited_on, 
        sum(amount) as amount 
    from Customer
    group by visited_on
)

select * 
from (
    select
        visited_on,
        SUM(amount) OVER (ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as amount, 
        ROUND(SUM(amount) OVER (ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) / 7.0, 2) as average_amount
    from Daily
) as D
where visited_on >= (
    select dateadd(day, 6, min(visited_on)) 
    from daily
)
order by visited_on asc

/* 626. Exchange Seats */
select 
    id,
    case 
        when id % 2 = 1 then isnull(lead(student, 1) OVER (ORDER BY id),student) 
        else lag(student, 1) OVER (ORDER BY id) 
    end as student
from Seat
order by id asc;

/*181. Employees Earning More Than Their Managers */
select E1.name as Employee 
from Employee E1
join Employee E2
on E1.managerId = E2.Id
where E1.salary > E2.salary

/*182. Duplicate Emails*/
select email as Email
from Person
group by email
having count(*) > 1

/* 183. Customers Who Never Order */
select name as Customers
from Customers
where id not in (
    select distinct customerID
    from Orders
)
/*v2*/
select name as Customers
from Customers as C
left join Orders as O
on O.customerId = C.id
where O.customerId is null

/*184. Department Highest Salary*/
with HighestSalaries as (
    select departmentId, max(salary) as Salary
    from Employee
    group by departmentId
)
select D.name as Department, E.name as  Employee, E.salary as Salary 
from Employee as E
inner Join Department as D
on E.departmentId = D.id
where exists (
    select *
    from HighestSalaries as HS
    where HS.departmentId = E.departmentId and HS.Salary = E.salary) 
/*v2*/
with RankedSalaries as (
    select D.name as Department, E.name as Employee, E.salary as Salary, dense_rank() over (partition by E.departmentId order by salary desc) as ranking
    from Employee as E
    inner Join Department as D
    on E.departmentId = D.id
)
select Department, Employee, Salary
from RankedSalaries
where ranking = 1

/*511. Game Play Analysis I*/
select player_id, min(event_date) as first_login 
from Activity
group by player_id

/* 586. Customer Placing the Largest Number of Orders */
select top 1 customer_number
from Orders
group by customer_number
order by count(*) desc

/*607. Sales Person*/
select P.name
from SalesPerson as P
where P.sales_id not in (
    select O.sales_id
    from Orders as O
    inner join Company as C
    on O.com_id = C.com_id
    where C.name = 'RED'
)

/*627. Swap Salary*/
update Salary
set sex = 
    case 
        when sex = 'm' then 'f' 
        when sex = 'f' then 'm' 
    end

/*1050. Actors and Directors Who Cooperated At Least Three Times*/
select actor_id, director_id 
from ActorDirector
group by actor_id, director_id
having count(*)  > 2

/*1084. Sales Analysis III*/
select product_id, product_name 
from Product
where product_id not in(
    select distinct product_id
    from sales
    where sale_date not between '2019-01-01' and '2019-03-31'
) and product_id in (    
    select distinct product_id
    from sales
)
/*v2*/
select P.product_id, P.product_name 
from Product as P
inner join sales as S
on  P.product_id = S.product_id
group by P.product_id, P.product_name
having min(S.sale_date) >= '2019-01-01' and max(S.sale_date) <= '2019-03-31'

/*1407. Top Travellers*/
select U.name, isnull(sum(R.distance),0) as travelled_distance 
from Users as U
left join Rides as R
on U.id = R.user_id
group by U.id, U.name
order by travelled_distance desc, name asc;

/*1587. Bank Account Summary II*/
select U.name, isnull(sum(T.amount),0) as balance
from Users as U
left join Transactions as T
on U.account = T.account
group by U.account, U.name
having isnull(sum(T.amount),0) > 10000

/*1693. Daily Leads and Partners*/
select date_id, make_name, count(distinct lead_id) as unique_leads, count(distinct partner_id) as unique_partners 
from DailySales
group by date_id, make_name;


/*1741. Find Total Time Spent by Each Employee*/
select event_day as day, emp_id, sum(out_time-in_time)as total_time 
from Employees
group by emp_id, event_day

/*1795. Rearrange Products Table*/
select product_id, 'store1' as store, store1 as price from Products where store1 is not null
union
select product_id, 'store2' as store, store2 as price from Products where store2 is not null
union
select product_id, 'store3' as store, store3 as price from Products where store3 is not null
/*v2*/
select product_id, store, price
from (
    SELECT product_id, store1, store2, store3
    FROM Products
) p
unpivot(
    price for store in (store1, store2, store3)
) as unpvt

/* 3436. Find Valid Emails */
select *
from Users
where email not like '%@%@%'
and email like '%@%.com'
and email not like '%[^A-Za-z0-9_]%@%[^A-Za-z]%'
order by user_id asc;

/* 1965. Employees With Missing Information */
select isnull(E.employee_id, S.employee_id) as employee_id
from Employees as E
full outer join Salaries as S
on E.employee_id = S.employee_id
where S.salary is null or E.name is null
order by employee_id asc

/*1873. Calculate Special Bonus*/
select 
    E.employee_id,
    case when E.employee_id % 2 = 1 and left(E.name, 1) != 'M' then salary else 0 end as bonus
from Employees as E
order by E.employee_id

/*1890. The Latest Login in 2020*/
select user_id, max(time_stamp) as last_stamp 
from Logins
where year(time_stamp) = 2020
group by user_id


with 
Roots as (
    select id, 'Root' as 'type' 
    from Tree 
    where p_id is null
),

Leafs as (
    select T2.id as id, 'Leaf' as 'type'
    from Tree as T1
    full outer join Tree as T2
    on T1.p_id = T2.id
    where T1.p_id is null and T2.p_id is not null
)

/*608. Tree Node */
select * from  Roots
union all
select id, 'Inner' as 'type'
from Tree
where id not in (
    select L.id
    from Leafs as L
) and id not in (
    select R.id
    from Roots as R
)
union all select * from Leafs
/*v2*/
select 
    id,
    case
        when p_id is null then 'Root'
        when id in (select p_id from Tree) then 'Inner'
        else 'Leaf'
    end as 'type'
from Tree

/*1158. Market Analysis I */
with Orders2019 as (
    select buyer_id, count(distinct order_id) as orders_in_2019
    from Orders
    where year(order_date) = 2019
    group by buyer_id
)

select U.user_id as buyer_id, U.join_date as join_date, isnull(O.orders_in_2019, 0) as orders_in_2019
from Users as U
left join Orders2019 as O
on O.buyer_id = U.user_id

/* 1393. Capital Gain/Loss */
select 
    stock_name, 
    sum(case when operation = 'sell' then price else -price end) as capital_gain_loss 
from Stocks
group by stock_name    

/* 3220. Odd and Even Transactions */
select 
    transaction_date,
    isnull(sum(case when amount % 2 = 1 then amount else 0 end),0) as odd_sum,
    isnull(sum(case when amount % 2 = 0 then amount else 0 end),0) as even_sum
from transactions
group by transaction_date 


/*3421. Find Students Who Improved */
with 
FirstScoreDate as(
    select student_id, subject, min(exam_date) as first_exam
    from Scores
    group by student_id, subject
    having count(*) > 1
),
LastScoreDate as(
    select student_id, subject, max(exam_date) as last_exam
    from Scores
    group by student_id, subject
    having count(*) > 1
)

select FS.student_id as 'student_id', FS.subject as 'subject', FS.first_score as 'first_score', LS.latest_score
from (
    select S.student_id as 'student_id', S.subject as 'subject', S.score as 'first_score'
    from Scores as S
    inner join FirstScoreDate as F
    on S.student_id = F.student_id and S.subject = F.subject and S.exam_date = F.first_exam 
) as FS
join (
    select S2.student_id as 'student_id', S2.subject as 'subject', S2.score as 'latest_score'
    from Scores as S2
    inner join LastScoreDate as L
    on S2.student_id = L.student_id and S2.subject = L.subject and S2.exam_date = L.last_exam 
) as LS
on FS.student_id = LS.student_id and FS.subject = LS.subject
where FS.first_score < LS.latest_score
order by student_id, subject ;
/*v2*/
WITH ScoreCTE AS (
    SELECT
        student_id,
        subject,
        COUNT(*) OVER (PARTITION BY student_id, subject) AS exam_count,
        FIRST_VALUE(score) OVER (PARTITION BY student_id, subject ORDER BY exam_date ASC) AS first_score,
        FIRST_VALUE(score) OVER (PARTITION BY student_id, subject ORDER BY exam_date DESC) AS latest_score
    FROM Scores
)
SELECT DISTINCT
    student_id,
    subject,
    first_score,
    latest_score
FROM ScoreCTE
WHERE exam_count > 1
  AND first_score < latest_score
ORDER BY student_id, subject;

/*262. Trips and Users*/
with BannedIds as (
    select users_id
    from Users
    where banned = 'Yes'
)

select 
    request_at as day,
    round(sum(case when left(status,3) = 'can' then 1.0 else 0.0 end) / count(*), 2) as 'Cancellation Rate'
from Trips
where request_at between '2013-10-01' and '2013-10-03' and client_id not in ( select * from BannedIds) and driver_id not in (select * from BannedIds)
group by request_at


/*3374. First Letter Capitalization II*/
with Words as ( 
    select 
        content_id,
        content_text as original_text,
        concat(upper(left(value,1)), lower(right(value, len(value)-1))) as words
    from user_content
    cross apply string_split(replace(content_text, '-', ' - '), ' ')
)

select 
    content_id, 
    original_text,
    replace(string_agg(words, ' '), ' - ', '-') as converted_text
from Words
group by content_id, original_text
order by content_id asc
/*PostgreSQL sql only*/
select content_id, content_text as original_text, initcap(content_text) as converted_text
from user_content
order by content_id asc;

/*601. Human Traffic of Stadium*/
with ConsecutiveRecords as (
    select id,
        visit_date,
        lag(people, 2) over (order by id) as prev2,
        lag(people, 1) over (order by id) as prev1,
        people,
        lead(people, 1) over (order by id) as next1,
        lead(people, 2) over (order by id) as next2
    from Stadium
)
select 
    id,
    visit_date,
    people
from ConsecutiveRecords
where (prev2 > 99 and prev1 > 99 and people > 99)
or (prev1 > 99 and next1 > 99 and people > 99)
or (next2 > 99 and next1 > 99 and people > 99)
order by visit_date asc
