#!/bin/bash

source color.sh
source print_slow_ds.sh

# Оформление сообшения
Message() {
    echo "========================================"
    Print_slow "$1" 0.03
    echo "========================================"
    sleep 2
}

# Генерация случайного числа (от 1 до 100)
Randomizer() {
    declare -g chislo=$((1 + $RANDOM % 100))
}

Message "Загадываю число от 1 до 100 включительно"
Randomizer
# echo "DEBUG: Ответ - $chislo"

declare -A spisok_otvetov=()
declare -i score=0
declare -i bet=1000
declare -i round=0
declare -i counter=6

# Если в игре 6 раундов
Counter() {
    case $counter in
        1)
            Message "У Вас осталось $counter попытка"
            ;;
        2|3|4)
            Message "У Вас осталось $counter попытки"
            ;;
        *)
            Message "У Вас осталось $counter попыток"
            ;;
    esac
}

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

        # Выводим приглашение как бегущую строку
        Print_slow "$vopros" 0.03 true  # true - без перевода строки

        read -r yn    
        case "$yn" in
            y|Y|[Yy][Ee][Ss])
                Message "У Вас есть $counter попыток."
                break
                ;;
            n|N|[Nn][Oo])
                if (( round > 0 )); then
                    Message "Игра завершена. Ваш долг: $score деревянных"
                else
                    Message "Не очень-то и хотелось!"
                fi
                exit
                ;;
            *)
                Message "Некорректный ввод, попробуйте еще раз!"
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

# Попадаю сюда после выигранного раунда
Revansh() {
    while true; do
        local vopros1="Позвольте мне отыграться! (y/n): "
        Print_slow "$vopros1" 0.03 true

        read -r ehala
        case "$ehala" in
            y|Y|[Yy][Ee][Ss])
                sleep 2
                Message "Продолжаем!"
                ((score+=$bet))
                # Message "DEBUG: Игровой баланс после победы пользователя $score"
                Go_next_round
                break
                ;;
            n|N|[Nn][Oo])
                ((score+=$bet))
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
    for ((i = 6; i > 0; i--))
    do
        # Валидация числа
        while true; do
            
            local vvod="Введите число от 1 до 100: "
            Print_slow "$vvod" 0.03 true
            # Ответ содержит только цифры
            read -r otvet
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
        Counter
    elif (( otvet < chislo )); then
        Message "Вы не угадали. Загаданное число - больше."
        Counter
    elif (( otvet == chislo )); then
        Message "Правильно! Удача на Вашей стороне!"
        Revansh
    fi
    done
}

Go_next_round() {
    spisok_otvetov=()
    counter=6
    sleep 1
    bet=$((bet*2))
    Message "Моя ставка - $bet деревянных"
    Randomizer
    # echo "DEBUG: Ответ - $chislo"
    Game
}

Game

# При использовании ассоциативного массива, ответы выводятся в случайном порядке.
# Message "Список ответов: ${spisok_otvetov[*]}"
# Если порядок ответов критичен, можно ввести индексируемый массив дополнительно.

# Попадаю сюда после проигрыша в раунде
while true; do
    Message "Вы проиграли!"
    ((score -= $bet))
    # Message "DEBUG: Игровой баланс после поражения пользователя $score"
    sleep 1
    Message "Сыграем еще раз?"
    ((round++))
    Choice
    Go_next_round
done 

# при досрочном вводе ответа происходит перекос вывода сообзений, что усложняет восприятие. проработать этот момент.
# оформить визуальную часть цветами и эмодзи

# подумать над графикой