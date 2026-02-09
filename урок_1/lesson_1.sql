SELECT USER FROM dual;




SQL -- декларативный язык, 

DDL - CREATE TABLE, ALTER TABLE, DROP TABLE  
DML - SELECT, UPDATE, DELETE, INSERT, MERGE, TRUNCATE
TCL - COMMIT, ROLLBACK, SAVEPOINT
DCL - GRANT,REVOKE 

REVOKE -- забрать права

--Транзакция
--внутри БД
--Операция 1
SAVEPOINT 
--Перевод 100 рублей
ROLLBACK;
--Успешно
COMMIT;



SELECT tablespace_name FROM user_tablespaces;

SELECT * FROM session_privs;



--Название столбца, тип данных, ограничения
/*
 Ограничения первичного ключа. Уникальность, Не нулевой.
 */

CREATE TABLE test_table (
    id NUMBER PRIMARY KEY, --Что данный столбец будет использоватся как первичный ключ. 
    name VARCHAR2(50) --Текстовый тип данных, максимальная длина строки
);

SELECT name,id FROM test_table

--Выбрать все колонки
--500 колонок, 15 колонок, 

-- Вставка данных
INSERT INTO test_table (id,name) VALUES (2, 'Test User');

UPDATE test_table SET name = 'USER IVAN' WHERE id=1;

DELETE FROM test_table WHERE id =2 

--Обновит все записи в таблице


COMMIT;

SELECT * FROM test_table;

DROP TABLE test_table;


SELECT * FROM USER_TABLE; --Из криминального чтива


-- 1. Посмотреть свои таблицы (метаданные)
SELECT * FROM user_tables;
-- 2. Посмотреть данные из конкретной таблицы
SELECT * FROM test_table; -- если бы была таблица customers
-- 3. Для реального "взлома" хакер бы искал что-то вроде:
SELECT username, password FROM dba_users;
-- или
SELECT * FROM all_tables WHERE owner = 'SYS';

