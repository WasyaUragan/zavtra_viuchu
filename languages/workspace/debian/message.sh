#!/bin/bash

source color.sh
source print_slow_ds.sh

Message() {
    echo -e "${BOLD}========================================${NC}"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    Print_slow "[$timestamp] $1" 0.03
    echo -e "${BOLD}========================================${NC}"
    sleep 2
}