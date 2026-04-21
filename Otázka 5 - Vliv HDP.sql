--Má výška HDP vliv na změny ve mzdách a cenách potravin?
--Neboli, pokud HDP vzroste výrazněji v jednom roce,
--projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

--Odpověď:

--Růst HDP koreluje s růstem mezd a potravin cca ve 2 ze 3 případů.

--Nějaká souvislost tam tedy je, ale pro vyvození validních závěrů by byla žádoucí širší analýza s více daty.


SELECT
	YEAR,
	round(gdp::NUMERIC, 0) AS GDP
FROM economies e 
WHERE country = 'Czech Republic'
AND gdp IS NOT NULL
AND YEAR BETWEEN 2006 AND 2018
ORDER BY YEAR



WITH gdp_yearly AS (
    SELECT
        year,
        gdp
    FROM economies
    WHERE country = 'Czech Republic'
    AND gdp IS NOT NULL
    AND year BETWEEN 2006 AND 2018
),
gdp_growth AS (
    SELECT
        year,
        ROUND(((gdp - LAG(gdp) OVER (ORDER BY year)) / LAG(gdp) OVER (ORDER BY year) * 100)::NUMERIC, 2) AS yoy_gdp_growth
    FROM gdp_yearly
),
gdp_with_lag AS (
    SELECT
        year,
        yoy_gdp_growth,
        LAG(yoy_gdp_growth) OVER (ORDER BY year) AS last_year_gdp_growth
    FROM gdp_growth
    WHERE yoy_gdp_growth IS NOT NULL
),
yearly_prices AS (
    SELECT
        cpc.name AS product_name,
        EXTRACT(YEAR FROM cp.date_from) AS price_year,
        AVG(cp.value) AS avg_price
    FROM czechia_price cp
    JOIN czechia_price_category cpc
        ON cp.category_code = cpc.code
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
        ROUND(AVG(((avg_price - prev_year_price) / prev_year_price * 100))::NUMERIC, 2) AS avg_food_yoy_growth
    FROM price_lag
    WHERE prev_year_price IS NOT NULL
    GROUP BY price_year
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
        ROUND(((avg_wage - prev_year_wage) / prev_year_wage * 100)::NUMERIC, 2) AS avg_wage_yoy_growth
    FROM wage_lag
    WHERE prev_year_wage IS NOT NULL
)
SELECT
    g.year,
    g.yoy_gdp_growth,
    g.last_year_gdp_growth,
    p.avg_food_yoy_growth,
    w.avg_wage_yoy_growth
FROM gdp_with_lag g
JOIN price_growth p ON g.year = p.price_year
JOIN wage_growth w ON g.year = w.wage_year
ORDER BY g.year ASC
