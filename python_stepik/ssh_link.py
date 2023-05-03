# написать функцию
# проверить валидность передаваемой пользователем ssh-ссылки на гит проект
# ссылка должна быть одна
# использовать срезы, сплит по пробелам, курл

#  git@gitlab.draszi.fintech.ru:code/fintech_tools/python3-fintech-unique-run.git

import subprocess

link = input('Адрес проекта в GIT: ')

def link_validation(link):
    if not ' ' in link:
        a = sum(char == '@' for char in link)
        b = sum(char == ':' for char in link)  
        if a == 1 and b == 1:
            # Is it a link or it\'s not? That is the question
            try:
                process = subprocess.Popen(['git', 'clone', link],
                     stdin=subprocess.PIPE,
                     stdout=subprocess.PIPE, 
                     stderr=subprocess.PIPE)
                while True:
                    break
            except Exception:
                return False



        # # if '@' and ':' in link and link[-4:] == '.git' and not ' ' in link:
        #     count += 1
        #     if count == 1:
        #         print('Is it a link or it\'s not? That is the question')
    else:
        print('It\'s not a link!')



a = link_validation(link)
print(a)


# def dfsdfs(ssssasdas):
#     try:
#         urllib.request.urlopen(url)
#         return True
#     except Exception:
#         return False





































