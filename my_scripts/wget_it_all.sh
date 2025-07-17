#!/bin/bash

file="./wget_list"

pushd "$1"  # директория назначения задается параметром $1
while IFS= read -r pkg; do

        if [[ "$pkg" == "[Pipeline] echo" ]]; then
                continue
        fi

        filename="${pkg##*/}" # удаляет самую длинную подстроку до последнего /
        echo "DEBUG: $filename"
        # awk -F'/' '{print $NF}' ${pkg}
        # echo ${pkg} | rev | cut -d'/' -f1 | rev

        echo ======================================
        echo "$pkg"     
        echo --------------------------------------

        if [[ -f "$filename" ]]; then
                echo "Пакет $filename уже существует"
        else
                echo "Скачиваю пакет $filename"
                echo
                wget ${pkg} --no-check-certificate
        fi

done < ../${file}

createrepo .
popd

# выделить из $filename название без версии - удалить все старые пакеты "rm -rf./название*" перед скачиванием новой