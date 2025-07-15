#!/bin/bash

file="./wget_list"

pushd "$1"  # директория назначения задается параметром $1
while IFS= read -r pkg; do

        filename="${pkg##*/}" # удаляет самую длинную подстроку до последнего /
        # awk -F'/' '{print $NF}' ${pkg}
        # echo ${pkg} | rev | cut -d'/' -f1 | rev

        echo ======================================
        echo "$pkg"     
        echo --------------------------------------

        if [[ -f "$filename" ]]; then
                echo "Пакет $filename уже существует"
        else
                echo "Скачиваю пакет $filename"
                wget ${pkg} --no-check-certificate
        fi

done < ../${file}

createrepo .
popd