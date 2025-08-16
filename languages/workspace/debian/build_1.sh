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
apt install vim dpkg-source-gitarchive -y \
    && apt build-dep bash gawk sed -y

Message "выкачиваю необходимые исходные тексты"
cd /opt/build_dir && apt source bash gawk sed

Message "начинаю параллельную сборку пакетов bash gawk sed"
dpkg-buildpackage -j$(nproc) -rfakeroot -b -uc -us

Message "Путь к .deb пакетам в chroot: /opt/build_dir/"   
ls -la /opt/build_dir/*.deb | cut -b60-