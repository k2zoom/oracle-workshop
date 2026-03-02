-- Без CHECK OPTION можно "потерять" запись
CREATE VIEW v_expensive AS
SELECT * FROM products WHERE price > 1000;

UPDATE v_expensive SET price = 500 WHERE id = 1;  -- Запись "исчезнет" из VIEW

-- С CHECK OPTION такие изменения запрещены
CREATE VIEW v_expensive_safe AS
SELECT * FROM products WHERE price > 1000
WITH CHECK OPTION;

UPDATE v_expensive_safe SET price = 500 WHERE id = 1;  -- Ошибка!



-- Тяжелый запрос, который выполняется долго
SELECT 
    TRUNC(o.order_time) as day,
    c.name as category,
    COUNT(*) as orders,
    SUM(oi.quantity) as items_sold,
    SUM(o.total_amount) as revenue
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
JOIN dishes d ON oi.dish_id = d.id
JOIN categories c ON d.category_id = c.id
GROUP BY TRUNC(o.order_time), c.name;

-- Создаем MATERIALIZED VIEW (Oracle)
CREATE MATERIALIZED VIEW mv_daily_sales
REFRESH COMPLETE ON DEMAND
AS
SELECT ... -- тот же запрос

-- Обновляем раз в день
EXEC DBMS_MVIEW.REFRESH('mv_daily_sales');


--Примеры вью
CREATE VIEW v_active_menu AS
SELECT 
    d.id,
    d.name AS dish_name,
    c.name AS category_name,
    d.price,
    d.weight_grams,
    d.calories,
    d.preparation_time_minutes
FROM dishes d
JOIN categories c ON d.category_id = c.id
WHERE d.is_available = 1;

--детали заказов
CREATE VIEW v_order_details AS
SELECT 
    o.id AS order_id,
    o.order_time,
    o.table_number,
    o.status AS order_status,
    o.total_amount,
    v.first_name || ' ' || v.last_name AS customer_name,
    v.phone AS customer_phone,
    w.first_name || ' ' || w.last_name AS waiter_name
FROM orders o
LEFT JOIN visitors v ON o.visitor_id = v.id
LEFT JOIN waiters w ON o.waiter_id = w.id;


--Выручка по дням
CREATE VIEW v_daily_revenue AS
SELECT 
    TRUNC(order_time) AS order_date,
    COUNT(*) AS orders_count,
    SUM(total_amount) AS total_revenue,
    AVG(total_amount) AS avg_order_value
FROM orders
WHERE status IN ('paid', 'served')
GROUP BY TRUNC(order_time);


--Популярность блюд
CREATE VIEW v_dish_popularity AS
SELECT 
    d.id,
    d.name AS dish_name,
    c.name AS category_name,
    d.price,
    COUNT(oi.id) AS times_ordered,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.quantity * oi.price_at_moment) AS total_revenue
FROM dishes d
JOIN categories c ON d.category_id = c.id
LEFT JOIN order_items oi ON d.id = oi.dish_id
GROUP BY d.id, d.name, c.name, d.price;

--Активные бронирования
CREATE VIEW v_active_reservations AS
SELECT 
    r.id AS reservation_id,
    r.reservation_time,
    r.table_number,
    r.guests_count,
    v.first_name || ' ' || v.last_name AS customer_name,
    v.phone AS customer_phone
FROM reservations r
JOIN visitors v ON r.visitor_id = v.id
WHERE r.status = 'confirmed'
AND r.reservation_time > CURRENT_TIMESTAMP;


--Состав блюд с ингридеентами
CREATE VIEW v_dish_ingredients_full AS
SELECT 
    d.id AS dish_id,
    d.name AS dish_name,
    i.name AS ingredient_name,
    di.quantity_required,
    i.unit,
    i.stock_quantity
FROM dishes d
JOIN dish_ingredients di ON d.id = di.dish_id
JOIN ingredients i ON di.ingredient_id = i.id;


--Эффективность оффициантов 
CREATE VIEW v_waiter_performance AS
SELECT 
    w.id,
    w.first_name || ' ' || w.last_name AS waiter_name,
    COUNT(o.id) AS orders_served,
    SUM(o.total_amount) AS total_revenue,
    AVG(o.total_amount) AS avg_order_value,
    MAX(o.total_amount) AS max_order_value
FROM waiters w
LEFT JOIN orders o ON w.id = o.waiter_id AND o.status IN ('paid', 'served')
GROUP BY w.id, w.first_name, w.last_name;