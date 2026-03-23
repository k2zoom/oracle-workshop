-- 1. Включение автоподсветки плана (в SQLcl или SQL*Plus)
SET AUTOTRACE ON EXPLAIN;

-- 2. Простой запрос без индекса
SELECT * FROM cities WHERE population > 5000000;

-- 3. Использование EXPLAIN PLAN
EXPLAIN PLAN FOR 
SELECT * FROM cities WHERE country_id = 'RU';

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- 4. Составное условие
EXPLAIN PLAN FOR 
SELECT * FROM cities 
WHERE country_id = 'US' AND population > 1000000 AND importance > 7;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- 5. Сортировка с LIMIT (Oracle использует ROWNUM или FETCH FIRST)
EXPLAIN PLAN FOR 
SELECT * FROM cities 
ORDER BY population DESC 
FETCH FIRST 10 ROWS ONLY;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- Отключить AUTOTRACE
SET AUTOTRACE OFF;
Задание для участников: Объяснить разницу между TABLE ACCESS FULL и TABLE ACCESS BY INDEX ROWID.


-- 1. Стандартный B-Tree индекс
CREATE INDEX idx_cities_population ON cities(population);

-- 2. Bitmap индекс (для низкой кардинальности)
CREATE BITMAP INDEX idx_cities_is_capital ON cities(is_capital);
CREATE BITMAP INDEX idx_cities_importance ON cities(importance);

-- 3. Function-Based индекс (регистронезависимый поиск)
CREATE INDEX idx_cities_name_upper ON cities(UPPER(city_name));

-- Проверка: теперь этот запрос использует индекс
SELECT * FROM cities WHERE UPPER(city_name) = 'MOSCOW';

-- 4. Reverse Key индекс (для последовательных ID)
CREATE INDEX idx_cities_reverse ON cities(city_id) REVERSE;

-- 5. Невидимый индекс (для тестирования)
CREATE INDEX idx_cities_test ON cities(population) INVISIBLE;

-- Проверить, используется ли индекс
SELECT index_name, visibility FROM user_indexes WHERE index_name = 'IDX_CITIES_TEST';

-- Сделать видимым
ALTER INDEX idx_cities_test VISIBLE;


-- Создаем составной индекс
CREATE INDEX idx_cities_composite 
ON cities(country_id, importance, population);

-- 1. Запрос с полным префиксом
EXPLAIN PLAN FOR
SELECT * FROM cities 
WHERE country_id = 'US' AND importance >= 8 AND population > 5000000;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
-- Должен быть INDEX RANGE SCAN

-- 2. Запрос с частичным префиксом
EXPLAIN PLAN FOR
SELECT * FROM cities 
WHERE country_id = 'US' AND importance >= 8;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
-- Тоже INDEX RANGE SCAN


-- INSERT с APPEND hint (прямая загрузка)
INSERT /*+ APPEND */ INTO cities_backup
SELECT * FROM cities;

-- SQL*Loader с direct path
-- sqlldr user/pass control=loader.ctl direct=true

-- CTAS с NOLOGGING
CREATE TABLE cities_new NOLOGGING AS
SELECT * FROM cities WHERE population > 1000000;