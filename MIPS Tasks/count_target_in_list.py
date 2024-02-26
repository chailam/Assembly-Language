#Task4

"""
author : Loi Chai Lam
date : 5/8/2017
pre-condition : the_list only contain natural number, >0
              : size of the list > 0 
post-condition : occurence >= 0

"""

size = int(input("Size : "))

if size > 0:
    
    the_list = size * [0]

    i = 0 #initialise i

    #read in the item of the_list
    while i < size:
        the_list[i] = int(input("Enter item(integer) : "))
        i = i + 1


    target = int(input("Enter the target(integer) : "))
    j = 0 #initialise j
    occurence = 0

    #find the occurence of the target in the_list
    while j < size:
        if target == the_list[j]:
            occurence = occurence + 1
        j = j + 1    

    print("The given temperature appears "+ str(occurence))
else:
    print("The size must larger than 0")        
