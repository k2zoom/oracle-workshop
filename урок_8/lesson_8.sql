--Функция без параметров
CREATE OR REPLACE FUNCTION get_total_revenue
RETURN NUMBER
IS
    v_total NUMBER;
BEGIN
    SELECT SUM(total_amount)
    INTO v_total
    FROM orders
    WHERE status IN ('paid', 'served');
    
    RETURN NVL(v_total, 0);
END;

--Запуск 
SELECT get_total_revenue() FROM dual;

--Функция с одним параметром IN 
CREATE OR REPLACE FUNCTION get_dish_price(p_dish_id NUMBER)
RETURN NUMBER
IS
    v_price dishes.price%TYPE;
BEGIN
    SELECT price
    INTO v_price
    FROM dishes
    WHERE id = p_dish_id;
    
    RETURN v_price;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN -1;
    WHEN OTHERS THEN
        RETURN NULL;
END;

SELECT get_dish_price(7) FROM dual;
SELECT name, price, get_dish_price(id) FROM dishes WHERE id = 7;

--Фукнция с параметром по умолчанию
CREATE OR REPLACE FUNCTION calculate_discounted_price(
    p_price NUMBER,
    p_discount_percent NUMBER DEFAULT 10
)
RETURN NUMBER
IS
    v_final_price NUMBER;
BEGIN
    v_final_price := p_price * (1 - p_discount_percent/100);
    RETURN ROUND(v_final_price, 2);
END;


SELECT 
    name,
    price,
    calculate_discounted_price(price) as price_with_default_discount,
    calculate_discounted_price(price, 20) as price_with_20_discount
FROM dishes;


--Функция с возратом BOOL
CREATE OR REPLACE FUNCTION is_dish_available(p_dish_id NUMBER)
RETURN BOOLEAN
IS
    v_available dishes.is_available%TYPE;
BEGIN
    SELECT is_available
    INTO v_available
    FROM dishes
    WHERE id = p_dish_id;
    
    RETURN v_available = 1;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
END;

DECLARE
    v_result BOOLEAN;
BEGIN
    v_result := is_dish_available(7);
    IF v_result THEN
        DBMS_OUTPUT.PUT_LINE('Блюдо доступно');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Блюдо недоступно');
    END IF;
END;


--Функция с сложной логикой и курсором

CREATE OR REPLACE FUNCTION get_dish_ingredients_list(p_dish_id NUMBER)
RETURN VARCHAR2
IS
    CURSOR c_ingredients IS
        SELECT i.name, di.quantity_required, i.unit
        FROM dish_ingredients di
        JOIN ingredients i ON di.ingredient_id = i.id
        WHERE di.dish_id = p_dish_id;
    
    v_result VARCHAR2(1000) := '';
    v_separator VARCHAR2(2) := '';
BEGIN
    FOR rec IN c_ingredients LOOP
        v_result := v_result || v_separator || rec.name || ' ' || 
                    rec.quantity_required || ' ' || rec.unit;
        v_separator := ', ';
    END LOOP;
    
    IF v_result = '' THEN
        v_result := 'Ингредиенты не указаны';
    END IF;
    
    RETURN v_result;
END;

--Процедура без параметров
CREATE OR REPLACE PROCEDURE update_expired_reservations
IS
BEGIN
    UPDATE reservations
    SET status = 'completed'
    WHERE reservation_time < SYSDATE
      AND status = 'confirmed';
    
    DBMS_OUTPUT.PUT_LINE('Обновлено бронирований: ' || SQL%ROWCOUNT);
    COMMIT;
END;


EXEC update_expired_reservations;

--Процедура с IN параметрами

CREATE OR REPLACE PROCEDURE update_dish_price(
    p_dish_id NUMBER,
    p_new_price NUMBER,
    p_apply_discount BOOLEAN DEFAULT FALSE
)
IS
    v_old_price dishes.price%TYPE;
BEGIN
    -- Получаем старую цену
    SELECT price INTO v_old_price
    FROM dishes
    WHERE id = p_dish_id
    FOR UPDATE;
    
    -- Обновляем цену
    IF p_apply_discount THEN
        UPDATE dishes
        SET price = p_new_price * 0.95
        WHERE id = p_dish_id;
    ELSE
        UPDATE dishes
        SET price = p_new_price
        WHERE id = p_dish_id;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('Цена изменена с ' || v_old_price || 
                         ' на ' || p_new_price);
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Блюдо с ID ' || p_dish_id || ' не найдено');
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
END;

EXEC update_dish_price(7, 1990.00);
EXEC update_dish_price(7, 2000.00, TRUE);

--Процедура с OUT параметрами
CREATE OR REPLACE PROCEDURE get_category_statistics(
    p_category_id NUMBER,
    p_dish_count OUT NUMBER,
    p_avg_price OUT NUMBER,
    p_min_price OUT NUMBER,
    p_max_price OUT NUMBER
)
IS
BEGIN
    SELECT 
        COUNT(*),
        NVL(AVG(price), 0),
        NVL(MIN(price), 0),
        NVL(MAX(price), 0)
    INTO 
        p_dish_count,
        p_avg_price,
        p_min_price,
        p_max_price
    FROM dishes
    WHERE category_id = p_category_id;
END;

DECLARE
    v_count NUMBER;
    v_avg NUMBER;
    v_min NUMBER;
    v_max NUMBER;
BEGIN
    get_category_statistics(4, v_count, v_avg, v_min, v_max);
    DBMS_OUTPUT.PUT_LINE('Категория 4 (Основные блюда):');
    DBMS_OUTPUT.PUT_LINE('  Блюд: ' || v_count);
    DBMS_OUTPUT.PUT_LINE('  Средняя цена: ' || v_avg);
    DBMS_OUTPUT.PUT_LINE('  Мин цена: ' || v_min);
    DBMS_OUTPUT.PUT_LINE('  Макс цена: ' || v_max);
END;

--Процедура с транзакцией и точкой сохраниения
CREATE OR REPLACE PROCEDURE transfer_ingredients(
    p_from_ingredient_id NUMBER,
    p_to_ingredient_id NUMBER,
    p_quantity NUMBER
)
IS
    v_from_stock ingredients.stock_quantity%TYPE;
    v_to_stock ingredients.stock_quantity%TYPE;
BEGIN
    -- Начинаем транзакцию
    SAVEPOINT start_transfer;
    
    -- Проверяем остаток
    SELECT stock_quantity INTO v_from_stock
    FROM ingredients
    WHERE id = p_from_ingredient_id
    FOR UPDATE;
    
    IF v_from_stock < p_quantity THEN
        RAISE_APPLICATION_ERROR(-20001, 'Недостаточно ингредиентов');
    END IF;
    
    -- Уменьшаем в источнике
    UPDATE ingredients
    SET stock_quantity = stock_quantity - p_quantity
    WHERE id = p_from_ingredient_id;
    
    -- Увеличиваем в приемнике
    UPDATE ingredients
    SET stock_quantity = stock_quantity + p_quantity
    WHERE id = p_to_ingredient_id;
    
    -- Логируем операцию
    INSERT INTO procedure_log (procedure_name, records_affected, message)
    VALUES ('transfer_ingredients', 2, 
            'Перемещено ' || p_quantity || ' с ID ' || p_from_ingredient_id || 
            ' на ID ' || p_to_ingredient_id);
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Перемещение выполнено успешно');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK TO start_transfer;
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
        RAISE;
END;


EXEC transfer_ingredients(1, 2, 0.5);

--Процедура с курсором и циклом

CREATE OR REPLACE PROCEDURE apply_discount_to_category(
    p_category_name VARCHAR2,
    p_discount_percent NUMBER
)
IS
    CURSOR c_dishes IS
        SELECT id, name, price
        FROM dishes d
        JOIN categories c ON d.category_id = c.id
        WHERE c.name = p_category_name
        FOR UPDATE;
    
    v_updated_count NUMBER := 0;
    v_new_price NUMBER;
BEGIN
    FOR rec IN c_dishes LOOP
        v_new_price := rec.price * (1 - p_discount_percent/100);
        
        UPDATE dishes
        SET price = v_new_price
        WHERE CURRENT OF c_dishes;
        
        v_updated_count := v_updated_count + 1;
        
        DBMS_OUTPUT.PUT_LINE('Блюдо ' || rec.name || 
                             ': ' || rec.price || ' → ' || v_new_price);
    END LOOP;
    
    INSERT INTO procedure_log (procedure_name, records_affected, message)
    VALUES ('apply_discount_to_category', v_updated_count,
            'Скидка ' || p_discount_percent || '% на категорию ' || p_category_name);
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Обновлено блюд: ' || v_updated_count);
END;

EXEC apply_discount_to_category('Десерты', 15);

--Процедура с MERGE 
CREATE OR REPLACE PROCEDURE merge_dish_data(
    p_id NUMBER,
    p_name VARCHAR2,
    p_category_id NUMBER,
    p_price NUMBER
)
IS
BEGIN
    MERGE INTO dishes d
    USING (SELECT p_id AS id FROM dual) src
    ON (d.id = src.id)
    WHEN MATCHED THEN
        UPDATE SET 
            name = p_name,
            category_id = p_category_id,
            price = p_price,
            last_updated = SYSDATE
    WHEN NOT MATCHED THEN
        INSERT (id, name, category_id, price, created_at)
        VALUES (p_id, p_name, p_category_id, p_price, SYSDATE);
    
    IF SQL%ROWCOUNT = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Данные обновлены/вставлены');
    END IF;
    COMMIT;
END;

--Динамический SQL
CREATE OR REPLACE PROCEDURE dynamic_table_query(
    p_table_name VARCHAR2,
    p_column_name VARCHAR2,
    p_value VARCHAR2
)
IS
    v_sql VARCHAR2(1000);
    v_result NUMBER;
BEGIN
    v_sql := 'SELECT COUNT(*) FROM ' || p_table_name || 
             ' WHERE ' || p_column_name || ' = :val';
    
    EXECUTE IMMEDIATE v_sql INTO v_result USING p_value;
    
    DBMS_OUTPUT.PUT_LINE('Найдено записей: ' || v_result);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Ошибка: ' || SQLERRM);
END;
EXEC dynamic_table_query('dishes', 'category_id', '4');


-- Просмотр информации
SELECT * FROM USER_PROCEDURES WHERE OBJECT_NAME LIKE '%DISH%';
SELECT * FROM USER_SOURCE WHERE NAME = 'GET_DISH_PRICE' ORDER BY LINE;

-- Компиляция
ALTER PROCEDURE update_dish_price COMPILE;
ALTER FUNCTION get_dish_price COMPILE;

-- Удаление
DROP PROCEDURE update_dish_price;
DROP FUNCTION get_dish_price;
DROP PACKAGE discount_pkg;

-- Получение кода
SELECT TEXT 
FROM USER_SOURCE 
WHERE NAME = 'GENERATE_CATEGORY_REPORT' 
ORDER BY LINE;