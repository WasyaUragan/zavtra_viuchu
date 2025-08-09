#!/bin/bash

Print_slow() {
    local text="$1"
    local delay="${2:-0.01}"  # Значение по умолчанию 0.01 сек
    local no_newline="${3:-false}" # Параметр для отключения перевода строки

    # Обработка escape-последовательностей
    local processed_text
    processed_text=$(echo -e "$text")
    
    # Проходим по строке как по массиву символов
    local i=0
    local len=${#processed_text}
    
    while (( i < len )); do
        # Обработка escape-последовательностей
        if [[ "${processed_text:$i:1}" == $'\e' ]]; then
            local seq_start=$i
            local seq_end=$((i+1))
            
            # Ищем конец последовательности (букву)
            while (( seq_end < len )) && 
                  [[ ! "${processed_text:$seq_end:1}" =~ [a-zA-Z] ]]; do
                ((seq_end++))
            done
            
            # Включаем завершающую букву
            if (( seq_end < len )); then
                ((seq_end++))
            fi
            
            local seq="${processed_text:$seq_start:$((seq_end - seq_start))}"
            echo -n "$seq"
            i=$seq_end
            continue
        fi
        
        # Определяем длину UTF-8 символа
        local byte_val
        printf -v byte_val '%d' "'${processed_text:$i:1}"
        local char_len=1
        
        if (( byte_val & 0x80 )); then
            if (( (byte_val & 0xE0) == 0xC0 )); then char_len=2
            elif (( (byte_val & 0xF0) == 0xE0 )); then char_len=3
            elif (( (byte_val & 0xF8) == 0xF0 )); then char_len=4
            fi
        fi
        
        # Выводим символ
        echo -n "${processed_text:$i:$char_len}"
        sleep "$delay"  # Используем указанную задержку
        
        ((i += char_len))
    done
    
    # Добавляем перевод строки только если не установлен флаг no_newline
    if [[ "$no_newline" != "true" ]]; then
        echo
    fi
}
