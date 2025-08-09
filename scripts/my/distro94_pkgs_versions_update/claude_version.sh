#!/bin/bash

# Проверка наличия необходимых инструментов
if ! command -v repoquery &> /dev/null; then
    echo "Ошибка: инструмент 'repoquery' не найден. Пожалуйста, установите yum-utils." >&2
    exit 1
fi

# Настройка файлов
input_file="pkgs.txt"
output_file="updated_pkgs_v2.txt"
clean_origin="pkgs_no_comments_v2.txt"
clean_updated="updated_pkgs_no_comments_v2.txt"
log_file="update_log_$(date +'%Y-%m-%d_%H-%M-%S')_v2.log"

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

# Улучшенная функция извлечения имени пакета для RPM-формата
extract_package_name() {
    local full_package="$1"
    
    # Используем rpm, если доступен
    if command -v rpm &>/dev/null; then
        # Проверяем, является ли строка путем к файлу или именем пакета
        if [[ -f "$full_package" ]]; then
            local rpm_name=$(rpm -qp --qf "%{NAME}" "$full_package" 2>/dev/null)
            if [[ $? -eq 0 && -n "$rpm_name" ]]; then
                echo "$rpm_name"
                return 0
            fi
        else
            # Пробуем запросить по имени (может не сработать для локальных файлов)
            local rpm_name=$(rpm -q --qf "%{NAME}" "$full_package" 2>/dev/null)
            if [[ $? -eq 0 && -n "$rpm_name" ]]; then
                echo "$rpm_name"
                return 0
            fi
        fi
    fi
    
    # Если rpm не доступен или не сработал, используем регулярное выражение
    # Для формата имя-версия-релиз.архитектура
    
    # Сначала получаем часть без архитектуры
    local without_arch=${full_package%.*}
    
    # Регулярное выражение для шаблона RPM
    # Ищем последнее вхождение -цифры где цифры - это версия
    # Затем определяем имя пакета как всё до этого вхождения
    
    # Попробуем найти последний дефис, после которого идут цифры,
    # предполагая, что это начало версии
    local name_part
    
    # Используем более точное регулярное выражение для определения версии и релиза
    if [[ "$without_arch" =~ ^(.*)-([0-9][0-9.]*)-(.*[0-9].*)$ ]]; then
        # Найден шаблон имя-версия-релиз
        name_part="${BASH_REMATCH[1]}"
    elif [[ "$without_arch" =~ ^(.*)-([0-9][0-9.]*)$ ]]; then
        # Найден шаблон имя-версия (без явного релиза)
        name_part="${BASH_REMATCH[1]}"
    else
        # Не смогли разобрать по шаблону, возвращаем как есть
        echo "$full_package"
        return 1
    fi
    
    echo "$name_part"
}

# Использование в функции process_package
process_package() {
    local line="$1"
    local pkg_part comment_part
    local log_messages=""
    
    # Разделение на пакет и комментарий
    if [[ "$line" == *"#"* ]]; then
        IFS='#' read -r pkg_raw comment_raw <<< "$line"
        pkg_part=$(sed -E 's/^[[:space:]]*//; s/[[:space:]]*$//' <<< "$pkg_raw")
        comment_part=$(sed -E 's/^[[:space:]]*//; s/[[:space:]]*$//' <<< "$comment_raw")
    else
        pkg_part=$(sed -E 's/^[[:space:]]*//; s/[[:space:]]*$//' <<< "$line")
        comment_part=""
    fi
    
    # Пропуск пустых строк
    [[ -z "$pkg_part" ]] && return

    # Извлечение архитектуры пакета
    local arch=""
    if [[ "$pkg_part" == *.* ]]; then
        arch="${pkg_part##*.}"
        local pkg_raw="${pkg_part%.*}"
    else
        pkg_raw="$pkg_part"
        # Если архитектура не указана, используем текущую
        arch=$(arch)
    fi
    
    # Извлечение базового имени пакета с использованием новой функции
    local pkg_name=$(extract_package_name "$pkg_raw")
    log_messages+="=======================\n"
    log_messages+="$pkg_name (arch: $arch)\n"
    log_messages+="Оригинал: $pkg_part\n"
    log_messages+="------------------------\n\n"

    # Запрос доступных версий - теперь с корректным именем пакета
    local versions=$(repoquery --qf "%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}\n" "$pkg_name" 2>/dev/null | grep "\.${arch}$" || echo "")
    
    # Запрос доступных версий
    echo DEBUG: $versions
    local versions=$(repoquery --qf "%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}\n" "$pkg_name" 2>/dev/null | grep "\.${arch}$" || echo "")
    
    log_messages+="Доступные версии:\n"
    if [[ -n "$versions" ]]; then
        log_messages+="$versions\n\n"
    else
        log_messages+="Не найдено\n\n"
    fi

    # Подсчет количества версий и выбор последней
    local versions_count=0
    local latest=""
    
    if [[ -n "$versions" ]]; then
        versions_count=$(echo "$versions" | wc -l)
        
        # Улучшенная сортировка версий с помощью sort -V
        latest=$(echo "$versions" | sort -V | tail -n1)
        
        log_messages+="Последняя версия:\n"
        log_messages+="$latest\n\n"
    else
        log_messages+="Не удалось обновить: $pkg_part\n\n"
        latest="$pkg_part"
    fi

    # Проверка: сравниваем только имя пакета и версию, а не полный формат
    local original_basename=$(basename "$pkg_part" ."$arch" | sed -E 's/-[0-9][0-9.]*-.*$//')
    local latest_basename=$(basename "$latest" ."$arch" | sed -E 's/-[0-9][0-9.]*-.*$//')
    
    local original_version=$(echo "$pkg_part" | grep -oP '(?<=-)[0-9][0-9.]*(?=-|$)' || echo "")
    local latest_version=$(echo "$latest" | grep -oP '(?<=-)[0-9][0-9.]*(?=-|$)' || echo "")

    # Условие: если версия одна и имя+версия совпадает с исходной, не логируем
    if [[ $versions_count -eq 1 && "$original_basename" == "$latest_basename" && "$original_version" == "$latest_version" ]]; then
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
echo "Начинаем обработку файла $input_file..."
total_lines=$(wc -l < "$input_file")
current_line=0

while IFS= read -r line || [[ -n "$line" ]]; do
    current_line=$((current_line + 1))
    echo -ne "Обработка: $current_line из $total_lines ($(( current_line * 100 / total_lines ))%)\r" >&2
    
    cleaned_origin=$(sed -E 's/#.*//; s/^[[:space:]]*//; s/[[:space:]]*$//' <<< "$line")
    [[ -n "$cleaned_origin" ]] && echo "$cleaned_origin" >> "$clean_origin"
    
    result=$(process_package "$line")
    [[ -n "$result" ]] && echo "$result" >> "$output_file"
done < "$input_file"
echo -e "\nОбработка завершена." >&2

# Формирование чистого списка обновлённых пакетов
sed -E 's/#.*//; s/^[[:space:]]*//; s/[[:space:]]*$//; /^$/d' "$output_file" > "$clean_updated"

# Вывод статистики
total_origin=$(wc -l < "$clean_origin")
total_updated=$(wc -l < "$clean_updated")

echo =======================
echo "Статистика:"
echo "Всего пакетов в исходном списке: $total_origin"
echo "Всего пакетов в обновлённом списке: $total_updated"
if [[ "$total_origin" -ne "$total_updated" ]]; then
    echo "ВНИМАНИЕ: Количество пакетов изменилось!"
fi
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

# нерабочее говнище, надо разобрать extract_package_name()
# все еще криво сравнивает верстии, еще хуже, чем дипсик