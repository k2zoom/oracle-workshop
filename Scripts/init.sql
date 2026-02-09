-- Скрипт создаст пользователя для воркшопа при первом запуске контейнера
ALTER SESSION SET "_ORACLE_SCRIPT"=TRUE;
CREATE USER workshop_user IDENTIFIED BY "StudentPass123!"
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON users;
GRANT CONNECT, RESOURCE TO workshop_user;
GRANT CREATE VIEW, CREATE PROCEDURE, CREATE TRIGGER TO workshop_user;
GRANT UNLIMITED TABLESPACE TO workshop_user;
