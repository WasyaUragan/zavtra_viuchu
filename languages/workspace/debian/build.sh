#!/bin/bash

source color.sh
source print_slow_ds.sh

Message() {
    # echo -e "${BOLD}========================================${NC}"
    Print_slow "$1" 0.03
    echo -e "${BOLD}========================================${NC}"
    sleep 2
}

Message "Обновляю repo cache"
apt update

Message "Устанавливаю debootstrap на $HOSTNAME"
apt install debootstrap -y

Message "Создаю chroot"
debootstrap bullseye /opt/chroot/ http://deb.debian.org/debian/

Message "Монтирую /dev в chroot" 
mount --bind /dev /opt/chroot/dev

Message "Монтирую /proc в chroot"
mount --bind /proc /opt/chroot/proc

Message "Монтирую /sys в chroot" 
mount --bind /sys /opt/chroot/sys

Message "Копирую конфигурацию dns в chroot"
cp /etc/resolv.conf /opt/chroot/etc/

Message "Создаю директорию сборки"
mkdir /opt/chroot/opt/build_dir

Message "Копирую скрипт в chroot"
cp build_1.sh /opt/chroot/opt/build_dir

Message "Делаю скрипт исполняемым"
chmod +x /opt/chroot/opt/build_dir/build_1.sh

Message "Исполняю скрипт внудри chroot"
chroot /opt/chroot /opt/build_dir/build_1.sh
