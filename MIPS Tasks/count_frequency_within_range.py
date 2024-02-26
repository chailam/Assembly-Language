#Task6

"""
author : Loi Chai Lam
date : 5/8/2017
pre-condition : the_list only contain natural number, >0
              : size of the list > 0
              : a < b , a > 0
              : a,b are integer
post-condition : occurence >= 0

"""

def the_target(the_list,size,target):
    """
    This function is used to find the occurence of target in the_list
    argument : the_list, size, target
    return : the occurence of the target
    pre-condition : size>0 , target>0
    post-condition : occurence>=0

    """
    occurence = 0
    j = 0
    while j < size:
        if target == the_list[j]:
            occurence = occurence + 1
        j = j + 1   
    return occurence    


def frequency(a,b,the_list,size):
    """
    This function is used to find the frequency from a to b in the_list
    argument : the_list, size, a, b
    return : the frequency from a to b of the target
    pre-condition : size>0 , a<b, a>0
    post-condition : each occurence>=0

    """
    while a <= b:
        target = a
        occurence = the_target(the_list,size,target)
        print(str(a)+" appears "+str(occurence)+" times " )
        a = a + 1

        
size = int(input("Size : "))
if size > 0:  
    the_list = size * [0]

    i = 0 #initialise i

    #read in the item of the_list
    while i < size:
        the_list[i] = int(input("Enter item(integer) : "))
        i = i + 1
    a = int(input("Enter a : "))
    b = int(input("Enter b : "))
    if a < b:
        frequency(a,b,the_list,size)
    else:
        print("a must smaller than b")
    
else:
    print("The size must larger than 0")
    

