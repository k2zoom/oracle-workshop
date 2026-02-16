INSERT ALL
    INTO categories (id,name, description, display_order) VALUES (2,'Салаты', 'Свежие салаты', 2)
    INTO categories (id,name, description, display_order) VALUES (3,'Супы', 'Первые блюда', 3)
    INTO categories (id,name, description, display_order) VALUES (4,'Основные блюда', 'Горячие блюда из мяса, рыбы, птицы', 4)
    INTO categories (id,name, description, display_order) VALUES (5,'Гарниры', 'Картофель, рис, овощи', 5)
    INTO categories (id,name, description, display_order) VALUES (6,'Десерты', 'Сладкие блюда', 6)
    INTO categories (id,name, description, display_order) VALUES (7,'Напитки', 'Безалкогольные напитки', 7)
    INTO categories (id,name, description, display_order) VALUES (8,'Алкоголь', 'Вина, крепкие напитки', 8)
    INTO categories (id,name, description, display_order) VALUES (9,'Детское меню', 'Блюда для детей', 9)
    INTO categories (id,name, description, display_order) VALUES (10,'Бизнес-ланч', 'Комплексные обеды', 10)
SELECT * FROM dual;



INSERT ALL
    INTO dishes (id,category_id, name, description, price, weight_grams, calories, preparation_time_minutes) 
    VALUES (1,1, 'Брускетта с томатами', 'Тосты с помидорами, базиликом и оливковым маслом', 350.00, 180, 320, 10)
    INTO dishes (id,category_id, name, description, price, weight_grams, calories, preparation_time_minutes) 
    VALUES (2,1, 'Сырное ассорти', 'Три вида сыра с медом и орехами', 650.00, 200, 580, 7)
    INTO dishes (id,category_id, name, description, price, weight_grams, calories, preparation_time_minutes) 
    VALUES (3,2, 'Цезарь с курицей', 'Классический салат с курицей, пармезаном и соусом', 480.00, 250, 420, 12)
    INTO dishes (id,category_id, name, description, price, weight_grams, calories, preparation_time_minutes) 
    VALUES (4,2, 'Греческий салат', 'Овощи, сыр фета, маслины', 420.00, 280, 280, 8)
    INTO dishes (id,category_id, name, description, price, weight_grams, calories, preparation_time_minutes) 
    VALUES (5,3, 'Тыквенный суп-пюре', 'Крем-суп из тыквы со сливками', 350.00, 300, 210, 15)
    INTO dishes (id,category_id, name, description, price, weight_grams, calories, preparation_time_minutes) 
    VALUES (6,3, 'Борщ', 'Украинский борщ с пампушками', 390.00, 350, 250, 20)
    INTO dishes (id,category_id, name, description, price, weight_grams, calories, preparation_time_minutes) 
    VALUES (7,4, 'Стейк Рибай', 'Мраморная говядина на гриле', 1890.00, 300, 680, 25)
    INTO dishes (id,category_id, name, description, price, weight_grams, calories, preparation_time_minutes) 
    VALUES (8,4, 'Лосось на гриле', 'Филе лосося с овощами', 1250.00, 280, 520, 20)
    INTO dishes (id,category_id, name, description, price, weight_grams, calories, preparation_time_minutes) 
    VALUES (9,5, 'Картофель фри', 'Хрустящий картофель', 220.00, 150, 350, 12)
    INTO dishes (id,category_id, name, description, price, weight_grams, calories, preparation_time_minutes) 
    VALUES (10,5, 'Овощи гриль', 'Кабачки, перец, баклажаны', 280.00, 200, 150, 15)
    INTO dishes (id,category_id, name, description, price, weight_grams, calories, preparation_time_minutes) 
    VALUES (11,6, 'Чизкейк Нью-Йорк', 'Классический чизкейк с ягодным соусом', 380.00, 180, 450, 5)
    INTO dishes (id,category_id, name, description, price, weight_grams, calories, preparation_time_minutes) 
    VALUES (12,6, 'Тирамису', 'Итальянский десерт с маскарпоне', 390.00, 160, 410, 5)
    INTO dishes (id,category_id, name, description, price, weight_grams, calories, preparation_time_minutes) 
    VALUES (13,7, 'Морс клюквенный', 'Домашний морс', 180.00, 250, 90, 3)
    INTO dishes (id,category_id, name, description, price, weight_grams, calories, preparation_time_minutes) 
    VALUES (14,7, 'Лимонад', 'Домашний лимонад с мятой', 250.00, 300, 120, 4)
    INTO dishes (id,category_id, name, description, price, weight_grams, calories, preparation_time_minutes) 
    VALUES (15,8, 'Вино красное сухое', 'Итальянское вино, 0.75 л', 890.00, 750, 620, 2)
    INTO dishes (id,category_id, name, description, price, weight_grams, calories, preparation_time_minutes) 
    VALUES (16,8, 'Пиво светлое', 'Чешское пиво, 0.5 л', 320.00, 500, 210, 1)
SELECT * FROM dual;
COMMIT;



-- 3. Ингредиенты
INSERT ALL
    INTO ingredients (id,name, unit, stock_quantity) VALUES (1,'Куриное филе', 'кг', 15.5)
    INTO ingredients (id,name, unit, stock_quantity) VALUES (2,'Говядина', 'кг', 10.2)
    INTO ingredients (id,name, unit, stock_quantity) VALUES (3,'Лосось', 'кг', 8.0)
    INTO ingredients (id,name, unit, stock_quantity) VALUES (4,'Помидоры', 'кг', 20.0)
    INTO ingredients (id,name, unit, stock_quantity) VALUES (5,'Огурцы', 'кг', 18.5)
    INTO ingredients (id,name, unit, stock_quantity) VALUES (6,'Сыр пармезан', 'кг', 5.0)
    INTO ingredients (id,name, unit, stock_quantity) VALUES (7,'Сыр фета', 'кг', 4.5)
    INTO ingredients (id,name, unit, stock_quantity) VALUES (8,'Картофель', 'кг', 50.0)
    INTO ingredients (id,name, unit, stock_quantity) VALUES (9,'Лук репчатый', 'кг', 12.0)
    INTO ingredients (id,name, unit, stock_quantity) VALUES (10,'Чеснок', 'кг', 3.0)
    INTO ingredients (id,name, unit, stock_quantity) VALUES (11,'Сливки 33%', 'л', 8.0)
    INTO ingredients (id,name, unit, stock_quantity) VALUES (12,'Масло оливковое', 'л', 12.0)
    INTO ingredients (id,name, unit, stock_quantity) VALUES (13,'Хлеб для тостов', 'шт', 30.0)
    INTO ingredients (id,name, unit, stock_quantity) VALUES (14,'Яйца', 'шт', 240.0)
    INTO ingredients (id,name, unit, stock_quantity) VALUES (15,'Мука', 'кг', 25.0)
    INTO ingredients (id,name, unit, stock_quantity) VALUES (16,'Сахар', 'кг', 20.0)
    INTO ingredients (id,name, unit, stock_quantity) VALUES (17,'Соль', 'кг', 10.0)
    INTO ingredients (id,name, unit, stock_quantity) VALUES (18,'Перец черный', 'кг', 1.5)
SELECT * FROM dual;
COMMIT;

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
    INTO visitors (id,first_name, last_name, phone, email, loyalty_card) 
    VALUES (1,'Алексей', 'Петров', '+7-999-123-45-67', 'alexey@mail.ru', 'LC-001')
    INTO visitors (id,first_name, last_name, phone, email, loyalty_card) 
    VALUES (2,'Мария', 'Иванова', '+7-999-234-56-78', 'maria@yandex.ru', 'LC-002')
    INTO visitors (id,first_name, last_name, phone, email, loyalty_card) 
    VALUES (3,'Дмитрий', 'Сидоров', '+7-999-345-67-89', 'dmitry@gmail.com', NULL)
    INTO visitors (id,first_name, last_name, phone, email, loyalty_card) 
    VALUES (4,'Елена', 'Козлова', '+7-999-456-78-90', 'elena@mail.ru', 'LC-003')
    INTO visitors (id,first_name, last_name, phone, email, loyalty_card) 
    VALUES (5,'Сергей', 'Михайлов', '+7-999-567-89-01', 'sergey@yandex.ru', NULL)
SELECT * FROM dual;
COMMIT;

-- 6. Официанты
INSERT ALL
    INTO waiters (id,first_name, last_name, hire_date, hourly_rate) 
    VALUES (1,'Анна', 'Смирнова', TO_DATE('2023-01-15', 'YYYY-MM-DD'), 350.00)
    INTO waiters (id,first_name, last_name, hire_date, hourly_rate) 
    VALUES (2,'Павел', 'Кузнецов', TO_DATE('2023-03-20', 'YYYY-MM-DD'), 320.00)
    INTO waiters (id,first_name, last_name, hire_date, hourly_rate) 
    VALUES (3,'Ольга', 'Новикова', TO_DATE('2023-06-10', 'YYYY-MM-DD'), 330.00)
    INTO waiters (id,first_name, last_name, hire_date, hourly_rate) 
    VALUES (4,'Иван', 'Попов', TO_DATE('2023-09-05', 'YYYY-MM-DD'), 300.00)
SELECT * FROM dual;
COMMIT;

-- 7. Бронирования
INSERT ALL
    INTO reservations (id,visitor_id, table_number, reservation_time, guests_count, status) 
    VALUES (1,1, 5, TO_TIMESTAMP('2025-03-15 19:00:00', 'YYYY-MM-DD HH24:MI:SS'), 4, 'confirmed')
    INTO reservations (id,visitor_id, table_number, reservation_time, guests_count, status) 
    VALUES (2,2, 3, TO_TIMESTAMP('2025-03-15 18:30:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 'confirmed')
    INTO reservations (id,visitor_id, table_number, reservation_time, guests_count, status) 
    VALUES (3,3, 7, TO_TIMESTAMP('2025-03-16 20:00:00', 'YYYY-MM-DD HH24:MI:SS'), 6, 'confirmed')
    INTO reservations (id,visitor_id, table_number, reservation_time, guests_count, status) 
    VALUES (4,1, 2, TO_TIMESTAMP('2025-03-16 13:00:00', 'YYYY-MM-DD HH24:MI:SS'), 2, 'confirmed')
SELECT * FROM dual;
COMMIT;

-- 8. Заказы
INSERT ALL
    INTO orders (id,visitor_id, waiter_id, table_number, order_time, status, total_amount) 
    VALUES (1,1, 1, 5, TO_TIMESTAMP('2025-03-14 19:15:00', 'YYYY-MM-DD HH24:MI:SS'), 'paid', 3250.00)
    INTO orders (id,visitor_id, waiter_id, table_number, order_time, status, total_amount) 
    VALUES (2,2, 2, 3, TO_TIMESTAMP('2025-03-14 18:45:00', 'YYYY-MM-DD HH24:MI:SS'), 'paid', 1890.00)
    INTO orders (id,visitor_id, waiter_id, table_number, order_time, status, total_amount) 
    VALUES (3,3, 3, 7, TO_TIMESTAMP('2025-03-15 20:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'served', 2840.00)
    INTO orders (id,visitor_id, waiter_id, table_number, order_time, status, total_amount) 
    VALUES (4,4, 1, 2, TO_TIMESTAMP('2025-03-15 13:30:00', 'YYYY-MM-DD HH24:MI:SS'), 'new', 1050.00)
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


