--Плохой пример

CREATE TABLE bad_orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    dishes VARCHAR(500),  -- 'стейк, салат, суп' - НЕ АТОМАРНО!
    quantities VARCHAR(100) -- '2, 1, 1' - НЕ АТОМАРНО!
);

CREATE TABLE bad_dishes (
    dish_id INT PRIMARY KEY,
    dish_name VARCHAR(100),
    ingredient1 VARCHAR(50),  -- повторяющиеся столбцы
    ingredient2 VARCHAR(50),   
    ingredient3 VARCHAR(50)
);


--Правильный пример 
-- Атомарные значения в каждой колонке
CREATE TABLE dishes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,  -- одно значение
    price DECIMAL(10,2) NOT NULL,        -- одно значение
    is_available BOOLEAN DEFAULT true    -- одно значение
);

-- Состав блюда вынесен в отдельную таблицу (нет повторяющихся групп)
CREATE TABLE dish_ingredients (
    dish_id INT REFERENCES dishes(id),
    ingredient_id INT REFERENCES ingredients(id),
    quantity_required DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (dish_id, ingredient_id)  -- составной ключ
);


--2НФ
-- ПЛОХО: таблица с составным ключом и частичной зависимостью
CREATE TABLE bad_order_details (
    order_id INT,
    dish_id INT,
    quantity INT,           -- зависит от (order_id, dish_id) - ОК
    dish_name VARCHAR(100), -- зависит ТОЛЬКО от dish_id - НАРУШЕНИЕ 2НФ!
    dish_price DECIMAL,     -- зависит ТОЛЬКО от dish_id - НАРУШЕНИЕ 2НФ!
    order_date DATE,        -- зависит ТОЛЬКО от order_id - НАРУШЕНИЕ 2НФ!
    customer_name VARCHAR,  -- зависит ТОЛЬКО от order_id - НАРУШЕНИЕ 2НФ!
    PRIMARY KEY (order_id, dish_id)
);

-- Проблемы:
-- 1. Избыточность: dish_name повторяется в каждом заказе
-- 2. Аномалии: если блюдо переименовать, нужно менять во всех заказах
-- 3. Занимает лишнее место

-- Таблица заказов (зависит от order_id)
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,  -- простой ключ
    visitor_id INT REFERENCES visitors(id),
    waiter_id INT REFERENCES waiters(id),
    order_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20),
    total_amount DECIMAL(10,2) DEFAULT 0
);

-- Таблица блюд (зависит от dish_id)
CREATE TABLE dishes (
    id SERIAL PRIMARY KEY,  -- простой ключ
    name VARCHAR(100) NOT NULL UNIQUE,
    price DECIMAL(10,2) NOT NULL,
    category_id INT REFERENCES categories(id)
);

-- Связующая таблица (только зависимость от составного ключа)
CREATE TABLE order_items (
    order_id INT REFERENCES orders(id) ON DELETE CASCADE,
    dish_id INT REFERENCES dishes(id) ON DELETE RESTRICT,
    quantity INT NOT NULL CHECK (quantity > 0),
    price_at_moment DECIMAL(10,2) NOT NULL, -- копия цены на момент заказа
    PRIMARY KEY (order_id, dish_id)  -- составной ключ
);

-- ВСЕ неключевые поля (quantity, price_at_moment) зависят от ПОЛНОГО ключа!

--3НФ
-- ПЛОХО: транзитивная зависимость
CREATE TABLE bad_orders (
    order_id SERIAL PRIMARY KEY,
    visitor_id INT,
    visitor_name VARCHAR(100),  -- зависит от visitor_id (не от order_id!)
    visitor_phone VARCHAR(20),   -- зависит от visitor_id (не от order_id!)
    waiter_id INT,
    waiter_name VARCHAR(100),    -- зависит от waiter_id (не от order_id!)
    table_number INT,
    order_time TIMESTAMP,
    total_amount DECIMAL
);

-- Проблемы:
-- visitor_name зависит от visitor_id, а visitor_id зависит от order_id
-- => visitor_name ТРАНЗИТИВНО зависит от order_id


--Правильный пример
CREATE TABLE bad_dishes (
    dish_id SERIAL PRIMARY KEY,
    category_id INT,
    category_name VARCHAR(50),  -- зависит от category_id, не от dish_id!
    category_description TEXT,   -- зависит от category_id, не от dish_id!
    dish_name VARCHAR(100),
    price DECIMAL
);

-- Таблица посетителей (отдельная сущность)
CREATE TABLE visitors (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20) UNIQUE,
    email VARCHAR(100) UNIQUE,
    loyalty_card VARCHAR(20) UNIQUE
);

-- Таблица заказов (хранит только ID, не дублирует данные)
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    visitor_id INT REFERENCES visitors(id),  -- только ссылка
    waiter_id INT REFERENCES waiters(id),    -- только ссылка
    table_number INT NOT NULL,
    order_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20),
    total_amount DECIMAL(10,2) DEFAULT 0
);

-- Таблица категорий (отдельная сущность)
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    display_order INTEGER DEFAULT 0
);

-- Таблица блюд (хранит только ID категории)
CREATE TABLE dishes (
    id SERIAL PRIMARY KEY,
    category_id INT REFERENCES categories(id),  -- только ссылка
    name VARCHAR(100) NOT NULL UNIQUE,
    price DECIMAL(10,2) NOT NULL,
    is_available BOOLEAN DEFAULT true
    -- НЕТ category_name - оно берется из таблицы categories!
);