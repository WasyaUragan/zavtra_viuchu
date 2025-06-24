#!/bin/bash

message() {
    echo "========================================"
    echo "$1"
    echo "========================================"
    sleep 2
}

randomizer() {
    declare -g chislo=$((1 + $RANDOM % 100))
}

message "Загадываю число от 1 до 100 включительно..."

declare -i bet=1000
declare -i round=0

# использую read при простом выборе (Y/N), при нескольких вариантах использую select
choice() {
while true; do    
    read -p "Спорим на $bet деревянных, что не отгадаете? (y/n): " yn  
    case "$yn" in
        y|Y|[Yy][Ee][Ss])
            message " у Вас есть 3 попытки."
            break
            ;;
        n|N|[Nn][Oo])
            # ошибка, если отказ при первой итерации :)
            if (( round > 0 )); then
                bet=$((bet / 2))
                message "Игра завершена. Ваш долг: $bet деревянных"
            fi
            message "Не очень-то и хотелось!"
            exit
            ;;
        *)
            echo "Неверный выбор, попробуйте еще раз!"
    esac
done
}

# choice() {
# select yn in "Да" "Нет"; do
#     case $yn in
#         ...    
#     esac 
# done
# }

declare -i counter=3
declare -a spisok_otvetov=()

choice

game() {
    for ((i = 3; i > 0; i--))
    do
        # Валидация числа
        while true; do
            read -p "Введите число от 1 до 100 (включительно): " otvet
            if ! [[ "$otvet" =~ ^[0-9]+$ ]]; then
                message "Ошибка! Ожидаемый ввод - число в десятичной системе исчисления."
                continue
            fi
            if ((otvet < 1 || otvet > 100)); then
                message "Число должно быть от 1 до 100!"
                continue
            fi
            spisok_otvetov+=("$otvet")
            break
        done
    
    ((counter=--counter))  
    
    if (( otvet > chislo )); then
        message "Вы не угадали. Загаданное число - меньше."
    elif (( otvet < chislo )); then
        message "Вы не угадали. Загаданное число - больше."
    elif (( otvet == chislo )); then
        message "Правильно! Удача на Вашей стороне!"
        exit 0
    fi
    done
}

game

while (( counter == 0 )); do
    message "Вы исчерпали все попытки, Вы проиграли!"
    message "Хотите Отыграться?"
    message "Повысим ставки!"
    bet=$((bet*2))
    message "Моя ставка - $bet деревянных"
    message "Играем?"
    counter=3
    choice
    randomizer
    game
done 

# 1) вести список ответов и проверять, был ли этот вариант ранее

# 2) после победы юзера скрипт хочет отыграться
# нужно вести счет кто кому сколько должен 


