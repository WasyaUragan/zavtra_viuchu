#!/bin/bash

input_file="pkgs.txt"
output_file="updated_pkgs.txt"
clean_origin="pkgs_no_comments.txt"
clean_updated="updated_pkgs_no_comments.txt"
log_file="update_log_$(date +'%Y-%m-%d_%H-%M-%S').log"

# Перенаправляем stderr и stdout в лог-файл
exec > >(tee -a "$log_file") 2>&1

# Очистка файлов
> "$output_file"
> "$clean_origin"
> "$clean_updated"

process_package() {
    local line="$1"
    local pkg_part comment_part
    
    IFS='#' read -r pkg_raw comment_raw <<< "$line"
    pkg_part=$(sed -E 's/^[[:space:]]*//; s/[[:space:]]*$//' <<< "$pkg_raw")
    comment_part=$(sed -E 's/^[[:space:]]*//; s/[[:space:]]*$//' <<< "$comment_raw")
    
    [[ -z "$pkg_part" ]] && return

    local arch="${pkg_part##*.}"
    local pkg_raw="${pkg_part%.$arch}"
    
    # Извлечение имени пакета
    local pkg_name=$(sed -E 's/-[0-9].*//' <<< "$pkg_raw")
    echo ======================= >&2
    echo $pkg_name >&2
    echo ----------------------- >&2
    echo >&2

    # Получение версий
    local versions=$(repoquery --qf "%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}\n" "$pkg_name" 2>/dev/null | grep "${arch}$")
    echo "Доступные версии:" >&2
    echo $versions >&2
    echo >&2

    if [[ -n "$versions" ]]; then
        # Получение последней версии пакета
        local latest=$(echo "$versions" | awk -F'[-.]' '{
            split($3, rel_parts, /_/);
            print $0 " " $2 "." rel_parts[1]
        }' | sort -t ' ' -k2,2V -r | head -n1 | cut -d' ' -f1)
        
        echo "Последняя версия:" >&2
        echo $latest >&2
        echo >&2

        printf "%s" "$latest"
    else
        echo "Не удалось обновить: $pkg_part" >&2
        printf "%s" "$pkg_part"
    fi
    
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


# списки формирует корректно, но версии сравнивает криво