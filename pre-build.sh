#!/bin/bash

echo "=== НАЧАЛО КОМПИЛЯЦИИ ZAPRET 2 ==="

# Автоматически находим точный путь к папке репозитория внутри Docker
BASE_DIR=$(pwd)
echo "Текущая рабочая директория сборщика: $BASE_DIR"

# Переходим в папку nfq, которую мы добавим в корень репозитория
cd "$BASE_DIR/zapret-nfq" || { echo "ОШИБКА: Папка zapret-nfq не найдена в корне!"; exit 1; }

# Компилируем nfqws под процессор роутера MIPS
make CC=mipsel-linux-uclibc-gcc STRIP=mipsel-linux-uclibc-strip

# Проверяем успешность компиляции и подменяем файл в дереве сборки padavan-ng
if [ -f nfqws ]; then
    echo "=== Сборка nfqws2 прошла успешно! Подменяем бинарник... ==="
    TARGET_BIN=$(find "$BASE_DIR/padavan-ng" -type d -name "bin" | grep "trunk/user/zapret/bin" | head -n 1)
    
    if [ -z "$TARGET_BIN" ]; then
        # Если папки еще нет, создаем её вручную
        TARGET_BIN="$BASE_DIR/padavan-ng/trunk/user/zapret/bin"
        mkdir -p "$TARGET_BIN"
    fi
    
    cp nfqws "$TARGET_BIN/nfqws"
    chmod +x "$TARGET_BIN/nfqws"
    echo "Файл Zapret 2 успешно заменен в: $TARGET_BIN/nfqws"
else
    echo "=== ОШИБКА: Компиляция nfqws2 провалилась! ==="
    exit 1
fi

echo "=== ЗАВЕРШЕНИЕ ИНТЕГРАЦИИ ZAPRET 2 ==="
