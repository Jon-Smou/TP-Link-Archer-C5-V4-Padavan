#!/bin/bash

echo "=== НАЧАЛО ИНТЕГРАЦИИ ZAPRET 2 ==="

# 1. Скачиваем чистый архив Zapret 2 с помощью curl, обрабатывая редиректы
curl -sL https://github.com -o /tmp/zapret2.tar.gz

# 2. Распаковываем tar.gz архив (он надежнее zip-архивов в этой среде)
tar -xzf /tmp/zapret2.tar.gz -C /tmp/

# 3. Переходим в папку с исходным кодом nfq (внутри архива папка называется zapret2-master)
cd /tmp/zapret2-master/nfq

# 4. Собираем бинарник nfqws под процессор роутера (MIPS)
make CC=mipsel-linux-uclibc-gcc STRIP=mipsel-linux-uclibc-strip

# 5. Проверяем, собран ли файл, и подменяем его в дереве исходников Padavan
if [ -f nfqws ]; then
    echo "=== Сборка nfqws2 прошла успешно! Подменяем файлы... ==="
    
    # Находим точный путь к папке встроенного запрета в репозитории padavan-ng
    TARGET_DIR=$(find $GITHUB_WORKSPACE -type d -name "zapret" | grep "trunk/user/zapret" | head -n 1)
    
    # Копируем свежий скомпилированный бинарник на место старого
    cp nfqws "$TARGET_DIR/bin/nfqws"
    chmod +x "$TARGET_DIR/bin/nfqws"
    
    echo "Файл успешно заменен в: $TARGET_DIR/bin/nfqws"
else
    echo "=== ОШИБКА: Не удалось скомпилировать nfqws2! ==="
    exit 1
fi

echo "=== ЗАВЕРШЕНИЕ ИНТЕГРАЦИИ ZAPRET 2 ==="
