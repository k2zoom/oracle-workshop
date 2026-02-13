
-- Удаляем таблицы, если существуют
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS reservations CASCADE;
DROP TABLE IF EXISTS dish_ingredients CASCADE;
DROP TABLE IF EXISTS dishes CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS ingredients CASCADE;
DROP TABLE IF EXISTS waiters CASCADE;
DROP TABLE IF EXISTS visitors CASCADE;

-- 1. Таблица посетителей

CREATE TABLE visitors (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20) UNIQUE,
    email VARCHAR(100) UNIQUE,
    loyalty_card VARCHAR(20) UNIQUE,
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT valid_email CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

-- 2. Таблица бронирований
CREATE TABLE reservations (
    id SERIAL PRIMARY KEY,
    visitor_id INTEGER NOT NULL REFERENCES visitors(id) ON DELETE CASCADE,
    table_number INTEGER NOT NULL,
    reservation_time TIMESTAMP NOT NULL,
    guests_count INTEGER NOT NULL CHECK (guests_count > 0 AND guests_count <= 20),
    status VARCHAR(20) DEFAULT 'confirmed' 
        CHECK (status IN ('confirmed', 'cancelled', 'completed')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_table_reservation UNIQUE (table_number, reservation_time)
);

-- 3. Таблица категорий блюд
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    display_order INTEGER DEFAULT 0
);

-- 4. Таблица блюд
CREATE TABLE dishes (
    id SERIAL PRIMARY KEY,
    category_id INTEGER NOT NULL REFERENCES categories(id) ON DELETE RESTRICT,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    weight_grams INTEGER CHECK (weight_grams > 0),
    calories INTEGER CHECK (calories >= 0),
    is_available BOOLEAN DEFAULT true,
    preparation_time_minutes INTEGER CHECK (preparation_time_minutes > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Таблица ингредиентов
CREATE TABLE ingredients (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    unit VARCHAR(20) NOT NULL CHECK (unit IN ('кг', 'г', 'л', 'мл', 'шт')),
    stock_quantity DECIMAL(10,2) DEFAULT 0 CHECK (stock_quantity >= 0)
);

-- 6. Связь блюд и ингредиентов (M:M)
CREATE TABLE dish_ingredients (
    dish_id INTEGER NOT NULL REFERENCES dishes(id) ON DELETE CASCADE,
    ingredient_id INTEGER NOT NULL REFERENCES ingredients(id) ON DELETE RESTRICT,
    quantity_required DECIMAL(10,2) NOT NULL CHECK (quantity_required > 0),
    PRIMARY KEY (dish_id, ingredient_id)
);

-- 7. Таблица официантов
CREATE TABLE waiters (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL DEFAULT CURRENT_DATE,
    hourly_rate DECIMAL(10,2) NOT NULL CHECK (hourly_rate >= 0),
    is_active BOOLEAN DEFAULT true
);

-- 8. Таблица заказов
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    visitor_id INTEGER REFERENCES visitors(id) ON DELETE SET NULL,
    waiter_id INTEGER NOT NULL REFERENCES waiters(id) ON DELETE RESTRICT,
    table_number INTEGER NOT NULL,
    order_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'new' 
        CHECK (status IN ('new', 'preparing', 'served', 'paid', 'cancelled')),
    total_amount DECIMAL(10,2) DEFAULT 0 CHECK (total_amount >= 0)
);

-- 9. Состав заказа (элементы заказа)
CREATE TABLE order_items (
    order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    dish_id INTEGER NOT NULL REFERENCES dishes(id) ON DELETE RESTRICT,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    price_at_moment DECIMAL(10,2) NOT NULL CHECK (price_at_moment > 0),
    special_requests TEXT,
    PRIMARY KEY (order_id, dish_id)
);

-- Создаем индексы для ускорения выборки данных
CREATE INDEX idx_visitors_phone ON visitors(phone);
CREATE INDEX idx_visitors_email ON visitors(email);
CREATE INDEX idx_reservations_time ON reservations(reservation_time);
CREATE INDEX idx_reservations_visitor ON reservations(visitor_id);
CREATE INDEX idx_dishes_category ON dishes(category_id);
CREATE INDEX idx_dishes_price ON dishes(price);
CREATE INDEX idx_dishes_available ON dishes(is_available);
CREATE INDEX idx_orders_time ON orders(order_time);
CREATE INDEX idx_orders_visitor ON orders(visitor_id);
CREATE INDEX idx_orders_waiter ON orders(waiter_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_order_items_order ON order_items(order_id);
