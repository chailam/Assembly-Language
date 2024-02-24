#Task1_b

"""
author : Loi Chai Lam
date : 5/8/2017
pre-condition : year entered > 0
post-condition : -

"""
year = int(input("Enter a year : "))

##if (year%4 == 0 and year%100 != 0) or year%400 == 0:
##    print("Is a leap year")
##else:
##    print("Is not a leap year")
            
if year%400 == 0:
    print("Is a leap year")
else:
    if year%4 == 0:
        if year%100 != 0:
            print("Is a leap year")
        else:
            print("Is not a leap year")
    else:
        print("Is not a leap year")
