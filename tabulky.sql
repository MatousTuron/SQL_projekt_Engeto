CREATE TABLE t_matous_turon_project_sql_primary_final AS
WITH yearly_prices AS (
    SELECT
        cpc.name AS product_name,
        EXTRACT(YEAR FROM cp.date_from) AS year,
        AVG(cp.value) AS avg_price
    FROM czechia_price cp
    JOIN czechia_price_category cpc
        ON cp.category_code = cpc.code
	WHERE EXTRACT(YEAR FROM cp.date_from) BETWEEN 2006 AND 2018
    GROUP BY cpc.name, EXTRACT(YEAR FROM cp.date_from)
),
price_lag AS (
    SELECT
        product_name,
        year,
        avg_price,
        LAG(avg_price) OVER (PARTITION BY product_name ORDER BY year) AS prev_year_price
    FROM yearly_prices
),
price_growth AS (
    SELECT
        year,
        product_name,
        ROUND(avg_price::NUMERIC, 2) AS avg_price,
        ROUND(((avg_price - prev_year_price) / prev_year_price * 100)::NUMERIC, 2) AS yoy_price_growth
    FROM price_lag
    WHERE prev_year_price IS NOT NULL
),
wages AS (
    SELECT
        cp.payroll_year AS year,
        AVG(cp.value) AS avg_wage
    FROM czechia_payroll cp
    WHERE cp.value_type_code = 5958
    AND cp.payroll_year BETWEEN 2006 AND 2018
    AND cp.calculation_code = 200
    GROUP BY cp.payroll_year
),
wage_lag AS (
    SELECT
        year,
        avg_wage,
        LAG(avg_wage) OVER (ORDER BY year) AS prev_year_wage
    FROM wages
),
wage_growth AS (
    SELECT
        year,
        ROUND(avg_wage::NUMERIC, 0) AS avg_wage,
        ROUND(((avg_wage - prev_year_wage) / prev_year_wage * 100)::NUMERIC, 2) AS yoy_wage_growth
    FROM wage_lag
    WHERE prev_year_wage IS NOT NULL
),
gdp_data AS (
    SELECT
        year,
        gdp,
        LAG(gdp) OVER (ORDER BY year) AS prev_year_gdp
    FROM economies
    WHERE country = 'Czech Republic'
    AND year BETWEEN 2006 AND 2018
    AND gdp IS NOT NULL
),
gdp_growth AS (
    SELECT
        year,
        ROUND(gdp::NUMERIC, 0) AS gdp,
        ROUND(((gdp - prev_year_gdp) / prev_year_gdp * 100)::NUMERIC, 2) AS yoy_gdp_growth
    FROM gdp_data
    WHERE prev_year_gdp IS NOT NULL
),
industry_wages AS (
    SELECT
        cp.payroll_year AS year,
        cpib.name AS industry_branch_name,
        AVG(cp.value) AS industry_avg_wage
    FROM czechia_payroll cp
    JOIN czechia_payroll_industry_branch cpib
        ON cp.industry_branch_code = cpib.code
    WHERE cp.value_type_code = 5958
    AND cp.payroll_year BETWEEN 2006 AND 2018
    AND cp.calculation_code = 200
    GROUP BY cp.payroll_year, cpib.name
),
industry_lag AS (
    SELECT
        year,
        industry_branch_name,
        industry_avg_wage,
        LAG(industry_avg_wage) OVER (PARTITION BY industry_branch_name ORDER BY year) AS prev_year_industry_wage
    FROM industry_wages
),
industry_growth AS (
    SELECT
        year,
        industry_branch_name,
        ROUND(industry_avg_wage::NUMERIC, 0) AS industry_avg_wage,
        ROUND(((industry_avg_wage - prev_year_industry_wage) / prev_year_industry_wage * 100)::NUMERIC, 2) AS industry_yoy_wage_growth
    FROM industry_lag
    WHERE prev_year_industry_wage IS NOT NULL
)
SELECT
    p.year,
    p.product_name,
    p.avg_price,
    p.yoy_price_growth,
    w.avg_wage,
    w.yoy_wage_growth,
    g.gdp,
    g.yoy_gdp_growth,
    NULL::TEXT AS industry_branch_name,
    NULL::NUMERIC AS industry_avg_wage,
    NULL::NUMERIC AS industry_yoy_wage_growth
FROM price_growth p
JOIN wage_growth w ON p.year = w.year
JOIN gdp_growth g ON p.year = g.year
UNION ALL
-- Typ 2: řádky s odvětvovými mzdami
SELECT
    i.year,
    NULL::TEXT AS product_name,
    NULL::NUMERIC AS avg_price,
    NULL::NUMERIC AS yoy_price_growth,
    w.avg_wage,
    w.yoy_wage_growth,
    g.gdp,
    g.yoy_gdp_growth,
    i.industry_branch_name,
    i.industry_avg_wage,
    i.industry_yoy_wage_growth
FROM industry_growth i
JOIN wage_growth w ON i.year = w.year
JOIN gdp_growth g ON i.year = g.year
ORDER BY year, product_name, industry_branch_name;


CREATE TABLE IF NOT EXISTS t_matous_turon_project_sql_secondary_final AS
SELECT
	c.country,
	e.year,
	round(e.gdp::NUMERIC, 0) AS gdp,
	e.gini,
	e.population 
FROM countries c 
JOIN economies e ON c.country = e.country
WHERE c.continent = 'Europe'
AND YEAR BETWEEN 2006 AND 2018
ORDER BY c.country, e.YEAR
