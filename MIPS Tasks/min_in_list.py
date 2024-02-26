#Task5

"""
author : Loi Chai Lam
date : 5/8/2017
pre-condition : the_list only contain natural number, >0
              : size of the list > 0 
post-condition : occurence >= 0

"""


def minimum(the_list,size):
    """
    This function is used to find the minimum number in the_list
    argument : the_list, size
    return : minimum_number 
    pre-condition : size>0 
    post-condition : -

    """
    minimum_number = the_list[0]
    i = 1
    while i < size: 
        if the_list[i] < minimum_number:
            minimum_number = the_list[i]
        i = i + 1    
    return minimum_number
    


size = int(input("Size : "))

if size > 0:
    the_list = size * [0]

    i = 0 #initialise i

    #read in the item of the_list
    while i < size:
        the_list[i] = int(input("Enter item(integer) : "))
        i = i + 1
    print(minimum(the_list,size))
else:
    print("The size must larger than 0")        

