#!/bin/bash

# ПРОВЕРКА: Если скрипт запущен на хосте GitHub Actions (где ЕСТЬ ИНТЕРНЕТ)
if [ -n "$GITHUB_WORKSPACE" ] && [ ! -f "/.dockerenv" ]; then
    echo "=== [ХОСТ GITHUB] СКАЧИВАНИЕ ИСХОДНИКОВ ZAPRET 2 ==="
    
    # Скачиваем архив силами GitHub Actions
    curl -sL https://github.com -o /tmp/zapret2.tar.gz
    tar -xzf /tmp/zapret2.tar.gz -C /tmp/
    
    # Создаем структуру папок внутри дерева Padavan и копируем исходники nfq
    mkdir -p "$GITHUB_WORKSPACE/padavan-ng/trunk/user/zapret"
    cp -r /tmp/zapret2-master/nfq "$GITHUB_WORKSPACE/padavan-ng/trunk/user/zapret/"
    
    echo "=== [ХОСТ GITHUB] ИСХОДНИКИ УСПЕШНО ПОДГОТОВЛЕНЫ ==="
    exit 0
fi

# ПРОВЕРКА: Если скрипт запущен внутри изолированного Docker-контейнера (где НЕТ ИНТЕРНЕТА)
echo "=== [DOCKER] НАЧАЛО КОМПИЛЯЦИИ ZAPRET 2 ==="

# Задаем базовый путь, если переменная очистилась в контейнере
BASE_DIR="/__w/TP-Link-Archer-C5-V4-Padavan/TP-Link-Archer-C5-V4-Padavan"

# Переходим в папку nfq, которую хост GitHub подготовил заранее
cd "$BASE_DIR/padavan-ng/trunk/user/zapret/nfq" || exit 1

# Компилируем nfqws под процессор роутера MIPS
make CC=mipsel-linux-uclibc-gcc STRIP=mipsel-linux-uclibc-strip

# Проверяем успешность компиляции и переносим бинарник на место старого
if [ -f nfqws ]; then
    echo "=== [DOCKER] Сборка nfqws2 прошла успешно! ==="
    mkdir -p "$BASE_DIR/padavan-ng/trunk/user/zapret/bin"
    cp nfqws "$BASE_DIR/padavan-ng/trunk/user/zapret/bin/nfqws"
    chmod +x "$BASE_DIR/padavan-ng/trunk/user/zapret/bin/nfqws"
    echo "Бинарный файл Zapret 2 успешно вшит в прошивку!"
else
    echo "=== [DOCKER] ОШИБКА: Компиляция nfqws2 провалилась! ==="
    exit 1
fi

echo "=== [DOCKER] ЗАВЕРШЕНИЕ ИНТЕГРАЦИИ ZAPRET 2 ==="
