#!/bin/bash

echo "Загадываю число от 1 до 100 включительно..."
sleep 3s

declare -i chislo=$((1 + $RANDOM % 100))
declare -i bet=1000

echo "Спорим на $bet деревянных, что не отгадаешь?"

select yn in "Да" "Нет"; do
    case $yn in
        Да ) echo " у Вас есть 7 попыток."; sleep 2s; break;;
        Нет ) exit;;
    esac
done

declare -i counter=7

for i in {1..7}
do
    echo "Введите число от 1 до 100 (включительно):"
    read otvet
    echo "Ваш вариант ответа: $otvet"
    sleep 2s

    ((counter=--counter))

    if (($counter==0)); then
        sleep 2s
        echo "ХА!"
        sleep 2s
        echo "На пенек сел? $bet должен!"
        sleep 2s
        echo "Повысим ставки?"
        bet=$bet*2 
        echo "Моя ставка - $bet деревянных"
        sleep 2s
        
        select yn in "Да" "Нет"; do
            case $yn in
                Да ) echo " у Вас есть 7 попыток."; sleep 2s;;
                Нет ) exit;;
            esac
        done
    fi    

    if [[ "$otvet" > "$chislo" ]]; then
        echo "Вы не угадали. Загаданное число - больше. У Вас осталось $counter попыток."
    elif [[ "$otvet" < "$chislo" ]]; then
        echo "Вы не угадали. Загаданное число - меньше. У Вас осталось $counter попыток."
    #elif [[ "$otvet" == "$chislo" ]]
    else
        echo "Правильно! Удача на Вашей стороне!"
    fi
done

