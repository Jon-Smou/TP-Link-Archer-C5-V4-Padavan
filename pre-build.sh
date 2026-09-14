#!/bin/bash

echo "=== НАЧАЛО ИНТЕГРАЦИИ ZAPRET 2 ==="

# 1. Скачиваем исходники Zapret 2 в виде стабильного ZIP-архива с помощью wget
wget -qO /tmp/zapret2.zip https://github.com

# 2. Распаковываем архив во временную папку
unzip -q /tmp/zapret2.zip -d /tmp/

# 3. Переходим в папку с исходным кодом nfq (у папки из архива имя будет 'zapret2-master')
cd /tmp/zapret2-master/nfq

# 4. Собираем бинарник nfqws под архитектуру роутера (используем тулчейн Padavan)
make CC=mipsel-linux-uclibc-gcc STRIP=mipsel-linux-uclibc-strip

# 5. Проверяем, собрался ли файл nfqws
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
