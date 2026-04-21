--Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

--Roky 2006-2018

--Odpověď:

--Největší meziroční pokles ceny zaznamenal cukr krystalový. Zlevnila i rajská jablka červená kulatá.

--Nejmenší nárůst ceny zaznamenaly banány žluté.

--Největší nárůst zaznamenaly papriky.


SELECT
    cpc.name AS product_name,
    EXTRACT(YEAR FROM cp.date_from) AS price_year,
    round(AVG(cp.value)::NUMERIC, 2) AS avg_price
FROM czechia_price cp
JOIN czechia_price_category cpc
    ON cp.category_code = cpc.code
GROUP BY cpc.name, EXTRACT(YEAR FROM cp.date_from)
ORDER BY cpc.name, EXTRACT(YEAR FROM cp.date_from)



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
with_lag AS (
    SELECT
        product_name,
        price_year,
        avg_price,
        LAG(avg_price) OVER (PARTITION BY product_name ORDER BY price_year) AS prev_year_price
    FROM yearly_prices
),
with_growth AS (
    SELECT
        product_name,
        price_year,
        avg_price,
        prev_year_price,
        ROUND(((avg_price - prev_year_price) / prev_year_price * 100)::NUMERIC, 2) AS yoy_growth
    FROM with_lag
    WHERE prev_year_price IS NOT NULL
)
SELECT
    product_name,
    ROUND(AVG(yoy_growth)::NUMERIC, 2) AS avg_yoy_growth
FROM with_growth
GROUP BY product_name
ORDER BY avg_yoy_growth ASC
