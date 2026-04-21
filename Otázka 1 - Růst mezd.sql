--Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

--Roky 2006-2018

--Odpověď: Ve všech odvětvích mzdy rostly - procentuálně nejvíce ve zdravotní a sociální péči, nejméně pak v peněžnictví a pojišťovnictví.


SELECT
	cp.industry_branch_code,
	cpib.name AS industry_branch_name,
	cp.value,
	cp.payroll_year,
	cp.payroll_quarter
FROM czechia_payroll cp 
JOIN czechia_payroll_industry_branch cpib
	ON cp.industry_branch_code = cpib.code
WHERE cp.value_type_code = 5958
AND cp.calculation_code = 200
AND cp.payroll_year BETWEEN 2006 AND 2018
ORDER BY cp.industry_branch_code, cp.payroll_year, cp.payroll_quarter 



WITH yearly_avg AS (
    SELECT
        cp.industry_branch_code,
        cpib.name,
        cp.payroll_year,
        avg(cp.value) AS avg_wage
    FROM czechia_payroll cp
    JOIN czechia_payroll_industry_branch cpib
        ON cp.industry_branch_code = cpib.code
    WHERE cp.value_type_code = 5958
    AND cp.calculation_code = 200
    AND cp.payroll_year BETWEEN 2006 AND 2018
    GROUP BY cp.industry_branch_code, cpib.name, cp.payroll_year
)
SELECT
    name AS industry_branch,
    round(avg(avg_wage)::numeric, 0) AS avg_wage,
    round(
        (regr_slope(avg_wage, payroll_year) / avg(avg_wage) * 100)::numeric
    , 2) AS wage_growth_pct
FROM yearly_avg
GROUP BY industry_branch_code, name
ORDER BY wage_growth_pct DESC;
