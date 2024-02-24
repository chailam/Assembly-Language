#task 5
#author : Loi Chai Lam
#date : 10/8/2017

.data
size: .word 0
sizeprint: .asciiz "Size : "
i: .word 0 #initialise i
item: .word 0 #assume the item entered is an integer
itemprint: .asciiz "Enter item(integer) : "
condition: .asciiz "The size must larger than 0"
the_list: .word 0

.text
j main

minimum: #the function name minimum
# callee call
addi $sp,$sp,-8 #allocate stack(-8)$sp 
sw $ra,4($sp) #save $ra to -4($sp) 
sw $fp,($sp) #save $fp to -8($sp) 
move $fp,$sp #fp = sp
addi $sp,$sp,-8 #allocate stack 8 byte (2 local variables,the_list and size) 

#body of function minimum
#calculate the address of the_list[0](address+4+4i,where i=0)
lw $t0,8($fp) #t0 = first argument(the_list)
li $t1,0 #t1=0
li $t2,4 #t2=4
mult $t1,$t2 #4*0
mflo $t1 #t1 = 4*0
addi $t1,$t1,4 #t1=4*0+4
add $t1,$t1,$t0 #address+4+4*0
lw $t2,($t1) #t2 = the_list[0]
sw $t2,-4($fp) #store minimum_number to -4($fp),first local variabla

li $t0,1 #t0=1
sw $t0,-8($fp) #store i to -8($fp),second local variable

while:
#condition check
lw $t0,-8($fp) #t0=i
lw $t1,12($fp) #t1 = second argument(size)
bge $t0,$t1,endwhile #if i>=size, goto endwhile, else continue

#calculate address of the_list[i] (address+4+4i)
lw $t0,8($fp) #t0 = first argument(the_list)
lw $t1,-8($fp) #t1=i=-8($fp)
li $t2,4 #t2=4
mult $t1,$t2 #4*i
mflo $t3 #t3=4*i
add $t3,$t3,$t2 #t3=4*i+4
add $t3,$t3,$t0 #t3=address+4+4*i

lw $t4,($t3) #t4=the_list[i]
lw $t5,-4($fp) #t5=minimum_number

#if the_list[i]>=minimum_number, goto endif; 
#else,minimum_number=the_list[i]
bge $t4,$t5,endif
sw $t4,-4($fp) #store latest minimum_number to stack(-4($fp))

endif:
lw $t0,-8($fp) #t0=i
addi $t0,$t0,1 #i=i+1
sw $t0,-8($fp) #store i back to stack
j while

endwhile:
#callee return
lw $v0,-4($fp) #save v0 as minimum_number(return value)
addi $sp,$sp,8 #clear 2 local variable(8 bytes)
lw $ra,4($sp) #restore saved $ra 
lw $fp,0($sp) #restore saved $fp
addi $sp,$sp,8 #clear it
jr $ra#return to caller

main:
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

#caller call
#pass argument on stack
lw $t0,the_list #t0=address of the_list
lw $t1,size #t1 = size
addi $sp,$sp,-8 #allocate two argument
sw $t0,0($sp) #save the_list to 0($fp)(first argument) 
sw $t1,4($sp) #save size to 4($fp)(second argument) 
jal minimum

#caller return
addi $sp,$sp,8 #clear 2 argument off stack
add $a0,$0,$v0 #a0=v0
li $v0,1 #print minimum_value
syscall
j exit

endsize:
la $a0,condition
li $v0,4 #print the condition
syscall

exit:
li $v0,10#exit the program
syscall
