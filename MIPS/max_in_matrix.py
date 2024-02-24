#Task7

"""
author : Loi Chai Lam
date : 5/8/2017
pre-condition : the_list only contain natural number, >0
              : size of the list > 0
              : number of cities > 0
              : number of days > 0
post-condition : -

"""


def maximum(the_list,size):
    """
    This function is used to find the maximum number in the_list
    argument : the_list, size
    return : maximum_number 
    pre-condition : size>0 
    post-condition : -

    """
    maximum_number = the_list[0]
    i = 1
    while i < size: 
        if the_list[i] > maximum_number:
            maximum_number = the_list[i]
        i = i + 1    
    return maximum_number


cities_number = int(input("Enter the number of the cities : "))

#check for the cities_number
if cities_number > 0:
    
    tmp_data = [0] * cities_number #initialise the row
    days_number = int(input("Enter the number of the days : "))
    
    #check for the days_number
    if days_number > 0:
        
        i = 0
        while i < cities_number:
            tmp_data[i] = [0] * days_number #initialise the column
            i = i + 1
            
        j = 0
        while j < cities_number:
            k = 0           
            while k < days_number:
                #input the data
                tmp_data[j][k] = int(input("Enter temperature data of city " +str(j+1)+" day "+str(k+1)+" : "))
                k = k + 1
            j = j + 1
            
        target_city = int(input("Enter the city 1 to "+str(cities_number)+" : "))

        print("The maximum temperature of city "+str(target_city)+" is "+ str(maximum(tmp_data[target_city-1],days_number)))

    else:

        print("The number of the days must larger than 0")   

else:

    print("The number of the cities must larger than 0")  

    





        



