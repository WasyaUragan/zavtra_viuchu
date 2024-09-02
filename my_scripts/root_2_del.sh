#!/bin/bash

ls -la:q | grep '\.tar\.' | awk -F " " '{ print $(NF) }' > tmp
file="./tmp"

while read line; do
    echo ===================
    echo ${line} 
    tar -xf ./${line}
    echo ===================
done < ${file}

