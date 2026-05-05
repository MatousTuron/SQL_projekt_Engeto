--Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

--Roky 2006-2018

--Odpověď:

--Největší meziroční pokles ceny zaznamenal cukr krystalový. Zlevnila i rajská jablka červená kulatá.

--Nejmenší nárůst ceny zaznamenaly banány žluté.

--Největší nárůst zaznamenaly papriky.


SELECT
    product_name,
    ROUND(AVG(yoy_price_growth)::NUMERIC, 2) AS avg_yoy_growth
FROM t_matous_turon_project_sql_primary_final
WHERE product_name IS NOT NULL
GROUP BY product_name
ORDER BY avg_yoy_growth ASC
