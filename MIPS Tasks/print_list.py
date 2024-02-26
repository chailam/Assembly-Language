#Task2_a

"""
author : Loi Chai Lam
date : 5/8/2017
pre-condition : size > 0, item entered is integer
post-condition : -

"""

size = int(input("Size : "))
the_list = size * [0]

i = 0 #initialise i

#read in the item of the_list
while i < size:
    the_list[i] = int(input("Enter item(integer) : "))
    i = i + 1


j = 0 #initialise j

while j < size:
    print(the_list[j])
    j = j + 2
