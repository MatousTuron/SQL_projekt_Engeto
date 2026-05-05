--Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

--Srovnatelná období: roky 2007 a 2018

--Odpověď:

--Maximum = pracovníci v informačních a komunikačních technologiích si v roce 2018 mohli průměrně za svou mzdu zakoupit 2.862l mléka.

--Minimum = pracovníci v ubytování, stravování a pohostinství si v roce 2007 mohli průměrně za svou mzdu zakoupit 656kg chleba.


SELECT
    f.industry_branch_name,
    f.year,
    p.product_name,
    ROUND(f.industry_avg_wage::NUMERIC, 0) AS avg_wage,
    p.avg_price,
    ROUND((f.industry_avg_wage / p.avg_price)::NUMERIC, 0) AS units_affordable
FROM t_matous_turon_project_sql_primary_final f
JOIN (
    SELECT product_name, avg_price, year
    FROM t_matous_turon_project_sql_primary_final
    WHERE product_name IS NOT NULL
    AND year IN (2007, 2018)
) p ON f.year = p.year
WHERE f.industry_branch_name IS NOT NULL
AND f.year IN (2007, 2018)
AND p.product_name IN ('Chléb konzumní kmínový', 'Mléko polotučné pasterované')
ORDER BY f.industry_branch_name, p.product_name, f.YEAR
