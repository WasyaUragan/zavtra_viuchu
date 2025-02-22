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

# questions = [
# "We don't serve strings around here. Are you a string?",
# "What is said on Father's Day in the forest?",
# "What makes the sound 'Sis! Boom! Bah!'?"
# ]

# answers = [
# "An exploding sheep.",
# "No, I'm a frayed knot.",
# "'Pop!' goes the weasel."
# ]

# print(f'Q:{questions[0]}\nA:{answers[0]}')
# print(f'Q:{questions[1]}\nA:{answers[2]}')
# print(f'Q:{questions[2]}\nA:{answers[1]}')


# count = 1
# while count <= 5:
#     print(count)
#     count += 1

# while True:
#     staff = input("String to capitalize [type q to quit]: ")
#     if staff == "q":
#         break
#     print(staff.capitalize())

# while True:
#     value = input("Integer, please [q to quit]: ")
#     if value == 'q':
#         break
#     number = int(value)
#     if number % 2 == 0:
#         continue
#     print(number, "squared is", number*number)

# numbers = [1, 3, 5]
# position = 0
# while position < len(numbers):
#     number = numbers[position]
#     if number % 2 == 0:
#         print('Found even number', number)
#         break
#     position += 1
# else:
#     print('Not even number found')

# test = [3, 2, 1, 0]
# for i in test:
#     print(i)

# Присвойте значение 7 переменной guess_me и значение 1 переменной number. На-
# пишите цикл while, который сравнивает переменные number и guess_me. Выведите
# строку 'too low', если значение переменной number меньше значения переменной
# guess_me. Если значение переменной number равно значению переменной guess_me,
# выведите строку 'found it!' и выйдите из цикла. Если значение переменной
# number больше значения переменной guess_me, выведите строку 'oops' и выйдите
# из цикла. Увеличьте значение переменной number на выходе из цикла.

# guess_me = 7
# number = 1

# while True:
#     if number < guess_me:
#         print('too low')
#     elif number == guess_me:
#         print('found it!')
#         break
#     elif number > guess_me:
#         print('oops')
#         break
#     number = number + 1

# guess_me = 5

# for number in range(10):
#     if number < guess_me:
#         print('too low')
#     elif number == guess_me:
#         print('found it!')
#         break
#     elif number > guess_me:
#         print('oops')
#         break

# number_list = []
# number_list.append(1)
# number_list.append(2)
# number_list.append(3)
# number_list.append(4)
# number_list.append(5)

# for i in range(1,6):
#     number_list.append(i)
# print(number_list)

# number_list = list(range(1,6))
# print(number_list)

# number_list = [number for number in range(1,6)]
# print(number_list)

# rows = range(1,4)
# cols = range(1,3)
# for row in rows:
#     for col in cols:
#         print(row, col)

# rows = range(1,4)
# cols = range(1,3)
# cells = [[row, col] for row in rows for col in cols]
# for row, col in cells:
#     print(row, col)


# small_birds = ['hummingbird', 'finch']
# extinct_birds = ['dodo', 'passenger pigeon', 'Norwegian Blue']
# carol_birds = [3, 'French hens', 2, 'turtledoves']
# all_birds = [small_birds, extinct_birds, 'macaw', carol_birds]

# print(all_birds[0][1])

# years_list = [years for years in range(1991,1997)]
# print(years_list)
# print(years_list[3])
# print(max(years_list))

# things = ['mozzarella', 'cinderella', 'salmonella']

# print(things[1].capitalize())
# print()

# print(things[0].upper())

# print(things)

#Можно «разбить» кортеж с именем args на позиционные параметры *args внутри
#функции, которые затем будут пересобраны в кортеж-параметр args

# def print_args(*args):
#     print('Positional argument tuple:', args)
# print_args()
# print_args(2, 5, 7, 'x')
# args = (2,5,7,'x')
# print_args(args)

# print_args(*args)

# class Person:
#     def __init__(self, n, s, r=1):
#         self.name = n
#         self.surname = s
#         self.rank = r

# p1 = Person('Ilon', 'Fucking', 'Musk')

# print(p1.name, p1.surname, p1.rank)

# def print_args(*args):
#     print('Positional argument tuple:', args)

# print_args('onetwo', 'onetwo')

# list = {1: 'a', 2: 'b', 3: 'c'}

# print(type(list))
# print(*list)

# def print_kwargs(**kwargs):
#     print('Keyword arguments:', kwargs)
    
# print_kwargs()
# print_kwargs(wine='merlot', entree='mutton', dessert='macaroon')

# def print_data(data, *, start=0, end=100):

# for value in (data[start:end]):

# print(value)

# data = ['a', 'b', 'c', 'd', 'e', 'f']
# >>> print_data(data)

# class Vehicle(object):
#     """docstring"""
 
#     def __init__(self, color, doors, tires):
#         """Constructor"""
#         self.color = color
#         self.doors = doors
#         self.tires = tires
    
#     def brake(self):
#         """
#         Stop the car
#         """
#         return "Braking"
    
#     def drive(self):
#         """
#         Drive the car
#         """
#         return "I'm driving!"

# if __name__ == "__main__":
#     car = Vehicle("blue", 5, 4)
#     print(car.color)
    
#     truck = Vehicle("red", 3, 6)
#     print(truck.color)

# import errno
# print(errno.errorcode.keys())

# def lol(kwargs, *, start=0, end=100):
#     for value in (kwargs[start:end]):
#         print(value)

# etodrugoe = ['nu', 'nichego', 'sebe', 'nomer']

# lol(etodrugoe, start=1, end=3)

# def answer():
#     print(42)

# def run_something(func):
#     func()

# run_something(answer)

# def add_args(arg1, arg2):
#     print(arg1 + arg2)

# def run_something_with_args(func, arg1, arg2):
#     func(arg1, arg2)

# def sum_args(*args):
#     return print(sum(args))

# def run_with_positional_args(func, *args):
#     return func(*args)

# run_with_positional_args(sum_args, 1, 2, 3, 4)

# def knights(saying):
#     def inner(quote):
#         return "We are the knights who say: '%s'" % quote
#     return inner(saying)

# print(knights('shabat_shalom'))

# def knights2(saying):
#     def inner2():
#         return "We are the knights who say: '%s'" % saying
#     return inner2
# a = knights2('shabat_shalom')
# # print(a())

# def document_it(func):
#     def new_function(*args, **kwargs):
#         print('Running function:', func.__name__)
#         print('Positional arguments:', args)
#         print('Keyword arguments:', kwargs)
#         result = func(*args, **kwargs)
#         print('Result:', result)
#         return result
#     return new_function

# print(document_it(a))

# def add_ints(a, b):
# 	return a + b

# add_ints(3, 5)

# cooler_add_ints = document_it(add_ints) # создание декоратора вручную
# cooler_add_ints(3, 5)


# def print_kwargs(**kwargs):
#     print('Keyword arguments:', kwargs)

# print_kwargs(wine='merlot', entree='mutton', dessert='macaroon')

# def edit_story(words, func):
#  	for word in words:
#  		print(func(word))

# stairs = ['thud', 'meow', 'thud', 'hiss']

# def enliven(word): # больше эмоций!
#  	return word.capitalize() + '!'

# edit_story(stairs, enliven)

# def my_range(first=0, last=10, step=1):
#     number = first
#     while number < last:
#         yield number
#         number += step

# #возвращает объект генератора:
# ranger = my_range(1, 5)
# ranger

# #Мы можем проитерировать по этому объекту генератора:
# for x in ranger:
#     print(x)


#9.3. Определите декоратор test, который выводит строку 'start' при вызове функ-
#ции и строку 'end', когда функция завершает свою работу.

# def test(func):
#     def wrapper():
#         print('start')
#         func()
#         print('end')
#     return wrapper

# def tst():
#     print('nu nuhuyasibe')


# tsttsts = (test(tst))

# tsttsts()

#9.4. Определите исключение OopsException. Сгенерируйте его и посмотрите, что
#произойдет. Затем напишите код, позволяющий поймать это исключение и вы-
#вести строку 'Caught an oops'.

# def print_data(data, *, start=1, end=3):
#     for value in (data[start:end]):
#         print(value)

# data = ['a', 'b', 'c', 'd', 'e', 'f']
# print_data(data)

# outside = ['one', 'fine', 'day']
# def mangle(arg):
#     arg[1] = 'terrible!'

# mangle(outside)
# print(outside)

# def echo(anything):
#     'echo returns its input argument'
#     return anything

# print(echo.__doc__)


# def print_if_true(thing, check):
#     '''
#     Prints the first argument if a second argument is true.
#     The operation is:
#     1. Check whether the *second* argument is true.
#     2. If it is, print the *first* argument.
#     '''
#     if check:
#         print(thing)

# # help(print_if_true)
# print(print_if_true.__doc__)

# def knights2(saying):
#     def inner2():
#         return "We are the knights who say: '%s'" % saying
#     return inner2

# a = knights2('nihuya_sibe1')
# print(a())

# def my_range(first=0, last=10, step=1):
#     number = first
#     while number < last:
#         yield number
#         number += step

# ranger = my_range(1, 5)

# for x in ranger:
#     print(x)

# def my_shiny_new_decorator(function_to_decorate):
#     # Внутри себя декоратор определяет функцию-"обёртку". Она будет обёрнута вокруг декорируемой,
#     # получая возможность исполнять произвольный код до и после неё.
#     def the_wrapper_around_the_original_function():
#         print("Я - код, который отработает до вызова функции")
#         function_to_decorate() # Сама функция
#         print("А я - код, срабатывающий после")
#     # Вернём эту функцию
#     return the_wrapper_around_the_original_function

# def stand_alone_function():
#     print("Я простая одинокая функция, ты ведь не посмеешь меня изменять?")

# stand_alone_function()


# stand_alone_function_decorated = my_shiny_new_decorator(stand_alone_function)
# stand_alone_function_decorated()

# def flatten(lol):
#     for item in lol:
#         if isinstance(item, list):
#             for subitem in flatten(item):
#                 yield subitem
#         else:
#             yield item

# lol = [1, 2, [3,4,5], [6,[7,8,9], []]]

# flatten(lol)

# print(list(flatten(lol)))


# def flatten(lol):
#     for item in lol:
#         if isinstance(item, list):
#             yield from flatten(item)
#         else:
#             yield item

# lol = [1, 2, [3,4,5], [6,[7,8,9], []]]
# print(list(flatten(lol)))

# short_list = [1, 2, 3]
# position = 5
# try:
#     short_list[position]
# except:
#     print('Need a position between 0 and', len(short_list)-1, ' but got', position)

# # Need a position between 0 and 2 but got 5

# # Любое исключение является классом, частным случаем класса Exception.
# class UppercaseException(Exception):
#     pass

# words = ['eeenie', 'meenie', 'miny', 'MO']
# for word in words:
#     if word.isupper():
#         raise UppercaseException(word)

# #[zhuzhu@workpc ~]$ /bin/python /opt/GIT/zavtra_viuchu/python_stepik/test.py
# #Need a position between 0 and 2  but got 5
# #Traceback (most recent call last):
# #  File "/opt/GIT/zavtra_viuchu/python_stepik/test.py", line 1201, in <module>
# #    raise UppercaseException(word)
# #__main__.UppercaseException: MO
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
#                 print('It\'s not a link!')
#         else:
#             print('It\'s not a link!')
#     else:
#         print('It\'s not a link!')

# a = link_validation(link)
# print(a)

# import pygit2
# from pygit2 import Repository

# current_working_directory = os.getcwd()
# repository_path = current_working_directory
# repo = Repository(input('Адрес проекта в GIT: '))

# import unittest
# from giturlparse import parse 


# p = 'gitlab.draszi.fintech.ru:code/fintech_tools/python3-fintec'


# print(parse(p).valid)


# class Repository:

#     """Pickleable proxy for pygit2.Repository."""

#     def __init__(self, path):
#         self._repo = pygit2.Repository(path)

#     def __getattr__(self, key):
#         return getattr(self._repo, key)

#     def __getitem__(self, key):
#         return self._repo[key]

#     def __getstate__(self):
#         return self._repo.path

#     def __setstate__(self, path):
#         self._repo = pygit2.Repository(path)

# def __init__(self):
#     self.gitdir = pygit2.discover_repository('.')
#     self.objmap = os.path.join(self.gitdir, 'objmap')
#     self.repo = Repository(self.gitdir)
#либа парамика

# process = subprocess.Popen(['echo', 'More output'],
#                      stdout=subprocess.PIPE, 
#                      stderr=subprocess.PIPE)
# stdout, stderr = process.communicate()
# print(stdout, stderr)

#  git ls-remote the-url-to-tes
import os
import math


# n = int(input())

# while n % 7 == 0:
#     print(n, end='\n')
#     n = int(input())

# score = int(input())
# count = 0

# while 1 <= score <= 5:
#     if score == 5:
#         count += 1
#     score = (int(input()))
# print(count)

# n = int(input())
# count = 0

# for i in (25, 10, 5, 1):
#     while n >= i:
#         count += 1
#         n = n - i
# print(count)    
    


# while n != 0:
#     last_digit = n % 10
#     print(last_digit, end='\n')
#     n = n // 10

# reversed_n = ''
# while n:
#     last_digit = n % 10
#     reversed_n = reversed_n + str(last_digit)
#     n = n // 10
# print(reversed_n)   
 
# n = int(input())
# row = ''

# while n >= 10:
#     last_digit = n % 10
#     row = row + str(last_digit)
#     n = n // 10
# if n < 10:
#     row = row + str(n)
# print('Максимальная цифра равна ' + max(row))
# print('Минимальная цифра равна ' + min(row))

# n = int(input())
# sum_all, count = 0, 0
# multiplication = 1

# last_digit = n % 10

# while n != 0:
#     last_in_circle = n % 10
    
#     sum_all += last_in_circle
#     count += 1
#     multiplication *= last_in_circle
#     first_digit = n
    
#     n = n // 10
    
# sum_fl = first_digit + last_digit
# avg = sum_all / count 
    
# print(sum_all, count, multiplication,
#       avg, first_digit, sum_fl, sep='\n',
#       )

# n = int(input())

# while n != 0:
#     last_in_circle = n % 10
#     if n < 100:
#         second_digit = n % 10
#         break
#     n = n // 10    

# print(second_digit)

# n = int(input())
# last_digit = n % 10
# result = 'YES'

# while n != 0:
#     memory_digit = n % 10    
#     if last_digit != memory_digit:
#         result = 'NO'    
#     n //= 10
    
# print(result)

# n = int(input())
# n = str(n)
 
# if max(n) != min(n):
#     print('NO')
# else:
#     print('YES')

# n = int(input())
# result = 'YES'

# while n != 0:
#     last_digit = n % 10
#     prelast_digit = n // 10 % 10
#     if last_digit > prelast_digit:
#         result = 'NO'
#         break
#     else:
#         if n > 99:
#             n //= 10
#         else:
#             break
      
# print(result)

# 12123223

# for i in range(1, 101):
#     if i == 7 or i == 17 or i == 29 or i == 78:
#         continue  # переходим на следующую итерацию
#     print(i)

# n = int(input())

# for i in range(2, n + 1):
#     if n % i == 0:
#         print(i)
#         break
#     else:
#         continue

# n = int(input())

# for i in range(1, n + 1):
#     if 5 <= i <= 9 or 17 <= i <= 37 or 78 <= i <= 87:
#         continue
#     print(i, end='\n')

# maximum = -1000000
# summary = 0

# for _ in range(10):
#     x = int(input())
#     if x < 0:
#         summary += x
#         if x > maximum:
#             maximum = x

# if summary < 0:          
#     print(summary, maximum, sep='\n')
# else:
#     print('NO')

# summary = 0

# for _ in range(7):
#     n = int(input())
#     if n % 2 == 0:
#         summary += n
        
# print(summary)

# n = int(input())
# count = 0
# max_digit = n % 10

# while n > 1:
#     current_digit = n % 10
#     if current_digit % 3 == 0:
#         count += 1
#         if current_digit < max_digit:
#             current_digit = max_digit
#     n = n // 10
    
# if count == 0:
#     print('NO')
# else:
#     print(max_digit)


# n = int(input())
# max_digit = n % 10

# while n > 0:
#     digit = n % 10
#     if digit % 3 == 0:
#         if digit < max_digit:
#             digit = max_digit
#     n = n % 10
    
# if max_digit == 0:
#     print('NO')
# else:
#     print(max_digit)
    
    
# n = int(input())

# for i in range(1, n + 1):
#     print(i, i, i, i, i)

# n = int(input())

# for i in range(1, n + 1):
#     for j in range(5):
#         print(i, end=' ')
#     print()
    
# n = int(input())

# for i in range(1, n // 2 + 1):
#     for _ in range(1, i + 1):
#         print('*', end='')
#     print()

# for j in range(n // 2 + 1, 0, -1):
#     for _ in range(1, j + 1):
#         print('*', end='')
#     print()

# n = int(input())

# for i in range(1, n + 1):
#     for j in range(i):
#         if i + j <= n:
#             print('*', end='')
        
#     print()

# n < 14
# k < 13
# m < 12

# total = 0

# for n in range(1, 14):
#     for k in range(1, 13):
#         for m in range(1, 12):
#             if 28 * n + 30 * k + 31 * m == 365:
#                 total += 1
#                 print(n, k, m, sep='\n')
#                 print()
# print('Общее количество решений: ', total)

# b + k + t == 100



# total = 0

# for b in range(1, 11):
#     for k in range(1, 21):
#         for t in range(1, 201):
#             if b * 10 + k * 5 + t * 0.5 == 100:
#                 if b + k + t == 100:
#                     total += 1
#                     print(b, k , t, sep='\n')
#                     print()
# print('Общее количество решений: ', total)                

# for i in range(144,152):
#     for x in range(5, 152,4):
#         for y in range(4, 152,4):
#             for z in range(3, 152,4):
#                 for w in range(2, 152,4):
#                     if (x**5)+(y**5)+(z**5)+(w**5)==i**5:
#                         print(i+x+y+z+w)


# n = int(input())
# total = 1

# for i in range(1, n + 1):
#     for _ in range(1, i + 1):
#         print(total, end=' ')
#         total += 1
#     print()


# n = int(input())

# for i in range(1, n + 1):
#     for j in range(i):
#         print(j + 1, end='')
#     for x in range(i - 1, 0, -1):
#         print(x, end='')
#     print()

# a = int(input())
# b = int(input())

# n = int(input())

# for i in range(1, n + 1):
#     count = 0
#     for j in range(1, i + 1):
#         if i % j == 0:
#             count += 1
#     print(i, '+' * count, sep='')

# a, b = int(input()), int(input())

# for i in range(a, b + 1):
#     count = 0
#     for j in range(1, i + 1):
#         if i % j == 0:
#             count += 1
#     if count == 2:
#         print(i, end='\n')

# n = int(input())

# while n > 9:
#     summary = 0
#     while n > 0:
#         last_digit = n % 10
#         summary += last_digit
#         n //= 10
#     n = summary    
# print(n)
        
# a, b = int(input()), int(input())
# total = 0
# largest = 0

# for i in range(a, b + 1):
#     counter = 0
#     for j in range(1, i + 1):
#         if i % j == 0:
#             counter += j
#         if counter >= total:
#             total = counter
#             largest = i    
# print(largest, total)     
        
# n = int(input())
# max_digit = -1

# while n > 0:
#     digit = n % 10
#     if digit % 3 == 0:
#         if digit > max_digit:
#             max_digit = digit
#     n = n // 10
    
# if max_digit % 3 != 0:
#     print('NO')
# else:
#     print(max_digit)


# s = input()

# for i in range(0, len(s), 2):
#     print(s[i])

# s = input()

# for i in range(-1, -len(s) - 1, -1):
#     print(s[i])

# name = input()
# surname = input()
# otchestvo = input()


# n, surn, otch = input(), input(), input()

# print(surn[0], n[0], otch[0], sep='')

# s = ''
# for _ in range(3):
#     i = input()
#     s = s + i[0]
# print(s[1] + s[0] + s[2])

# string = input()
# summary = 0
    
# for number in range(len(string)):
#     summary += int(string[number])
# print(summary)
    
# s = input()
# sl = 0
# umn = 0

# for c in s:
#     if '+' in c:
#         sl += 1
#     if '*' in c:
#         umn += 1
# print('Символ + встречается', sl, 'раз')
# print('Символ * встречается', umn, 'раз')
        
# s = input()

# vovels = 'ауоыиэяюёеАУОЫИЭЯЮЁЕ'
# consonants = 'бвгджзйклмнпрстфхцчшщБВГДЖЗЙКЛМНПРСТФХЦЧШЩ'
# vov = 0
# cons = 0

# for c in s:
#     if c in vovels:
#         vov += 1
#     elif c in consonants:
#         cons += 1
        
# print('Количество гласных букв равно', vov)
# print('Количество согласных букв равно', cons)

# word = input()

# if word[:] == word[::-1]:
#     print('YES')
# else:
#     print('NO')

# string = input()

# print(string[2])
# print(string[-2])
# print(string[:5])
# print(string[:-2])
# print(string[::2])
# print(string[1::2])
# print(string[::-1])
# print(string[-1::-2])

# string = input()

# if len(string) % 2 == 0:
#     half = len(string) // 2
# else:
#     half = (len(string) // 2) + 1
        
# print(string[half:] + string[:half])

# imyafamiliya = input()

# if imyafamiliya.istitle():
#     print('YES')
# else:
#     print('NO')

# stroka = input()

# print(input().swapcase())

# stroka = input()
# stroka = stroka.lower()

# if 'хорош' in stroka:
#     print('YES')
# else:
#     print('NO')

# string = input()
# counter = 0

# for c in string:
#     if c != c.title():
#         counter += 1
# print(counter)
    
# string = input()
# a, g, c, t = 'а', 'г', 'ц', 'т'
# string = string.lower()

# print('Аденин:', string.count(a))
# print('Гуанин:', string.count(g))
# print('Цитозин:', string.count(c))
# print('Тимин:', string.count(t))

# obrascheniya = int(input())
# count = 0

# for _ in range(obrascheniya):
#     a = input()
#     messages = a.count('11')
#     if messages >= 3:    
#         count += 1
        
# print(count)
        
# string = input()
# numbers = '0123456789'
# count = 0

# for c in string:
#     if c in numbers:
#         count += 1

# print(count)

# string = input()

# if string.endswith(('.com', '.ru')):
#     print('YES')
# else:
#     print('NO')

# string = input()
# # c = 'f'
# count = 0

# for _ in string:
#     if _ == 'f':
#         count += 1

# if count >= 2:
#     print(string.find('f'), string.rfind('f') + 1)
# elif count == 1:
#     print(string.find('f'))
# else:
#     print('NO')
#########################################
#########################################
###############05.08.24##################

n = input()

spisok = list(n.split())
result = 0
chislo = []

for i in spisok:
    tmp = spisok.count(i)
    if i not in chislo:
        if tmp > 1:
            result += 1
            chislo.append(i)
        else:
            continue
    else:
        continue

print(result)









