#!/bin/bash

file="./pkgs.txt"

while read line; do
    echo ===================
    echo ${line} 
    dnf download --destdir='rpms_4_miniso' ${line}
    echo ===================
done < ${file}