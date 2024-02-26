##Author: Chai Lam Loi
# Change directory to the file directory and run in Desktop :java -jar Mars4_5.jar FIT3159_4_Lab/FIT3159_4.2_Lab.asm < FIT3159_4_Lab/sample.base64
# In this task, I use register t7 to mark down the equal mark. Hence, t7 is reserved
# Author: Chai Lam Loi
 
   
# base64decode.s 
# Author: Chai Lam Loi
#
#  This MIPS program reads lines of Base 64-encoded text from standard
#  input, and outputs the decoded bytes to standard output.
#
# In this task, I use register t7 to mark down the equal mark. Hence, t7 is reserved

# Instruction to run:
# Change directory to the file directory and run in Command Prompt :java -jar Mars4_5.jar MIPS_base64_decoder.asm < base64_encoded_file/sample.base64

#
# Data segment
#
        .data
        # Space to read a line into.
inbuffer: .space 80
        # The Base 64 alphabet, in order.
sequence: .asciiz "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
.align 4 # align it to match the boundary
equal:	.asciiz "="

#
# Text segment
#
        .text
        # Program entry.
main:
        # The first byte we're expecting is byte 0 of a group of 4.
        la $t9, byte0

        # Read a string from standard input.
loop:   li $v0, 8
        la $a0, inbuffer
        li $a1, 80
        syscall

        # Is this an empty line?  Since SPIM can't detect when end of
        # file has been reached, we need to use another way to indicate
        # the end of the Base 64 data.  We'll use a completely
        # blank line for this.
        lb $t0, inbuffer
        # First character newline means there was no text on this line,
        # so end the program.
        beq $t0, 10, alldone

        # Walk along the string.  Start at the beginning.
        la $t8, inbuffer

        # Go back to where we left off last time (byte 0, 1, 2 or 3).
        jr $t9


        # Get four characters at a time.
byte0:  lbu $s0, 0($t8)
        add $t8, $t8, 1
        beq $s0, 10, linedone
        
        # Now up to byte 1.
        la $t9, byte1
byte1:  lbu $s1, 0($t8)
        add $t8, $t8, 1
        beq $s1, 10, linedone

        # Now up to byte 2.
        la $t9, byte2
byte2:  lbu $s2, 0($t8)
        add $t8, $t8, 1
        beq $s2, 10, linedone

        # Now up to byte 3.
        la $t9, byte3
byte3:  lbu $s3, 0($t8)
        add $t8, $t8, 1
        beq $s3, 10, linedone

        # Now all bytes in this block are read.
        # Four Base64 characters are now in $s0, $s1, $s2, $s3.
bytesdone:
        #
        # DO NOT DELETE THIS LINE.

        ######
        #
        # PUT YOUR ANSWER HERE.
        # Your answer should not modify $t8 or $t9, as they are used by
        # the above code.
        #1. find the index
        #2. Shift and mask to make it 3 8-bits
        #4. change to ascii
        ######
        
        #------------------ Find the index----------------#
	la $t0, sequence # load address of sequence into t0
        li $t1 , 0 #load counter into t1
        
        #Find index of s0
index0a:        
        lbu $t2, 0($t0) #load the character in sequence to t2
        beq $t2, $s0, index0b
        addi $t1,$t1,1 #Add index by 1
        addi $t0,$t0,1 #Increase address by 1
        j index0a
        
index0b:
	#Save index of s0 in s0
	addi $s0,$t1,0
	#reinitialise the counter and sequence address
	la $t0, sequence # load address of sequence into t0
        li $t1 , 0 #load counter into t1
      
        # Find index of s1
index1a:
        lbu $t2, 0($t0) #load the character in sequence to t2
        beq $t2, $s1, index1b
        addi $t1,$t1,1 #Add index by 1
        addi $t0,$t0,1 #Increase address by 1
        j index1a
        
index1b:
	#Save index of s1 in s1
	addi $s1,$t1,0
	#reinitialise the counter and sequence address
	la $t0, sequence # load address of sequence into t0
        li $t1 , 0 #load counter into t1   
        
 	# Find index of s2
index2a:
	# check if the character is "="
        lw $t3,equal
        bne $t3,$s2,index2aCon
        li $t7,2  # Use register t7 to mark down the equal marks
        j decode
        
index2aCon:        
        lbu $t2, 0($t0) #load the character in sequence to t2
        beq $t2, $s2, index2b
        addi $t1,$t1,1 #Add index by 1
        addi $t0,$t0,1 #Increase address by 1
        j index2a
        
index2b:
	#Save index of s1 in s1
	addi $s2,$t1,0
	#reinitialise the counter and sequence address
	la $t0, sequence # load address of sequence into t0
        li $t1 , 0 #load counter into t1  
        
         # Find index of s3
index3a:
	# check if the character is "="
        lw $t3,equal
        bne $t3,$s3,index3aCon
        li $t7,1  # Use register t7 to mark down the equal marks
        j decode
        
index3aCon:        
        lbu $t2, 0($t0) #load the character in sequence to t2
        beq $t2, $s3, index3b
        addi $t1,$t1,1 #Add index by 1
        addi $t0,$t0,1 #Increase address by 1
        j index3a
	        
index3b:
	#Save index of s1 in s1
	addi $s3,$t1,0
       
decode:  
       #------------------ Shift and Mask to make it 3 8-bits(with 0xff; ob11111111 in python)---------------#
        #Load mask to t0
        li $t0, 0xff
        #Load s0 to t1 
        la $t1,($s0)
        #Load s1 to t2
        la $t2, ($s1)
        
        # Left shift s0 to 2
        sll $t1,$t1,2
        # Right shift s1 to 4
        srl $t2,$t2,4
        # Get the first byte using OR
        or $s4,$t1,$t2
        
        # Check if there is two equal, if there is , jump to outputAscii
        beq $t7,2,outputAscii
         
        #Load s1 to t1 
        la $t1,($s1)
        #Load s2 to t2
        la $t2, ($s2)
        
        # Left shift s1 to 4 
        sll $t1,$t1,4
        # Mask t1
        and $t1,$t1,$t0
        # Right shift s2 to 2
        srl $t2,$t2,2
        # Get the second byte using OR
        or $s5,$t1,$t2
        
        # Check if there is one equal, if there is , jump to outputAscii
        beq $t7,1,outputAscii
        
         #Load s2 to t1 
        la $t1,($s2)
        #Load s3 to t2
        la $t2, ($s3)
        
        # Left shift s2 to 4 
        sll $t1,$t1,6
        # Mask t1
        and $t1,$t1,$t0
        # Get the second byte using OR
        or $s6,$t1,$t2
        
            
        #------------------ Change it to ascii ----------------#
outputAscii:  
        # Use v0 = 11 to print character , $a0 = character to print
        # the bytes stored in s4,s5,s6
        li $v0,11
        la $a0, ($s4)
        syscall
        
        # Check if there is two equal, if there is , jump to endgroup
        beq $t7,2,endgroup
        
        la $a0, ($s5)
        syscall
        
        
        # Check if there is one equal, if there is , jump to endgroup
        beq $t7,1,endgroup
        
        la $a0, ($s6)
        syscall
        

        # DO NOT DELETE THIS LINE.
        #
endgroup:
        # Go back to do next bunch of four bytes.  We're now expecting
        # byte 0 of 4.
        la $t9, byte0
        j byte0

linedone:
        # Line is finished; go get another one.
        j loop

alldone:
        # Exit.
        li $v0, 10
        syscall

