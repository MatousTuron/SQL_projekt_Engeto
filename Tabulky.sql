CREATE TABLE IF NOT EXISTS t_matous_turon_project_SQL_primary_final AS
WITH yearly_prices AS (
    SELECT
        cpc.name AS product_name,
        EXTRACT(YEAR FROM cp.date_from) AS price_year,
        AVG(cp.value) AS avg_price
    FROM czechia_price cp
    JOIN czechia_price_category cpc
        ON cp.category_code = cpc.code
    WHERE cp.category_code IN ('111301', '114201')
    GROUP BY cpc.name, EXTRACT(YEAR FROM cp.date_from)
),
price_lag AS (
    SELECT
        product_name,
        price_year,
        avg_price,
        LAG(avg_price) OVER (PARTITION BY product_name ORDER BY price_year) AS prev_year_price
    FROM yearly_prices
),
price_growth AS (
    SELECT
        price_year,
        ROUND(avg_price::NUMERIC, 2) AS avg_price,
        product_name,
        ROUND(((avg_price - prev_year_price) / prev_year_price * 100)::NUMERIC, 2) AS yoy_price_growth
    FROM price_lag
    WHERE prev_year_price IS NOT NULL
),
wages AS (
    SELECT
        cp.payroll_year AS wage_year,
        AVG(cp.value) AS avg_wage
    FROM czechia_payroll cp
    WHERE cp.value_type_code = 5958
    AND cp.calculation_code = 200
    GROUP BY cp.payroll_year
),
wage_lag AS (
    SELECT
        wage_year,
        avg_wage,
        LAG(avg_wage) OVER (ORDER BY wage_year) AS prev_year_wage
    FROM wages
),
wage_growth AS (
    SELECT
        wage_year,
        ROUND(avg_wage::NUMERIC, 0) AS avg_wage,
        ROUND(((avg_wage - prev_year_wage) / prev_year_wage * 100)::NUMERIC, 2) AS yoy_wage_growth
    FROM wage_lag
    WHERE prev_year_wage IS NOT NULL
)
SELECT
    p.price_year AS year,
    p.product_name,
    p.avg_price,
    p.yoy_price_growth,
    w.avg_wage,
    w.yoy_wage_growth
FROM price_growth p
JOIN wage_growth w
    ON p.price_year = w.wage_year
ORDER BY p.product_name, p.price_year



CREATE TABLE IF NOT EXISTS t_matous_turon_project_SQL_secondary_final AS
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
