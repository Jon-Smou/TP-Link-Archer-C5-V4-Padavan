#!/bin/bash

echo "=== НАЧАЛО ИНТЕГРАЦИИ ZAPRET 2 ==="

# Скачиваем архив исходников с помощью Python (он встроен в контейнер и работает со 100% стабильностью сети)
python3 -c "import urllib.request; urllib.request.urlretrieve('https://github.com', '/tmp/z2.zip')"

# Распаковываем архив
unzip -q /tmp/z2.zip -d /tmp

# Создаем структуру папок в репозитории Padavan, если она еще не создана автоматикой
mkdir -p $GITHUB_WORKSPACE/padavan-ng/trunk/user/zapret
cp -r /tmp/zapret2-master/nfq $GITHUB_WORKSPACE/padavan-ng/trunk/user/zapret/

# Переходим в папку и компилируем nfqws2
cd $GITHUB_WORKSPACE/padavan-ng/trunk/user/zapret/nfq
make CC=mipsel-linux-uclibc-gcc STRIP=mipsel-linux-uclibc-strip

# Проверяем успешность компиляции и подменяем оригинальный файл
if [ -f nfqws ]; then
    echo "=== Сборка nfqws2 прошла успешно! ==="
    mkdir -p $GITHUB_WORKSPACE/padavan-ng/trunk/user/zapret/bin
    cp nfqws $GITHUB_WORKSPACE/padavan-ng/trunk/user/zapret/bin/nfqws
    chmod +x $GITHUB_WORKSPACE/padavan-ng/trunk/user/zapret/bin/nfqws
    echo "Файл Zapret 2 успешно вшит!"
else
    echo "=== ОШИБКА: Компиляция nfqws2 провалилась! ==="
    exit 1
fi

echo "=== ЗАВЕРШЕНИЕ ИНТЕГРАЦИИ ZAPRET 2 ==="
