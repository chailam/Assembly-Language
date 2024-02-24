#task2_b
#author : Loi Chai Lam
#date : 5/8/2017
.data
item: .word 0 #assume the item entered is an integer
itemprint: .asciiz "Enter item(integer) : "
size: .word 0
sizeprint: .asciiz "Size : "
i: .word 0 #initialise i
j: .word 0 #initialise j
the_list: .word 0
newline: .asciiz  "\n"

.text
#print sizeprint
li $v0,4
la $a0,sizeprint
syscall

#input the size and save it to size
li $v0,5
syscall
sw $v0,size

#calculate the required memory (4 + 4*size)
li $t0,4 #t0=4
lw $t1,size #t1=size
mult $t0,$t1 #4*size
mflo $t2 #t2=4*size
add $a0,$t0,$t2 #a0=4+4*size

#allocate memory in heap
li $v0,9
syscall

#the_list point to returned address and store the length
sw $v0,the_list
lw $t1,size #t1=size
sw $t1,($v0)

readloop:
#read the integer to the_list
lw $t0,i #i=t0, initially i=0
lw $t1,size #t1=size
bge $t0,$t1,endreadloop #i>=size, goto endreadloop; i<size, read the integer

#print itemprint
li $v0,4 
la $a0,itemprint
syscall

#read integer
li $v0,5
syscall

#calculate the required address to save the integer entered (address of the_list+4+4*index)
lw $t0,i #i=t0
lw $t1,the_list #address of the_list=t1
li $t2,4 #4=t2
mult $t0,$t2 #4*i
mflo $t3 #t3=4*i
add $t3,$t3,$t2 #t3=4*i+4
add $t3,$t3,$t1 #t3=address+4+4*i

#save the entered integer to the address
sw $v0,($t3)

#increase i
lw $t0,i #t0=i
addi $t0,$t0,1 #i=i+1
sw $t0,i #i=t0
j readloop

endreadloop:

printloop:
#print the integer in the_list
lw $t0,j #j=t0, initially j=0
lw $t1,size #t1=size
bge $t0,$t1,endprintloop #j>=size, goto endprintloop; j<size, print the integer in the_list

#calculate the required address to print the integer in the_list (address of the_list+4+4*index)
lw $t0,j #j=t0
lw $t1,the_list #address of the_list=t1
li $t2,4 #4=t2
mult $t0,$t2 #4*j
mflo $t3 #t3=4*j
add $t3,$t3,$t2 #t3=4*j+4
add $t3,$t3,$t1 #t3=address+4+4*j

#load the item in the address to a0
lw $a0,($t3)

#print the integer and newline
li $v0,1
syscall
li $v0,4
la $a0,newline
syscall

#increase j
lw $t0,j #t0=j
addi $t0,$t0,2 #j=j+2
sw $t0,j #j=t0
j printloop
endprintloop:

exit:
li $v0,10 #exit the program
syscall
