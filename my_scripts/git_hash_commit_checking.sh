#!/bin/bash

SHORT_HASH_COMMIT=(chrootww hash 1.0.1 1 17971224)

for i in ${SHORT_HASH_COMMIT[@]}; do
    flag=0
    if [ ${#i} != 8 ] && [ ${#i} != 40 ]; then
        flag=1
        continue
    else
        if HASH_COMMIT=$(git rev-parse $i 2>/dev/null); then
            echo $i is a git hash-commit.
	        exit
        else
            flag=1
            continue
        fi
    fi
done

    if [ $flag == 1 ]; then
	    echo There is no hash in this tag.
    fi