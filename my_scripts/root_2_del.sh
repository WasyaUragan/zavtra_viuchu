#!/bin/bash

sudo find . -type d -name 'root' > root_2_del

file="./root_2_del"

while read line; do
    echo ===================
    echo ${line}
    rm -rf ./${line}
    echo ===================
done < ${file}


