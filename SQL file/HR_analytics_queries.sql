/* =========================================
   HR ANALYTICS SQL PROJECT
========================================= */


/* =========================================
   PHASE 1 : KPI ANALYSIS
========================================= */

-- Total Employees

SELECT COUNT(*) AS total_employees
FROM hr_data;

-- Attrition Count
SELECT COUNT(*) AS attrition_count
FROM hr_data
WHERE Attrition = 'Yes';

-- Attrition Rate

SELECT ROUND(
       COUNT(CASE WHEN Attrition = 'Yes' THEN 1 END) * 100.0
       / COUNT(*), 2
       ) AS attrition_rate
FROM hr_data;

-- Average Salary

SELECT ROUND(AVG(MonthlyIncome), 2) AS avg_salary
FROM hr_data;

-- Average Age

SELECT ROUND(AVG(Age), 2) AS avg_age
FROM hr_data;

-- Average Experience
SELECT ROUND(AVG(TotalWorkingYears), 2) AS avg_experience
FROM hr_data;


/* =========================================
   PHASE 2 : DEPARTMENT ANALYSIS
========================================= */

-- Employee Count by Department

SELECT Department,
       COUNT(*) AS employee_count
FROM hr_data
GROUP BY Department
ORDER BY employee_count DESC;

-- Attrition by Department

SELECT Department,
       COUNT(*) AS attrition_count
FROM hr_data
WHERE Attrition = 'Yes'
GROUP BY Department
ORDER BY attrition_count DESC;

-- Average Salary by Department

SELECT Department,
       ROUND(AVG(MonthlyIncome), 2) AS avg_salary
FROM hr_data
GROUP BY Department
ORDER BY avg_salary DESC;


/* =========================================
   PHASE 3 : JOB ROLE ANALYSIS
========================================= */

-- Employee Count by Job Role

SELECT JobRole,
       COUNT(*) AS employee_count
FROM hr_data
GROUP BY JobRole
ORDER BY employee_count DESC;

-- Attrition by Job Role
SELECT JobRole,
       COUNT(*) AS attrition_count
FROM hr_data
WHERE Attrition = 'Yes'
GROUP BY JobRole
ORDER BY attrition_count DESC;

-- Average Salary by Job Role

SELECT JobRole,
       ROUND(AVG(MonthlyIncome), 2) AS avg_salary
FROM hr_data
GROUP BY JobRole
ORDER BY avg_salary DESC;


/* =========================================
   PHASE 4 : SALARY, AGE & EXPERIENCE ANALYSIS
========================================= */

-- Salary Band Analysis

SELECT
    CASE
        WHEN MonthlyIncome < 5000 THEN 'Low Salary'
        WHEN MonthlyIncome BETWEEN 5000 AND 10000 THEN 'Medium Salary'
        ELSE 'High Salary'
    END AS salary_band,
    COUNT(*) AS employee_count
FROM hr_data
GROUP BY salary_band
ORDER BY employee_count DESC;

-- Attrition by Age Group

SELECT
    CASE
        WHEN Age < 25 THEN 'Below 25'
        WHEN Age BETWEEN 25 AND 35 THEN '25-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        ELSE '45+'
    END AS age_group,
    COUNT(*) AS attrition_count
FROM hr_data
WHERE Attrition = 'Yes'
GROUP BY age_group;

-- Employee Count by Years at Company

SELECT YearsAtCompany,
       COUNT(*) AS employee_count
FROM hr_data
GROUP BY YearsAtCompany
ORDER BY YearsAtCompany;

-- Attrition by Years at Company
SELECT YearsAtCompany,
       COUNT(*) AS attrition_count
FROM hr_data
WHERE Attrition = 'Yes'
GROUP BY YearsAtCompany
ORDER BY YearsAtCompany;

-- Average Job Satisfaction by Department

SELECT Department,
       ROUND(AVG(JobSatisfaction), 2) AS avg_job_satisfaction
FROM hr_data
GROUP BY Department
ORDER BY avg_job_satisfaction DESC;

-- Average Work-Life Balance by Department

SELECT Department,
       ROUND(AVG(WorkLifeBalance), 2) AS avg_worklife_balance
FROM hr_data
GROUP BY Department
ORDER BY avg_worklife_balance DESC;


/* =========================================
   PHASE 5 : WINDOW FUNCTIONS (ADVANCED SQL)
========================================= */

-- Salary Rank Within Department

SELECT
    EmployeeID,
    Department,
    MonthlyIncome,
    RANK() OVER (
        PARTITION BY Department
        ORDER BY MonthlyIncome DESC
    ) AS salary_rank
FROM hr_data;

-- Top 3 Highest Paid Employees Per Department

WITH ranked_employees AS (
    SELECT *,
           RANK() OVER (
               PARTITION BY Department
               ORDER BY MonthlyIncome DESC
           ) AS salary_rank
    FROM hr_data
)
SELECT *
FROM ranked_employees
WHERE salary_rank <= 3;

-- Compare Employee Salary with Department Average

SELECT
    EmployeeID,
    Department,
    MonthlyIncome,
    ROUND(
        AVG(MonthlyIncome) OVER (
            PARTITION BY Department
        ), 2
    ) AS dept_avg_salary
FROM hr_data;

-- Department Size

SELECT
    EmployeeID,
    Department,
    COUNT(*) OVER (
        PARTITION BY Department
    ) AS dept_size
FROM hr_data;

-- Previous Salary Comparison (LAG)

SELECT
    EmployeeID,
    Department,
    MonthlyIncome,
    LAG(MonthlyIncome) OVER (
        PARTITION BY Department
        ORDER BY MonthlyIncome
    ) AS previous_salary
FROM hr_data;

-- Salary Difference from Previous Employee

SELECT
    EmployeeID,
    Department,
    MonthlyIncome,
    MonthlyIncome -
    LAG(MonthlyIncome) OVER (
        PARTITION BY Department
        ORDER BY MonthlyIncome
    ) AS salary_difference
FROM hr_data;

-- Highest Paid Employee in Each Department

WITH department_rank AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY Department
               ORDER BY MonthlyIncome DESC
           ) AS rn
    FROM hr_data
)
SELECT *
FROM department_rank
WHERE rn = 1;

