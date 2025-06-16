#!/bin/bash

message() {
    echo "========================================"
    echo "$1"
    echo "========================================"
    sleep 2
}

randomizer() {
    declare -i chislo=$((1 + $RANDOM % 100))
}

message "Загадываю число от 1 до 100 включительно..."

declare -i chislo=$((1 + $RANDOM % 100))
declare -i bet=1000

message "Спорим на $bet деревянных, что не отгадаешь?"

choice() {
select yn in "Да" "Нет"; do
    case $yn in
        Да)
            message " у Вас есть 7 попыток."; break;;
        Нет)
            bet=$((bet/2))
            message "Игра завершена. Ваш долг: $bet деревянных"; exit;;
    esac 
done
}

declare -i counter=7
declare -a spisok_otvetov=()

choice

game() {
    for ((i = 7; i > 0; i--))
    do
        while true; do
            read -p "Введите число от 1 до 100 (включительно): " otvet
            spisok_otvetov+=("$otvet")
            [[ "$otvet" =~ ^[0-9]+$ ]] && break
            message "Ошибка: введите корректное число!"
        done
    # do
        # message "Введите число от 1 до 100 (включительно):"
        # read otvet
        # message "Ваш вариант ответа: $otvet"
    
    spisok_otvetov+=("$otvet")
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
    counter=7
    choice
    randomizer
    game
done 

# 1) добить проверку на числа в диапазоне 1 - 100
# вести список ответов и проверять, был ли этот вариант ранее

# 2) после победы юзера скрипт хочет отыграться
# нужно вести счет кто кому сколько должен 