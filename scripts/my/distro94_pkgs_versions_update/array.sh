#!/bin/bash

repo_versions="binutils-2.41-38.el9.x86_64 binutils-2.41-38.el9_4.x86_64 binutils-2.35.2-54.el9_4.x86_64 binutils-2.41-38.el9_4.sz.x86_64 binutils-2.35.2-54.el9_4.sz.x86_64"

IFS=' ' read -ra versions_array <<< "$repo_versions"

# рабочий вариант, разделяет вывод в массив по '\n'
# IFS=$'\n' read -rd '' -a versions_array <<< "$repo_versions"

printf "%s\n" "${versions_array[@]}" | sort -V

# stable_100425 похож на рабочий вариант. нужно доработать преоритетный вывод 9_4.sz новее 9_4, сейчас наоборот. также el9_4.sz должен быть новее el9_4.0.1, сейчас наоборот.
# пока не пригодилась разбивка на части строки-пакета. удалить лишнее, причесать.