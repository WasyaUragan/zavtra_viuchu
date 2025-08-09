#!/bin/bash

source message.sh

Message "Добавляю репозиторий с исходными текстами"
echo > /etc/apt/sources.list
sed -i '1a\deb http://deb.debian.org/debian bullseye main' /etc/apt/sources.list
sed -i '1a\deb-src http://deb.debian.org/debian bullseye main' /etc/apt/sources.list
sed -i '1a\deb http://security.debian.org/debian-security bullseye-security main' /etc/apt/sources.list
sed -i '1a\deb-src http://security.debian.org/debian-security bullseye-security main' /etc/apt/sources.list
sed -i '1a\deb http://deb.debian.org/debian/ bullseye-updates main' /etc/apt/sources.list
sed -i '1a\deb-src http://deb.debian.org/debian/ bullseye-updates main' /etc/apt/sources.list

Message "обновляю repo cache"
apt update

Message "устанавливаю необходимые пакеты в chroot"
apt install vim dpkg-source-gitarchive -y

Message "выкачиваю необходимые исходные тексты"
cd /opt/build_dir && apt source bash gawk sed

Message "установливаю необходимые для сборки зависимости"
apt build-dep bash gawk sed -y

Message "начинаю сборку пакетов bash gawk sed"

for i in $(find . -maxdepth 1 -type d | cut -b3-); do
    
    line="override_dh_auto_test:"
    file="./debian/rules"
    
    pushd ${i}

    if [ -f $file ]; then
        if grep -Fxq $line $file; then
            sed -i '25s/^/#/' $file
            sed -i '26s/^/#/' $file
            sed -i '27s/^/#/' $file
            sed -i '28s/^/#/' $file
        else
            echo "$line" >> $file
        fi
    else
        echo "File $file not found in ${i}"
    fi

    dpkg-buildpackage -rfakeroot -b -uc -us

    popd
done

Message "Путь к .deb пакетам: /opt/chroot/opt/build_dir/"   
ls -la /opt/build_dir/*.deb | cut -b60-