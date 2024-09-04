
from collections import Counter

def countWord(s = input()):
    letters_count = Counter(s.lower())
    tinkoff_count = Counter('tinkoff')
    max_words = float('inf')
    
    for letter, count in tinkoff_count.items():
        if letters_count[letter] // count < max_words:
            max_words = letters_count[letter] // count
    return max_words
    