#!/bin/bash

file="./f2d"

while read line; do
    echo ===================
    echo ${line} 
    rm -rf ${line}
    echo ===================
done < ${file}
