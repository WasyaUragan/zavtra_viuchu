#!/bin/bash

source color.sh
source print_slow_ds.sh

# Оформление сообшения
Message() {
    echo -e "${BOLD}========================================${NC}"
    Print_slow "$1" 0.03
    echo -e "${BOLD}========================================${NC}"
    sleep 2
}

# Генерация случайного числа (от 1 до 100)
Randomizer() {
    declare -g chislo=$((1 + $RANDOM % 100))
}

Message "Загадываю число от ${GREEN}1${NC} до ${GREEN}100${NC} включительно"
Randomizer
echo "DEBUG: Ответ - $chislo"

declare -A spisok_otvetov=()
declare -i score=0
declare -i bet=1000
declare -i round=0
declare -i counter=6

# Если в игре 6 раундов
Counter() {
    case $counter in
        1)
            Message "У Вас осталось ${GREEN}$counter${NC} попытка"
            ;;
        2|3|4)
            Message "У Вас осталось ${GREEN}$counter${NC} попытки"
            ;;
        *)
            Message "У Вас осталось ${GREEN}$counter${NC} попыток"
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
            vopros="Спорим на ${GREEN}$bet${NC} деревянных, что не отгадаете? ${RED}(y/n)${NC}: "
        else
            vopros="Спорим, что не отгадаете? ${RED}(y/n)${NC}: "
        fi

        # Выводим приглашение как бегущую строку
        Print_slow "$vopros" 0.03 true  # true - без перевода строки

        read -r yn    
        case "$yn" in
            y|Y|[Yy][Ee][Ss])
                Message "У Вас есть ${GREEN}$counter${NC} попыток."
                break
                ;;
            n|N|[Nn][Oo])
                if (( round > 0 )); then
                    Message "🤝 Игра завершена. Игровой баланс: ${GREEN}$score${NC} деревянных 🤝"
                else
                    Message "${RED}🤬 Не очень-то и хотелось!${NC} 🤬"
                fi
                exit
                ;;
            *)
                Message "${YELLOW}Некорректный ввод, попробуйте еще раз!${NC}"
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
        local vopros1="Позвольте мне отыграться! ${RED}(y/n)${NC}: "
        Print_slow "$vopros1" 0.03 true

        read -r ehala
        case "$ehala" in
            y|Y|[Yy][Ee][Ss])
                sleep 2
                Message "😈 Продолжаем! 😈"
                ((score+=$bet))
                # Message "DEBUG: Игровой баланс после победы пользователя $score"
                Go_next_round
                break
                ;;
            n|N|[Nn][Oo])
                ((score+=$bet))
                Message "Спасибо за игру! Игровой баланс: ${GREEN}$score${NC} деревянных"
                exit
                ;;
            *)
                echo -e "${YELLOW}Некорректный ввод, попробуйте еще раз!${NC}"
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
            
            local vvod="Введите число от ${GREEN}1${NC} до ${GREEN}100${NC}: "
            Print_slow "$vvod" 0.03 true
            # Ответ содержит только цифры
            read -r otvet
            if ! [[ "$otvet" =~ ^[0-9]+$ ]]; then
                Message "${YELLOW}Ошибка! Ожидаемый ввод - число.${NC}"
                continue
            fi
            
            # Ответ - число от 1 до 100
            if ((otvet < 1 || otvet > 100)); then
                Message "${YELLOW}Число должно быть от${NC} ${GREEN}1${NC} до ${GREEN}100${NC}!"
                continue
            fi
            
            # Проверка на дублирование ответа
            if [[ -v spisok_otvetov[$otvet] ]]; then
                Message "${YELLOW}Вы уже называли${NC} ${GREEN}$otvet${NC}! ${YELLOW}Предложите другую версию!${NC}"
                continue
            else
                spisok_otvetov["$otvet"]=1
            fi

            break
        done

    ((counter--))  
    
    # Больше/Меньше
    if (( otvet > chislo )); then
        Message "${YELLOW}🔻 Вы не угадали. Загаданное число - меньше. 🔻${NC}"
        Counter
    elif (( otvet < chislo )); then
        Message "${YELLOW}🔺 Вы не угадали. Загаданное число - больше. 🔺${NC}"
        Counter
    elif (( otvet == chislo )); then
        Message "${GREEN}💰 Правильно! Удача на Вашей стороне! 💰${NC}"
        Revansh
    fi
    done
}

Go_next_round() {
    spisok_otvetov=()
    counter=6
    sleep 1
    bet=$((bet*2))
    Message "Моя ставка - ${GREEN}$bet${NC} деревянных"
    Randomizer
    echo "DEBUG: Ответ - $chislo"
    Game
}

Game

# При использовании ассоциативного массива, ответы выводятся в случайном порядке.
# Message "Список ответов: ${spisok_otvetov[*]}"
# Если порядок ответов критичен, можно ввести индексируемый массив дополнительно.

# Попадаю сюда после проигрыша в раунде
while true; do
    Message "${RED}Вы проиграли!${NC}"
    ((score -= $bet))
    # Message "DEBUG: Игровой баланс после поражения пользователя $score"
    sleep 1
    Message "👀 Сыграем еще раз? 👀"
    ((round++))
    Choice
    Go_next_round
done 

# при досрочном вводе ответа происходит перекос вывода сообзений, что усложняет восприятие. проработать этот момент.
# оформить визуальную часть цветами и эмодзи

# подумать над графикой