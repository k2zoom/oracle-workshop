--ATOMICITY
-- Транзакция: оформить заказ и списать ингредиенты
BEGIN
    -- Шаг 1: Создаем заказ
    INSERT INTO orders (id, visitor_id, waiter_id, table_number, total_amount)
    VALUES (5, 1, 1, 8, 1250.00);
    
    -- Шаг 2: Добавляем позиции
    INSERT INTO order_items (order_id, dish_id, quantity, price_at_moment)
    VALUES (5, 8, 1, 1250.00);  -- Лосось
    
    -- Шаг 3: Списание ингредиентов (ингредиента нет)
    UPDATE ingredients 
    SET stock_quantity = stock_quantity - 0.28 
    WHERE id = 3;  -- Лосось
    
    -- Если на шаге 3 ошибка, то шаги 1 и 2 должны отмениться
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;  -- Отмена ВСЕХ изменений
        RAISE;
END;

/*
Заказ создан ✓
Позиции добавлены ✓
Ингредиент не списан ✗
Итог: заказ есть, а ингредиенты числятся, ошибка, отменяем транзакцию
*/


--CONSISTENCY
-- Создаем ограничения
ALTER TABLE orders ADD CONSTRAINT chk_total_amount CHECK (total_amount >= 0);
ALTER TABLE dishes ADD CONSTRAINT chk_price_positive CHECK (price > 0);
ALTER TABLE reservations ADD CONSTRAINT chk_future_reservation 
    CHECK (reservation_time >= TRUNC(SYSDATE));

-- Транзакция, нарушающая согласованность
BEGIN
    -- Попытка создать заказ с отрицательной суммой
    INSERT INTO orders (id, visitor_id, total_amount)
    VALUES (6, 1, -100.00);  -- НАРУШЕНИЕ CHECK!
    COMMIT;  -- Сюда не дойдем
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
        ROLLBACK;
END;



--Isolation

-- Сессия 1 (кассир)
BEGIN
    -- Читаем цену стейка
    SELECT price INTO v_price FROM dishes WHERE id = 7;
    -- Получили 1890.00
    -- В это время Сессия 2 меняет цену...
    -- (пауза)
    -- Снова читаем цену для подтверждения
    SELECT price INTO v_new_price FROM dishes WHERE id = 7;
    -- Уже 1990.00
    -- Клиент возмущен
END;


-- Сессия 2 (менеджер)
UPDATE dishes SET price = 1990.00 WHERE id = 7;
COMMIT;


-- Установка уровня изоляции для сессии
ALTER SESSION SET ISOLATION_LEVEL = READ COMMITTED;      -- по умолчанию
ALTER SESSION SET ISOLATION_LEVEL = SERIALIZABLE;        -- максимальный
-- Для конкретной транзакции
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- Явная блокировка строки
SELECT * FROM dishes WHERE id = 7 FOR UPDATE;  -- Блокируем стейк

-- Теперь другая сессия не сможет изменить эту строку
-- Пока первая не сделает COMMIT или ROLLBACK

-- Проверка блокировок
SELECT * FROM v$locked_object;
SELECT * FROM v$lock;

--Durability
--
-- 14:29:00 - пользователь делает BEGIN TRANSACTION
-- 14:30:00 - пользователь делает COMMIT
COMMIT;
-- 14:30:01 - запись в Redo Log (успешно)
-- 14:30:02 - подтверждение пользователю "Готово"
-- 14:30:03 - ОТКЛЮЧЕНИЕ ЭЛЕКТРИЧЕСТВА
-- 14:45:00 - сервер перезагрузился
-- Oracle читает Redo Logs и восстанавливает все закоммиченные транзакции
-- 14:46:00 - данные на месте, пользователь счастлив


--Пример процедуры полностью соотвествующей ACID
-- Ситуация: посетитель делает заказ и расплачивается картой лояльности

DECLARE
    v_order_id NUMBER;
    v_visitor_id NUMBER := 1;
    v_waiter_id NUMBER := 1;
    v_discount NUMBER;
    e_insufficient_stock EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_insufficient_stock, -20001);
BEGIN
    -- Начинаем транзакцию (неявно)
    SAVEPOINT sp_start;
    
    -- 1. Проверяем карту лояльности
    SELECT 
        CASE WHEN loyalty_card IS NOT NULL THEN 10 ELSE 0 END
    INTO v_discount
    FROM visitors
    WHERE id = v_visitor_id;
    
    -- 2. Создаем заказ
    INSERT INTO orders (id, visitor_id, waiter_id, table_number, status, total_amount)
    VALUES (orders_seq.NEXTVAL, v_visitor_id, v_waiter_id, 5, 'new', 0)
    RETURNING id INTO v_order_id;
    
    -- 3. Добавляем позиции (стейк и картошку)
    INSERT INTO order_items (order_id, dish_id, quantity, price_at_moment)
    VALUES (v_order_id, 7, 2, 1890.00);
    
    INSERT INTO order_items (order_id, dish_id, quantity, price_at_moment)
    VALUES (v_order_id, 9, 1, 220.00);
    
    -- 4. Обновляем общую сумму
    UPDATE orders 
    SET total_amount = (SELECT SUM(quantity * price_at_moment) 
                        FROM order_items WHERE order_id = v_order_id)
    WHERE id = v_order_id;
    
    -- 5. Применяем скидку
    UPDATE orders 
    SET total_amount = total_amount * (1 - v_discount/100)
    WHERE id = v_order_id;
    
    -- 6. Списание ингредиентов (с проверкой остатков)
    UPDATE ingredients 
    SET stock_quantity = stock_quantity - 0.6  -- 300г * 2
    WHERE id = 2;  -- Говядина
    
    IF SQL%ROWCOUNT = 0 OR SQL%ROWCOUNT IS NULL THEN
        RAISE e_insufficient_stock;
    END IF;
    
    UPDATE ingredients 
    SET stock_quantity = stock_quantity - 0.15
    WHERE id = 8;  -- Картофель
    
    -- 7. Фиксируем транзакцию
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Заказ ' || v_order_id || ' успешно оформлен');
    
EXCEPTION
    WHEN e_insufficient_stock THEN
        ROLLBACK TO sp_start;
        DBMS_OUTPUT.PUT_LINE('Ошибка: недостаточно ингредиентов');
        RAISE;
        
    WHEN DUP_VAL_ON_INDEX THEN
        ROLLBACK TO sp_start;
        DBMS_OUTPUT.PUT_LINE('Ошибка: дубликат данных');
        
    WHEN OTHERS THEN
        ROLLBACK TO sp_start;
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
        RAISE;
END;
