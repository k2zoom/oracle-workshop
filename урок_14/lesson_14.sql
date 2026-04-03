-- Города с нумерацией по убыванию населения
SELECT 
    ROW_NUMBER() OVER (ORDER BY population DESC) AS rank_num,
    city_name,
    country_id,
    population
FROM cities
WHERE population > 1000000
FETCH FIRST 10 ROWS ONLY;


SELECT 
    city_name,
    country_id,
    population,
    ROW_NUMBER() OVER (ORDER BY population DESC) AS row_num,
    RANK() OVER (ORDER BY population DESC) AS rank_pos,
    DENSE_RANK() OVER (ORDER BY population DESC) AS dense_rank_pos
FROM cities
WHERE country_id IN ('RU', 'US', 'CN')
ORDER BY population DESC;


-- Топ-3 города по населению в каждой стране
SELECT 
    country_id,
    city_name,
    population,
    ROW_NUMBER() OVER (PARTITION BY country_id ORDER BY population DESC) AS city_rank_in_country
FROM cities
WHERE population IS NOT NULL
ORDER BY country_id, city_rank_in_country;


-- Сравнение населения города с предыдущим и следующим в той же стране
SELECT 
    country_id,
    city_name,
    population,
    LAG(population, 1) OVER (PARTITION BY country_id ORDER BY population DESC) AS prev_population,
    LEAD(population, 1) OVER (PARTITION BY country_id ORDER BY population DESC) AS next_population,
    CASE 
        WHEN LAG(population, 1) OVER (PARTITION BY country_id ORDER BY population DESC) IS NOT NULL
        THEN ROUND((population - LAG(population, 1) OVER (PARTITION BY country_id ORDER BY population DESC)) / 
                   LAG(population, 1) OVER (PARTITION BY country_id ORDER BY population DESC) * 100, 2)
        ELSE NULL
    END AS pct_diff_from_prev
FROM cities
WHERE country_id IN ('RU', 'US', 'CN')
ORDER BY country_id, population DESC;

-- Для каждой страны: самый большой и самый маленький город
SELECT DISTINCT
    country_id,
    FIRST_VALUE(city_name) OVER (PARTITION BY country_id ORDER BY population DESC 
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS largest_city,
    FIRST_VALUE(population) OVER (PARTITION BY country_id ORDER BY population DESC 
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS largest_population,
    LAST_VALUE(city_name) OVER (PARTITION BY country_id ORDER BY population DESC 
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS smallest_city,
    LAST_VALUE(population) OVER (PARTITION BY country_id ORDER BY population DESC 
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS smallest_population
FROM cities
WHERE population IS NOT NULL
ORDER BY country_id;




-- Накопительная сумма населения по городам России (от большего к меньшему)
SELECT 
    city_name,
    population,
    SUM(population) OVER (ORDER BY population DESC) AS running_total,
    ROUND(SUM(population) OVER (ORDER BY population DESC) * 100.0 / 
          SUM(population) OVER (), 2) AS cumulative_percent
FROM cities
WHERE country_id = 'RU' AND population IS NOT NULL
ORDER BY population DESC;



-- Скользящее среднее населения за 3 города (текущий + 2 предыдущих)
SELECT 
    city_name,
    population,
    AVG(population) OVER (ORDER BY population DESC 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_3
FROM cities
WHERE country_id = 'US' AND population IS NOT NULL;


-- Разбить города на 4 группы (квартили) по населению
SELECT 
    city_name,
    country_id,
    population,
    NTILE(4) OVER (ORDER BY population DESC) AS quartile,
    CASE NTILE(4) OVER (ORDER BY population DESC)
        WHEN 1 THEN 'Крупнейшие'
        WHEN 2 THEN 'Крупные'
        WHEN 3 THEN 'Средние'
        WHEN 4 THEN 'Небольшие'
    END AS size_category
FROM cities
WHERE population IS NOT NULL
ORDER BY population DESC;



--Сравнение температуры города со средней по стране
WITH city_weather AS (
    SELECT 
        wd.city_name,
        c.country_id,
        wd.temp_c,
        wd.created_date
    FROM weather_data wd
    JOIN cities c ON wd.city_name = c.city_name
    WHERE wd.created_date >= SYSDATE - 7
),
country_avg AS (
    SELECT 
        country_id,
        AVG(temp_c) AS avg_country_temp
    FROM city_weather
    GROUP BY country_id
)
SELECT 
    cw.city_name,
    cw.temp_c,
    ca.avg_country_temp,
    ROUND(cw.temp_c - ca.avg_country_temp, 2) AS temp_diff,
    CASE 
        WHEN cw.temp_c > ca.avg_country_temp THEN 'Теплее среднего'
        WHEN cw.temp_c < ca.avg_country_temp THEN 'Холоднее среднего'
        ELSE 'Как в среднем'
    END AS comparison
FROM city_weather cw
JOIN country_avg ca ON cw.country_id = ca.country_id
ORDER BY temp_diff DESC;

--Ранжирование городов по температуре в каждой стране
SELECT 
    c.country_id,
    c.city_name,
    wd.temp_c,
    ROW_NUMBER() OVER (PARTITION BY c.country_id ORDER BY wd.temp_c DESC) AS hottest_rank,
    RANK() OVER (PARTITION BY c.country_id ORDER BY wd.temp_c) AS coldest_rank
FROM weather_data wd
JOIN cities c ON wd.city_name = c.city_name
WHERE wd.created_date = (SELECT MAX(created_date) FROM weather_data)
ORDER BY c.country_id, wd.temp_c DESC;

--Изменение температуры (LAG) для каждого города
SELECT 
    city_name,
    created_date,
    temp_c,
    LAG(temp_c, 1) OVER (PARTITION BY city_name ORDER BY created_date) AS prev_temp,
    temp_c - LAG(temp_c, 1) OVER (PARTITION BY city_name ORDER BY created_date) AS temp_change
FROM weather_data
WHERE city_name IN ('Moscow', 'London', 'New York')
ORDER BY city_name, created_date DESC;

