При работе с текстовыми файлами вам часто нужно искать и заменять строки текста в одном или нескольких файлах.

sed является s Tream ред itor. Он может выполнять базовые операции с текстом над файлами и входными потоками, такими как конвейеры. С помощью sed вы можете искать, находить и заменять, вставлять и удалять слова и строки. Он поддерживает базовые и расширенные регулярные выражения, которые позволяют сопоставлять сложные шаблоны.

В этой статье мы поговорим о том, как найти и заменить строки с помощью sed . Мы также покажем вам, как выполнить рекурсивный поиск и замену.

Содержание	
Найти и заменить строку с помощью sed
Рекурсивный поиск и замена
Найти и заменить строку с помощью sed
Существует несколько версий sed с некоторыми функциональными различиями. macOS использует версию BSD, в то время как большинство дистрибутивов Linux поставляются с предустановленной по умолчанию GNU sed . Мы будем использовать версию GNU.

Общая форма поиска и замены текста с помощью sed имеет следующий вид:

sed -i 's/SEARCH_REGEX/REPLACEMENT/g' INPUTFILE
-i — По умолчанию sed записывает свой вывод в стандартный вывод. Эта опция указывает sed редактировать файлы на месте. Если указано расширение (например, -i.bak), создается резервная копия исходного файла.
s — Заменяющая команда, вероятно, наиболее часто используемая команда в sed.
/ / / — Символ-разделитель. Это может быть любой символ, но обычно используется символ косой черты ( / ).
SEARCH_REGEX — обычная строка или регулярное выражение для поиска.
REPLACEMENT — строка замены.
g — Флаг глобальной замены. По умолчанию sed читает файл построчно и изменяет только первое вхождение SEARCH_REGEX в строке. Если указан флаг замены, заменяются все вхождения.
INPUTFILE — имя файла, для которого вы хотите запустить команду.
Рекомендуется заключать аргумент в кавычки, чтобы метасимволы оболочки не расширялись.

Давайте посмотрим, как мы можем использовать команду sed для поиска и замены текста в файлах некоторыми из наиболее часто используемых параметров и флагов.

В демонстрационных целях мы будем использовать следующий файл:

file.txt
123 Foo foo foo 
foo /bin/bash Ubuntu foobar 456
Если флаг g опущен, заменяется только первый экземпляр строки поиска в каждой строке:

sed -i 's/foo/linux/' file.txt
123 Foo linux foo 
linux /bin/bash Ubuntu foobar 456
С флагом глобальной замены sed заменяет все вхождения шаблона поиска:

sed -i 's/foo/linux/g' file.txt
123 Foo linux linux
linux /bin/bash Ubuntu linuxbar 456
Как вы могли заметить, подстрока foo внутри строки foobar также заменена в предыдущем примере. Если это нежелательное поведение, используйте выражение границы слова ( b ) на обоих концах строки поиска. Это гарантирует, что частичные слова не совпадают.

sed -i 's/bfoob/linux/g' file.txt
123 Foo linux linux
linux /bin/bash Ubuntu foobar 456
Чтобы сделать совпадение с шаблоном нечувствительным к регистру, используйте флаг I В приведенном ниже примере мы используем флаги g и I

sed -i 's/foo/linux/gI' file.txt
123 linux linux linux 
linux /bin/bash Ubuntu linuxbar 456
Если вы хотите найти и заменить строку, содержащую символ-разделитель ( / ), вам нужно будет использовать обратную косую черту ( ), чтобы избежать косой черты. Например, чтобы заменить /bin/bash на /usr/bin/zsh вы должны использовать

sed -i 's//bin/bash//usr/bin/zsh/g' file.txt
Более простой и понятный вариант — использовать другой символ-разделитель. Большинство людей используют вертикальную полосу ( | ) или двоеточие ( : ) , но вы можете использовать любой другой символ:

sed -i 's|/bin/bash|/usr/bin/zsh|g' file.txt
123 Foo foo foo 
foo /usr/bin/zsh Ubuntu foobar 456
Вы также можете использовать регулярные выражения. Например, чтобы найти все трехзначные числа и заменить их строковым number вы должны использовать:

sed -i 's/b[0-9]{3}b/number/g' file.txt
number Foo foo foo 
foo /bin/bash demo foobar number
Еще одна полезная функция sed заключается в том, что вы можете использовать символ амперсанда & который соответствует сопоставленному шаблону. Персонаж можно использовать несколько раз.

Например, если вы хотите добавить фигурные скобки {} вокруг каждого трехзначного числа, введите:

sed -i 's/b[0-9]{3}b/{&}/g' file.txt
{123} Foo foo foo 
foo /bin/bash demo foobar {456}
И последнее, но не менее важное: всегда рекомендуется делать резервную копию при редактировании файла с помощью sed . Для этого просто укажите расширение файла резервной копии для параметра -i . Например, чтобы отредактировать file.txt и сохранить исходный файл как file.txt.bak вы должны использовать:

sed -i.bak 's/foo/linux/g' file.txt
Чтобы убедиться, что резервная копия создана, выведите список файлов с помощью команды ls :

ls
file.txt file.txt.bak
Рекурсивный поиск и замена
Иногда может потребоваться рекурсивный поиск в каталогах файлов, содержащих строку, и замена строки во всех файлах. Это можно сделать с помощью таких команд, как find или grep для рекурсивного поиска файлов в каталоге и передачи имен файлов в sed .

Следующая команда будет рекурсивно искать файлы в текущем рабочем каталоге и передавать имена файлов в sed .

find . -type f -exec sed -i 's/foo/bar/g' {} +
Чтобы избежать проблем с файлами, содержащими пробелы в своих именах, используйте параметр -print0 , который указывает find напечатать имя файла, за которым следует нулевой символ, и xargs -0 вывод в sed используя xargs -0 :

find . -type f -print0 | xargs -0 sed -i 's/foo/bar/g'
Чтобы исключить каталог, используйте параметр -not -path . Например, если вы заменяете строку в локальном репозитории git, чтобы исключить все файлы, начинающиеся с точки ( . ), Используйте:

find . -type f -not -path '*/.*' -print0 | xargs -0 sed -i 's/foo/bar/g'
Если вы хотите искать и заменять текст только в файлах с определенным расширением, вы будете использовать:

find . -type f -name "*.md" -print0 | xargs -0 sed -i 's/foo/bar/g'
Другой вариант — использовать команду grep для рекурсивного поиска всех файлов, содержащих шаблон поиска, а затем передать имена файлов в sed :

grep -rlZ 'foo' . | xargs -0 sed -i.bak 's/foo/bar/g'
Выводы
Хотя это может показаться сложным и сложным, поначалу поиск и замена текста в файлах с помощью sed очень просты.

Чтобы узнать больше о sed команд, опций и флагов, посетить GNU СЭД руководство и Grymoire СЭД учебник .

Если у вас есть какие-либо вопросы или отзывы, не стесняйтесь оставлять комментарии.
