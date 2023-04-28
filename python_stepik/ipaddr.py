#В программу подается текстовая строка с ip-адресом.
#Проверить валидность ip-адреса. 
#Честно спизженое решение.
# import ipaddress
 
 
# def check_ip(ip):
#     try:
#         ipaddress.ip_address(ip)
#     except ValueError:
#         return False
#     else:
#         return True
 
# print(check_ip('192.168.1.256'))
# print(check_ip('192.168.1.255'))
# print(check_ip('0.0.0.0'))

# В сети интернет каждому компьютеру присваивается четырехбайтовый код, который принято записывать в виде четырех чисел, 
# каждое из которых может принимать значения от 0 до 255, разделенных точками
# если ты получишь список из строки по разделителю '.' то есть '127.0.0.1'.split() и список будет равен 4-ем элементам 
# при этом каждый элемент число и находиться в диапазоне 0-255 то IP-адрес правильный.
#ip всегда одного формата и одного размера

# a, b, c, d = input(int()), input(int()), input(int()), input(int())

# ip = a, b, c, d
# str_ip = str.split()(ip)
# print(type(str_ip))

# Разобраться с обработкой stdin в питоне

data = input('Введите IP-адрес: ')
tst = data.split('.')

if len(tst) == 4:
    if tst[0].isdigit() and tst[1].isdigit() and tst[2].isdigit() and tst[3].isdigit():
        oct1, oct2, oct3, oct4 = int(tst[0]), int(tst[1]), int(tst[2]), int(tst[3])
        if 0 <= oct1 <= 255 and 0 <= oct2 <= 255 and 0 <= oct3 <= 255 and 0 <= oct4 <= 255:
            print('ip-address is valid')
        else:
            print('there\'s a mistake')
    else:
        print('it\'s not an ip-addr')        
else:
    print('it\'s not an ip-addr')

# def getNumber02 ():
#     while True:
#         getNumber = input('Введите целое положительное число: ')  # Ввод числа
#         if getNumber.isdigit() : return getNumber

# print(getNumber02())


# data = input('Введите IP-адрес: ')
# tst = data.split('.')

# if len(tst) == 4:
#     oct1, oct2, oct3, oct4 = int(tst[0]), int(tst[1]), int(tst[2]), int(tst[3])
#     if 0 <= oct1 <= 255 and 0 <= oct2 <= 255 and 0 <= oct3 <= 255 and 0 <= oct4 <= 255:
#         print('ip-address is valid')
#     else:
#         print('there\'s a mistake')
# else:
#         print('it\'s not an ip-addr')        



# data = input('Введите IP-адрес: ')
# tst = data.split('.')

# if len(tst) == 4:
#     if tst[0].isdigit() and tst[1].isdigit() and tst[2].isdigit() and tst[3].isdigit():
#         oct1, oct2, oct3, oct4 = int(tst[0]), int(tst[1]), int(tst[2]), int(tst[3])
#         print(type(oct1))
#         print(type(tst[1]))
#         if 0 <= oct1 <= 255 and 0 <= oct2 <= 255 and 0 <= oct3 <= 255 and 0 <= oct4 <= 255:
#             print('ip-address is valid')
#         else:
#             print('there\'s a mistake')
#     else:
#         print('it\'s not an ip-addr')        
# else:
#     print('it\'s not an ip-addr')
















