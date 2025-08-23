#!/bin/bash

# остановка выполнения при ошибке
set -euo pipefail
trap 'echo "Ошибка в $0 на строке $LINENO: Команда: $BASH_COMMAND"' ERR

source message.sh

CHROOT_DIR="$HOME/chroot"

# логгирование
exec > >(tee ./build.log) 2>&1

Message "Обновляю repo cache"
apt update

Message "Устанавливаю debootstrap на $HOSTNAME"
apt install debootstrap -y
# добавляю в $PATH путь к debootstrap
PATH="$PATH:/usr/sbin/"

Message "Создаю chroot"
rm -rf "$CHROOT_DIR/"
mkdir -p "$CHROOT_DIR/"
debootstrap --include=vim,dpkg-source-gitarchive bullseye "$CHROOT_DIR/" http://deb.debian.org/debian/

Message "Монтирую /dev /proc /sys в chroot"
for i in dev proc sys; do
    mkdir -p "$HOME/chroot/$i"
    mount --bind "/$i" "$CHROOT_DIR/$i"
done

Message "Копирую конфигурацию dns в chroot"
cp /etc/resolv.conf "$CHROOT_DIR/etc/"

Message "Создаю директорию сборки"
mkdir -p "$CHROOT_DIR/opt/build_dir"

Message "Копирую необходимые скрипты в chroot"
cp {build_1.sh,message.sh,color.sh,print_slow_ds.sh} "$CHROOT_DIR/opt/build_dir"
chmod +x "$CHROOT_DIR/opt/build_dir"/*.sh

Message "Исправляю пути в message.sh"
TEMP_MSG=$(mktemp)
sed 's|source color.sh|source /opt/build_dir/color.sh|' "$CHROOT_DIR/opt/build_dir/message.sh" > "$TEMP_MSG"
sed 's|source print_slow_ds.sh|source /opt/build_dir/print_slow_ds.sh|' "$TEMP_MSG" > "$CHROOT_DIR/opt/build_dir/message.sh"
rm -f "$TEMP_MSG"
# sed -i 's|source color.sh|source /opt/build_dir/color.sh|; s|source print_slow_ds.sh|source /opt/build_dir/print_slow_ds.sh|' "$CHROOT_DIR/opt/build_dir/message.sh"

Message "Исполняю скрипт внудри chroot"
chroot "$CHROOT_DIR" /opt/build_dir/build_1.sh

# задавать собираемые пакеты параметрами при вызове скрипта
# собранные пакеты перемещать в отдельную папку, очищать сборочную директорию после сборки, отмонтировать из чрута /dev и т д