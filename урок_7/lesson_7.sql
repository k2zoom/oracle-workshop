--Задача: Получить список всех имен из таблиц посетителей и официантов.
SELECT first_name, last_name, 'Посетитель' AS source
FROM visitors
UNION
SELECT first_name, last_name, 'Официант' AS source
FROM waiters
ORDER BY last_name, first_name;

--Задача: Показать все дни, когда были заказы или бронирования (с возможными дубликатами).
SELECT TRUNC(order_time) AS event_date, 'Заказ' AS event_type
FROM orders
UNION ALL
SELECT TRUNC(reservation_time) AS event_date, 'Бронирование' AS event_type
FROM reservations
ORDER BY event_date;

--Задача: Получить общий список всех объектов с их идентификаторами и названиями.
SELECT 
    id,
    name AS item_name,
    'Блюдо' AS item_type,
    price AS value,
    NULL AS quantity
FROM dishes
UNION ALL
SELECT 
    id,
    name AS item_name,
    'Ингредиент' AS item_type,
    NULL AS value,
    stock_quantity AS quantity
FROM ingredients
ORDER BY item_type, item_name;

--Задача: Получить статистику по заказам и бронированиям за каждый день.
SELECT 
    TO_CHAR(dt, 'YYYY-MM-DD') AS date,
    'Заказы' AS category,
    order_count AS count,
    order_total AS total
FROM (
    SELECT TRUNC(order_time) AS dt, 
           COUNT(*) AS order_count, 
           SUM(total_amount) AS order_total
    FROM orders
    GROUP BY TRUNC(order_time)
)
UNION ALL
SELECT 
    TO_CHAR(dt, 'YYYY-MM-DD') AS date,
    'Бронирования' AS category,
    reservation_count AS count,
    NULL AS total
FROM (
    SELECT TRUNC(reservation_time) AS dt, 
           COUNT(*) AS reservation_count
    FROM reservations
    GROUP BY TRUNC(reservation_time)
)
ORDER BY date, category;


--Задача: Найти посетителей, которые делали заказы, но не делали бронирований.

-- Вариант с MINUS
SELECT id, first_name, last_name
FROM visitors
WHERE id IN (SELECT DISTINCT visitor_id FROM orders WHERE visitor_id IS NOT NULL)
MINUS
SELECT id, first_name, last_name
FROM visitors
WHERE id IN (SELECT DISTINCT visitor_id FROM reservations);

-- Вариант с NOT EXISTS (альтернатива)
SELECT id, first_name, last_name
FROM visitors v
WHERE EXISTS (SELECT 1 FROM orders o WHERE o.visitor_id = v.id)
AND NOT EXISTS (SELECT 1 FROM reservations r WHERE r.visitor_id = v.id);

--Задача: Найти посетителей, которые и делали заказы, и делали бронирования.
SELECT id, first_name, last_name
FROM visitors
WHERE id IN (SELECT DISTINCT visitor_id FROM orders WHERE visitor_id IS NOT NULL)
INTERSECT
SELECT id, first_name, last_name
FROM visitors
WHERE id IN (SELECT DISTINCT visitor_id FROM reservations);

--Задача: Сравнить продажи текущего и прошлого месяца.
SELECT 
    'Текущий месяц' AS period,
    COUNT(*) AS orders_count,
    SUM(total_amount) AS total_revenue
FROM orders
WHERE TRUNC(order_time, 'MM') = TRUNC(SYSDATE, 'MM')
UNION ALL
SELECT 
    'Прошлый месяц' AS period,
    COUNT(*) AS orders_count,
    SUM(total_amount) AS total_revenue
FROM orders
WHERE TRUNC(order_time, 'MM') = TRUNC(ADD_MONTHS(SYSDATE, -1), 'MM');

--Задача: Получить полный список всех используемых единиц измерения.
SELECT unit AS measurement_unit, 'Ингредиенты' AS source
FROM ingredients
WHERE unit IS NOT NULL
UNION
SELECT 'шт' AS measurement_unit, 'Стандартная' AS source FROM dual
UNION
SELECT 'порц' AS measurement_unit, 'Стандартная' AS source FROM dual
ORDER BY measurement_unit;


--EXISTS 
--Задача: Найти посетителей, у которых есть заказы.
SELECT 
    v.id,
    v.first_name || ' ' || v.last_name AS full_name,
    v.phone,
    v.email
FROM visitors v
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.visitor_id = v.id
);

--Задача: Найти посетителей, у которых нет заказов.
SELECT 
    v.id,
    v.first_name || ' ' || v.last_name AS full_name,
    v.phone,
    v.email,
    v.registered_at
FROM visitors v
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.visitor_id = v.id
);

--Задача: Найти посетителей, у которых были заказы дороже 2000 рублей.
SELECT 
    v.id,
    v.first_name || ' ' || v.last_name AS full_name,
    v.loyalty_card
FROM visitors v
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.visitor_id = v.id
    AND o.total_amount > 2000
    AND o.status = 'paid'
);

--Задача: Найти блюда, которые заказывали больше 1 раза.

SELECT 
    d.id,
    d.name,
    d.price,
    c.name AS category
FROM dishes d
JOIN categories c ON d.category_id = c.id
WHERE EXISTS (
    SELECT 1
    FROM order_items oi
    WHERE oi.dish_id = d.id
    GROUP BY oi.dish_id
    HAVING SUM(oi.quantity) > 1
);

--Задача: Найти официантов, у которых есть заказы дороже среднего чека этого официанта.
SELECT 
    w.id,
    w.first_name || ' ' || w.last_name AS waiter_name,
    w.hourly_rate
FROM waiters w
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.waiter_id = w.id
    AND o.total_amount > (
        SELECT AVG(o2.total_amount)
        FROM orders o2
        WHERE o2.waiter_id = w.id
    )
);

--EXISTS в UPDATE
--Задача: Повысить ставку официантам, у которых были заказы дороже 2000.

UPDATE waiters w
SET hourly_rate = hourly_rate * 1.10
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.waiter_id = w.id
    AND o.total_amount > 2000
);

--Задача: Найти блюда из категорий, в которых есть доступные блюда.

-- Вариант с EXISTS (часто эффективнее)
SELECT c.id, c.name, c.description
FROM categories c
WHERE EXISTS (
    SELECT 1
    FROM dishes d
    WHERE d.category_id = c.id
    AND d.is_available = 1
);

-- Вариант с IN
SELECT c.id, c.name, c.description
FROM categories c
WHERE c.id IN (
    SELECT DISTINCT category_id
    FROM dishes
    WHERE is_available = 1
);



--Задача: Найти посетителей, которые одновременно и делали заказы, и делали бронирования.
SELECT visitor_id
FROM orders
WHERE visitor_id IS NOT NULL
INTERSECT
SELECT visitor_id
FROM reservations;

--Задача: Найти посетителей, у которых средний чек выше 2000 И есть карта лояльности.
SELECT visitor_id
FROM orders
WHERE visitor_id IS NOT NULL
GROUP BY visitor_id
HAVING AVG(total_amount) > 2000
INTERSECT
SELECT id
FROM visitors
WHERE loyalty_card IS NOT NULL;


--Задача: Найти посетителей, которые делали заказы, но НЕ делали бронирований.
SELECT visitor_id
FROM orders
WHERE visitor_id IS NOT NULL
MINUS
SELECT visitor_id
FROM reservations;

--Задача: Получить полные данные посетителей, которые заказывали, но не бронировали.
SELECT id, first_name, last_name, phone, email
FROM visitors
WHERE id IN (
    SELECT visitor_id FROM orders WHERE visitor_id IS NOT NULL
    MINUS
    SELECT visitor_id FROM reservations
);


