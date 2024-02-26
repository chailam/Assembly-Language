#task 7
#author : Loi Chai Lam
#date : 11/8/2017
.data
cities_number: .word 0
cities_numberprint: .asciiz "Enter the number of the cities : "
days_number: .word 0
days_numberprint: .asciiz "Enter the number of the days : "
tmp_data: .word 0
str1: .asciiz "Enter temperature data of city "
str2: .asciiz " day "
str3: .asciiz " : "
str4: .asciiz "Enter the city 1 to "
str5: .asciiz "The maximum temperature of city "
str6: .asciiz " is "
i: .word 0
j: .word 0
k: .word 0
target_city: .word 0
condition1: .asciiz "The number of the days must larger than 0"
condition2: .asciiz "The number of the cities must larger than 0"

.text
j main

maximum: #function maximum
#callee call 
#save ra and fp on stack
addi $sp,$sp,-8 #allocate 8bytes for ra and fp
sw $ra,4($sp) #save $ra to -4($sp) 
sw $fp,($sp) #save $fp to -8($sp) 
move $fp,$sp #fp = sp
addi $sp,$sp,-8 #allocate stack 8 byte (2 local variables, maximum_number and i)

#body of function maximum
li $t0,1 #t0=1
sw $t0,-4($fp) #-4(fp)=t0=i=first local variable
lw $t0,8($fp) #t0=8(fp)=the_list

#calculate the_list[0] (address+4+4*0)
li $t1,0 #t1=0
li $t2,4 #t2=4
mult $t1,$t2 #4*0
mflo $t1 #t1 = 4*0
addi $t1,$t1,4 #t1=4*0+4
add $t1,$t1,$t0 #address+4+4*0
lw $t2,($t1) #t2 = the_list[0]
sw $t2,-8($fp) #store maximum_number to -8($fp),second local variabla

while:
#condition check
lw $t0,-4($fp) #t0=-4(fp)=i
lw $t1,12($fp) #t1=12(fp)=size
#if i>=size, goto endwhile; else, continue
bge $t0,$t1,endwhile

#calculate address of the_list[i] (address+4+4i)
lw $t0,8($fp) #t0 = first argument(the_list)
lw $t1,-4($fp) #t1=i=-4($fp)
li $t2,4 #t2=4
mult $t1,$t2 #4*i
mflo $t3 #t3=4*i
add $t3,$t3,$t2 #t3=4*i+4
add $t3,$t3,$t0 #t3=address+4+4*i

lw $t4,($t3) #t4=the_list[i]
lw $t5,-8($fp) #t5=maximum_number

#if the_list[i]<=maximum_number, goto endif; 
#else,maximum_number=the_list[i]
ble $t4,$t5,endif
sw $t4,-8($fp) #store latest maximum_number to stack(-8($fp))

endif:
lw $t0,-4($fp) #t0=i
addi $t0,$t0,1 #i=i+1
sw $t0,-4($fp) #store i back to stack
j while

endwhile:
#callee return
lw $v0,-8($fp) #save v0 as maximum_number(return value)
addi $sp,$sp,8 #clear 2 local variable(8 bytes)
lw $ra,4($sp) #restore saved $ra 
lw $fp,0($sp) #restore saved $fp
addi $sp,$sp,8 #clear it
jr $ra#return to caller

main:
#print cities_numberprint
li $v0,4
la $a0,cities_numberprint
syscall

#input integer and store it to cities_number
li $v0,5
syscall
sw $v0,cities_number

#check if cities_number<=0, goto endsize1; else, initialise citiesnumber
lw $t0,cities_number #t0=cities_number
ble $t0,$0,endsize1

#calculate the required memory (4 + 4*size)
li $t0,4 #t0=4
lw $t1,cities_number #t1=cities_number
mult $t0,$t1 #4*cities_number
mflo $t2 #t2=4*cities_number
add $a0,$t0,$t2 #a0=4+4*cities_number

#allocate memory in heap
li $v0,9
syscall

#tmp_data point to returned address and store the length
sw $v0,tmp_data
lw $t1,cities_number #t1=cities_number
sw $t1,($v0)


#print days_numberprint
li $v0,4
la $a0,days_numberprint
syscall

#input integer and store it to days_number
li $v0,5
syscall
sw $v0,days_number

#check if days_number<=0, goto endsize2; else,continue
lw $t0,days_number #t0=days_number
ble $t0,$0,endsize2

while1:
#condition check
lw $t1,i #t1=i
lw $t2,cities_number #t2=cities_number
#if i>=cities_number, goto endwhile1;
# else,initialise daysnumber
bge $t1,$t2,endwhile1

#calculate the required memory (4 + 4*days_number)
li $t0,4 #t0=4
lw $t1,days_number #t1=days_number
mult $t0,$t1 #4*days_number
mflo $t2 #t2=4*days_number
add $a0,$t0,$t2 #a0=4+4*days_number

#allocate memory in heap
li $v0,9
syscall

#calculate tmp_data[i] to save the column entered (address+4+4i)
lw $t0,i #i=t0
lw $t1,tmp_data #address of tmp_data=t1
li $t2,4 #4=t2
mult $t0,$t2 #4*i
mflo $t3 #t3=4*i
add $t3,$t3,$t2 #t3=4*i+4
add $t3,$t3,$t1 #t3=address+4+4*i

#save the initialise address of daynumber to tmp_data[i]
sw $v0,($t3)
#store the length
lw $t1,days_number #t1=days_number
sw $t1,($v0)

lw $t0,i #t0=i
addi $t0,$t0,1 #i=i+1
sw $t0,i #save i 

j while1
endwhile1:

while2:
lw $t0,j #t0=j
lw $t1,cities_number #t1=cities_number

#condition check
#if j>=cities_number, goto endwhile2; 
#else,continue check
bge $t0,$t1,endwhile2
#set k back to 0
li $t0,0 #t0=0
sw $t0,k #k=t0=0

while3:
lw $t0,k #t0=k
lw $t1,days_number #t1=days_number
#if k>=days_number, goto endwhile3; 
#else,input data
bge $t0,$t1,endwhile3

#print str1
li $v0,4
la $a0,str1
syscall

#print j+1
lw $a0,j #t0=j
addi $a0,$a0,1 #j=j+1
li $v0,1
syscall

#print str2
li $v0,4
la $a0,str2
syscall

#print k+1
lw $a0,k #t0=k
addi $a0,$a0,1 #k=k+1
li $v0,1
syscall

#print str3
li $v0,4
la $a0,str3
syscall

#input integer(data)
li $v0,5
syscall

#calculate tmp_data[j][k]
lw $t0,j #t0=j

#calculate tmp_data[j] (address+4+4j)
lw $t2,tmp_data #address of tmp_data=t2
li $t3,4 #4=t3
mult $t0,$t3 #4*j
mflo $t4 #t4=4*j
add $t4,$t4,$t3 #t4=4*j+4
add $t4,$t4,$t2 #t4=address+4+4*j
lw $t4,($t4) #t4 = address of tmp_data[j] 

#calculate tmp_data[j][k] (address in t4+4+4k)
lw $t1,k #t1=k
li $t0,4 #4=t0
mult $t0,$t1 #4*k
mflo $t2 #t2=4*k
add $t2,$t2,$t0 #t2=4*k+4
add $t2,$t2,$t4 #t2=address in t4+4+4*k

#save input integer(v0) to tmp_data[j][k](t2)
sw $v0,($t2)

lw $t0,k #t0=k
addi $t0,$t0,1 #k=k+1
sw $t0,k #save k back

j while3
endwhile3:

lw $t0,j #t0=j
addi $t0,$t0,1 #j=j+1
sw $t0,j #save j back
j while2

endwhile2:
#print str4
li $v0,4
la $a0,str4
syscall

#print cities_number
li $v0,1
lw $a0,cities_number
syscall

#print str3
li $v0,4
la $a0,str3
syscall

#input integer and save it to target_city
li $v0,5
syscall
sw $v0,target_city

#caller call for maximum function
#pass argument on stack
#calculate tmp_data(target_city-1)
lw $t0,target_city #t0=target_city
addi $t0,$t0,-1 #target_city=target_city-1

#calculate (address+4+4i),where i is (target_city-1)
lw $t1,tmp_data
li $t2,4
mult $t2,$t0 #(target_city-1)*4
mflo $t2 #t2=(target_city-1)*4
addi $t2,$t2,4 #t2=(target_city-1)*4+4
add $t2,$t2,$t1 #t2=(target_city-1)*4+4+address
lw $t2,($t2) 
lw $t1,days_number #t1 = days_number

#so, t1=days_number  t2=address of tmp_data[target_city-1]
addi $sp,$sp,-8 #allocate two argument
sw $t2,0($sp) #save tmp_data[target_city-1] to 0($fp)(first argument) 
sw $t1,4($sp) #save days_number to 4($fp)(second argument) 
jal maximum

#caller return from maximum function
addi $sp,$sp,8 #clear 2 argument off stack
add $t0,$0,$v0 #t0=v0=maximum_number

#print str5
li $v0,4
la $a0,str5
syscall

#print target_city
li $v0,1
lw $a0,target_city
syscall

#print str6
li $v0,4
la $a0,str6
syscall

#print returned value(which store to t0)
li $v0,1
add $a0,$0,$t0 #a0=t0
syscall

j exit 
endsize2:
# print condition1
li $v0,4
la $a0,condition1
syscall
j exit

endsize1:
# print condition2
li $v0,4
la $a0,condition2
syscall

exit:
li $v0,10#exit the program
syscall
