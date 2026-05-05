--Má výška HDP vliv na změny ve mzdách a cenách potravin?
--Neboli, pokud HDP vzroste výrazněji v jednom roce,
--projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

--Odpověď:

--Růst HDP koreluje s růstem mezd a potravin cca ve 2 ze 3 případů.

--Nějaká souvislost tam tedy je, ale pro vyvození validních závěrů by byla žádoucí širší analýza s více daty.


WITH gdp_with_lead AS (
    SELECT
        year,
        yoy_gdp_growth,
        LEAD(yoy_gdp_growth) OVER (ORDER BY year) AS next_year_gdp_growth
    FROM t_matous_turon_project_sql_primary_final
    WHERE yoy_gdp_growth IS NOT NULL
    GROUP BY year, yoy_gdp_growth
)
SELECT
    g.year,
    g.yoy_gdp_growth,
    g.next_year_gdp_growth,
    ROUND(AVG(f.yoy_price_growth)::NUMERIC, 2) AS avg_food_yoy_growth,
    ROUND(AVG(f.yoy_wage_growth)::NUMERIC, 2) AS avg_wage_yoy_growth
FROM gdp_with_lead g
JOIN t_matous_turon_project_sql_primary_final f ON g.year = f.year
WHERE f.product_name IS NOT NULL
GROUP BY g.year, g.yoy_gdp_growth, g.next_year_gdp_growth
ORDER BY g.year ASC
