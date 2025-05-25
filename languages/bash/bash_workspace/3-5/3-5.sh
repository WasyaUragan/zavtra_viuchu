#!/bin/bash

dir1="/usr/bin"
dir2="/usr/sbin"

echo "Файлы только в dir1:"
for file in $dir1/*; do
    if [[ -f "$file" ]]; then
        filename=$(basename "$file")
        if [[ ! -e "$dir2/$filename" ]]; then
            echo "- $filename"
        fi
    fi
done
    















