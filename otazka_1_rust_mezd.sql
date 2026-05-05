--Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

--Roky 2006-2018

--Odpověď: Ve všech odvětvích mzdy rostly - procentuálně nejvíce ve zdravotní a sociální péči, nejméně pak v peněžnictví a pojišťovnictví.


SELECT
    industry_branch_name,
    ROUND(AVG(industry_avg_wage)::NUMERIC, 0) AS avg_wage,
    ROUND(AVG(industry_yoy_wage_growth)::NUMERIC, 2) AS avg_yoy_wage_growth
FROM t_matous_turon_project_sql_primary_final
WHERE industry_branch_name IS NOT NULL
GROUP BY industry_branch_name
ORDER BY AVG(industry_yoy_wage_growth) DESC;
