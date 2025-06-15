#!/bin/bash

echo "Загадываю число от 1 до 100 включительно..."
sleep 3s

declare -i chislo=$((1 + $RANDOM % 100))
declare -i bet=1000

echo "Спорим на $bet деревянных, что не отгадаешь?"

choice() {
select yn in "Да" "Нет"; do
    case $yn in
        Да ) echo " у Вас есть 7 попыток."; sleep 2s; break;;
        Нет ) exit;;
    esac 
done
}

declare -i counter=7

choice

game() {
for i in {1..7}
do
    echo "Введите число от 1 до 100 (включительно):"
    read otvet
    echo "Ваш вариант ответа: $otvet"
    sleep 2s

    ((counter=--counter))  
    

    if (( otvet > chislo )); then
        echo "Вы не угадали. Загаданное число - меньше."
    elif (( otvet < chislo )); then
        echo "Вы не угадали. Загаданное число - больше."
    elif (( otvet == chislo )); then
        echo "Правильно! Удача на Вашей стороне!"
        exit 0
    fi
done
}

game

while (( counter == 0 )); do
    sleep 2s; echo "ХА!"
    sleep 2s; echo "На пенек сел? $bet должен!"
    sleep 2s; echo "Отыграться хочешь?"
    sleep 2s; echo "Повысим ставки!"
    bet=$((bet*2))
    sleep 1s; echo "Моя ставка - $bet деревянных"
    sleep 2s; echo "Играем?"
    counter=7
    choice
    chislo=$((1 + $RANDOM % 100))
    game
done 

# после победы юзера скрипт хочет отыграться
# нужно вести счет кто кому сколько должен 