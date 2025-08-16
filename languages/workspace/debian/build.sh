#!/bin/bash

# остановка выполнения при ошибке
set -euo pipefail
trap 'echo "Ошибка в $0 на строке $LINENO: Команда: $BASH_COMMAND"' ERR

source message.sh

# логгирование
exec > >(tee ./build.log) 2>&1

Message "Обновляю repo cache"
apt update

Message "Устанавливаю debootstrap на $HOSTNAME"
apt install debootstrap -y

Message "Создаю chroot"
rm -rf $HOME/chroot/
mkdir -p $HOME/chroot/
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
chmod +x $HOME/chroot/opt/build_dir/{build_1.sh,message.sh,color.sh,print_slow_ds.sh}
sed -i "3s|color.sh|/opt/build_dir/color.sh|"  /root/chroot/opt/build_dir/message.sh
sed -i "4s|print_slow_ds.sh|/opt/build_dir/print_slow_ds.sh|"  /root/chroot/opt/build_dir/print_slow_ds.sh

Message "Исполняю скрипт внудри chroot"
chroot $HOME/chroot /opt/build_dir/build_1.sh

# ERROR:
# ========================================
# [2025-08-16 12:48:20] Исполняю скрипт внудри chroot
# ========================================
# /opt/build_dir/message.sh: line 3: /root/chroot/opt/build_dir/color.sh: No such file or directory
# Ошибка в ./build.sh на строке 42: Команда: chroot $HOME/chroot /opt/build_dir/build_1.sh
# zhuzhu@debian ~/workspace_debian [1]> sudo ls -la /root/chroot/opt/build_dir/message.sh
# -rwxr-xr-x 1 root root 327 Aug 16 12:48 /root/chroot/opt/build_dir/message.sh
# zhuzhu@debian ~/workspace_debian> sudo ls -la /root/chroot/opt/build_dir/
# total 24
