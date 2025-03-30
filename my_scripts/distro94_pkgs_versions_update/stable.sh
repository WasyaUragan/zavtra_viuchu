#!/bin/bash

# Наименования файлов
input_file="pkgs.txt"
output_file="updated_pkgs_latest.txt"
clean_origin="pkgs_no_comments_latest.txt"
clean_updated="updated_pkgs_no_comments_latest.txt"
log_file="update_log_$(date +'%Y-%m-%d_%H-%M-%S')_latest.log"

# Проверка наличия необходимых инструментов
if ! command -v repoquery &> /dev/null; then
    echo "Ошибка: инструмент 'repoquery' не найден. Пожалуйста, установите yum-utils." >&2
    exit 1
fi

# Перенаправление вывода в лог и консоль
exec > >(tee -a "$log_file") 2>&1

# Проверка наличия входного файла
if [[ ! -f "$input_file" ]]; then
    echo "Ошибка: Входной файл '$input_file' не найден!" >&2
    exit 1
fi

# Очистка/создание выходных файлов
> "$output_file"
> "$clean_origin"
> "$clean_updated"

# Основная функция обработки пакета
process_package() {
    local line="$1"
    local pkg_part comment_part
    local log_messages=""
    
    # Разделение на пакет и комментарий
    IFS='#' read -r pkg_raw comment_raw <<< "$line"
    pkg_part=$(sed -E 's/^[[:space:]]*//; s/[[:space:]]*$//' <<< "$pkg_raw")
    comment_part=$(sed -E 's/^[[:space:]]*//; s/[[:space:]]*$//' <<< "$comment_raw")
    
    [[ -z "$pkg_part" ]] && return

    local arch="${pkg_part##*.}"
    local pkg_raw="${pkg_part%.$arch}"
    
    local pkg_name=$(sed -E 's/-[0-9].*//' <<< "$pkg_raw")
    
    #DEBUG 
    log_messages+="DEBUG: pkg_part - $pkg_part\n"
    log_messages+="DEBUG: arch - $arch\n"
    log_messages+="DEBUG: pkg_name - $pkg_name\n"
    log_messages+="DEBUG: pkg_raw - $pkg_raw\n\n\n"
    log_messages+="=======================\n"
    log_messages+="$pkg_name\n"
    log_messages+="-----------------------\n\n"

    # Запрос доступных версий
    local versions=$(repoquery --qf "%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}\n" "$pkg_name" 2>/dev/null | grep "${arch}$")
    log_messages+="Доступные версии:\n"
    log_messages+="$versions\n\n"

    # Подсчет количества версий и выбор последней
    local versions_count=$(echo "$versions" | wc -l)
    local latest=""

    if [[ -n "$versions" ]]; then
        latest=$(echo "$versions" | awk -F'[-.]' '{
            split($3, rel_parts, /_/);
            print $0 " " $2 "." rel_parts[1]
        }' | sort -t ' ' -k2,2V -r | head -n1 | cut -d' ' -f1)
        
        log_messages+="Последняя версия:\n"
        log_messages+="$latest\n\n"
    #условие отрабатывает криво - esle не выводится вообще
    else
        log_messages+="Не удалось обновить: $pkg_part\n\n"
        latest="$pkg_part"
    fi

    # Условие: если версия одна и совпадает с исходной, не логируем
    if [[ $versions_count -eq 1 && "$latest" == "$pkg_part" ]]; then
        log_messages=""  # Очищаем сообщения
    fi

    # Вывод логов, если они не пустые
    if [[ -n "$log_messages" ]]; then
        echo -e "$log_messages" >&2
    fi

    # Формируем итоговую строку для вывода
    printf "%s" "$latest"
    [[ -n "$comment_part" ]] && printf " #%s" "$comment_part"
    echo
}

# Обработка входного файла
echo "Начинаем обработку файла $input_file"
total_lines=$(wc -l < "$input_file")
current_line=0

if [[ $(tail -c 1 "$input_file" | wc -l) -eq 0 ]]; then
    total_lines=$((total_lines + 1))
fi

while IFS= read -r line || [[ -n "$line" ]]; do
    current_line=$((current_line + 1))
    echo -ne "Обработка: $current_line из $total_lines ($(( current_line * 100 / total_lines ))%)\r" >&2

    cleaned_origin=$(sed -E 's/#.*//; s/^[[:space:]]*//; s/[[:space:]]*$//' <<< "$line")
    [[ -n "$cleaned_origin" ]] && echo "$cleaned_origin" >> "$clean_origin"
    
    result=$(process_package "$line")
    [[ -n "$result" ]] && echo "$result" >> "$output_file"
done < "$input_file"
echo -e "\n=======================" >&2
echo -e "\nОбработка завершена." >&2

# Формирование чистого списка обновлённых пакетов
sed -E 's/#.*//; s/^[[:space:]]*//; s/[[:space:]]*$//; /^$/d' "$output_file" > "$clean_updated"

echo =======================
echo "Результаты сохранены в:"
echo -----------------------
echo "Исходный список:"
echo
echo "$(realpath "$input_file")"
echo -----------------------
echo "Исходный без комментариев:"
echo
echo "$(realpath "$clean_origin")"
echo -----------------------
echo "Обновлённый с комментариями:" 
echo
echo "$(realpath "$output_file")"
echo -----------------------
echo "Обновлённый без комментариев:"
echo
echo "$(realpath "$clean_updated")"
echo -----------------------
echo "Логи процесса:"
echo
echo "$(realpath "$log_file")"
echo =======================

# выводит в лог только пакеты с несколькими доступными версиями
# криво сравнивает версии