--Demographic Analysis:

-- distribution of employees by gender and ethnicity
select gender , Ethnicity 
from Project..Employee
order by gender , Ethnicity 

-- the average age of employees in the company
select AVG(age) 
from Project..Employee

-- the average age of employees in the company regarding to each Dep.
select Department, AVG(age) 
from Project..Employee
group by Department

--Salary Analysis:

-- overall distribution of annual salaries

select distinct Annual_Salary
from Project..Employee
order by Annual_Salary

--the highest and lowest-paid employees
select Full_Name,job_title , Annual_Salary
from Project..Employee
where Annual_Salary = (select Max(Annual_Salary) from Project..Employee ) or Annual_Salary = (select min(Annual_Salary) from Project..Employee )



--Bonus Analysis:

-- the average bonus percentage for employees
SELECT Avg(CAST(REPLACE(bonus, '%', '') AS DECIMAL(10, 2))) AS Max_Bonus_Percentage
FROM Project..Employee;

--Max bonus for employees

SELECT MAX(CAST(REPLACE(bonus, '%', '') AS DECIMAL(10, 2))) AS Max_Bonus_Percentage
FROM Project..Employee;
 


--Are there any trend or patterns in bonus distribution across departments?
select department , bonus
from Project..Employee
group by department , bonus

--Tenure Analysis:

--How long, on average, do employees stay with the company

SELECT
    AVG(DATEDIFF(MONTH, Hire_Date, COALESCE(Exit_Date, GETDATE()))) AS Average_Tenure_Months
from Project..Employee

SELECT
    AVG(DATEDIFF(MONTH, Hire_Date, Exit_Date)) AS Average_Tenure_Months
from Project..Employee
where Exit_date is not null

--Can you identify the employees with the longest and shortest tenures?
--Departmental Analysis:

--How many employees are there in each department?

select Count (full_name) 
from Project..Employee
group by Department

--What is the average salary in each department?

select department,AVG(annual_salary) 
from project..Employee
group by Department

--Geographical Analysis:

--In which countries and cities does the company have a presence?

select country , count( country) country_count , city,count(City)  city_count
from project..Employee
group by country, city
order by Country

--Are there any salary variations based on the country or city?

select job_title , department, country , city , Annual_Salary
from project..Employee
order by job_title, Department, country , City

--Exit Analysis:

--What is the primary reason for employee exits?
select * 
from Project..Employee 
where Exit_Date is not null
order by Department

--Can you identify any patterns in exit dates or tenures?
--Promotion Analysis:

--Are there employees who have been promoted? If so, what is the distribution of promotions across job titles?
WITH PromotionHistory AS (
    SELECT
        EEID,
        Job_Title AS PreviousJobTitle,
        LEAD(Job_Title) OVER (PARTITION BY eeid ORDER BY Hire_Date) AS CurrentJobTitle
    FROM
       project..Employee
)


SELECT
    CurrentJobTitle,
    COUNT(*) AS PromotionCount
FROM
    PromotionHistory
WHERE
    CurrentJobTitle IS NOT NULL
    AND PreviousJobTitle IS NOT NULL
    AND CurrentJobTitle <> PreviousJobTitle
GROUP BY
    CurrentJobTitle
ORDER BY
    PromotionCount DESC;

--Is there a correlation between promotions and salary increases?
--Diversity and Inclusion:

--How diverse is the workforce in terms of gender and ethnicity?
select Gender,Ethnicity, count(ethnicity) Total
from project..Employee
group by Gender,Ethnicity


--Are there any initiatives in place to promote diversity and inclusion?
--Performance Metrics:


--Is there a correlation between performance metrics and salary/bonus?
select CAST(REPLACE(bonus, '%', '') AS DECIMAL(10, 0)) bonus ,Department,Business_Unit,Job_Title
from project..Employee
group by CAST(REPLACE(bonus, '%', '') AS DECIMAL(10, 0)) ,Department,Business_Unit,Job_Title