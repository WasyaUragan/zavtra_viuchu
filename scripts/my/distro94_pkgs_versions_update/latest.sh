#!/bin/bash

Задача написать функцию, определяющую новейшую версию из списка доступных версий, полученных в результате команды repoquery:

local repo_versions=$(repoquery --qf "%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}\n" "$pkg_name" 2>/dev/null | grep "${pkg_arch}$")

Вывод $repo_versions на примере пакета capstone:
capstone-4.0.2-10.el9_4.sz.x86_64
capstone-4.0.2-10.el9_4.x86_64



latest () {
    if [[ -n "$repo_versions" ]]; then

}