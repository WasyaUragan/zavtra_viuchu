#!/bin/bash

repo_versions="binutils-2.41-38.el9.x86_64 binutils-2.41-38.el9_4.x86_64 binutils-2.35.2-54.el9_4.x86_64 binutils-2.41-38.el9_4.sz.x86_64 binutils-2.35.2-54.el9_4.sz.x86_64"

IFS=' ' read -ra versions_array <<< "$repo_versions"

# рабочий вариант, разделяет вывод в массив по '\n'
# IFS=$'\n' read -rd '' -a versions_array <<< "$repo_versions"

printf "%s\n" "${versions_array[@]}" | sort -V

# stable_100425 похож на рабочий вариант. нужно доработать 
# пока не пригодилась разбивка на части строки-пакета. удалить лишнее, причесать.

# косяк!
# Доступные версии:
# libtdb-1.4.10-1.el9_4.sz.x86_64
# libtdb-1.4.10-1.el9_4.x86_64

# Последняя версия:
# libtdb-1.4.10-1.el9_4.x86_64

# еще косяк!
# Доступные версии:
# libldb-2.9.1-2.el9_4.sz.x86_64
# libldb-2.9.1-2.el9_4.x86_64

# Последняя версия:
# libldb-2.9.1-2.el9_4.x86_64