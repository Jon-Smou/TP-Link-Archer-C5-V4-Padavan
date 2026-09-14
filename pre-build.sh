#!/bin/bash

echo "=== НАЧАЛО ИНТЕГРАЦИИ ZAPRET 2 ==="

# Фикс для старых версий git в контейнерах сборщика
git config --global url."https://github.com/".insteadOf "git@github.com:"

# 1. Скачиваем чистые исходники Zapret 2 во временную папку (с явным указанием ветки master)
git clone -b master https://github.com /tmp/zapret2

# 2. Переходим в папку с исходным кодом nfq (исправлено имя каталога)
cd /tmp/zapret2/nfq

# 3. Собираем бинарник nfqws2 под архитектуру роутера (используем тулчейн Padavan)
make CC=mipsel-linux-uclibc-gcc STRIP=mipsel-linux-uclibc-strip

# 4. Проверяем, собрался ли файл nfqws
if [ -f nfqws ]; then
    echo "=== Сборка nfqws2 прошла успешно! Подменяем файлы... ==="
    
    # Заменяем старый бинарник nfq в исходниках прошивки на новый собранный nfqws2
    cp nfqws $GITHUB_WORKSPACE/padavan-ng/trunk/user/zapret/bin/nfqws
    
    # Даем права на исполнение
    chmod +x $GITHUB_WORKSPACE/padavan-ng/trunk/user/zapret/bin/nfqws
else
    echo "=== ОШИБКА: Не удалось скомпилировать nfqws2! ==="
    exit 1
fi

echo "=== ЗАВЕРШЕНИЕ ИНТЕГРАЦИИ ZAPRET 2 ==="
