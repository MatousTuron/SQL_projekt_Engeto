--Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

--Odpověď:

--Růst cen potravin převyšoval růst mezd v polovině případů, nikdy však ne více než o 7.5%. 


SELECT
    year,
    ROUND(AVG(yoy_price_growth)::NUMERIC, 2) AS avg_food_yoy_growth,
    ROUND(AVG(yoy_wage_growth)::NUMERIC, 2) AS avg_wage_yoy_growth,
    ROUND((AVG(yoy_price_growth) - AVG(yoy_wage_growth))::NUMERIC, 2) AS difference,
    CASE WHEN AVG(yoy_price_growth) - AVG(yoy_wage_growth) > 10 THEN 'ANO' ELSE 'NE' END AS problem_year
FROM t_matous_turon_project_sql_primary_final
WHERE product_name IS NOT NULL
GROUP BY year
ORDER BY year ASC
