#!/bin/bash

file="./wget_list"

pushd "$1" # директория назначения задается параметром $1
while read line; do
	echo ===================
	echo ${line}
	wget ${line} --no-check-certificate
	echo ===================
done < ../${file}
popd
