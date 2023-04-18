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

ip = str(input())

if len(ip.split('.')) == 4:
    print('yes')
else:
    print('lol')

tst = ip.split('.')
print(tst[2])

count = 0
count = sum(map(lambda item: item == int, ip))

print(
    "количество элементов списка, удовлетворяющих заданному условию:",
    count
)

# split_ip = list(ip.split('.'))

# print(split_ip)





















