#!/bin/bash

ls -la | grep '\.tar\.' | awk -F " " '{ print $(NF) }' > tmp
file="./tmp"

while read line; do
    echo ===================
    echo ${line} 
    tar -xf ./${line}
    echo ===================
done < ${file}

