#!/bin/bash

source color.sh
source print_slow_ds.sh

Message() {
    # echo -e "${BOLD}========================================${NC}"
    Print_slow "$1" 0.03
    echo -e "${BOLD}========================================${NC}"
    sleep 2
}