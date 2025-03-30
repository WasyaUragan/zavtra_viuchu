#!/bin/bash

input_file="pkgs.txt"
output_file="updated_pkgs_v2.txt"
clean_origin="pkgs_no_comments_v2.txt"
clean_updated="updated_pkgs_no_comments_v2.txt"
log_file="update_log_$(date +'%Y-%m-%d_%H-%M-%S')_v2.log"

exec > >(tee -a "$log_file") 2>&1

> "$output_file"
> "$clean_origin"
> "$clean_updated"

process_package() {
    local line="$1"
    local pkg_part comment_part
    local log_messages=""
    
    IFS='#' read -r pkg_raw comment_raw <<< "$line"
    pkg_part=$(sed -E 's/^[[:space:]]*//; s/[[:space:]]*$//' <<< "$pkg_raw")
    comment_part=$(sed -E 's/^[[:space:]]*//; s/[[:space:]]*$//' <<< "$comment_raw")
    
    [[ -z "$pkg_part" ]] && return

    local arch="${pkg_part##*.}"
    local pkg_raw="${pkg_part%.$arch}"
    
    local pkg_name=$(sed -E 's/-[0-9].*//' <<< "$pkg_raw")
    log_messages+="=======================\n"
    log_messages+="$pkg_name\n"
    log_messages+="------------------------\n\n"

    local versions=$(repoquery --qf "%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}\n" "$pkg_name" 2>/dev/null | grep "${arch}$")
    log_messages+="Доступные версии:\n"
    log_messages+="$versions\n\n"

    local versions_count=$(echo "$versions" | wc -l)
    local latest=""
    if [[ -n "$versions" ]]; then
        latest=$(echo "$versions" | awk -F'[-.]' '{
            split($3, rel_parts, /_/);
            print $0 " " $2 "." rel_parts[1]
        }' | sort -t ' ' -k2,2V -r | head -n1 | cut -d' ' -f1)
        
        log_messages+="Последняя версия:\n"
        log_messages+="$latest\n\n"
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

    printf "%s" "$latest"
    [[ -n "$comment_part" ]] && printf " #%s" "$comment_part"
    echo
}

while IFS= read -r line || [[ -n "$line" ]]; do
    cleaned_origin=$(sed -E 's/#.*//; s/^[[:space:]]*//; s/[[:space:]]*$//' <<< "$line")
    [[ -n "$cleaned_origin" ]] && echo "$cleaned_origin" >> "$clean_origin"
    
    result=$(process_package "$line")
    [[ -n "$result" ]] && echo "$result" >> "$output_file"
done < "$input_file"

sed -E 's/#.*//; s/^[[:space:]]*//; s/[[:space:]]*$//; /^$/d' "$output_file" > "$clean_updated"

echo =======================
echo Результаты сохранены в:
echo -----------------------
echo "Исходный список:"
echo
echo $(pwd)/$input_file
echo -----------------------
echo Исходный без комментариев:
echo
echo $(pwd)/$clean_origin
echo -----------------------
echo Обновлённый с комментариями: 
echo
echo $(pwd)/$output_file
echo -----------------------
echo Обновлённый без комментариев:
echo
echo $(pwd)/$clean_updated
echo -----------------------
echo Логи процесса:
echo
echo $(pwd)/$log_file
echo =======================

# выводит в лог только пакеты с несколькими доступными версиями
# криво сравнивает версии