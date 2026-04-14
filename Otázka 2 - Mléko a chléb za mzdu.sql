SELECT *
FROM czechia_payroll cp 

SELECT *
FROM czechia_payroll_calculation cpc 

SELECT *
FROM czechia_payroll_industry_branch cpib 

SELECT *
FROM czechia_payroll_unit cpu 

SELECT *
FROM czechia_payroll_value_type cpvt 

SELECT *
FROM czechia_price cp 

SELECT *
FROM czechia_price_category cpc 


SELECT *
FROM czechia_region cr 

SELECT *
FROM czechia_district cd 


SELECT *
FROM countries c 

SELECT *
FROM economies e 


--Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

--Roky 2006-2018???

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
ORDER BY cpc.name asc


