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

bet=1000
round=0
counter=7

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
                    bet=$((bet / 2))
                    Message "Игра завершена. Ваш долг: $bet деревянных"
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
                Go_next_round
                break
                ;;
            n|N|[Nn][Oo])
                Message "Спасибо за игру! Ваш долг: $bet деревянных"
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
        Revansh
    fi
    done
}

Go_next_round() {
    spisok_otvetov=()
    counter=7
    ((round++))
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
    sleep 1
    Message "Сыграем еще раз?"
    sleep 1
    bet=$((bet*2))
    Message "Моя ставка - $bet деревянных"
    Choice
    Go_next_round
done 

# нужно вести счет кто кому сколько должен 

# ввести "Осталось n попыток"

# печать сообщений бегущей строкой

# подумать над графикой