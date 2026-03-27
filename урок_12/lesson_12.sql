CREATE TABLE sales (
    sale_id         NUMBER(12) PRIMARY KEY,
    product_id      NUMBER(8) NOT NULL,
    customer_id     NUMBER(8) NOT NULL,
    sale_date       DATE NOT NULL,
    quantity        NUMBER(5) NOT NULL,
    amount          NUMBER(12,2) NOT NULL,
    region          VARCHAR2(20)
)
PARTITION BY RANGE (sale_date)
(
    PARTITION sales_q1_2024 VALUES LESS THAN (TO_DATE('2024-04-01', 'YYYY-MM-DD')),
    PARTITION sales_q2_2024 VALUES LESS THAN (TO_DATE('2024-07-01', 'YYYY-MM-DD')),
    PARTITION sales_q3_2024 VALUES LESS THAN (TO_DATE('2024-10-01', 'YYYY-MM-DD')),
    PARTITION sales_q4_2024 VALUES LESS THAN (TO_DATE('2025-01-01', 'YYYY-MM-DD')),
    PARTITION sales_future VALUES LESS THAN (MAXVALUE)
);

--Добавить партицию
ALTER TABLE sales 
SPLIT PARTITION sales_future 
AT (TO_DATE('2025-04-01', 'YYYY-MM-DD')) 
INTO (PARTITION sales_q1_2025, PARTITION sales_future);

CREATE INDEX idx_sales_date ON sales(sale_date) LOCAL;

-----
-- Вставляем данные за разные кварталы 2024 года
INSERT INTO sales (sale_id, product_id, customer_id, sale_date, quantity, amount, region)
VALUES (1, 101, 1001, TO_DATE('2024-01-15', 'YYYY-MM-DD'), 2, 299.98, 'EUROPE');

INSERT INTO sales (sale_id, product_id, customer_id, sale_date, quantity, amount, region)
VALUES (2, 102, 1002, TO_DATE('2024-03-20', 'YYYY-MM-DD'), 1, 149.99, 'EUROPE');

INSERT INTO sales (sale_id, product_id, customer_id, sale_date, quantity, amount, region)
VALUES (3, 103, 1003, TO_DATE('2024-05-10', 'YYYY-MM-DD'), 3, 449.97, 'ASIA');

INSERT INTO sales (sale_id, product_id, customer_id, sale_date, quantity, amount, region)
VALUES (4, 101, 1004, TO_DATE('2024-07-25', 'YYYY-MM-DD'), 1, 149.99, 'AMERICA');

INSERT INTO sales (sale_id, product_id, customer_id, sale_date, quantity, amount, region)
VALUES (5, 104, 1005, TO_DATE('2024-10-05', 'YYYY-MM-DD'), 5, 749.95, 'EUROPE');

COMMIT;

-- Смотрим распределение данных по партициям
SELECT 
    table_name,
    partition_name,
    num_rows
FROM user_tab_partitions
WHERE table_name = 'SALES'
ORDER BY partition_name;

EXPLAIN PLAN FOR 
SELECT * FROM sales 
WHERE sale_date BETWEEN TO_DATE('2024-01-01', 'YYYY-MM-DD') 
                    AND TO_DATE('2024-03-31', 'YYYY-MM-DD');
                    
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);


-- Создаем таблицу-заглушку с той же структурой
CREATE TABLE sales_staging (
    sale_id         NUMBER(12) PRIMARY KEY,
    product_id      NUMBER(8) NOT NULL,
    customer_id     NUMBER(8) NOT NULL,
    sale_date       DATE NOT NULL,
    quantity        NUMBER(5) NOT NULL,
    amount          NUMBER(12,2) NOT NULL,
    region          VARCHAR2(20)
);

-- Создаем индексы, идентичные основным (для быстрой замены)
CREATE INDEX idx_staging_date ON sales_staging(sale_date);

-- Загружаем данные за 1-й квартал 2025 года
INSERT INTO sales_staging VALUES (101, 201, 2001, TO_DATE('2025-01-10', 'YYYY-MM-DD'), 2, 399.98, 'EUROPE');
INSERT INTO sales_staging VALUES (102, 202, 2002, TO_DATE('2025-02-15', 'YYYY-MM-DD'), 1, 199.99, 'ASIA');
INSERT INTO sales_staging VALUES (103, 203, 2003, TO_DATE('2025-03-20', 'YYYY-MM-DD'), 4, 799.96, 'AMERICA');

COMMIT;

-- Проверяем, что данные загружены корректно
SELECT COUNT(*) FROM sales_staging; -- должно быть 3


-- КЛЮЧЕВАЯ ОПЕРАЦИЯ: мгновенно заменяем партицию на staging-таблицу
ALTER TABLE sales 
EXCHANGE PARTITION sales_q4_2024 
WITH TABLE sales_staging 
WITHOUT VALIDATION;

SELECT * FROM SALES s 
DROP TABLE sales_staging