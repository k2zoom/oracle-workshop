--Логический синтаксис
SELECT - выбор аттрибутов
FROM - выбор источника
JOIN -условие сооеденения
WHERE - условие фильтрации 
GROUP BY -условие группировки
HAVING -фильтрация после группировки
ORDER BY -сортировка
LIMIT -ограничение по стокам


SELECT DISTINCT column1, AGG(column2)
FROM table1
JOIN table2 ON condition
WHERE condition
GROUP BY column1
HAVING condition
ORDER BY column1
LIMIT n;

--Физическое выполнение внутри БД
1. FROM / JOIN     -- Создание рабочего набора данных (всех возможных комбинаций)
2. WHERE           -- Фильтрация строк (еще до группировки)
3. GROUP BY        -- Группировка строк
4. HAVING          -- Фильтрация групп
5. SELECT          -- Вычисление выражений и выбор столбцов
6. DISTINCT        -- Удаление дубликатов
7. ORDER BY        -- Сортировка
8. LIMIT / OFFSET / FETCH  -- Ограничение вывода

--Как можно увидить план запроса
EXPLAIN PLAN FOR
SELECT * FROM orders o
JOIN order_items oi ON o.id = oi.order_id;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);


WHERE
Нельзя использовать агрегатные функции в WHERE
WHERE SUM(oi.quantity) > 5 


GROUP BY
Важное правило группировки 
Все колонки в SELECT, не участвующие в агрегации, должны быть в GROUP BY

Having
Отбрасываются группы, не удовлетворяющие условиям.
HAVING выполняется ПОСЛЕ группировки, поэтому можно использовать агрегаты.

Отличие WHERE/HAVING

WHERE	                               HAVING
Фильтрует строки ДО группировки	    Фильтрует группы ПОСЛЕ группировки
Нельзя использовать агрегаты	    Можно использовать агрегаты
Применяется к каждой строке	        Применяется к каждой группе

SELECT 
На этом этапе:
Выбираются указанные колонки
Вычисляются выражения
Создаются псевдонимы (алиасы)

Конкретно про оракл - 
Псевдонимы, созданные в SELECT, НЕЛЬЗЯ использовать в WHERE, GROUP BY, HAVING:
Пример:

SELECT 
    d.category_id,
    COUNT(*) as dishes_count,
    ROUND(AVG(d.price), 2) as avg_price,
    d.price * 1.2 as price_with_vat


DISTINCT 
Удаляются полностью дублирующиеся строки из результата.

--Два примера, схожий результат будет
SELECT DISTINCT category_id FROM dishes;
SELECT category_id FROM dishes GROUP BY category_id;

ORDER BY 
Сортировка результирующего набора по указанным колонкам.
ASC — по возрастанию (по умолчанию)
DESC — по убыванию
--Для оракла
NULLS FIRST / NULLS LAST — как обрабатывать NULL


LIMIT/OFFSET/FETCH
Обрезается результирующий набор до указанного количества строк.
Пример для оракла - 
FETCH FIRST 10 ROWS ONLY;
FETCH NEXT 10 ROWS ONLY;
OFFSET 20 ROWS FETCH NEXT 10 ROWS ONLY;

OFFSET N ROWS — пропустить первые N строк
FETCH NEXT M ROWS ONLY — взять следующие M строк
FETCH FIRST M ROWS ONLY — взять первые M строк (то же что OFFSET 0)


SELECT * FROM dishes
ORDER BY price DESC
OFFSET 10 ROWS FETCH NEXT 5 ROWS ONLY;
-- Сначала отсортировали, потом взяли 5 строк, пропустив первые 10

Posgresql- 
LIMIT 10;
LIMIT 5 OFFSET 10;


