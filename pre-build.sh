#!/bin/bash

echo "=== НАЧАЛО ИНТЕГРАЦИИ ZAPRET 2 ==="

# 1. Скачиваем чистые исходники Zapret 2 во временную папку
git clone --depth 1 https://github.com /tmp/zapret2

# 2. Переходим в папку с исходным кодом nfqws
cd /tmp/zapret2/nfq2

# 3. Собираем бинарник nfqws2 под архитектуру роутера (используем тулчейн Padavan)
# В контейнере padavan-ng кросс-компилятор mipsel-linux-uclibc-gcc уже установлен в PATH
make CC=mipsel-linux-uclibc-gcc STRIP=mipsel-linux-uclibc-strip

# 4. Проверяем, собрался ли файл nfqws2
if [ -f nfqws2 ]; then
    echo "=== Сборка nfqws2 прошла успешно! Подменяем файлы... ==="
    
    # Заменяем старый бинарник nfqws в исходниках прошивки на новый nfqws2
    cp nfqws2 $GITHUB_WORKSPACE/padavan-ng/trunk/user/zapret/bin/nfqws
    
    # На всякий случай даем права на исполнение
    chmod +x $GITHUB_WORKSPACE/padavan-ng/trunk/user/zapret/bin/nfqws
else
    echo "=== ОШИБКА: Не удалось скомпилировать nfqws2! ==="
    exit 1
fi

echo "=== ЗАВЕРШЕНИЕ ИНТЕГРАЦИИ ZAPRET 2 ==="
