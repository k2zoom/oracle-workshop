# Oracle Database 21c XE Workshop

Минимальная среда для проведения воркшопа по Oracle Database.

## Быстрый старт
### Вариант 1: Простой запуск (рекомендуется)
# Скачайте готовый скрипт и запустите
chmod +x start-oracle.sh
./start-oracle.sh

# Необходимый софт:
Docker-desktop
WSL - для Windows

Либо  
Docker для Linux

# Ручной запуск

# 1. Клонируйте репозиторий
git clone <репозиторий>
# 2. Перейдите в директорию
cd oracle-workshop
# 3. Запустите контейнер
docker-compose up -d
# 4. Дождитесь запуска (2-3 минуты)
# Проверьте статус:
docker-compose logs -f


# Команды для оракла
1. Проверить какой пользователь используется 
SELECT USER FROM dual;
