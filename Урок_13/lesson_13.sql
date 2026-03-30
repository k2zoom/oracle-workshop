
--Информация о таблицах
-- USER_TABLES: таблицы текущего пользователя
SELECT table_name, 
       tablespace_name,
       num_rows,           -- количество строк (если есть статистика)
       blocks,             -- количество блоков
       last_analyzed       -- дата последнего сбора статистики
FROM user_tables
WHERE table_name LIKE 'EMP%';

-- DBA_TABLES: все таблицы в БД (требуются права DBA)
SELECT owner,
       table_name,
       tablespace_name,
       num_rows,
       partitioned        -- секционированная ли таблица
FROM dba_tables
WHERE owner IN ('HR', 'OE');

-- ALL_TABLES: таблицы, доступные текущему пользователю
SELECT owner, table_name, tablespace_name
FROM all_tables
WHERE table_name = 'EMPLOYEES';

--Информация о столбцах
-- USER_TAB_COLUMNS: столбцы таблиц пользователя
SELECT table_name,
       column_name,
       data_type,
       data_length,
       data_precision,    -- для NUMBER
       data_scale,        -- для NUMBER
       nullable,
       column_id          -- позиция столбца
FROM user_tab_columns
WHERE table_name = 'EMPLOYEES'
ORDER BY column_id;

-- DBA_TAB_COLUMNS: столбцы всех таблиц
SELECT owner,
       table_name,
       column_name,
       data_type,
       avg_col_len        -- средняя длина значения
FROM dba_tab_columns
WHERE owner = 'HR'
  AND table_name LIKE 'EMP%';

--Информация об индексах
-- USER_INDEXES: индексы текущего пользователя
SELECT index_name,
       table_name,
       uniqueness,        -- UNIQUE или NONUNIQUE
       status,            -- VALID или UNUSABLE
       tablespace_name,
       blevel,            -- высота B-дерева
       leaf_blocks        -- количество листовых блоков
FROM user_indexes
WHERE table_name = 'EMPLOYEES';

-- USER_IND_COLUMNS: столбцы в составе индексов
SELECT index_name,
       table_name,
       column_name,
       column_position    -- порядок столбца в индексе
FROM user_ind_columns
WHERE table_name = 'EMPLOYEES'
ORDER BY index_name, column_position;

--Информация об ограничениях 
-- USER_CONSTRAINTS: все ограничения
SELECT constraint_name,
       constraint_type,   -- P=Primary, R=Foreign, U=Unique, C=Check
       table_name,
       status,            -- ENABLED или DISABLED
       deferrable,
       validated
FROM user_constraints
WHERE table_name = 'EMPLOYEES';

-- USER_CONS_COLUMNS: столбцы, участвующие в ограничениях
SELECT constraint_name,
       table_name,
       column_name,
       position
FROM user_cons_columns
WHERE table_name = 'EMPLOYEES'
ORDER BY constraint_name, position;

-- Расшифровка типов ограничений
SELECT c.constraint_name,
       c.constraint_type,
       CASE c.constraint_type
           WHEN 'P' THEN 'Primary Key'
           WHEN 'R' THEN 'Foreign Key'
           WHEN 'U' THEN 'Unique'
           WHEN 'C' THEN 'Check'
           WHEN 'V' THEN 'With Check Option'
           WHEN 'O' THEN 'Read Only'
       END as constraint_type_name,
       c.table_name,
       cc.column_name
FROM user_constraints c
JOIN user_cons_columns cc ON c.constraint_name = cc.constraint_name
WHERE c.table_name = 'EMPLOYEES';

--Внешние ключи
-- USER_CONS_COLUMNS: детали внешних ключей
SELECT c.constraint_name,
       c.table_name as child_table,
       c.r_constraint_name as parent_constraint,
       c2.table_name AS source_table,
       cc.column_name as child_column
FROM user_constraints c
JOIN user_cons_columns cc ON c.constraint_name = cc.constraint_name
JOIN user_constraints c2 ON c2.constraint_name=c.r_constraint_name
WHERE c.constraint_type = 'R'
  AND c.table_name = 'ORDERS';

-- Находим родительскую таблицу для внешнего ключа
SELECT c.constraint_name as fk_name,
       c.table_name as child_table,
       cc.column_name as child_column,
       p.table_name as parent_table,
       pc.column_name as parent_column
FROM user_constraints c
JOIN user_cons_columns cc ON c.constraint_name = cc.constraint_name
JOIN user_constraints p ON c.r_constraint_name = p.constraint_name
JOIN user_cons_columns pc ON p.constraint_name = pc.constraint_name
                          AND cc.position = pc.position
WHERE c.constraint_type = 'R'
  AND c.table_name = 'EMPLOYEES';


  --view
  -- USER_VIEWS: тексты представлений
SELECT view_name,
       text_length,
       text               -- SQL-текст представления
FROM user_views
WHERE view_name = 'EMP_DETAILS_VIEW';

-- USER_UPDATABLE_COLUMNS: какие столбцы представления можно обновлять
SELECT column_name,
       updatable,         -- YES/NO
       insertable,
       deletable
FROM user_updatable_columns
WHERE table_name = 'EMP_DETAILS_VIEW';

--procedures/functions
-- USER_SOURCE: исходный код процедур, функций, пакетов
SELECT name,           -- имя объекта
       type,           -- PROCEDURE, FUNCTION, PACKAGE, TRIGGER
       line,           -- номер строки
       text            -- код
FROM user_source
WHERE name = 'CALCULATE_SALARY'
ORDER BY line;

-- USER_PROCEDURES: процедуры и функции
SELECT object_name,
       procedure_name,
       object_type,
       authid          -- DEFINER/CURRENT_USER
FROM user_procedures
WHERE object_name LIKE 'CALC%';

-- USER_ARGUMENTS: параметры процедур и функций
SELECT object_name,
       argument_name,
       data_type,
       in_out,         -- IN/OUT/IN OUT
       position
FROM user_arguments
WHERE object_name = 'CALCULATE_SALARY'
ORDER BY position;

--Триггеры
-- USER_TRIGGERS: триггеры
SELECT trigger_name,
       table_name,
       triggering_event,    -- INSERT, UPDATE, DELETE
       trigger_type,        -- BEFORE/AFTER/INSTEAD OF
       status,              -- ENABLED/DISABLED
       trigger_body         -- PL/SQL тело триггера
FROM user_triggers
WHERE table_name = 'EMPLOYEES';

--сессии
-- V$SESSION: активные сессии
SELECT sid,
       serial#,
       username,
       status,              -- ACTIVE, INACTIVE, KILLED
       osuser,
       machine,
       program,
       logon_time,
       last_call_et         -- время последней активности (в секундах)
FROM v$session
WHERE username IS NOT NULL
ORDER BY logon_time DESC;

-- V$SESSION_LONGOPS: длительные операции
SELECT opname,
       target,
       sofar,               -- выполнено
       totalwork,          -- всего
       ROUND(sofar/totalwork*100, 2) as pct_complete,
       time_remaining
FROM v$session_longops
WHERE sofar < totalwork
  AND totalwork > 0;

--Запросы
-- V$SQL: выполняемые SQL-запросы
SELECT sql_id,
       sql_text,
       executions,         -- количество выполнений
       elapsed_time,       -- общее время выполнения
       cpu_time,
       buffer_gets,        -- логические чтения
       disk_reads,         -- физические чтения
       rows_processed
FROM v$sql
WHERE executions > 0
ORDER BY elapsed_time DESC
FETCH FIRST 10 ROWS ONLY;

-- V$SQLAREA: агрегированная информация по SQL
SELECT sql_id,
       SUBSTR(sql_text, 1, 100) as sql_text_short,
       executions,
       elapsed_time/executions as avg_elapsed_time,
       buffer_gets/executions as avg_buffer_gets
FROM v$sqlarea
WHERE executions > 0
  AND elapsed_time > 1000000  -- запросы дольше 1 секунды
ORDER BY avg_elapsed_time DESC;

--блокировки
-- V$LOCK: активные блокировки
SELECT sid,
       type,               -- TX (транзакция), TM (DML)
       lmode,              -- режим блокировки (0-6)
       request,
       block,              -- блокирующая ли блокировка
       id1, id2
FROM v$lock
WHERE lmode > 0 OR request > 0;

-- Блокировки с информацией о сессиях
SELECT l.sid,
       l.type,
       DECODE(l.lmode, 0, 'None', 1, 'Null', 2, 'RS', 3, 'RX', 
                      4, 'S', 5, 'SRX', 6, 'X') as lock_mode,
       DECODE(l.request, 0, 'None', 1, 'Null', 2, 'RS', 3, 'RX',
                        4, 'S', 5, 'SRX', 6, 'X') as requested_mode,
       s.username,
       s.osuser,
       s.machine,
       s.program,
       l.block
FROM v$lock l
JOIN v$session s ON l.sid = s.sid
WHERE (l.lmode > 0 OR l.request > 0)
ORDER BY l.block DESC, l.sid;

-- Обнаружение заблокированных и блокирующих сессий
SELECT blocking_session,
       sid,
       serial#,
       username,
       ROUND(seconds_in_wait/60, 2) as minutes_waited,
       event,
       sql_id
FROM v$session
WHERE blocking_session IS NOT NULL;

--транзакции
-- V$TRANSACTION: активные транзакции
SELECT addr,
       xidusn,            -- номер сегмента отката
       xidslot,
       xidsqn,
       status,            -- ACTIVE или INACTIVE
       start_time,
       used_ublk,         -- использованные блоки отката
       log_io,            -- логические IO
       phy_io             -- физические IO
FROM v$transaction;

-- Связь транзакций с сессиями
SELECT s.sid,
       s.username,
       t.status as tx_status,
       t.start_time as tx_start,
       t.used_ublk
FROM v$transaction t
JOIN v$session s ON t.addr = s.taddr;


-- V$TABLESPACE: табличные пространства
SELECT ts#,
       name,
       included_in_database_backup
FROM v$tablespace;

-- V$DATAFILE: свободное пространство в файлах
SELECT tablespace_name,
       file_name,
       ROUND(bytes/1024/1024, 2) as total_mb,
       ROUND(maxbytes/1024/1024, 2) as max_mb,
       autoextensible,
       ROUND((bytes - (SELECT SUM(bytes) 
                       FROM dba_free_space f 
                       WHERE f.file_id = d.file_id))/1024/1024, 2) as used_mb
FROM dba_data_files d;

--статистика 
-- Сравнение актуальности статистики
SELECT table_name,
       num_rows,
       last_analyzed,
       ROUND((SYSDATE - last_analyzed), 2) as days_old,
       CASE 
           WHEN SYSDATE - last_analyzed > 7 THEN 'OLD'
           WHEN SYSDATE - last_analyzed > 1 THEN 'STALE'
           ELSE 'FRESH'
       END as freshness_status
FROM user_tables
WHERE last_analyzed IS NOT NULL
ORDER BY last_analyzed;


--Размеры объектов
-- Размер таблиц в МБ
SELECT segment_name,
       segment_type,
       bytes/1024/1024 as size_mb,
       extents,
       blocks
FROM user_segments
WHERE segment_type = 'TABLE'
ORDER BY bytes DESC;

-- Размер индексов по таблицам
SELECT i.table_name,
       i.index_name,
       s.bytes/1024/1024 as size_mb
FROM user_indexes i
JOIN user_segments s ON i.index_name = s.segment_name
WHERE s.segment_type = 'INDEX'
ORDER BY s.bytes DESC;

--Полная инфа по таблице
-- Комплексный запрос для получения всей информации о таблице
SELECT 
    'TABLE' as object_type,
    t.table_name,
    t.tablespace_name,
    t.num_rows,
    t.last_analyzed,
    LISTAGG(DISTINCT c.column_name || ' (' || c.data_type || ')', ', ') 
        WITHIN GROUP (ORDER BY c.column_id) as columns,
    LISTAGG(DISTINCT i.index_name || ' (' || i.uniqueness || ')', ', ') 
        WITHIN GROUP (ORDER BY i.index_name) as indexes,
    LISTAGG(DISTINCT con.constraint_name || ' (' || con.constraint_type || ')', ', ') 
        WITHIN GROUP (ORDER BY con.constraint_name) as constraints
FROM user_tables t
LEFT JOIN user_tab_columns c ON t.table_name = c.table_name
LEFT JOIN user_indexes i ON t.table_name = i.table_name
LEFT JOIN user_constraints con ON t.table_name = con.table_name
WHERE t.table_name = 'EMPLOYEES'
GROUP BY t.table_name, t.tablespace_name, t.num_rows, t.last_analyzed;

--Мониторинг активности БД
-- Активность за последний час
SELECT 
    TO_CHAR(logon_time, 'HH24:MI') as hour,
    COUNT(*) as sessions_count,
    COUNT(DISTINCT username) as users_count,
    COUNT(DISTINCT machine) as machines_count
FROM v$session
WHERE logon_time > SYSDATE - 1/24
  AND username IS NOT NULL
GROUP BY TO_CHAR(logon_time, 'HH24:MI')
ORDER BY hour;