#!/bin/bash

source message.sh


Message "Обновляю repo cache"
apt update

Message "Устанавливаю debootstrap на $HOSTNAME"
apt install debootstrap -y

Message "Создаю chroot"
debootstrap --include=vim,dpkg-source-gitarchive bullseye $HOME/chroot/ http://deb.debian.org/debian/

Message "Монтирую /dev /proc /sys в chroot"
for i in dev proc sys; do
    mkdir -p $HOME/chroot/$i
    mount --bind /$i $HOME/chroot/$i
done

Message "Копирую конфигурацию dns в chroot"
cp /etc/resolv.conf $HOME/chroot/etc/

Message "Создаю директорию сборки"
mkdir -p $HOME/chroot/opt/build_dir

Message "Копирую необходимые скрипты в chroot"
cp {build_1.sh,message.sh,color.sh,print_slow_ds.sh} $HOME/chroot/opt/build_dir

Message "Делаю скрипты исполняемыми"
chmod +x $HOME/chroot/opt/build_dir/{build_1.sh,message.sh,color.sh,print_slow_ds.sh}

Message "Исполняю скрипт внудри chroot"
chroot $HOME/chroot /opt/build_dir/build_1.sh

#добавить остановку выполнения в случае ошибки