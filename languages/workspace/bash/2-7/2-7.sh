#!/bin/bash

LINE='======================='

echo $LINE
pushd photo > /dev/null
for i in {2019..2020}; do
    pushd $i > /dev/null
    echo $(pwd)
    echo $LINE
    for y in $(find . -type d | grep 1); do
        #pushd $(find . -type d | grep 1 | cut -c3-) > /dev/null
        pushd $y > /dev/null
        tar -czf ../$y.tar.gz ./*
        tar -tf ../$y.tar.gz
        popd > /dev/null
        #rm -rf $y
        echo $LINE
    done
    popd > /dev/null
done
popd > /dev/null
tree && echo $LINE

# find photo -type d -path '*/2019/*' -o -path '*/2020/*' -print0 | awk -F'/' '{print $1"/"$2"/"$3"/"}' | xargs -0 -I% tar  --strip-components=3 -czf %.tar.xz %

# s#pattern#replacement#
# sed 's#^\([^/]*/[^/]*/[^/]*/\).*#\1#')
