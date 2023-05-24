import paramiko

link = input('Адрес проекта в GIT: ')

def link_validation(link):
    # 1)сплит на количество значений
    if len(link.split()) == 1:
        # 2)гитсобака
        if 'git@' in link:
            # 3)paramiko
            a = paramiko.Agent.
            return('этап проверки ссылки')
        else:
            return('It\'s not a link!')
    else:
        return('It\'s not a link!')

print(link_validation(link))




# import os
# import git

# link = input('Адрес проекта в GIT: ')

# def link_validation(link):
#     # 1)сплит на количество значений
#     if len(link.split()) == 1:
#         # 2)гитсобака
#         if 'git@' in link:
#             # 3)проверка ссылки
#             cmd = 'git ls-remote ' + link + ' > /tmp/output'
#             cmd1 = 'cat /tmp/output | grep HEAD' + ' > /tmp/output1'
#             os.system(cmd)
#             os.system(cmd1)
#             with open('/tmp/output1') as vivod:
#                 vivod = vivod.read()
#             if 'HEAD' in vivod:
#                 print('The link is valid!')
#             else:
#                 print('neok') 
            
#             # print('The link is valid!')
#         else:
#             print('It\'s not a link!')
#     else:
#         print('It\'s not a link!')

# a = link_validation(link)
# # print(a)

























