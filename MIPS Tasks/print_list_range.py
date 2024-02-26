#Task3_b

"""
author : Loi Chai Lam
date : 5/8/2017
pre-condition : size > 0 , item entered is integer
post-condition : the_range >= 0

"""

size = int(input("Size : "))

if size > 0:
    the_list = size * [0]

    i = 0 #initialise i

    #read in the item of the_list
    while i < size:
        the_list[i] = int(input("Enter item(integer) : "))
        i = i + 1

    maximum = the_list[0]
    minimum = the_list[0]

    j = 1 #initialise j

    #find the maximum, minimum and the_range of the_list
    while j < size:
        if the_list[j] > maximum:
            maximum = the_list[j]
        if the_list[j] < minimum:
            minimum = the_list[j]
        j = j + 1
        the_range = maximum - minimum
    print(the_range)    
else:
    print("The size must larger than 0")


