"""
Loi Chai Lam
Write an algorithm (in any language you prefer) which accepts four characters, performs a Base 64 decode on them, and
prints out the three decoded bytes. Use the above description of Base 64 as a guide. Note that you will need to use shifting
and masking to assemble the decoded bytes.
source : https://stackoverflow.com/questions/10493411/what-is-bit-masking

"""

import base64

def base64Decode(cha):
    assert len(cha) == 4 , "Length of the character should be 4."

    encoding = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y",
                "Z","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x",
                "y","z","0","1","2","3","4","5","6","7","8","9","+","/"]
    indexList = []
    binary = ""

    # To get the index of the character in encoding list
    for c in cha:
        indexList.append(encoding.index(c))

    # To change the index to 6 bits binary number
    for i in indexList:
        binary = binary + ("{0:06b}".format(i))

    # Mask and shift the binary number
    binary = int(binary,2)
    byte1 = binary >> 16
    byte2 = (binary & 0b1111111100000000) >> 8
    byte3 = binary & 0b0000000011111111
        
    result = chr(byte1) + chr(byte2) + chr(byte3)
    return result
    
        
def base64Decode11(cha):
    assert len(cha) == 4 , "Length of the character should be 4."

    encoding = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y",
                "Z","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x",
                "y","z","0","1","2","3","4","5","6","7","8","9","+","/"]
    indexList = []
    binary = ""

    # To get the index of the character in encoding list
    for c in cha:
        indexList.append(encoding.index(c))

    # First bytes
    tmp1 = indexList[0] 
    tmp2 = indexList[1] 

    tmp1 = tmp1 << 2 # first 8 bits (left shift 2: add two bits 0 at the end; shift all to left by 2)
    tmp2 = tmp2 >> 4 # second 8 bits
    result1 = chr(tmp1|tmp2) # First 8 bits formed by OR

    # Second bytes
    tmp1 = indexList[1] 
    tmp2 = indexList[2] 

    tmp1 = (tmp1 << 4)& 0b11111111 # first 8 bits  
    tmp2 = tmp2 >> 2 # second 8 bits
    result2 = chr(tmp1|tmp2) # Second 8 bits formed by OR

    # Third bytes
    tmp1 = indexList[2] 
    tmp2 = indexList[3] 

    tmp1 = (tmp1 << 6) & 0b11111111# first 8 bits & mask
    result3 = chr(tmp1|tmp2) # Third 8 bits formed by OR

    return(result1+result2+result3)

 
    
print(base64Decode("KGl0"))
print(base64Decode("J3Mp"))

print(base64Decode11("KGl0"))
print(base64Decode11("J3Mp"))
