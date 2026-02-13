-- 1. Категории блюд
INSERT ALL
    INTO categories (name, description, display_order) VALUES ('Закуски', 'Холодные и горячие закуски', 1)
    INTO categories (name, description, display_order) VALUES ('Салаты', 'Свежие салаты', 2)
    INTO categories (name, description, display_order) VALUES ('Супы', 'Первые блюда', 3)
    INTO categories (name, description, display_order) VALUES ('Основные блюда', 'Горячие блюда из мяса, рыбы, птицы', 4)
    INTO categories (name, description, display_order) VALUES ('Гарниры', 'Картофель, рис, овощи', 5)
    INTO categories (name, description, display_order) VALUES ('Десерты', 'Сладкие блюда', 6)
    INTO categories (name, description, display_order) VALUES ('Напитки', 'Безалкогольные напитки', 7)
    INTO categories (name, description, display_order) VALUES ('Алкоголь', 'Вина, крепкие напитки', 8)
SELECT * FROM dual;
COMMIT;

-- 2. Блюда
INSERT ALL
    INTO dishes (category_id, name, description, price, weight_grams, calories, preparation_time_minutes) 
    VALUES (1, 'Брускетта с томатами', 'Тосты с помидорами, базиликом и оливковым маслом', 350.00, 180, 320, 10)
    INTO dishes (category_id, name, description, price, weight_grams, calories, preparation_time_minutes) 
    VALUES (1, 'Сырное ассорти', 'Три вида сыра с медом и орехами', 650.00, 200, 580, 7)
    INTO dishes (category_id, name, description, price, weight_grams, calories, preparation_time_minutes) 
    VALUES (2, 'Цезарь с курицей', 'Классический салат с курицей, пармезаном и соусом', 480.00, 250, 420, 12)
    INTO dishes (category_id, name, description, price, weight_grams, calories, preparation_time_minutes) 
    VALUES (2, 'Греческий салат', 'Овощи, сыр фета, маслины', 420.00, 280, 280, 8)
    INTO dishes (category_id, name, description, price, weight_grams, calories, preparation_time_minutes) 
    VALUES (3, 'Тыквенный суп-пюре', 'Крем-суп из тыквы со сливками', 350.00, 300, 210, 15)
    INTO dishes (category_id, name, description, price, weight_grams, calories, preparation_time_minutes) 
    VALUES (3, 'Борщ', 'Украинский борщ с пампушками', 390.00, 350, 250, 20)
    INTO dishes (category_id, name, description, price, weight_grams, calories, preparation_time_minutes) 
    VALUES (4, 'Стейк Рибай', 'Мраморная говядина на гриле', 1890.00, 300, 680, 25)
    INTO dishes (category_id, name, description, price, weight_grams, calories, preparation_time_minutes) 
    VALUES (4, 'Лосось на гриле', 'Филе лосося с овощами', 1250.00, 280, 520, 20)
    INTO dishes (category_id, name, description, price, weight_grams, calories, preparation_time_minutes) 
    VALUES (5, 'Картофель фри', 'Хрустящий картофель', 220.00, 150, 350, 12)
    INTO dishes (category_id, name, description, price, weight_grams, calories, preparation_time_minutes) 
    VALUES (5, 'Овощи гриль', 'Кабачки, перец, баклажаны', 280.00, 200, 150, 15)
    INTO dishes (category_id, name, description, price, weight_grams, calories, preparation_time_minutes) 
    VALUES (6, 'Чизкейк Нью-Йорк', 'Классический чизкейк с ягодным соусом', 380.00, 180, 450, 5)
    INTO dishes (category_id, name, description, price, weight_grams, calories, preparation_time_minutes) 
    VALUES (6, 'Тирамису', 'Итальянский десерт с маскарпоне', 390.00, 160, 410, 5)
    INTO dishes (category_id, name, description, price, weight_grams, calories, preparation_time_minutes) 
    VALUES (7, 'Морс клюквенный', 'Домашний морс', 180.00, 250, 90, 3)
    INTO dishes (category_id, name, description, price, weight_grams, calories, preparation_time_minutes) 
    VALUES (7, 'Лимонад', 'Домашний лимонад с мятой', 250.00, 300, 120, 4)
    INTO dishes (category_id, name, description, price, weight_grams, calories, preparation_time_minutes) 
    VALUES (8, 'Вино красное сухое', 'Итальянское вино, 0.75 л', 890.00, 750, 620, 2)
    INTO dishes (category_id, name, description, price, weight_grams, calories, preparation_time_minutes) 
    VALUES (8, 'Пиво светлое', 'Чешское пиво, 0.5 л', 320.00, 500, 210, 1)
SELECT * FROM dual;
COMMIT;

-- 3. Ингредиенты
INSERT ALL
    INTO ingredients (name, unit, stock_quantity) VALUES ('Куриное филе', 'кг', 15.5)
    INTO ingredients (name, unit, stock_quantity) VALUES ('Говядина', 'кг', 10.2)
    INTO ingredients (name, unit, stock_quantity) VALUES ('Лосось', 'кг', 8.0)
    INTO ingredients (name, unit, stock_quantity) VALUES ('Помидоры', 'кг', 20.0)
    INTO ingredients (name, unit, stock_quantity) VALUES ('Огурцы', 'кг', 18.5)
    INTO ingredients (name, unit, stock_quantity) VALUES ('Сыр пармезан', 'кг', 5.0)
    INTO ingredients (name, unit, stock_quantity) VALUES ('Сыр фета', 'кг', 4.5)
    INTO ingredients (name, unit, stock_quantity) VALUES ('Картофель', 'кг', 50.0)
    INTO ingredients (name, unit, stock_quantity) VALUES ('Лук репчатый', 'кг', 12.0)
    INTO ingredients (name, unit, stock_quantity) VALUES ('Чеснок', 'кг', 3.0)
    INTO ingredients (name, unit, stock_quantity) VALUES ('Сливки 33%', 'л', 8.0)
    INTO ingredients (name, unit, stock_quantity) VALUES ('Масло оливковое', 'л', 12.0)
    INTO ingredients (name, unit, stock_quantity) VALUES ('Хлеб для тостов', 'шт', 30.0)
    INTO ingredients (name, unit, stock_quantity) VALUES ('Яйца', 'шт', 240.0)
    INTO ingredients (name, unit, stock_quantity) VALUES ('Мука', 'кг', 25.0)
    INTO ingredients (name, unit, stock_quantity) VALUES ('Сахар', 'кг', 20.0)
    INTO ingredients (name, unit, stock_quantity) VALUES ('Соль', 'кг', 10.0)
    INTO ingredients (name, unit, stock_quantity) VALUES ('Перец черный', 'кг', 1.5)
SELECT * FROM dual;
COMMIT;

-- 4. Состав блюд (связи)
INSERT ALL
    INTO dish_ingredients (dish_id, ingredient_id, quantity_required) 
    VALUES (1, 4, 0.15)   -- Брускетта: помидоры 150г
    INTO dish_ingredients (dish_id, ingredient_id, quantity_required) 
    VALUES (1, 13, 2.0)   -- Брускетта: хлеб 2 шт
    INTO dish_ingredients (dish_id, ingredient_id, quantity_required) 
    VALUES (1, 12, 0.03)  -- Брускетта: масло 30мл
    INTO dish_ingredients (dish_id, ingredient_id, quantity_required) 
    VALUES (3, 1, 0.15)   -- Цезарь: курица 150г
    INTO dish_ingredients (dish_id, ingredient_id, quantity_required) 
    VALUES (3, 6, 0.03)   -- Цезарь: пармезан 30г
    INTO dish_ingredients (dish_id, ingredient_id, quantity_required) 
    VALUES (3, 14, 1.0)   -- Цезарь: яйцо 1 шт
    INTO dish_ingredients (dish_id, ingredient_id, quantity_required) 
    VALUES (7, 2, 0.3)    -- Стейк: говядина 300г
    INTO dish_ingredients (dish_id, ingredient_id, quantity_required) 
    VALUES (8, 3, 0.28)   -- Лосось: рыба 280г
    INTO dish_ingredients (dish_id, ingredient_id, quantity_required) 
    VALUES (9, 8, 0.15)   -- Картофель фри: картофель 150г
SELECT * FROM dual;
COMMIT;

-- 5. Посетители
INSERT ALL
    INTO visitors (first_name, last_name, phone, email, loyalty_card) 
    VALUES ('Алексей', 'Петров', '+7-999-123-45-67', 'alexey@mail.ru', 'LC-001')
    INTO visitors (first_name, last_name, phone, email, loyalty_card) 
    VALUES ('Мария', 'Иванова', '+7-999-234-56-78', 'maria@yandex.ru', 'LC-002')
    INTO visitors (first_name, last_name, phone, email, loyalty_card) 
    VALUES ('Дмитрий', 'Сидоров', '+7-999-345-67-89', 'dmitry@gmail.com', NULL)
    INTO visitors (first_name, last_name, phone, email, loyalty_card) 
    VALUES ('Елена', 'Козлова', '+7-999-456-78-90', 'elena@mail.ru', 'LC-003')
    INTO visitors (first_name, last_name, phone, email, loyalty_card) 
    VALUES ('Сергей', 'Михайлов', '+7-999-567-89-01', 'sergey@yandex.ru', NULL)
SELECT * FROM dual;
COMMIT;

-- 6. Официанты
INSERT ALL
    INTO waiters (first_name, last_name, hire_date, hourly_rate) 
    VALUES ('Анна', 'Смирнова', TO_DATE('2023-01-15', 'YYYY-MM-DD'), 350.00)
    INTO waiters (first_name, last_name, hire_date, hourly_rate) 
    VALUES ('Павел', 'Кузнецов', TO_DATE('2023-03-20', 'YYYY-MM-DD'), 320.00)
    INTO waiters (first_name, last_name, hire_date, hourly_rate) 
    VALUES ('Ольга', 'Новикова', TO_DATE('2023-06-10', 'YYYY-MM-DD'), 330.00)
    INTO waiters (first_name, last_name, hire_date, hourly_rate) 
    VALUES ('Иван', 'Попов', TO_DATE('2023-09-05', 'YYYY-MM-DD'), 300.00)
SELECT * FROM dual;
COMMIT;

-- 7. Бронирования
INSERT ALL
    INTO reservations (visitor_id, table_number, reservation_time, guests_count, status) 
    VALUES (1, 5, TO_TIMESTAMP('2025-03-15 19:00:00', 'YYYY-MM-DD HH24:MI:SS'), 4, 'confirmed')
    INTO reservations (visitor_id, table_number, reservation_time, guests_count, status) 
    VALUES (2, 3, TO_TIMESTAMP('2025-03-15 18:30:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 'confirmed')
    INTO reservations (visitor_id, table_number, reservation_time, guests_count, status) 
    VALUES (3, 7, TO_TIMESTAMP('2025-03-16 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 6, 'confirmed')
    INTO reservations (visitor_id, table_number, reservation_time, guests_count, status) 
    VALUES (1, 2, TO_TIMESTAMP('2025-03-16 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 'confirmed')
SELECT * FROM dual;
COMMIT;

-- 8. Заказы
INSERT ALL
    INTO orders (visitor_id, waiter_id, table_number, order_time, status, total_amount) 
    VALUES (1, 1, 5, TO_TIMESTAMP('2025-03-14 19:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'paid', 3250.00)
    INTO orders (visitor_id, waiter_id, table_number, order_time, status, total_amount) 
    VALUES (2, 2, 3, TO_TIMESTAMP('2025-03-14 18:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'paid', 1890.00)
    INTO orders (visitor_id, waiter_id, table_number, order_time, status, total_amount) 
    VALUES (3, 3, 7, TO_TIMESTAMP('2025-03-15 20:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'served', 2840.00)
    INTO orders (visitor_id, waiter_id, table_number, order_time, status, total_amount) 
    VALUES (4, 1, 2, TO_TIMESTAMP('2025-03-15 13:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'new', 1050.00)
SELECT * FROM dual;
COMMIT;

-- 9. Состав заказов
INSERT ALL
    INTO order_items (order_id, dish_id, quantity, price_at_moment, special_requests) 
    VALUES (1, 7, 2, 1890.00, 'Medium rare')
    INTO order_items (order_id, dish_id, quantity, price_at_moment, special_requests) 
    VALUES (1, 1, 1, 350.00, NULL)
    INTO order_items (order_id, dish_id, quantity, price_at_moment, special_requests) 
    VALUES (1, 11, 2, 380.00, NULL)
    INTO order_items (order_id, dish_id, quantity, price_at_moment, special_requests) 
    VALUES (2, 8, 1, 1250.00, 'Без соли')
    INTO order_items (order_id, dish_id, quantity, price_at_moment, special_requests) 
    VALUES (2, 13, 2, 180.00, NULL)
    INTO order_items (order_id, dish_id, quantity, price_at_moment, special_requests) 
    VALUES (3, 3, 2, 480.00, NULL)
    INTO order_items (order_id, dish_id, quantity, price_at_moment, special_requests) 
    VALUES (3, 4, 1, 420.00, NULL)
    INTO order_items (order_id, dish_id, quantity, price_at_moment, special_requests) 
    VALUES (3, 7, 1, 1890.00, 'Well done')
SELECT * FROM dual;
COMMIT;

