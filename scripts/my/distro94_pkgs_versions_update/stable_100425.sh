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
    
    # Пропуск пустых строк
    [[ -z "$pkg_part" ]] && return

    # Разбиваем пакет на:
    # Имя-Версия-Номер-Релиза
    local pkg_raw="${pkg_part%.*}"
    # Архитектура
    local pkg_arch="${pkg_part##*.}"
    # Релиз
    local pkg_rel="${pkg_raw##*-}"
    # Номер релиза
    local pkg_rel_num="${pkg_rel%%.*}"
    # Имя
    # local pkg_name=$(sed -E 's/-[0-9].*//' <<< "$pkg_raw") # Рабочий вариант
    local pkg_name_ver="${pkg_raw%-*}"
    local pkg_name="${pkg_name_ver%-*}"
    # Версия
    local pkg_ver="${pkg_name_ver##*-}"
    
    log_messages+="=======================\n"
    log_messages+="$pkg_name\n"
    log_messages+="-----------------------\n\n"

    # Запрос доступных версий
    local repo_versions=$(repoquery --qf "%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}\n" "$pkg_name" 2>/dev/null | grep "${pkg_arch}$")
    log_messages+="Доступные версии:\n"
    if [[ -n "$repo_versions" ]]; then
        log_messages+="$repo_versions\n\n"
    else
        log_messages+="Доступных версий пакета для $pkg_arch не найдено.\n\n"
    fi

    # Подсчет количества версий и выбор последней
    local repo_versions_count=$(echo "$repo_versions" | wc -l)
    local latest=""

    # IFS=$'\n' read -rd '' -a versions_array <<< "$repo_versions"
    readarray -t versions_array <<< "$repo_versions"

    if [[ -n "$repo_versions_count" ]]; then
        latest=$(printf "%s\n" "${versions_array[@]}" | sort -V | tail -n1)
        
        log_messages+="Последняя версия:\n"
        log_messages+="$latest"
    #условие отрабатывает криво - esle не выводится вообще
    else
        log_messages+="Пакет в репозитории не найден: $pkg_part\n\n"
        latest="$pkg_part"
    fi

    # Условие: если версия одна и совпадает с исходной, не логируем
    if [[ $repo_versions_count -eq 1 && "$latest" == "$pkg_part" ]]; then
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
    echo -e "\n======================="
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

# корректно определяем старшую версию (продолжить тесты), но не ставит релиз el9_4.sz в преоритет при равных версиях (см. заметки в array.sh)
# понять нужна ли вообще в скрипте архитектура. у нас либо noarch, либо x86_64 в pkgs.txt
# но в удаленной репе каким-то боком может быть и i686 например, продумать этот момент