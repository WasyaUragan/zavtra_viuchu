#!/bin/bash

Message() {
    echo "========================================"
    echo "$1"
    echo "========================================"
    sleep 2
}

Randomizer() {
    declare -g chislo=$((1 + $RANDOM % 100))
}

Message "Загадываю число от 1 до 100 включительно..."
Randomizer

declare -i bet=1000
declare -i round=0

# использую read при простом выборе (Y/N), при нескольких вариантах использую select
Choice() {
while true; do    
    read -p "Спорим на $bet деревянных, что не отгадаете? (y/n): " yn  
    case "$yn" in
        y|Y|[Yy][Ee][Ss])
            Message " у Вас есть 3 попытки."
            break
            ;;
        n|N|[Nn][Oo])
            # ошибка, если отказ при первой итерации :)
            if (( round > 0 )); then
                bet=$((bet / 2))
                Message "Игра завершена. Ваш долг: $bet деревянных"
            fi
            Message "Не очень-то и хотелось!"
            exit
            ;;
        *)
            echo "Неверный выбор, попробуйте еще раз!"
    esac
done
}

# Choice() {
# select yn in "Да" "Нет"; do
#     case $yn in
#         ...    
#     esac 
# done
# }

declare -i counter=3
declare -ag SPISOK_OTVETOV=()

Choice

Game() {
    for ((i = 3; i > 0; i--))
    do
        # Валидация числа
        while true; do
            read -p "Введите число от 1 до 100 (включительно): " otvet
            if ! [[ "$otvet" =~ ^[0-9]+$ ]]; then
                Message "Ошибка! Ожидаемый ввод - число в десятичной системе исчисления."
                continue
            fi
            if ((otvet < 1 || otvet > 100)); then
                Message "Число должно быть от 1 до 100!"
                continue
            fi
            SPISOK_OTVETOV+=("$otvet")
            round+=1
            break
        done

    ((counter=--counter))  
    
    if (( otvet > chislo )); then
        Message "Вы не угадали. Загаданное число - меньше."
    elif (( otvet < chislo )); then
        Message "Вы не угадали. Загаданное число - больше."
    elif (( otvet == chislo )); then
        Message "Правильно! Удача на Вашей стороне!"
        exit 0
    fi
    done
}

Game

Message "Список ответов: ${SPISOK_OTVETOV[*]}"

while (( counter == 0 )); do
    Message "Вы исчерпали все попытки, Вы проиграли!"
    bet=$((bet*2))
    Message "Моя ставка - $bet деревянных"
    Message "Играем?"
    SPISOK_OTVETOV=()
    counter=3
    Choice
    Randomizer
    Game
done 

# 1) список ответов ведется, нужно проверять, был ли этот вариант ранее

# 2) после победы юзера скрипт хочет отыграться
# нужно вести счет кто кому сколько должен 


