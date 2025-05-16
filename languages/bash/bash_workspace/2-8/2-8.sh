#!/bin/bash

# Напишите команду, работающую по такому алгоритму:
# 1. Скопировать файл README с документацией по Bash в каталог пользователя.
# 2. Архивировать скопированный файл README.
# 3. Удалить скопированный файл README.
# Каждый шаг выполняется только, если предыдущий завершился успешно.
# Результат каждого шага записывается в лог-файл result.txt.


# /home/zhuzhu/GIT/zavtra_viuchu/languages/bash/bash_workspace/ "$1"

cd /usr/share/doc/bash/ \
&& tar -czvf "$1"README.tar.gz README >> "$1"file.log 2>&1 \
&& cp -v "$1"README.tar.gz "$1"READYOU.tar.gz >> "$1"file.log 2>&1 \
&& cd "$1"
