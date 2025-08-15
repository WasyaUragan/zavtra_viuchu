import re

def extract_package_name(full_name):
    """
    Извлекает имя RPM-пакета — всё до первого вхождения '-<цифра>'.
    """
    match = re.match(r'^(.+?)-\d', full_name)
    if match:
        return match.group(1)
    # Если не нашли -<цифра>, возвращаем всё (на всякий случай)
    return full_name

def main():
    diff_file = 'diff_86_2_94_sorted.txt'
    update_file = 'updated_pkgs_no_comments_latest.txt'
    output_file = 'updated_diff.txt'

    # Чтение обновлённых пакетов
    updated_packages = {}
    with open(update_file, 'r') as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith('#'):
                continue
            pkg_name = extract_package_name(line)
            updated_packages[pkg_name] = line

    # Обработка основного файла
    output_lines = []
    with open(diff_file, 'r') as f:
        for line in f:
            stripped_line = line.rstrip()
            if not stripped_line or stripped_line.startswith('#'):
                output_lines.append(stripped_line)
                continue

            # Разделяем строку на имя пакета и остаток (комментарий)
            parts = stripped_line.split(None, 1)  # Первый пробел/таб
            if not parts:
                output_lines.append(stripped_line)
                continue

            pkg_name_in_diff = parts[0]
            rest_part = parts[1] if len(parts) > 1 else ''

            # Проверяем, есть ли это имя в обновлённых пакетах
            if pkg_name_in_diff in updated_packages:
                new_line = updated_packages[pkg_name_in_diff]
                # Сохраняем комментарий
                if rest_part.strip():
                    output_lines.append(f"{new_line}\t{rest_part}")
                else:
                    output_lines.append(new_line)
            else:
                output_lines.append(stripped_line)

    # Запись результата
    with open(output_file, 'w') as f:
        f.write('\n'.join(output_lines))

    print(f"Результат сохранён в '{output_file}'")


if __name__ == '__main__':
    main()