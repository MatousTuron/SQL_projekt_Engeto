# Projekt z SQL: Dostupnost potravin v ČR

## Úvod

Tento projekt vznikl jako analytický podklad pro tiskové oddělení nezávislé společnosti zabývající se životní úrovní občanů. Cílem bylo zodpovědět pět výzkumných otázek týkajících se dostupnosti základních potravin v České republice v letech 2006–2018, a to na základě dat o průměrných mzdách a cenách potravin.

Jako dodatečný materiál byla připravena tabulka s makroekonomickými ukazateli (HDP, GINI koeficient, populace) pro evropské státy ve stejném období.

---

## Výstupní tabulky

### `t_matous_turon_project_SQL_primary_final`
Primární datový podklad. Obsahuje průměrné mzdy, ceny vybraných potravin a jejich meziroční růst (YoY) za období 2006–2018 pro Českou republiku. Data mezd a cen jsou sjednocena na totožné porovnatelné období.

**Sloupce:**
| Sloupec | Popis |
|---|---|
| `year` | rok měření |
| `product_name` | název kategorie potraviny |
| `avg_price` | průměrná cena potraviny v daném roce (Kč) |
| `yoy_price_growth` | meziroční růst ceny v % |
| `avg_wage` | průměrná hrubá mzda v daném roce (Kč) |
| `yoy_wage_growth` | meziroční růst mzdy v % |
| `gdp` | HDP v daném roce (Kč) |
| `yoy_gdp_growth` | meziroční růst HDP v % |
| `industry_branch_name` | název ekonomického odvětví |
| `industry_avg_wage` | průměrná hrubá mzda v odvětví v daném roce (Kč) |
| `industry_yoy_wage_growth` | meziroční růst mzdy v odvětví v % |

### `t_matous_turon_project_SQL_secondary_final`
Dodatečný přehled makroekonomických ukazatelů evropských států za období 2006–2018.

**Sloupce:**
| Sloupec | Popis |
|---|---|
| `country` | název státu |
| `year` | rok |
| `gdp` | hrubý domácí produkt (USD) |
| `gini` | GINI koeficient |
| `population` | počet obyvatel |

---

## Výzkumné otázky a odpovědi

### 1. Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
Ve všech sledovaných odvětvích mzdy v období 2006–2018 rostly. Nejvyšší procentuální růst byl zaznamenán ve zdravotní a sociální péči, nejnižší pak v peněžnictví a pojišťovnictví.

### 2. Kolik litrů mléka a kilogramů chleba bylo možné koupit za průměrnou mzdu v prvním a posledním srovnatelném období?
Srovnání bylo provedeno mezi lety 2007 a 2018. Výpočet vychází z průměrné mzdy v daném odvětví a průměrné ceny potraviny v daném období — výsledkem je počet kusů (litrů/kilogramů) které si průměrný zaměstnanec mohl pořídit.
Nejvyšší cifru mezi výsledky představují litry mléka, které si mohli v roce 2018 za svou mzdu zakoupit pracovníci v informačních a komunikačních technologiích - 2.862l mléka.
Naopak nejnižší výsledek představují kilogramy chleba, které za svou mzdu dostali v roce 2007 lidé pracující v ubytování, stravování a pohostinství - 656kg chleba.

### 3. Která kategorie potravin zdražuje nejpomaleji?
Na základě průměrného meziročního růstu cen (YoY) napříč všemi kategoriemi potravin v období 2006–2018 byly identifikovány kategorie s poklesem ceny:
největší meziroční pokles zaznamenal cukr krystalový, zlevnila však i rajská jablka červená kulatá.
Nejmenší nárůst ceny zaznamenaly banány žluté, největší naopak papriky.

### 4. Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (více než 10 %)?
Byl spočítán rozdíl mezi meziročním růstem průměrných cen potravin a meziročním růstem průměrných mezd pro každý rok.
Růst cen potravin převyšoval růst mezd v polovině případů, nikdy však ne více než o 7.5%. 

### 5. Má výška HDP vliv na změny ve mzdách a cenách potravin?
Byl porovnán meziroční růst HDP s růstem mezd a cen potravin ve stejném i následujícím roce, aby bylo možné posoudit případné zpožděné efekty.
Bylo zjištěno, že růst HDP koreluje s růstem mezd a potravin cca ve 2 ze 3 případů. 
Nějakou souvislost tedy lze připustit, ale pro vyvození validních závěrů by byla žádoucí širší analýza s více daty.

---

## Poznámky k datům

- Veškerá analytika čerpá z tabulek `t_matous_turon_project_sql_primary_final` a `t_matous_turon_project_sql_secondary_final`.
- Zdrojová data mezd jsou filtrována na průměrnou mzdu (`value_type_code = 5958`) a přepočtené úvazky (`calculation_code = 200`).
- U GINI koeficientu v `t_matous_turon_project_sql_secondary_final` chybí hodnoty pro některé státy a roky — chybějící hodnoty zůstávají jako `NULL`.
- Průměrné mzdy jsou počítány jako průměr přes všechna odvětví s výjimkou otázek č. 1 a č. 2, kde jsou uvedeny hodnoty za jednotlivá odvětví.
- Data pokrývají období 2006–2018. Vzhledem k výpočtu meziročních změn pomocí LAG začínají analytické výsledky od roku 2007.

---

## Použité technologie

- PostgreSQL
- DBeaver
