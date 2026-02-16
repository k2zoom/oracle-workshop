-- Условие: Найти все блюда дешевле 300 рублей
SELECT name, price 
FROM dishes 
WHERE price < 300;


-- Условие: Найти посетителей без карты лояльности
SELECT first_name, last_name, phone 
FROM visitors 
WHERE loyalty_card IS NULL;

--Условие: Найти посетителей с картами лояльности
SELECT first_name, last_name, phone 
FROM visitors 
WHERE loyalty_card IS NOT NULL;

-- Условие: Найти блюда из категорий 1, 3, 5 (Закуски, Супы, Гарниры)
SELECT name, category_id, price 
FROM dishes 
WHERE category_id IN (1, 3, 5);


--Условие: Найти посетителей, у которых есть бронирования
SELECT first_name, last_name 
FROM visitors v
WHERE EXISTS (
    SELECT 1 FROM reservations r 
    WHERE r.visitor_id = v.id
);


-- Условие: Найти блюда, в названии которых есть "суп"
SELECT name, description 
FROM dishes 
WHERE LOWER(name) LIKE '%суп%'; --LOWER перевод в нижний регистр Суп - суп.'Суп морковный', 'морковный суп с креветками' Тыквенный суп-пюре


-- Условие: Вывести блюда, отсортированные по категории и цене (по убыванию)
SELECT category_id, name, price 
FROM dishes 
ORDER BY category_id,price DESC;


-- Условие: Найти 5 самых дорогих блюд
SELECT name, price 
FROM dishes 
ORDER BY price DESC 
FETCH FIRST 5 ROWS ONLY;


-- Условие: Показать 3 самых новых посетителей (по дате регистрации)
SELECT first_name, last_name, registered_at 
FROM visitors 
ORDER BY registered_at DESC --Самые новые записи вверху
FETCH FIRST 3 ROWS ONLY;


-- Условие: Найти блюдо, которое заказывали чаще всего
SELECT 	dish_id, 
		COUNT(*) as order_count  --Посчитать кол-во записей
FROM order_items 
GROUP BY dish_id --Все колонки которые которые не участвуют в аггрегации должны быть в GROUP BY
ORDER BY order_count DESC 
FETCH FIRST 1 ROWS ONLY;


SELECT * FROM dishes

SELECT category_id,
		count(*) AS cnt_all 
FROM dishes
GROUP BY category_id 
ORDER BY category_id;


-- Условие: Посчитать количество блюд в каждой категории
SELECT category_id, COUNT(*) as dish_count 
FROM dishes 
GROUP BY category_id 
ORDER BY dish_count DESC;


--Аггрегационные функции
-- Условие: Найти среднюю цену и общую сумму всех блюд, минимальную и максимальную цену блюда.
--А так же количество блюд
SELECT 
    ROUND(AVG(price),2) as avg_price, --Средняя
    SUM(price) as total_price_sum, --Суммирование
    MIN(price) as min_price, --Минимальное
    MAX(price) as max_price, --Максимальное
    COUNT(*) as dish_count --Кол-во
FROM dishes;


SELECT 
    CONCAT('avg_price: ',
    ROUND(AVG(price),2))
FROM dishes;


CONCAT(Value_1,VALUE_2)


-- Условие: Найти категории, где средняя цена выше 500 рублей
SELECT 
    category_id,
    AVG(price) as avg_price
FROM dishes 
GROUP BY category_id
HAVING AVG(price) >= 500;
--Фильтрация после группировки


--Работа с датами
-- Условие: Найти заказы, сделанные в марте 2025 года
SELECT id, order_time, total_amount 
FROM orders 
WHERE order_time BETWEEN 
    TO_TIMESTAMP('2025-03-01 00:00:00', 'YYYY-MM-DD HH24:MI:SS') --YYYY - год в формате 2025, HH24-24 часовой формат времени
    AND TO_TIMESTAMP('2025-03-31 23:59:59', 'YYYY-MM-DD HH24:MI:SS');

-- Условие: Показать количество заказов по часам
SELECT 
    EXTRACT(MONTH FROM order_time) as hour_of_day, --EXTRACT извлечение времени
    COUNT(*) as order_count --все записи
FROM orders 
GROUP BY EXTRACT(HOUR FROM order_time)
ORDER BY hour_of_day;


-- Условие: Показать количество заказов по дням
SELECT 
    TRUNC(order_time) as order_date, --TRUNC обрезать, дата останется, обрежем время
    COUNT(*) as order_count,
    SUM(total_amount) as daily_revenue --сумма выручки
FROM orders 
GROUP BY TRUNC(order_time)
ORDER BY order_date DESC;


-- Условие: Найти заказы за последние 7 дней, с текущей даты
SELECT id, order_time, total_amount 
FROM orders 
WHERE order_time >= SYSDATE - 7; --SYSDATE выводит текущее время и дату

SELECT SYSDATE FROM dual

2026-02-16 16:51:10.000
UTC +0
UTC +3


