#!/usr/bin/python

import sys

class Letter:
    amount = 0
    counter = 0
    letter = ''
    def __init__(self, letter):
        self.letter = letter
    
    def display(self):
        print('{0}  {1}  {2:.2f}%'.format(self.letter, self.counter, (100 * self.counter / Letter.amount))) 


try:
    with open(str(sys.argv[1])) as file:
        lines = file.readlines()

except FileNotFoundError:
    print('Missing "{0}" file'.format(str(sys.argv[1])))
    exit()

letters = []
for letter in lines[0]:
    if letter not in letters:
        if letter != '\n':
            letters.append(Letter(letter))

lines[0] = ""

for line in lines:
    for letter in letters:    
        c = line.count(letter.letter)
        letter.counter += c
        Letter.amount += c

letters.sort(key=lambda x: x.counter, reverse=True)

for letter in letters:
    letter.display()
