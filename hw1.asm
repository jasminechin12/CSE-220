# Jasmine Chin
# jasmchin
# 111717723

.data
# Command-line arguments
num_args: .word 0
addr_arg0: .word 0
addr_arg1: .word 0
addr_arg2: .word 0
addr_arg3: .word 0
no_args: .asciiz "You must provide at least one command-line argument.\n"

# Error messages
invalid_operation_error: .asciiz "INVALID_OPERATION\n"
invalid_args_error: .asciiz "INVALID_ARGS\n"

# Output strings
zero_str: .asciiz "Zero\n"
neg_infinity_str: .asciiz "-Inf\n"
pos_infinity_str: .asciiz "+Inf\n"
NaN_str: .asciiz "NaN\n"
floating_point_str: .asciiz "_2*2^"

# Miscellaneous strings
nl: .asciiz "\n"

# Put your additional .data declarations here, if any.
remainders: .space 32

# Main program starts here
.text
.globl main
main:
    # Do not modify any of the code before the label named "start_coding_here"
    # Begin: save command-line arguments to main memory
    sw $a0, num_args
    beq $a0, 0, zero_args
    beq $a0, 1, one_arg
    beq $a0, 2, two_args
    beq $a0, 3, three_args
four_args:
    lw $t0, 12($a1)
    sw $t0, addr_arg3
three_args:
    lw $t0, 8($a1)
    sw $t0, addr_arg2
two_args:
    lw $t0, 4($a1)
    sw $t0, addr_arg1
one_arg:
    lw $t0, 0($a1)
    sw $t0, addr_arg0
    j start_coding_here
zero_args:
    la $a0, no_args
    li $v0, 4
    syscall
    j exit
    # End: save command-line arguments to main memory
    
start_coding_here:
    # Start the assignment by writing your code here
    li $t3, 0
    li $t4, 0
    li $t5, 0
    li $t6, 0
    li $t7, 0
    li $t8, 0
    li $t9, 0
    li $s1, 0
    li $s2, 0
    li $s3, 0
    li $s4, 0
    li $s5, 0
    li $s5, 0
    li $s7, 0
    
    lw $t0, addr_arg0 # load first arg into t0
    lbu $t1, 0($t0) # load first byte of first arg into t1
    
    lbu $t2, 1($t0) # load second byte of first arg into t2
    bne $t2, '\0', print_invalid_op_error # if second byte is not null then invalid operation
    
    beq $t1, 'F', floating_point_number # if first byte is F then go to floating point number
    beq $t1, '2', twos_complement # if first byte is 2 then go to twos complement
    beq $t1, 'C', another_base # if first byte is C then go to another base
    j print_invalid_op_error # if it's neither F, 2 or C then invalid operation
    
twos_complement:
    lw $t0, num_args # load number of args into t0
    bne $t0, 2, print_invalid_arg_error # if number of args isn't 2 then invalid args
    
    lw $s0, addr_arg1 # load 2nd command line arg into s0
	lbu $s1, 0($s0) # load 1st/sign bit of 2nd command line arg into s1
	
	li $t2, 0 # set t2 to 0 and t2 stands for decimal value
	beq $s1, '0', zero_sign_bit   # check if sign bit is 0
	beq $s1, '1', one_sign_bit   # check if sign bit is 1
    j print_invalid_arg_error   # if it's not 0 or 1 then print invalid arg

one_sign_bit:
	li $t1, 1 # counter = 1
	li $t3, 2 # set t3 to 2 so you can use it to multiply by 2
	li $t7, -1 # sign bit is -1
	li $t6, 0 # magnitude is 0
	j for_zero_and_ones

zero_sign_bit:
	li $t1, 1 # counter = 1
	li $t3, 2 # set t3 to 2 so you can use it to multiply by 2
	li $t7, 0 # sign bit is 0
	li $t6, 0 # magnitude is 0
	j for_zero_and_ones 
		
for_zero_and_ones:
	addi $s0,$s0, 1
	lbu $t0, 0($s0) # load current byte
	beq $t0, '\0', decimal_value # if it's done reading 32 bits and there are only 32 bits go to dec value
	
	mul $t7, $t7, $t3 # multiply sign bit value by 2 and set it equal to t2
	mul $t6, $t6, $t3 # multiply magnitude value by 2 and set it equal to t5
	
	beq $t0, '0', for_zero_and_ones_continued  # check if it's 0
	beq $t0, '1', for_zero_and_ones_continued  # check if it's 1
	j print_invalid_arg_error # it's not 1 so invalid arg
	
	for_zero_and_ones_continued:
		addi $t1, $t1, 1 # counter goes up by 1 
		
		addi $t0, $t0, -48 # Convert ascii '0', '1' to 0, 1
		add $t6, $t6, $t0 # add current bit after multiplying
		
		beq $t1, 33, print_invalid_arg_error # if counter exceeds 32 characters, invalid arg
		j for_zero_and_ones # loop

decimal_value:
	add $a0, $t6, $t7 # add t2 with magnitude value
	li $v0, 1 # print integer
	syscall
	la $a0, nl
	li $v0, 4
	syscall
	j exit
	
floating_point_number:
    lw $t0, num_args # load number of args in t0
    bne $t0, 2, print_invalid_arg_error # if number of args isnt 2, invalid arg error
    
    lw $s2, addr_arg1 # load 2nd command line arg into t0
    li $t1, 0 # counter = 0
    
    check_input:
    	lbu $s3, 0($s2) # load first byte of 2nd command line arg
    	beq $s3, '\0', convert_to_thirty_two_bit
    	blt $s3, '0', print_invalid_arg_error # if ascii value less than 0, invalid
	    bgt $s3, '9', check_two # if ascii value  
	
	check_two: 			    
	    beq $s3, ':', print_invalid_arg_error # invalid char
	    beq $s3, ';', print_invalid_arg_error # invalid char
	    beq $s3, '<', print_invalid_arg_error # invalid char
	    beq $s3, '=', print_invalid_arg_error # invalid char
	    beq $s3, '>', print_invalid_arg_error # invalid char
	    beq $s3, '?', print_invalid_arg_error # invalid char
	    beq $s3, '@', print_invalid_arg_error # invalid char
	    bgt $s3, 'F', print_invalid_arg_error # if ascii greater than F, invalid
    	
    	addi $t1, $t1, 1 # increment counter by 1
    	addi $s2, $s2, 1
    	
 		j check_input
	    
	convert_to_thirty_two_bit:
	    bne $t1, 8, print_invalid_arg_error # check to see if there are 8 bits
	    lw $s2, addr_arg1 # load 2nd command line arg into t0
	    	
	    convert_cont:
	    	li $s1, 0 
	    	addi $t1, $0, 0 # initial 32 bit
	    	li $t2, 28 # variable for shift
	    	lbu $s3, 0($s2) # load bit from 2nd command line arg
	    	addi $s2, $s2, 1
	    	bgt $s3, '9', a_to_f # if it's A to F go to a_to_f
	    		
		    addi $t3, $s3, -48 # subtract ascii code to get number in bit value
			sll $t0, $t3, 28 # shift initial four bits by 28
			or $s1, $s1, $t0 # combine
			
			convert_cont_two:
				addi $t2, $t2, -4
				lbu $s3, 0($s2) # load byte from 2nd command line arg
				beq $s3, '\0', triple_e # if end of arg, go to triple e
				addi $s2, $s2, 1
				bgt $s3, '9', a_to_f_two # if it's A to F go to a_to_f_two
				
				addi $t3, $s3, -48 # subtract ascii code to get number in bit value
				sllv $t0, $t3, $t2 # shift left by -4 bits
				or $s1, $s1, $t0 # combine
				
				j convert_cont_two
		
		a_to_f:
			addi $t3, $s3, -55 # subtract ascii code to get number in bit value
			sll $t0, $t3, 28 # shift initial four bits by 28
			or $s1, $s1, $t0 # combine
			
			j convert_cont_two
			
		a_to_f_two:		
			addi $t3, $s3, -55 # subtract ascii code to get number in bit value
			sllv $t0, $t3, $t2 # shift left by -4 bits
			or $s1, $s1, $t0 # combine
				
			j convert_cont_two
	
	triple_e:
		li $t4, 0
		li $t5, 0
		srl $t1, $s1, 31 # shift right to get sign bit	  					t1 = sign bit
	    sll $t4, $s1, 1 # shift left once to get rid of sign bit			
	    srl $t4, $t4, 24 # shift right to get 8 bits  						t4 = 8 bits
	    sll $t5, $s1, 9 # shift left to get rid of sign bit and exponent
	    srl $t5, $t5, 9 # shift right to get mantissa  						t5 = mantissa

		beq $t4, 0, check_if_zero
		beq $t4, 255, check_if_special
		
		j triple_e_cont		
		
check_if_zero:
	beq $t5, 0, print_zero_string
	j triple_e_cont

print_zero_string:
	li $v0, 4
    la $a0, zero_str
    syscall
    j exit

check_if_special:
	beq $t5, 0, check_which_infi
	j print_nan_str

check_which_infi:
	beq $t1, 0, print_pos_infi
	beq $t1, 1, print_neg_infi

print_pos_infi:
	li $v0, 4
    la $a0, pos_infinity_str
    syscall
    j exit

print_neg_infi:
	li $v0, 4
    la $a0, neg_infinity_str
    syscall
    j exit

print_nan_str:
	li $v0, 4
    la $a0, NaN_str
    syscall
    j exit
		
triple_e_cont:
	addi $t4, $t4, -127 # t4 is exponent
	beq $t1, 0, print_pos_num
	beq $t1, 1, print_neg_num

print_pos_num:
	li $t6, 1
	addi $a0, $t6, 0
	li $v0, 1
	syscall
	li $t7, '.'
	addi $a0, $t7, 0
	li $v0, 11
	syscall
	li $t6, 0 # counter
	li $t8, 10 # shift left counter
	li $t9, 0
	loop_for_mantissa:
		srl $t9, $t5, 22 # shift right 22 to get first bit
		addi $a0, $t9, 0
		li $v0, 1
		syscall
		addi $t6, $t6, 1
		mantissa_two:
			beq $t6, 23, keep_printing_float
			sllv $t9, $t5, $t8 # shift left
			srl $t9, $t9, 31 # shift right to lsb
			addi $a0, $t9, 0
			li $v0, 1
			syscall
			addi $t6, $t6, 1 # increment counter
			addi $t8, $t8, 1 # increment shift left counter
			
			j mantissa_two

keep_printing_float:	
	li $v0, 4
	la $a0, floating_point_str
	syscall
	addi $a0, $t4, 0
	li $v0, 1
	syscall
	la $a0, nl
	li $v0, 4
	syscall
	j exit

print_neg_num:
	li $t6, -1
	addi $a0, $t6, 0
	li $v0, 1
	syscall
	li $t7, '.'
	addi $a0, $t7, 0
	li $v0, 11
	syscall
	li $t6, 0 # counter
	li $t8, 10 # shift left counter
	li $t9, 0
	loop_for_mantissa_two:
		srl $t9, $t5, 22 # shift right 22 to get first bit
		addi $a0, $t9, 0
		li $v0, 1
		syscall
		addi $t6, $t6, 1
		mantissa_two_two:
			beq $t6, 23, keep_printing_float
			sllv $t9, $t5, $t8 # shift left
			srl $t9, $t9, 31 # shift right to lsb
			addi $a0, $t9, 0
			li $v0, 1
			syscall
			addi $t6, $t6, 1 # increment counter
			addi $t8, $t8, 1 # incremement shift left counter
			
			j mantissa_two_two
	    	        	    
another_base:
    lw $t0, num_args # load number of args into t0
    bne $t0, 4, print_invalid_arg_error # if number of args isn't 4, invalid arg error
    
    lw $t0, addr_arg1 # load 2nd command line arg
    lw $t1, addr_arg2 # load 3rd command line arg
    lw $t2, addr_arg3 # load 4th command line arg
    lb $s4, 0($t2) # load byte of 4th command line arg
    lbu $s7, 0($t1) # load byte of 3rd command line arg
    lbu $t4, 0($t0) # load 1st byte of 2nd command line arg
    
    # if each byte is less than 3rd command line argument then it is valid else invalid
    check_validity_and_convert_to_dec:
    	bge $t4, $s7, print_invalid_arg_error # if 3rd command line arg is bigger than bit in 2nd command line arg, invalid 
     	addi $s7, $s7, -48
     	addi $t4, $t4, -48
     	mul $t3, $t4, $s7 # multiply first byte by radix and store in t3
     	addi $t0, $t0, 1 
     	lbu $t4, 0($t0) # load next byte
     	addi $t4, $t4, -48
     	add $t3, $t3, $t4 # add current value with next byte
     	
     	convert_to_dec_cont:    		
     		mul $t3, $t3, $s7 # multiply byte by radix and store in t3
     		addi $t0, $t0, 1
     		lbu $t4, 0($t0) # load next byte
     		addi $t4, $t4, -48
     		add $t3, $t3, $t4 # add current value with next byte
     		addi $t0, $t0, 1
     		lbu $t4, 0($t0) 
     		beq $t4, '\0', decimal_to_desired_base # if null terminator, go to decimal to desired base
     		addi $t0, $t0, -1
     		lbu $t4, 0($t0)
     		
     		j convert_to_dec_cont # loop
	
	decimal_to_desired_base:
		beq $s4, '1', base_ten
#		li $t9, 1 # counter for how many times to multiply by 10
#		li $t7, 10 # number 10
#		li $s6, 0
#		li $s5, 0
#		li $t7, 0 # counter
		addi $s4, $s4, -48
		div $t3, $s4 # divide 2nd line arg by desired radix
		mflo $t6 # set quotient to t6
		la $s3, remainders 
		mfhi $t5 # move remainder to t5
		addi $t7, $s4, 0
		sb $t7, 0($s3) # terminator
		addi $s3, $s3, 1
		sb $t5, 0($s3) # store remainder in memory
#		addi $t7, $t7, 1
		addi $s3, $s3, 1
#		mul $s5, $t5, $t9 # multiply remainder by 10^0 and store in t9
		
		decimal_to_desired_base_cont: 
			beq $t6, 0, pull_data # if quotient is 0, go to print dec value
			div $t6, $s4 # divide quotient by desired radix
			mflo $t6 # set quotient to t6
			mfhi $t5 # set remainder to t5
			sb $t5, 0($s3)
#			addi $t7, $t7, 1
			addi $s3, $s3, 1
#			mul $t8, $t5, $t9 # multiply remainder by counter and set it equal to t8
#			mul $t9, $t9, $t7 # multiply counter by 10 and set it equal to t9
#			add $s6, $s5, $t9 # add t9 (new decimal value) with previous decimal value
			j decimal_to_desired_base_cont # loop

base_ten:
	addi $a0, $t3, 0
	li $v0, 1
	syscall
	la $a0, nl
	li $v0, 4
	syscall
	j exit

pull_data:
	addi $s3, $s3, -1
	lb $t5, 0($s3)
	beq $t5, $s4, finish_printing
	addi $a0, $t5, 0
	li $v0, 1 
	syscall
	j pull_data
		
finish_printing:		
	la $a0, nl
	li $v0, 4
	syscall
	j exit
        
print_invalid_op_error:
    li $v0, 4
    la $a0, invalid_operation_error
    syscall
    j exit

print_invalid_arg_error:
    li $v0, 4
    la $a0, invalid_args_error
    syscall
    j exit

exit:
    li $v0, 10   # terminate program
    syscall
