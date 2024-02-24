#task4
#author : Loi Chai Lam
#date : 5/8/2017
.data
size: .word 0
sizeprint: .asciiz "Size : "
i: .word 0 #initialise i
j: .word 0 #initialise j
item: .word 0 #assume the item entered is an integer
itemprint: .asciiz "Enter item(integer) : "
condition: .asciiz "The size must larger than 0"
target: .word 0
targetprint: .asciiz "Enter the target(integer) : "
str: .asciiz "The given temperature appears  "
occurence: .word 0
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

#print targetprint
li $v0,4
la $a0,targetprint
syscall

#input target and save to target
li $v0,5
syscall
sw $v0,target #target=v0

#find the occurence of the target in the_list
findloop:
lw $t0,j #t0=j, initially j=0
lw $t1,size #t1=size

bge $t0,$t1,endfindloop #if j>=size, goto endfindloop; j<size find the occurence of target

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

#comparison - find the occurence
lw $t0,target #t0=target
bne $t0,$t4,endtargetloop #if target!=the_list[j], goto endtargetloop; target=the_list[j], occurence+=1
lw $t1,occurence #t1=occurence
addi $t1,$t1,1 #t1=t1+1 (occurence=occurence+1)
sw $t1,occurence #occurence=t1

endtargetloop:
# increase j
lw $t0,j #t0=j
addi $t0,$t0,1 #t0=t0+1
sw $t0,j #j=t0
j findloop

endfindloop:
#print str and the occurence
li $v0,4
la $a0,str
syscall
li $v0,1
lw $a0,occurence #a0=occurence
syscall
j exit

endsize:
la $a0,condition
li $v0,4 #print the condition
syscall

exit:
li $v0,10#exit the program
syscall
