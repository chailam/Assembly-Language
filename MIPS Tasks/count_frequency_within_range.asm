#task 6
#author : Loi Chai Lam
#date : 11/8/2017
.data
size: .word 0
sizeprint: .asciiz "Size : "
i: .word 0 #initialise i
item: .word 0 #assume the item entered is an integer
itemprint: .asciiz "Enter item(integer) : "
condition: .asciiz "The size must larger than 0"
aprint: .asciiz "Enter a : "
bprint: .asciiz "Enter b : "
a: .word 0
b: .word 0
the_list: .word 0
str1: .asciiz " appears "
str2: .asciiz " times "
newline: .asciiz "\n"
condition2: .asciiz "a must smaller than b"

.text
j main

frequency: #function frequency
#callee call for frequency
#save ra and fp on stack
addi $sp,$sp,-8 #allocate 8bytes for ra and fp
sw $ra,4($sp) #save $ra to -4($sp) 
sw $fp,($sp) #save $fp to -8($sp) 
move $fp,$sp #fp = sp
addi $sp,$sp,-8 #allocate stack 8 byte (2 local variables, target and occurence)

#body of function frequency
while1:
lw $t0,8($fp) #t0=a=8(fp)
lw $t1,12($fp) #t1=b=12(fp)
bgt $t0,$t1,exit #if a>b, goto exit;else, continue
sw $t0,-4($fp) #save a to -4(fp), first local variable(target)

#caller call for the_target function
#pass argument on stack
addi $sp,$sp,-12 #3 argument ,allocate 12 bytes
lw $t0,20($fp) #t0=the_list
lw $t1,16($fp) #t1=size
lw $t2,-4($fp) #t2=-4(fp)=target=local variable of frequency function
sw $t0,($sp) #(sp)=the_list=argument of the_target
sw $t1,4($sp) #4(sp)=size=argument of the_target
sw $t2,8($sp) #8(sp)=target=argument of the_target
jal the_target

#caller return for the_target
#clear argument off stack
addi $sp,$sp,12 #3 arguments, 12bytes
sw $v0,-8($fp) #save v0 to local variable of occurence(-8fp)

li $v0,1 #print a
lw $a0,8($fp)
syscall
li $v0,4 #print str1
la $a0,str1
syscall
li $v0,1 #print occurence
lw $a0,-8($fp)
syscall
li $v0,4 #print str2
la $a0,str2
syscall
li $v0,4 #print newline
la $a0,newline
syscall

lw $t0,8($fp) #t0=8(fp)=a
addi $t0,$t0,1 #a=a+1
sw $t0,8($fp) #save a back to 8(fp)
j while1

the_target: #function the_target
#callee call for the_target function
#save ra and fp on stack
addi $sp,$sp,-8 #allocate 8bytes for ra and fp
sw $ra,4($sp) #save $ra to -4($sp) 
sw $fp,($sp) #save $fp to -8($sp) 
move $fp,$sp #fp = sp
addi $sp,$sp,-8 #allocate stack 8 byte (2 local variables, occurence and j)

#body of function the_target
li $t0,0 #t0=0=j
li $t1,0 #t1=0=occurence
sw $t0,-4($fp) #-4(fp)=0=j, save local variable
sw $t1,-8($fp) #-8(fp)=0=occurence, save local variable

while2:
lw $t0,-4($fp) #t0=j
lw $t1,12($fp) #t1=size
#if j>=size,endwhile2;else,continue
bge $t0,$t1,endwhile2

lw $t0,-4($fp) #t0=j
lw $t1,8($fp) #t1=8(fp)=the_list

#calculate the_list[j] (address+4+4j)
li $t3,4 #t3=4
mult $t0,$t3 #4*j
mflo $t3 #t3=4*j
addi $t3,$t3,4 #t3=4*j+4
add $t3,$t3,$t1 #t3=address+4+4*i=the_list[j]
lw $t3,($t3) #t3=the_list[j]
lw $t2,16($fp) #t2=16(fp)=target
#if target !=the_list[j],goto endif; else, continue
bne $t2,$t3,endif
lw $t0,-8($fp) #t0=-8(fp)=occurence
addi $t0,$t0,1#occurence=occurence+1
sw $t0,-8($fp) #save occurence back to -8(fp)

endif:
lw $t0,-4($fp) #t0=-4(sp)=j
addi $t0,$t0,1 #j=j+1
sw $t0,-4($fp) #save j back to -4(fp)
j while2

endwhile2:
#callee return for the_target function
lw $v0,-8($fp) #v0=-8(fp)=occurence=return value
addi $sp,$sp,8 #clear 2 local variable (8 bytes)
lw $fp,0($sp) #restore saved $fp 
lw $ra,4($sp) #restore saved $ra 
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

#print aprint
li $v0,4
la $a0,aprint
syscall

#input a and save it 
li $v0,5
syscall
sw $v0,a

#print bprint
li $v0,4
la $a0,bprint
syscall

#input b and save it 
li $v0,5
syscall
sw $v0,b

lw $t0,a #t0=a
lw $t1,b #t1=b
bge $t0,$t1,endcondition #if a>=b, goto endcondition; else, continue
#caller call for frequency
#pass argument on stack
addi $sp,$sp,-16 #4 argument ,allocate 16 bytes
lw $t0,a #t0=a
lw $t1,b #t1=b
lw $t2,size #t3=size
lw $t3,the_list #t4=the_list
sw $t0,($sp) #save a to ($sp)
sw $t1,4($sp) #save b to 4($sp)
sw $t2,8($sp) #save size to 8($sp)
sw $t3,12($sp) #save the_list to 12($sp)
jal frequency

#caller return for frequency
#clear argument off stack
addi $sp,$sp,16 #4 arguments, 16bytes
j exit

endcondition:
li $v0,4 #print condition2
la $a0,condition2
syscall
j exit

endsize:
la $a0,condition
li $v0,4 #print the condition
syscall

exit:
li $v0,10#exit the program
syscall
