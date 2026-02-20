-- Самый частый JOIN: заказы с информацией о посетителях и официантах
SELECT 
    o.id AS order_id,
    v.first_name || ' ' || v.last_name AS visitor,
    w.first_name || ' ' || w.last_name AS waiter,
    TO_CHAR(o.order_time, 'DD.MM.YYYY HH24:MI') AS order_time,
    o.total_amount
FROM orders o
INNER JOIN visitors v ON o.visitor_id = v.id
INNER JOIN waiters w ON o.waiter_id = w.id
ORDER BY o.order_time DESC;


-- Все посетители и их бронирования (даже если бронирований нет)
SELECT 
    v.id,
    v.first_name || ' ' || v.last_name AS visitor_name,
    v.phone,
    r.table_number,
    TO_CHAR(r.reservation_time, 'DD.MM.YYYY HH24:MI') AS reservation_time,
    NVL(r.guests_count, 0) AS guests_count,
    NVL(r.status, 'no reservation') AS status
FROM visitors v
LEFT JOIN reservations r ON v.id = r.visitor_id
ORDER BY v.id;



-- Все бронирования и информация о посетителях (даже если данные посетителя неполные)
SELECT 
    r.id AS reservation_id,
    r.table_number,
    TO_CHAR(r.reservation_time, 'DD.MM.YYYY HH24:MI') AS reservation_time,
    v.first_name || ' ' || v.last_name AS visitor_name,
    v.phone,
    v.email
FROM visitors v
RIGHT JOIN reservations r ON v.id = r.visitor_id;



-- Все посетители и все бронирования (полная картина)
SELECT 
    NVL(TO_CHAR(v.id), 'НЕТ') AS visitor_id,
    NVL(v.first_name || ' ' || v.last_name, 'нет посетителя') AS visitor_name,
    NVL(TO_CHAR(r.id), 'НЕТ') AS reservation_id,
    NVL(TO_CHAR(r.table_number), 'не указан') AS table_number,
    NVL(TO_CHAR(r.reservation_time, 'DD.MM'), 'нет брони') AS reservation_date
FROM visitors v
FULL OUTER JOIN reservations r ON v.id = r.visitor_id
ORDER BY v.id NULLS LAST;


-- Все возможные комбинации категорий и ингредиентов (аналитический запрос)
--CROSS JOIN
SELECT 
    c.name AS category_name,
    i.name AS ingredient_name,
    'Возможно использовать' AS note
FROM categories c
CROSS JOIN ingredients i
WHERE c.id IN (1, 2) -- Ограничим для наглядности
ORDER BY c.name, i.name;



-- "Соседние" блюда по цене (для анализа меню)
--SELF JOIN 
SELECT 
    d1.name AS dish_1,
    d1.price AS price_1,
    d2.name AS dish_2,
    d2.price AS price_2,
    ROUND(ABS(d1.price - d2.price), 2) AS price_difference
FROM dishes d1
JOIN dishes d2 ON d1.id < d2.id -- исключаем дубли и само-сравнения
WHERE d1.category_id = d2.category_id -- в одной категории
ORDER BY d1.category_id, price_difference;


-- Статистика по заказам с разбивкой по времени суток
SELECT 
    CASE 
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 6 AND 11 THEN 'Утро (6-11)'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 12 AND 16 THEN 'День (12-16)'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 17 AND 21 THEN 'Вечер (17-21)'
        ELSE 'Ночь (22-5)'
    END AS day_part,
    COUNT(*) AS orders_count,
    SUM(total_amount) AS total_revenue,
    ROUND(AVG(total_amount), 2) AS avg_check,
    MIN(total_amount) AS min_check,
    MAX(total_amount) AS max_check
FROM orders
GROUP BY 
    CASE 
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 6 AND 11 THEN 'Утро (6-11)'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 12 AND 16 THEN 'День (12-16)'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 17 AND 21 THEN 'Вечер (17-21)'
        ELSE 'Ночь (22-5)'
    END
ORDER BY day_part;


-- Сводка по статусам заказов для каждого официанта
SELECT 
    w.first_name || ' ' || w.last_name AS waiter_name,
    COUNT(*) AS total_orders,
    COUNT(CASE WHEN o.status = 'new' THEN 1 END) AS new_orders,
    COUNT(CASE WHEN o.status = 'served' THEN 1 END) AS served_orders,
    COUNT(CASE WHEN o.status = 'paid' THEN 1 END) AS paid_orders,
    COUNT(CASE WHEN o.status = 'cancelled' THEN 1 END) AS cancelled_orders,
    ROUND(AVG(CASE WHEN o.status = 'paid' THEN o.total_amount END), 2) AS avg_paid_check
FROM waiters w
LEFT JOIN orders o ON w.id = o.waiter_id
GROUP BY w.id, w.first_name, w.last_name
ORDER BY waiter_name;


-- Полный анализ эффективности меню
SELECT 
    c.name AS category,
    d.name AS dish_name,
    d.price,
    COUNT(oi.dish_id) AS times_ordered,
    SUM(oi.quantity) AS total_units_sold,
    SUM(oi.quantity * oi.price_at_moment) AS revenue,
    ROUND(AVG(oi.quantity * oi.price_at_moment), 2) AS avg_revenue_per_order,
    CASE 
        WHEN SUM(oi.quantity * oi.price_at_moment) > 5000 THEN 'ХИТ'
        WHEN SUM(oi.quantity * oi.price_at_moment) > 2000 THEN 'Популярное'
        WHEN SUM(oi.quantity * oi.price_at_moment) > 500 THEN 'Среднее'
        WHEN COUNT(oi.dish_id) = 0 THEN 'Не заказывали'
        ELSE 'Низкий спрос'
    END AS popularity,
    CASE 
        WHEN COUNT(oi.dish_id) = 0 THEN 'Включить в акцию'
        WHEN AVG(oi.quantity * oi.price_at_moment) > d.price * 2 THEN 'Рекомендовать как дополнение'
        ELSE 'Стандартная позиция'
    END AS recommendation
FROM dishes d
LEFT JOIN categories c ON d.category_id = c.id
LEFT JOIN order_items oi ON d.id = oi.dish_id
GROUP BY c.id, c.name, d.id, d.name, d.price
ORDER BY revenue DESC NULLS LAST;



-- Массовое обновление цен с использованием CASE
UPDATE dishes
SET price = CASE 
    WHEN category_id IN (4, 8) AND price < 1000 THEN price * 1.1 -- Основные блюда и алкоголь +10%
    WHEN category_id IN (6, 7) AND price < 500 THEN price * 0.95 -- Десерты и напитки -5% для привлечения
    WHEN category_id = 2 AND calories < 300 THEN price * 1.05 -- Легкие салаты +5%
    ELSE price
END
WHERE id > 0; -- Будьте осторожны с UPDATE!
-- ROLLBACK; -- Не забудьте откатить, если это просто демо!