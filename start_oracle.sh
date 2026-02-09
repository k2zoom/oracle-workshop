#!/bin/bash
# Скрипт для сборки и запуска Oracle для воркшопа

set -e

echo "=== Oracle Workshop Environment ==="

read -p "Собрать Docker образ? (y/n): " BUILD
if [[ $BUILD == "y" ]]; then
    echo "Сборка образа Oracle Database 21c XE..."
    docker build -t oracle-workshop:21c .
fi

echo "Проверка портов..."
PORTS=(1521 5500 8080)
for PORT in "${PORTS[@]}"; do
    if lsof -i :$PORT > /dev/null; then
        echo "⚠️  Порт $PORT занят! Освободите его перед запуском."
        exit 1
    fi
done

echo "Запуск Oracle Database..."
docker-compose up -d

echo "Ожидание полного старта базы данных (это займет 2-3 минуты)..."
sleep 60
echo "Проверка статуса..."
for i in {1..30}; do
    if docker exec oracle-workshop healthcheck.sh > /dev/null 2>&1; then
        echo "✅ Oracle Database готова к работе!"
        break
    fi
    echo "Ожидание... ($i/30)"
    sleep 10
done

echo ""
echo "========================================="
echo "Соединение установлено!"
echo ""
echo "Подключение через SQLcl/SQL Developer:"
echo "  Host: localhost"
echo "  Port: 1521"
echo "  Service: XE"
echo "  Пользователи:"
echo "    - system/StudentPass123!"
echo "    - workshop_user/StudentPass123!"
echo ""
echo "Веб-интерфейсы:"
echo "  - Enterprise Manager: https://localhost:5500/em"
echo "  - REST API: http://localhost:8080/ords/workshop/"
echo ""
echo "Команды управления:"
echo "  • Просмотр логов: docker-compose logs -f"
echo "  • Остановка: docker-compose down"
echo "  • Остановка с сохранением данных: docker-compose stop"
echo "========================================="