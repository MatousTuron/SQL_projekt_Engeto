# Projekt z SQL: Dostupnost potravin v ČR

## Úvod

Tento projekt vznikl jako analytický podklad pro tiskové oddělení nezávislé společnosti zabývající se životní úrovní občanů. Cílem bylo zodpovědět pět výzkumných otázek týkajících se dostupnosti základních potravin v České republice v letech 2006–2018, a to na základě dat o průměrných mzdách a cenách potravin.

Jako dodatečný materiál byla připravena tabulka s makroekonomickými ukazateli (HDP, GINI koeficient, populace) pro evropské státy ve stejném období.

---

## Výstupní tabulky

### `t_matous_turon_project_SQL_primary_final`
Primární datový podklad. Obsahuje průměrné mzdy, ceny vybraných potravin (chléb konzumní kmínový, mléko polotučné pasterované) a jejich meziroční růst (YoY) za období 2006–2018 pro Českou republiku. Data mezd a cen jsou sjednocena na totožné porovnatelné období.

**Sloupce:**
| Sloupec | Popis |
|---|---|
| `year` | rok měření |
| `product_name` | název kategorie potraviny |
| `avg_price` | průměrná cena potraviny v daném roce (Kč) |
| `yoy_price_growth` | meziroční růst ceny v % |
| `avg_wage` | průměrná hrubá mzda v daném roce (Kč) |
| `yoy_wage_growth` | meziroční růst mzdy v % |

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
Srovnání bylo provedeno mezi lety 2006 a 2018. Výpočet vychází z průměrné mzdy v daném odvětví a průměrné ceny potraviny v daném období — výsledkem je počet kusů (litrů/kilogramů) které si průměrný zaměstnanec mohl pořídit.
Nejvyšší cifru mezi výsledky představují litry mléka, které si mohli v roce 2018 za svou mzdu zakoupit pracovníci v informačních a komunikačních technologiích - 2.862l mléka.
Naopak nejnižší výsledek představují kilogramy chleba, které za svou mzdu dostali v roce 2006 lidé pracující v ubytování, stravování a pohostinství - 724kg chleba.

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

- Data mezd pocházejí z tabulky `czechia_payroll`, filtrováno na `value_type_code = 5958` (průměrná mzda) a `calculation_code = 200` (přepočtené úvazky).
- Data cen pocházejí z tabulky `czechia_price`.
- HDP data pocházejí z tabulky `economies`, filtrováno na Českou republiku a evropské státy.
- U GINI koeficientu v tabulce `t_matous_turon_project_SQL_secondary_final` chybí hodnoty pro některé státy a roky — data nebyla doplňována, chybějící hodnoty zůstávají jako `NULL`.
- Průměrné mzdy jsou počítány jako průměr přes všechna odvětví s výjimkou otázky č. 1 a č. 2, kde jsou uvedeny hodnoty za jednotlivá odvětví.

---

## Použité technologie

- PostgreSQL
- DBeaver
