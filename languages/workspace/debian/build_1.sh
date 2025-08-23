#!/bin/bash

# остановка выполнения при ошибке
set -euo pipefail
trap 'echo "Ошибка в $0 на строке $LINENO: Команда: $BASH_COMMAND"' ERR

source /opt/build_dir/message.sh

# отключение тестов
export DEB_BUILD_OPTIONS="nocheck"
export DEB_CFLAGS_SET="-O2"

Message "Добавляю репозиторий с исходными текстами"
cat <<EOF > /etc/apt/sources.list
deb http://deb.debian.org/debian bullseye main
deb-src http://deb.debian.org/debian bullseye main
deb http://security.debian.org/debian-security bullseye-security main
deb-src http://security.debian.org/debian-security bullseye-security main
deb http://deb.debian.org/debian/ bullseye-updates main
deb-src http://deb.debian.org/debian/ bullseye-updates main
EOF

Message "обновляю repo cache"
apt update

Message "устанавливаю необходимые пакеты в chroot"
apt install vim dpkg-source-gitarchive fakeroot build-essential devscripts -y \
    && apt build-dep bash gawk sed -y

Message "выкачиваю необходимые исходные тексты"
cd /opt/build_dir && apt source bash gawk sed

Message "начинаю сборку пакетов bash gawk sed"

# Находим все директории (исключая точки и специальные директории)
for package_dir in $(find . -maxdepth 1 -type d ! -name "." ! -name ".." -printf '%f\n'); do
    # Проверяем, содержит ли директория необходимые файлы для сборки
    if [ -f "${package_dir}/debian/changelog" ] && [ -f "${package_dir}/debian/control" ]; then
        Message "Собираю пакет: $package_dir"
        pushd "$package_dir"
        
        # Запускаем сборку
        dpkg-buildpackage -j$(nproc) -rfakeroot -b -uc -us
        
        # Возвращаемся обратно в /opt/build_dir
        popd
    else
        Message "Пропускаю $package_dir (не содержит файлов для сборки Debian пакета)"
    fi
done

Message "Собранные .deb пакеты:"  
find /opt/build_dir -maxdepth 1 -name "*.deb" -exec ls -la {} \;