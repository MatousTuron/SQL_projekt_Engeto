--Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

--Odpověď:

--Růst cen potravin převyšoval růst mezd v polovině případů, nikdy však ne více než o 7.5%. 


WITH yearly_prices AS (
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
    p.price_year AS year,
    p.avg_food_yoy_growth,
    w.avg_wage_yoy_growth,
    ROUND((p.avg_food_yoy_growth - w.avg_wage_yoy_growth)::NUMERIC, 2) AS difference,
    CASE WHEN p.avg_food_yoy_growth - w.avg_wage_yoy_growth > 10 THEN 'ANO' ELSE 'NE' END AS problem_year
FROM price_growth p
JOIN wage_growth w
    ON p.price_year = w.wage_year
ORDER BY p.price_year ASC
