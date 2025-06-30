#!/bin/bash

# Оформление сообшения
Message() {
    echo "========================================"
    echo "$1"
    echo "========================================"
    sleep 2
}

# Генерация случайного числа (от 1 до 100)
Randomizer() {
    declare -g chislo=$((1 + $RANDOM % 100))
}

Message "Загадываю число от 1 до 100 включительно"
Randomizer

declare -A spisok_otvetov=()
declare -i score=0
declare -i bet=1000
declare -i round=0
declare -i counter=7
declare -i flag=0 #true

# Для многострочных комментариев предпочтительнее использовать '#', а не heredoc. Тут для демострации возможностей bash.
<< 'COMMENT' 
    Использую read при простом выборе (Y/N).
    При нескольких вариантах использую select.
COMMENT

# Играем / Не играем
Choice() {
    while true; do
        local vopros
        if (( round == 0 )); then    
            vopros="Спорим на $bet деревянных, что не отгадаете? (y/n): "
        else
            vopros="Спорим, что не отгадаете? (y/n): "
        fi

        read -p "$vopros" yn    
        case "$yn" in
            y|Y|[Yy][Ee][Ss])
                Message "У Вас есть 7 попыток."
                break
                ;;
            n|N|[Nn][Oo])
                # ошибка, если отказ при первой итерации :)
                if (( round > 0 )); then
                    if (( flag == 0 )); then
                        ((score+=$bet))
                    else
                        ((score-=$bet))
                    fi
                    Message "Игра завершена. Ваш долг: $score деревянных"
                else
                    Message "Не очень-то и хотелось!"
                fi
                exit
                ;;
            *)
                echo "Некорректный ввод, попробуйте еще раз!"
                ;;
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

Choice

Revansh() {
    while true; do
        read -p "Позвольте мне отыграться! (y/n): " ehala
        case "$ehala" in
            y|Y|[Yy][Ee][Ss])
                sleep 2
                Message "Продолжаем!"
                if (( flag == 0 )); then
                    ((score+=$bet))
                else
                    ((score-=$bet))
                fi
                Message "DEBUG: Игровой баланс после победы пользователя $score"
                Go_next_round
                break
                ;;
            n|N|[Nn][Oo])
                Message "Спасибо за игру! Игровой баланс: $score деревянных"
                exit
                ;;
            *)
                echo "Некорректный ввод, попробуйте еще раз!"
                ;;
        esac
    done    
}

# Основной функционал.
Game() {
    for ((i = 7; i > 0; i--))
    do
        # Валидация числа
        while true; do
            # Ответ содержит только цифры
            read -p "Введите число от 1 до 100: " otvet
            if ! [[ "$otvet" =~ ^[0-9]+$ ]]; then
                Message "Ошибка! Ожидаемый ввод - число."
                continue
            fi
            
            # Ответ - число от 1 до 100
            if ((otvet < 1 || otvet > 100)); then
                Message "Число должно быть от 1 до 100!"
                continue
            fi
            
            # Проверка на дублирование ответа
            if [[ -v spisok_otvetov[$otvet] ]]; then
                Message "Вы уже называли $otvet! Предложите другую версию!"
                continue
            else
                spisok_otvetov["$otvet"]=1
            fi

            break
        done

    ((counter--))  
    
    # Больше/Меньше
    if (( otvet > chislo )); then
        Message "Вы не угадали. Загаданное число - меньше."
    elif (( otvet < chislo )); then
        Message "Вы не угадали. Загаданное число - больше."
    elif (( otvet == chislo )); then
        Message "Правильно! Удача на Вашей стороне!"
        flag=true
        Revansh
    fi
    done

    flag=1
}

Go_next_round() {
    ((score -= $bet))
    spisok_otvetov=()
    counter=7
    ((round++))
    sleep 1
    bet=$((bet*2))
    Message "Моя ставка - $bet деревянных"
    Randomizer
    Game
}

Game

# При использовании ассоциативного массива, ответы выводятся в случайном порядке.
# Message "Список ответов: ${spisok_otvetov[*]}"
# Если порядок ответов критичен, можно ввести индексируемый массив дополнительно.

# Вечный цикл
while true; do
    Message "Вы исчерпали все попытки, Вы проиграли!"
    flag=1
    Message "DEBUG: Игровой баланс после поражения пользователя $score"
    sleep 1
    Message "Сыграем еще раз?"
    Choice
    Go_next_round
done 

# пользователь выиграл 1ый раунд, дал боту реванш
# пользователь выиграл 2ый раунд, НЕ дал боту реванш - "Игровой баланс: 1000 деревянных", вместо 3000

# ввести "Осталось n попыток"

# печать сообщений бегущей строкой

# подумать над графикой