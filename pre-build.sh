#!/bin/bash

echo "=== НАЧАЛО КОМПИЛЯЦИИ ZAPRET 2 ==="

# Переходим в папку с исходным кодом nfq, который уже подготовил GitHub
cd $GITHUB_WORKSPACE/padavan-ng/trunk/user/zapret/nfq

# Собираем бинарник nfqws под процессор роутера (MIPS)
make CC=mipsel-linux-uclibc-gcc STRIP=mipsel-linux-uclibc-strip

# Проверяем, собран ли файл, и копируем его в нужную папку
if [ -f nfqws ]; then
    echo "=== Сборка nfqws2 прошла успешно! Подменяем файлы... ==="
    cp nfqws $GITHUB_WORKSPACE/padavan-ng/trunk/user/zapret/bin/nfqws
    chmod +x $GITHUB_WORKSPACE/padavan-ng/trunk/user/zapret/bin/nfqws
    echo "Файл успешно заменен!"
else
    echo "=== ОШИБКА: Не удалось скомпилировать nfqws2! ==="
    exit 1
fi

echo "=== ЗАВЕРШЕНИЕ КОМПИЛЯЦИИ ZAPRET 2 ==="
