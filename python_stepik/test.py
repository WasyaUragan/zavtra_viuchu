# a = int(input())
# b = a + 1
# c = b + 1
# print(a, b, c, sep='\n')

# a = int(input())
# b = int(input())
# c = int(input())
# print(a + b + c)

# a = int(input())
# print('Объем =', a * a * a)
# print('Площадь полной поверхности =', 6 * (a * a))

# a = int(input())
# b = int(input())
# # print(int(3)*((a+b)**3)+int(275)*(b**2)-int(127)*a-int(41))
# print(int(3*(a+b)**3 + 275*b**2 - 127*a - 41))

# a = int(input())
# print('Следующее за числом', a, 'число:', a + int(1))
# print('Для числа', a, 'предыдущее число:', a - int(1))

# a = int(input())
# b = int(input())
# c = int(input())
# d = int(input())
# coast = int((a + b + c + d)*3)
# print(coast)

# a = int(input())
# b = int(input())
# c = int(a + b)
# d = int(a - b)
# e = int(a * b)
# print(a, '+', b, '=', c)
# print(a, '-', b, '=', d)
# print(a, '*', b, '=', e)

# a = int(input())
# b = int(input())
# c = int(input())
# d = int((a + b * (c - 1)))
# print(d)

# a = int(input())
# b, c, d, e = int(2 * a), int(3 * a), int(4 * a), int(5 * a)
# print(a, b, c, d, e, sep='---')

# a = int(input())
# b = int(input())
# c = int(input())
# d = int(a * b ** (c - 1))
# print(d)

# a = int(input())
# b = int(a // int(100))
# print(b)

# a = int(input())  # pizduki
# b = int(input())  # mandarini
# c = int(b // a)  # mandarini kazhdomu pizduku 
# d = int(b % a)  # ostatok v korzine
# print(c, d, sep='\n')

# n = int(input())
# polovina = int(n / 2)
# vizhivshie = int(n - polovina)
# print(vizhivshie)

# mesto = int(input())
# c = int(mesto % 4)  #ostatok
# d = int(mesto + 3)  #odno iz 4h mest
# e = int(d // 4)  #kupe
# print(e)

# a = int(input())
# print((a-1) // 4 + 1)

# a = int(input())  #минуты
# b = int(a // 60)  #часов в а-минут
# c = int(a % 60)  #остаток в мин
# print(a, 'мин - это', b, 'час', c, 'минут.')

# a = int(input())
# print(f'{a} мин - это {a // 60} час {a % 60} минут.')

# chislo = int(input())
# last_num = chislo % 10
# second_mun = (chislo % 100) // 10
# first_num = chislo // 100
# print(f'Сумма цифр = {last_num + second_mun + first_num}')
# print(f'Произведение цифр = {last_num * second_mun * first_num}')

# chislo = int(input())
# c = chislo % 10
# b = (chislo % 100) // 10
# a = chislo // 100
# print(a, b, c, sep='')
# print(a, c, b, sep='')
# print(b, a, c, sep='')
# print(b, c, a, sep='')
# print(c, a, b, sep='')
# print(c, b, a, sep='')

# chislo = int(input())
# d = chislo % 10
# c = (chislo % 100) // 10
# b = (chislo // 100) % 10
# a = chislo // 1000
# print('Цифра в позиции тысяч равна', a)
# print('Цифра в позиции сотен равна', b)
# print('Цифра в позиции десятков равна', c)
# print('Цифра в позиции единиц равна', d)

# print('*****************')
# print('*', '*', sep='               ')
# print('*', '*', sep='               ')
# print('*****************')

# a, b = int(input()), int(input())
# print(f'Квадрат суммы {a} и {b} равен {(a + b)**2}')
# print(f'Сумма квадратов {a} и {b} равна {a**2 + b**2}')

# a, b, c, d = int(input()), int(input()), int(input()), int(input())
# print(a**b + c**d)

# n = int(input())
# a = n % 10 # edinica
# b = (n % 100) // 10 #desyatki
# c = n // 100 #sotni
# d = n // 1000 #tisyachi

# n = int(input())
# x = n+(10*n+n)+(100*n+10*n+n)  # x = n * 123
# print(x)


# n = input()
# # print(int(n)+int(n+n)+int(n+n+n))
# print(int(n+n))

# n = int(input())  # user's age
# if n >= 18:
#     print('Доступ разрешен')
# else:
#     print('Доступ запрещен')

# a = int(input())
# b = int(input())
# c = int(input())
# if b - a == c - b:  # ( b - a) + b = c 
#     print('YES')
# else:
#     print('NO')

# a = int(input())
# b = int(input())
# if a < b:
#     print(a)
# else:
#     print(b)

# a = int(input())
# b = int(input())
# c = int(input())

# if c > a > b or b > a > c:
#     print(a)
# elif a > b > c or c > b > a:
#     print(b)
# else:
#     print(c)

# a, b, c = int(input()), int(input()), int(input())
# if c < a:  # a либо большее, либо среднее
#     a, c = c, a  # подмена значений 
# if b < a:  # если b < a, то а - среднее(т к мы подменили ее значение выше)
#     a, b = b, a
# if c < b:
#     b, c = c, b
# print(b)

# month = int(input())
# # 1 3 5 7 8 10 11 12 == 31
# # 4 6 9 11 == 30
# # 2 == 28(29)
# if  month == 2:
#     print(28)
# elif month == 4 or month == 6 or month == 9 or month == 11:
#     print(30) 
# else:
#     print(31)

# m = int(input())
# if m == 2:
#     print('28')
# elif m <= 7:
#     print(30 + m%2 )
# else: 
#     print(31 - m%2 )

# w = int(input())

# if w < 60:
#     print('Легкий вес')
# elif w < 64:
#     print('Первый полусредний вес')
# elif w < 69:
#     print('Полусредний вес')

# a = int(input())
# b = int(input())
# c = str(input())


# if b == 0:
#     if c == '/':
#         print('На ноль делить нельзя!')
#     elif c == '-':
#         d = a - b
#         print(d)
#     elif c == '*':
#         d = a * b
#         print(d)
#     else:
#         d = a + b
#         print(d)
# elif c == '-':
#     d = a - b
#     print(d)
# elif c == '*':
#     d = a * b
#     print(d)
# elif c == '/':
#     d = a / b
#     print(d)
# elif c == '+':
#     d = a + b
#     print(d)
# else:
#     print('Неверная операция')

# a, b = int(input()), int(input())
# c = input()

# if c == '-':
#     print(a - b)
# elif c == '+':
#     print(a + b)
# elif c == '*':
#     print(a * b)
# elif c == '/':
#     if b != 0:
#         print(a / b)
#     else:
#         print('На ноль делить нельзя!')
# else:
#     print('Неверная операция')

# a, b = input(), input()
# result = a + b

# if a == 'красный': 
#     if b not in ('красный', 'желтый', 'синий'):
#         result = 'ошибка цвета'
#     elif b == a:
#         result = a
#     elif b == 'синий':
#         result = 'фиолетовый'
#     elif b == 'желтый':
#         result = 'оранжевый'
# elif a == 'желтый':
#     if b not in ('красный', 'желтый', 'синий'):
#         result = 'ошибка цвета'
#     elif b == a:
#         result = a
#     elif b == 'синий':
#         result = 'зеленый'
#     elif b == 'красный':
#         result = 'оранжевый'
# elif a == 'синий':
#     if b not in ('красный', 'желтый', 'синий'):
#         result = 'ошибка цвета'
#     elif b == a:
#         result = a
#     elif b == 'красный':
#         result = 'фиолетовый'
#     elif b == 'желтый':
#         result = 'зеленый'
# elif a not in ('красный', 'желтый', 'синий'):
#     result = 'ошибка цвета'
# print(result)

# a, b = input(), input()

# if a == 'красный':
#     if b == a:
#         print('красный')
#     elif b == 'синий':
#         print('фиолетовый')
#     elif b == 'желтый':
#         print('оранжевый')
#     else:
#         print('ошибка цвета')
# elif a == 'желтый':
#     if b == a:
#         print('желтый')
#     elif b == 'синий':
#         print('зеленый')
#     elif b == 'красный':
#         print('оранжевый')
#     else:
#         print('ошибка цвета')
# elif a == 'синий':
#     if b == a:
#         print('синий')
#     elif b == 'красный':
#         print('фиолетовый')
#     elif b == 'желтый':
#         print('зеленый')
#     else:
#         print('ошибка цвета')
# else:
#     print('ошибка цвета')

# a = int(input())

# if a != 0:
#     if 10 >= a >= 1 or 28 >= a >= 19:
#         if a % 2 != 0:
#             print('красный')
#         else:
#             print('черный')
#     elif 18 >= a >= 11 or 36 >= a >= 29:
#         if a % 2 != 0:
#             print('черный')
#         else:
#             print('красный')
#     elif a < 0 or a > 36:
#         print('ошибка ввода')
# else:
#     print('зеленый')

# a = int(input())

# if a == 0:
#     print('зеленый')
# elif 1 <= a <= 10 or 19 <= a <= 28:
#     if a % 2 == 0:
#         print('черный')
#     else:
#         print('красный')
# elif 11 <= a <= 18 or 29 <= a <= 36:
#     if a % 2 == 0:
#         print('красный')
#     else:
#         print('черный')
# elif a < 0 or a > 36:
#     print('ошибка ввода')

# a = int(input())
# if a == 0:
#     print("зеленый")
# elif a < 0 or a > 36:
#     print("ошибка ввода")
# elif (1 <= a <= 10 or 19 <= a <= 28) + (not a % 2) == 1:
#     print("красный")
# else:
#     print("черный")

# a1, b1, a2, b2 = int(input()), int(input()), int(input()), int(input())


# if a1 <= a2 and b2 <= b1:
#     print(a2, b2)
# elif a2 <= a1 and b1 <= b2:
#     print(a1, b1)
# elif a1 < a2 and a2 < b1 and b1 < b2:
#     print(a2, b1)
# elif a2 < a1 and a1 < b2 and b2 < b1:
#     print(a1, b2)
# elif a2 == b1:
#     print(b1)
# elif a1 == b2:
#     print(b2)
# elif a1 < b1 and a2 < b2:
#     print('пустое множество')
    
# a1, b1, a2, b2 = int(input()), int(input()), int(input()), int(input())


# if a1 <= a2 and b2 <= b1:
#     print(a2, b2)
# elif a2 <= a1 and b1 <= b2:
#     print(a1, b1)
# elif a1 < a2 < b1 < b2:
#     print(a2, b1)
# elif a2 < a1 < b2 < b1:
#     print(a1, b2)
# elif a2 == b1:
#     print(b1)
# elif a1 == b2:
#     print(b2)
# elif a1 < b1 and a2 < b2:
#     print('пустое множество')

# a = int(input())
# b = int(input())
# c = int(input())

# print(max(a, b, c), f'{(a + b + c) - (max(a, b, c) + min(a, b, c))}', min(a, b, c), sep='\n')

# num = int(input())
# a = num // 100
# b = num % 100 // 10
# c = num % 10
# # print(a, b, c)
# if max(a, b, c) - min(a, b, c) == (a + b + c) - (max(a, b, c) + min(a, b, c)):
#      print('Число интересное')
# else:
#      print('Число неинтересное')

# a = float(input())
# b = float(input())
# c = float(input())
# d = float(input())
# e = float(input())

# print(abs(a) + abs(b) + abs(c) + abs(d) + abs(e))

# a1 = float(input())
# b1 = float(input())
# a2 = float(input())
# b2 = float(input())

# print(abs(a1 - a2) + abs(b1 -b2))


# a = float(input())
# b = float(input())
# ari = (a + b) / 2
# geo = sqrt(a * b)
# gar = (2 * a * b) / (a + b)
# kva = sqrt((pow(a, 2) + pow(b, 2)) / 2)

# print(ari, geo, gar, kva, sep='\n')



#print('"Python is a great language!", said Fred. ' + '"' "I don't ever remember having this much fun before." + '"')

# name = input()
# surname = input()

# print('Hello ' + name + ' ' + surname + '! You just delved into Python')


# team = input()

# print('Футбольная команда ' + team + ' имеет длину', len(team), 'символов')

# a, b, c = input(), input(), input()

# if len(a) < len(b) < len(c):
#     print(a, c, sep='\n')
# elif len(b) < len(a) < len(c):
#     print(b, c, sep='\n')
# elif len(b) < len(c) < len(a):
#     print(b, a, sep='\n')
# elif len(a) < len(c) < len(b):
#     print(a, b, sep='\n')
# elif len(c) < len(a) < len(b):
#     print(c, b, sep='\n')
# elif len(c) < len(b) < len(a):
#     print(c, a, sep='\n')

# a, b, c = input(), input(), input()
# second = max(a, b, c)

# print(first, second, sep='\n')

# print(min(a, b, c), max(a, b, c), sep='\n')

# a = len(input())
# b = len(input())
# c = len(input())

# print(a, b, c, sep='\n')

# menshee = min(a, b, c)
# bolshee = max(a, b, c)
# srednee = a + b + c - menshee - bolshee

# if bolshee - srednee == srednee - menshee:
#     print('YES')
# else:
#     print('NO')

# stroka = input()

# if 'суббота' in stroka:
#     print('YES')
# elif 'воскресенье' in stroka:
#     print('YES')
# else:
#     print('NO')

# n = int(input())
# a = float(input())

# S = (n * pow(a, 2)) / (4 * tan(pi / n))
# print(S)

# from math import *

# a = float(input())
# b = float(input())
# c = float(input())
# D = b ** 2 - 4 * a * c

# if D < 0:
#     print('Нет корней')
# elif D == 0:
#     print(f'{-b / (2 * a)}')
# elif D > 0:
#     e = (-b + sqrt(D)) / (2 * a)
#     f = (-b - sqrt(D)) / (2 * a)
#     print(min(e, f), max(e, f), sep='\n')

# n = int(input())

# for i in range (n + 1):
#     print(f'Квадрат числа {i} равен {i ** 2}')

# n = int(input())

# for i in range (n):
#      print((n - i) * '*')

# for i in range (n, 0, -1):
#      print(i * '*')

# n = int(input())
# for _ in range(n):
#     print('*' * n)
#     n -= 1

# m = int(input())  # стартовое количество организмов
# p = int(input())  # среднесуточное увеличение в %
# n = int(input())  # количество дней для размножения

# for i in range(n):
#     print(i + 1, m)
#     m = m + m * p / 100

# m = int(input())
# n = int(input())

# if n < m:
#     for _ in range(m, n - 1, -1):
#         print(_)
# else:
#     for _ in range(m, n + 1):
#         print(_)

# for _ in range(m, n - 1, -1):
#     if _ % 2 != 0:
#         print(_)
# m = m % 2 - 1 + m  # сделать число нечетным
# for _ in range(m, n - 1, -2):
#     print(_)  

# m = int(input())
# n = int(input())

# for _ in range(m, n + 1):
#     if _ % 17 == 0 or _ % 10 == 9 or _ % 3 == 0 and _ % 5 == 0:
#         print(_)

# n = int(input())

# for i in range(1, 11):
#     print(f'{n} x {i} = {n * i}')

# a, b = int(input()), int(input())

# res = 0

# for i in range(a , b + 1):
#     if i ** 3 % 10 == 4 or i ** 3 % 10 == 9:
#     # if i ** 3 % 10 in [4, 9]:
#         res += 1
# print(res)

# n = int(input())
# res = 0
# for i in range(n):
#     var = int(input())
#     res += var
# print(res)

#7.3
# n = int(input())
# num = 0

# for i in range(1, n +1):
#     num += (1 / i)
# print(num - log(n))

# не существует полных квадратов, которые оканчиваются на 2 или 8
# n = int(input())
# res = 0
# for i in range(1, n + 1):
#     if i ** 2 % 10 in [5]:
#         res += i
# print(res) 

# n = int(input())
# res = 1
# for i in range(1, n + 1):
#     res *= i
# print(res)

# print(factorial(int(input())))




from math import *

# total = 1

# for _ in range(10):
#     n = int(input())
#     if n != 0:
#         total *= n
# print(total)

# n = int(input())
# total = 0
# for i in range(1, n +1):
#     if n % i == 0:
#         total += i
# print(total)

# n = int(input())
# tot = 0

# for i in range(n):
#     if i % 2 == 0:
#         tot += i + 1
#     else:
#         tot -= i + 1
# print(tot)

# n = int(input())
# largest = -1
# large = -1 
# for _ in range(1, n + 1):
#     num = int(input())
#     if num > largest:
#         large = largest
#         largest = num
#     elif num > large and num != largest:
#         large = num
# print(largest, large, sep='\n')


# yes = 0
# for _ in range(10):
#     n = int(input())
#     if n % 2 == 0:
#         yes += 1
# if yes == 10:
#     print('YES')
# else:
#     print('NO')

# n = int(input())

# first = 0
# second = 1

# for i in range(n):
#     first, second = second, first + second
#     print(first, end=' ')

# text = input()

# while text != 'КОНЕЦ' or text != 'конец':
#     print(text, end='\n')
#     text = input()

# text = input()
# res = 0
# while text not in ['стоп', 'хватит', 'достаточно']:
#     res += 1
#     text = input()
# print(res)

# n = int(input())

# while n % 7 == 0:
#     print(n, end='\n')
#     n = int(input())

# languages = ['Python', 'Java', 'C++', 'Ruby', 'C']
# print('\nWhen -3 is passed:') 
# print('Return Value:', languages.pop(-3))
# print('Updated List:', languages)

# print('\nWhen -1 is passed:') 
# print('Return Value:', languages.pop(-1)) 
# # print('Updated List:', languages)
# print('When index is not passed:') 
# print('Return Value:', languages.pop())
# print('Updated List:', languages)

# list = [{1, 2}, ('a'), ['1.1', '2.2']]
# del list[:]
# print('List:', list)


# secret = 8
# guess = 3

# if guess == secret:
#     print('just rigth')
# elif guess > 7:
#     print('too low')
# else:
#     print('too high')

# small = True
# green = False

# if small:
#     if green:
#         print('peas')
#     else:
#         print('cherry')
# if not small:
#     if green:
#         print('watermelon')
#     else:
#         print('pumpkin')            

# actor = 'krutoi_pacan'

# "My wife's favourite actor is %+s" % actor
# Q: вопрос
# A: ответ

questions = [
"We don't serve strings around here. Are you a string?",
"What is said on Father's Day in the forest?",
"What makes the sound 'Sis! Boom! Bah!'?"
]

answers = [
"An exploding sheep.",
"No, I'm a frayed knot.",
"'Pop!' goes the weasel."
]

print(f'Q:{questions[0]}\nA:{answers[0]}')
print(f'Q:{questions[1]}\nA:{answers[2]}')
print(f'Q:{questions[2]}\nA:{answers[1]}')
