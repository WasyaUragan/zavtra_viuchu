#!/bin/bash

ls -la ../ | grep '\.patch' | awk -F " " '{ print $(NF) }' > ../tmp
file="../tmp"

while read line; do
    echo ===================
    echo ${line} 
    patch -p1 <../${line}
    echo ===================
done < ${file}
