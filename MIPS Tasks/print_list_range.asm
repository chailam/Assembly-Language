#task3_c
#author : Loi Chai Lam
#date : 5/8/2017
.data
item: .word 0 #assume the item entered is an integer
itemprint: .asciiz "Enter item(integer) : "
condition: .asciiz "The size must larger than 0"
size: .word 0
sizeprint: .asciiz "Size : "
i: .word 0 #initialise i
j: .word 1 #initialise j
maximum: .word 0
minimum: .word 0
the_range: .word 0
the_list: .word 0

.text
#print sizeprint
li $v0,4
la $a0,sizeprint
syscall

#input the size and save it to size
li $v0,5
syscall
sw $v0,size

#if size <= 0, goto endsize , size>0, continue
lw $t0, size #t0=size
ble $t0,$0,endsize

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

#initialise the maximum and minimum
#calculate the address of the first integer and put it as maximum and minimum
#(address+4+4(0))
lw $t0,the_list
addi $t1,$t0,4 #address of the first item
lw $t2,($t1) #t2=first item
sw $t2,maximum #first item=maximum
sw $t2,minimum #first item=minimum

rangeloop:
#find the range of the_list
lw $t0,j #j=t0, initially j=1
lw $t1,size #t1=size
bge $t0,$t1,endrangeloop #j>=size, goto endrangeloop; j<size, find the range 

#calculate the required address(address of the_list+4+4*index)
lw $t0,j #j=t0
lw $t1,the_list #address of the_list=t1
li $t2,4 #4=t2
mult $t0,$t2 #4*j
mflo $t3 #t3=4*j
add $t3,$t3,$t2 #t3=4*j+4
add $t3,$t3,$t1 #t3=address+4+4*j

#load the item in the address to t4
lw $t4,($t3)

#comparison to find the maximum
lw $t5,maximum #t5=maximum
ble $t4,$t5,endif1 #if the_list[j](t4)<=maximum, goto minimum;t4>maximum, maximum=t4
sw $t4,maximum #maximum=the_list[j]

endif1:
#comparison to find the minimum
lw $t5,minimum #t5=minimum
bge $t4,$t5,endif2 #if the_list[j](t4)>=minimum, goto endif;t4<minimum, minimum=t4
sw $t4,minimum #minimum=the_list[j]

endif2:
#increase j
lw $t0,j #t0=j
addi $t0,$t0,1 #j=j+1
sw $t0,j #j=t0

#calculate the_range
lw $t0,maximum #t0=maximum
lw $t1,minimum #t1=minimum
sub $t2,$t0,$t1 #t2=maximum-minimum
sw $t2,the_range #the_range=t2
j rangeloop

endrangeloop:
#print the_range
li $v0,1
lw $a0,the_range
syscall
j exit

endsize:
la $a0,condition
li $v0,4 #print the condition
syscall

exit:
li $v0,10 #exit the program
syscall
