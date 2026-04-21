--Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

--Srovnatelná období: roky 2006 a 2018

--Odpověď:

--Maximum = pracovníci v informačních a komunikačních technologiích si v roce 2018 mohli průměrně za svou mzdu zakoupit 2.862l mléka.

--Minimum = pracovníci v ubytování, stravování a pohostinství si v roce 2006 mohli průměrně za svou mzdu zakoupit 724kg chleba.


SELECT
	cp.category_code,
	cpc.name,
	cp.value,
	to_char(cp.date_from, 'YYYY') AS year,
	cp.date_from
FROM czechia_price cp 
JOIN czechia_price_category cpc 
	ON cp.category_code = cpc.code
WHERE cp.category_code IN ('111301', '114201')
ORDER BY cpc.name, cp.date_from 



WITH bounds AS (
    SELECT MIN(date_from) AS oldest, MAX(date_from) AS newest
    FROM czechia_price
)
SELECT
    cpc.name,
    round(AVG(cp.value) FILTER (WHERE cp.date_from = b.oldest)::NUMERIC, 2) AS price_oldest,
    round(AVG(cp.value) FILTER (WHERE cp.date_from = b.newest)::NUMERIC, 2) AS price_newest
FROM czechia_price cp
JOIN czechia_price_category cpc
    ON cp.category_code = cpc.code
CROSS JOIN bounds b
WHERE cp.category_code IN ('111301', '114201')
GROUP BY cpc.name
ORDER BY cpc.name ASC



WITH wages AS (
    SELECT
        cpib.name AS industry_branch_name,
        cp.payroll_year,
        AVG(cp.value) AS avg_wage
    FROM czechia_payroll cp
    JOIN czechia_payroll_industry_branch cpib
        ON cp.industry_branch_code = cpib.code
    WHERE cp.value_type_code = 5958
    AND cp.calculation_code = 200
    AND (
        cp.payroll_year = 2006
        OR
        cp.payroll_year = 2018
    )
    GROUP BY cpib.name, cp.payroll_year
),
prices AS (
    SELECT
        cpc.name AS product_name,
        EXTRACT(YEAR FROM cp.date_from) AS price_year,
        AVG(cp.value) AS avg_price
    FROM czechia_price cp
    JOIN czechia_price_category cpc
        ON cp.category_code = cpc.code
    WHERE cp.category_code IN ('111301', '114201')
    AND EXTRACT(YEAR FROM cp.date_from) IN (2006, 2018)
    GROUP BY cpc.name, EXTRACT(YEAR FROM cp.date_from)
)
SELECT
    w.industry_branch_name,
    w.payroll_year,
    p.product_name,
    ROUND(w.avg_wage::NUMERIC, 2) AS avg_wage,
    ROUND(p.avg_price::NUMERIC, 2) AS avg_price,
    ROUND((w.avg_wage / p.avg_price)::NUMERIC, 0) AS units_affordable
FROM wages w
JOIN prices p
    ON w.payroll_year = p.price_year
ORDER BY w.industry_branch_name, p.product_name, w.payroll_year
