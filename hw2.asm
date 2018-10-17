# Jasmine Chin
# jasmchin
# 111717723

#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################

.text

### Part I ###
index_of_car:
	li $v0, -200
	li $v1, -200
	
	# a0 = address of cars array
	# a1 = length of cars array
	# a2 = start index: index at which to start search
	# a3 = year of manufacture
	
	is_valid:
		li $t0, 1885 # store 1885 into $t0
		ble $a1, $0, no # if length of cars array is <= 0 then invalid
		blt $a2, $0, no # if start index < 0 then invalid
		bge $a2, $a1, no # if start index is >= length of cars array then invalid
		blt $a3, $t0, no # if year is less than 1885 then invalid
	
	find_car:
		li $t3, 0 # initialize t3
		li $t4, 0 # initialize t4
		li $t5, 0 # initialize t5
		sll $t3, $a2, 4 # shifting 4 bits 
		add $t4, $t3, $a0 # t4 holds start of memory address of car[a2] 
		lh $t5, 12($t4) # skipping 12 bytes to get to address of year    t5 = year
		bne $t5, $a3, find_car2 # go to find_car2 if year of car[a2] doesn't match year wanted
		addi $v0, $a2, 0 # if it does match, set index (a2) to v0
		jr $ra # jump back to index_of_Car_main.asm
	
	find_car2:
		addi $a2, $a2, 1 # increment start index
		beq $a2, $a1, no # if index = length, go to no b/c not found in array
		sll $t3, $a2, 4  # shifting 4 bits
		add $t4, $t3, $a0 # t4 holds start of memory address of car[a2] after a2 was incremented
		lh $t5, 12($t4) # t5 = year
		bne $t5, $a3, find_car2 # loop if year of car[a2] doesn't match year wanted
		addi $v0, $a2, 0 # set index (a2) to v0
		jr $ra # jump back to index_of_car_main.asm

no:
	li $v0, -1 # return -1
	jr $ra # jump back to index_of_car_main.asm	

### Part II ###
strcmp:
	li $v0, -200
	li $v1, -200
	
	# a0 = str1
	# a1 = str2
	
	check_if_string_empty:
		lbu $t0, 0($a0) # load first char of str1
		lbu $t1, 0($a1) # load first char of str2
		li $t2, 1 # counter for length of str1
		li $t3, 1 # counter for length of str2
		beq $t0, '\0', check_if_t1_null # if first char of str1 is null, check if first char of str2 is null 
		beq $t1, '\0', find_length_of_str1 # if first char of str1 is not null and first char of str2 is null, find length of str1
		bne $t0, $t1, mismatch # if first char of both strings aren't equal, mismatch
	
	check_string:		
		addi $a0, $a0, 1 # move pointer by 1 to get next char of str1
		addi $a1, $a1, 1 # move pointer by 1 to get next char of str2
		lbu $t0, 0($a0) # load next char of str1
		lbu $t1, 0($a1) # load next char of str2
		beq $t0, '\0', check_str2_char # if end of str1, check if end of str2
		beq $t1, '\0', check_str1_char # if not end of str1 but end of str2, check_str1_char
		bne $t0, $t1, mismatch # if both chars don't match, mismatch
		j check_string

mismatch:
	sub $v0, $t0, $t1 # first char of str1 - first char of str2 = difference in ASCII values
	jr $ra

check_str1_char:
	li $t1, 0 # if end of str2 but str1 has char, set t1 = 0 to go to mismatch
	j mismatch # jump to mismatch 

check_str2_char:
	beq $t1, '\0', empty_or_same_strings
	li $t0, 0 # if end of str1 but str2 still has char, set t0 = 0 to go to mismatch  
	j mismatch # jump to mismatch

check_if_t1_null:
	beq $t1, '\0', empty_or_same_strings # if first char of str2 is also null, go to empty_strings
	find_length_of_str2:
		addi $a1, $a1, 1
		lbu $t1, 0($a1) # load next char for str2
		beq $t1, '\0', len_of_str2 # if char is null, go to len_of_str2
		addi $t3, $t3, 1 # increment counter
		j find_length_of_str2 # loop

empty_or_same_strings:
	li $v0, 0 # set 0 to v0
	jr $ra # jump back to strcmp_main.asm

len_of_str2:
	sub $v0, $0, $t3 # set v0 equal to negative counter
	jr $ra # jump back to strcmp_main.asm

find_length_of_str1:
	addi $a0, $a0, 1 # move pointer
	lbu $t0, 0($a0) # load next char for str1
	beq $t0, '\0', len_of_str1 # if char is null, go to len_of_str1
	addi $t2, $t2, 1 # incremeent counter
	j find_length_of_str1 # loop

len_of_str1:
	addi $v0, $t2, 0 # set v0 equal to counter
	jr $ra # jump back to strcmp_main.asm

### Part III ###
memcpy:
	li $v0, -200
	li $v1, -200

	# a0 = address of src
	# a1 = address of dest
	# a2 = n (number of bytes to copy)
	
	ble $a2, 0, error
	li $t0, 0 # t0 is loop counter
	copy_loop:
		lbu $t1, 0($a0) # load byte from src
		sb $t1, 0($a1) # store byte into dest
		addi $t0, $t0, 1 # increment counter
		beq $t0, $a2, success # if counter = number of bytes to copy, success
		addi $a0, $a0, 1 # move pointer by 1 byte
		addi $a1, $a1, 1 # move pointer by 1 byte
		j copy_loop # loop

error:
	li $v0, -1 # load -1 into v0
	jr $ra # jump back to memcpy_main.asm

success:
	li $v0, 0
	jr $ra # jump back to memcpy_main.asm

### Part IV ###
insert_car:
	li $v0, -200
	li $v1, -200
	
	# a0 = address of cars array
	# a1 = length of cars array
	# a2 = address of new car
	# a3 = index to insert new car
	
	blt $a1, $0, error2 # if length < 0, error
	blt $a3, $0, error2 # if index < 0, error
	bgt $a3, $a1, error2 # if index > length, error
	beq $a3, $a1, append # if index = length, append 

	li $t2, 16 # t4 = 16
	addi $sp, $sp, -16 # making space on stack to store 4 registers
	sw $s0, 12($sp) # preserve s0
	sw $s1, 8($sp) # preserve s1
	sw $s2, 4($sp) # preserve s2 
	sw $ra, 0($sp) # save $ra on stack
	move $s0, $a0 # preserve a0
	move $s1, $a1 # preserve a1
	move $s2, $a2 # preserve a2
	li $t3, 0 # initialize t3
	sll $t3, $a3, 4 # shifting 4 bits
	add $t3, $t3, $s0 # t3 holds address of index after index to insert new car

	shift_elements_loop:
		sll $t1, $s1, 4 # shifting 4 bits
		add $t1, $t1, $s0 # t1 holds start of memory address for dest
		addi $s1, $s1, -1 # subtract 1 to get index of last element in cars array (keep -1 until index to loop)
		sll $t0, $s1, 4 # shifting 4 bits 
		add $t0, $t0, $s0 # t0 holds start of memory address of last element in cars array (keep getting previous element addr)
		move $a0, $t0 # cars[i] = src
		move $a1, $t1 # cars[i+1] = dest 
		move $a2, $t2 # 16 = n bytes to copy
		beq $a1, $t3, insert # after shifting, if address of index = address of index to insert new car, go to insert
		jal memcpy # jump and link memcpy
		j shift_elements_loop

	insert:
		move $a0, $s2 # set src = address of new_car
		move $a1, $t3 # set dest = address of index to insert new car
		jal memcpy # jump and link memcpy
		lw $ra 0($sp) # restore $ra
		lw $s2, 4($sp) # restore original s2
		lw $s1, 8($sp) # restore original s1
		lw $s0, 12($sp) # restore original s0
		addi $sp, $sp, 16 # deallocate stack space
		j success2 
		
append:
	addi $sp, $sp, -4 # make space on stack to store 1 register
	sw $ra, 0($sp) # save $ra on stack
	li $t2, 16 # t2 = 16 = n bytes to copy
	sll $a3, $a3, 4 # shifting 4 bits
	add $a3, $a3, $a0 # a3 holds start of memory address for dest
	move $a0, $a2 # set src = address of new_car
	move $a1, $a3 # set dest = address of index to insert
	move $a2, $t2 # set n = t3 = 16
	jal memcpy # jump and link memcpy
	lw $ra, 0($sp) # restore $ra from stack
	addi $sp, $sp, 4 # deallocate stack space
	j success2
								
error2:
	li $v0, -1 # load -1 into v0
	jr $ra # jump back to insert_car_main.asm

success2:
	li $v0, 0 # load 0 into v0
	jr $ra # jump back to insert_car_main.asm	

### Part V ###
most_damaged:
	li $v0, -200
	li $v1, -200
	
	# a0 = address of cars array
	# a1 = address of repairs array
	# a2 = length of cars array
	# a3 = length of repairs array
	
	ble $a2, $0, error3 # if length of cars array <= 0, error
	ble $a3, $0, error3 # if length of repairs array <= 0, error
	beq $a3, 1, one_repair # if length of repairs array = 1, one_repair
	
	li $t0, 0 # t0 = cars array counter
	li $t1, 0 # t1 = repairs array counter
	li $t2, -1 # t2 = highest total cost
	li $t3, 0 # t3 = current car's highest cost
	li $t4, 0 # t4 = address of element in cars array
	li $t5, 0 # t5 = holds address of element in repairs array
	li $t6, 0 # t6 = holds address of car struc of element in repairs array
	li $t7, 0 # t7 = cost of current car's repair
	li $t8, 0 # t8 = counter for repairs per car
	li $t9, 0 # t9 = holds index for car with highest repair costs
	addi $sp, $sp, -8
	sw $s1, 4($sp)
	sw $s2, 0($sp)
	li $s1, 12
	
	loop_cars:
		beq $t0, $a2, success3 # if counter = length of cars array, end loop
		sll $t4, $t0, 4
		add $t4, $t4, $a0 # t4 = holds address of element in cars array
		loop_repairs:
			beq $t1, $a3, increment_car_counter # when counter = length of repairs array, increment_car_counter
#			sll $t5, $t1, 4
			mul $t5, $t1, $s1 
			add $t5, $t5, $a1 # t5 = holds address of element in repairs array
			lw $t6, 0($t5) # t6 = holds address of car struc
			bne $t4, $t6, increment_repair_counter # if addr of element in cars array != addr of car struc, increment repair counter
			bge $t8, 1, multiple_repairs # if there are more than 1 repair per car, multiple_repairs 
			lh $t7, 8($t5) # t7 = holds cost of current car's repair
			addi $t8, $t8, 1 # increment repairs per car counter by 1
			blt $t7, $t2, increment_repair_counter # if current car's repair cost < highest total cost, increment
			beq $t7, $t2, check_lower_index # if cost of repair is equal, check for lower index
			move $t2, $t7 # current car's repair cost > highest total cost, set highest total cost to current car's repair cost 
			sub $t9, $t4, $a0
			srl $t9, $t9, 4 # t9 = holds index of car with highest total cost of repair
			addi $t1, $t1, 1 # increment repairs array counter by 1
			j loop_repairs # loop

increment_repair_counter:
	addi $t1, $t1, 1 # incremenet repairs array counter by 1
	j loop_repairs # loop

increment_car_counter:
	addi $t0, $t0, 1 # increment cars array counter by 1
	li $t1, 0 # reset repairs array counter to 0
	li $t8, 0 # reset repairs per car counter to 0
	j loop_cars # loop

check_lower_index:
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	sub $s0, $t4, $a0
	srl $s0, $s0, 4 # s0 = holds index of current car
	blt $t9, $s0, increment_repair_counter
	move $t9, $s0 # set t9 to the lower index
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	j increment_repair_counter  

multiple_repairs:
	lh $s2, 8($t5) # t7 = holds cost of current car's repair
	add $t7, $s2, $t7 # t7 += additional cost of repairs
	blt $t7, $t2, increment_repair_counter
	move $t2, $t7 # set t2 = new highest total
	sub $t9, $t4, $a0
	srl $t9, $t9, 4 # t9 = holds new index of car with highest total cost of repair
	addi $t1, $t1, 1 # increment repairs array counter by 1
	addi $t8, $t8, 1 # increment repairs per car counter by 1
	j loop_repairs

one_repair:
	lw $t0, 0($a1) # load car struc address in repairs array
	sub $t1, $t0, $a0 # t1 = address of car struc - base addr of cars array
	srl $t1, $t1, 4 # shifting 4 bits
	addi $t1, $t1, -1 # subtract 1 for index 0
	move $v0, $t1 # v0 = index in cars array 
	lh $t2, 8($a1) # load cost of repair in repairs array
	move $v1, $t2 # v1 = cost of repair
	jr $ra # jump back to most_damaged_main.asm

error3:
	li $v0, -1 # set v0 = -1
	li $v1, -1 # set v1 = -1
	jr $ra # jump back to most_damaged_main.asm

success3:
	lw $s2, 0($sp)
	lw $s1, 4($sp)
	addi $sp, $sp, 8
	move $v0, $t9 # v0 = index of car with highest total repair cost
	move $v1, $t2 # v1 = total repair cost for car
	jr $ra # jump back to most_damage_main.asm

### Part VI ###
sort:
	li $v0, -200
	li $v1, -200
	
	# a0 = address of cars array
	# a1 = length of cars array
	
	ble $a1, $0, error6 # if length <= 0, error
	
	li $t8, 0 # t0 = sorted = 0 = false
	addi $a1, $a1, -1 # length - 1
	while:
		li $t0, 0
		li $t1, 0
		li $t8, 1 # sorted = 1 = true
		li $t9, 1 # counter
		li $t7, 1 # t7 = address of car[i+1]
		li $t2, 0 # t2 = index i (will hold address of car[i])
		li $t3, 0 # t3 = will hold year of car[i]
		addi $t4, $t9, 1 # t4 = index i + 1
		li $t5, 0 # t5 = will hold year of car[i+1]
		
		first_loop:
			beq $t8, 1, success6 # if sorted, go to success6
			bge $t9, $a1, reset_counter
			sll $t2, $t9, 4
			add $t2, $t2, $a0 # t2 = address of car[i]
			lh $t3, 12($t2) # t3 = year of car[i]
			sll $t7, $t4, 4 
			add $t7, $t7, $a0 # t7 = address of car[i+1]
			lh $t5, 12($t7) # t5 = year of car[i+1]
			ble $t3, $t5, increment_first_loop_counter # if year of car[i] <= year of car[i+1], increment loop counter
			addi $sp, $sp, -28
			sw $ra 24($sp)
			sw $s0 20($sp)
			sw $s1, 16($sp)
			move $s0, $a0 # s0 = holds address of cars array
			move $s1, $a1 # s1 = a1 = length - 1
			move $a0, $t2 # load address of car[i] into a0
			addi $sp, $sp, 12
			move $a1, $sp
			li $a2, 16
			jal memcpy
			addi $a0, $a0, -15
			move $a1, $a0 # a1 = address of car[i]
			move $a0, $t7 # a0 = address of car[i+1]
			jal memcpy
			addi $a0, $a0, -15
			addi $a1, $a1, -15
			move $t2, $a1 # t2 = address of car[i]
			move $a1, $a0 # a1 = address of car[i+1]
			move $a0, $sp
			jal memcpy
			move $a0, $s0
			move $a1, $s1
			lw $s1, 16($sp)
			lw $s0, 20($sp)
			lw $ra 24($sp)
			addi $sp, $sp, 16
			li $t8, 0 # t0 = sorted = 0 = false
			addi $t9, $t9, 2 # increment i index/counter by two
			addi $t4, $t4, 2 # increment i+1 index by two
			j first_loop
		
		second_loop:
			bge $t9, $a1, check_if_sorted
			sll $t2, $t9, 4
			add $t2, $t2, $a0 # t2 = address of car[i]
			lh $t3, 12($t2) # t3 = year of car[i]
			sll $t7, $t4, 4 
			add $t7, $t7, $a0 # t7 = address of car[i+1]
			lh $t5, 12($t7) # t5 = year of car[i+1]
			ble $t3, $t5, increment_second_loop_counter # if year of car[i] <= year of car[i+1], increment loop counter
			addi $sp, $sp, -28
			sw $ra 24($sp)
			sw $s0 20($sp)
			sw $s1, 16($sp)
			move $s0, $a0 # s0 = holds address of cars array
			move $s1, $a1 # s1 = a1 = length - 1
			move $a0, $t2 # load address of car[i] into a0
			addi $sp, $sp, 12
			move $a1, $sp
			li $a2, 16
			jal memcpy
			addi $a0, $a0, -15
			move $a1, $a0 # a1 = address of car[i]
			move $a0, $t7 # a0 = address of car[i+1]
			jal memcpy
			addi $a0, $a0, -15
			addi $a1, $a1, -15
			move $t2, $a1 # t2 = address of car[i]
			move $a1, $a0 # a1 = address of car[i+1]
			move $a0, $sp
			jal memcpy
			move $a0, $s0
			move $a1, $s1
			lw $s1, 16($sp)
			lw $s0, 20($sp)
			lw $ra 24($sp)
			addi $sp, $sp, 16
			li $t8, 0 # t0 = sorted = 0 = false
			addi $t9, $t9, 2 # increment i index/counter by two
			addi $t4, $t4, 2 # increment i+1 index by two
			j second_loop 	
	
#	jr $ra

increment_first_loop_counter:
	addi $t9, $t9, 2 # increment i index/counter by 2
	addi $t4, $t4, 2 # increment i + 1 index by 2
	j first_loop

increment_second_loop_counter:
	addi $t9, $t9, 2 # increment i index/counter by 2
	addi $t4, $t4, 2 # increment i + 1 index by 2
	j second_loop

reset_counter:
	li $t9, 0 # t1 = i index/counter = 0
	li $t4, 1 # t4 = i+1 indexx = 1
	j second_loop

check_if_sorted:
	beq $t8, $0, while # if t0 = 0 = not sorted = false, go to while
	j success6

success6:
	li $v0, 0
	jr $ra # jump back to sort_main.asm

error6:
	li $v0, -1
	jr $ra # jump back to sort_main.asm

### Part VII ###
most_popular_feature:
	li $v0, -200
	li $v1, -200
	
	# a0 = address of cars array
	# a1 = length of cars array
	# a2 = features to be considered
	
	ble $a1, $0, error5 # if length of cars array <= 0, error
	ble $a2, $0, error5 # if features <= 0, error
	bgt $a2, 15, error5 # if features > 15, error 
	
	li $t0, 0 # t0 = 0 bit position
	li $t1, 0 # t1 = 1 bit position
	li $t2, 0 # t2 = 2 bit position
	li $t3, 0 # t3 = 3 bit position
	li $t4, 0 # t4 = loop counter
	li $t5, 0 # t5 = address of car in cars array
	li $t7, 0 # t7 = number of convertibles
	li $t8, 0 # t8 = number of hybrids
	li $t9, 0 # t9 = number of tinted windows
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	li $s0, 0 # s0 = number of gps
	
	sll $t0, $a2, 31 # shift left 31 bits
	srl $t0, $t0, 31 # shift right 31 bits to isolate 0 bit position
	sll $t1, $a2, 30 # shift left 31 bits
	srl $t1, $t1, 31 # shift right 31 bits to isolate 1 bit position
	sll $t2, $a2, 29 # shift left 29 bits
	srl $t2, $t2, 31 # shift right 31 bits to isolate 2 bit position
	sll $t3, $a2, 28 # shift left 28 bits
	srl $t3, $t3, 31 # shift right 31 bits to isolate 3 bit position
	
	beq $t0, 1, convertibles
	beq $t1, 1, hybrids
	beq $t2, 1, tinted_windows
	beq $t3, 1, gps
	
convertibles:
	beq $t4, $a1, find_most_pop # if counter = length of array, find most pop feature
	sll $t5, $t4, 4
	add $t5, $t5, $a0 # t5 = address of car in cars array
	lbu $t6, 14($t5) # t6 = value of features
	bne $t0, 1, check_hybrids # if 0 bit position isn't 1, don't check convertibles
	sll $t6, $t6, 31 # shift left 31 bits
	srl $t6, $t6, 31 # shift right 31 bits to isolate 0 bit position
	bne $t6, 1, check_hybrids # if it isn't 1 = not convertible = check for hybrid
	addi $t7, $t7, 1 # increment number of convertibles by 1
	j check_hybrids

hybrids:
	sll $t5, $t4, 4
	add $t5, $t5, $a0 # t5 = address of car in cars array
	j check_hybrids

tinted_windows:
	sll $t5, $t4, 4
	add $t5, $t5, $a0 # t5 = address of car in cars array
	j check_windows

gps:
	sll $t5, $t4, 4
	add $t5, $t5, $a0 # t5 = address of car in cars array
	j check_gps

check_hybrids:
	bne $t1, 1, check_windows # if 1 bit position isn't 1, don't check hybrids
	lbu $t6, 14($t5) # t6 = value of features
	sll $t6, $t6, 30 # shift left 30 bits
	srl $t6, $t6, 31 # shift right by 31 bits to isolate 1 bit position
	bne $t6, 1, check_windows # if it isn't 1 = not hybrid = check windows
	addi $t8, $t8, 1 # increment number of hybrids by 1
	j check_windows

check_windows:
	bne $t2, 1, check_gps # if 2 bit position isn't 1, don't check windows
	lbu $t6, 14($t5) # t6 = value of features
	sll $t6, $t6, 29 # shift left 29 bits
	srl $t6, $t6, 31 # shift right by 31 bits to isolate 2 bit position
	bne $t6, 1, check_gps # if it isn't 1 = no tinted windows = check gps
	addi $t9, $t9, 1 # increment number of tinted windows by 1
	j check_gps

check_gps:
	bne $t3, 1, increment_loop_counter # if 3 bit position isn't 1, don't check gps
	lbu $t6, 14($t5) # t6 = value of features
	sll $t6, $t6, 28 # shift left 28 bits
	srl $t6, $t6, 31 # shift right by 31 bits to isolate 3 bit position
	bne $t6, 1, increment_loop_counter # if it isn't 1 = no gps = no features for first car = increment loop counter
	addi $s0, $s0, 1 # increment number of gps by 1
	j increment_loop_counter

increment_loop_counter:
	addi $t4, $t4, 1
	j convertibles
	
find_most_pop:
	beq $t0, 1, cmp_con_w_else # if t0 = compare con with all other features
	beq $t1, 1, cmp_hyb_w_else # if t0 != 1 and t1 = 1, compare hyb with win and gps
	beq $t2, 1, cmp_win_w_gps # if t0 != 1 and t1 != 1 but t2 = 1, compare win with gps
	j gps_most_pop

cmp_con_w_else:
	bne $t1, 1, cmp_con_w_else2 # if t1 = 0, compare con with win and gps
	bne $t2, 1, cmp_con_w_else3 # if t2 = 0, compare con with hyb and gps
	bne $t3, 1, cmp_con_w_else4 # if t3 = 0, compare con with hyb and win
	ble $t7, $t8, cmp_hyb_w_else # if num of con <= num of hyb, compare hyb with win and gps
	ble $t7, $t9, cmp_win_w_gps # if num of con > num of hyb but <= num of win, compare win and gps
	ble $t7, $s0, gps_most_pop # if num of con > num of hyb and num of win but <= gps, gps most pop
	j con_most_pop

cmp_con_w_else2: # compare con with win and gps
	bne $t2, 1, cmp_con_w_gps # if t2 = 0, compare con with gps
	bne $t3, 1, cmp_con_w_win # if t3 = 0, compare con with win
	ble $t7, $t9, cmp_win_w_gps # if num of con <= num of win, compare win with gps
	ble $t7, $s0, gps_most_pop # if num of con > num of win but <= num of gps, gps most pop
	j con_most_pop

cmp_con_w_else3: # compare con with hyb and gps
	bne $t3, 1, cmp_con_w_hyb # if t3 = 0, compare con with hyb
	ble $t7, $t8, cmp_hyb_w_gps # if num of con <= num of hyb, compare hyb with gps
	ble $t7, $s0, gps_most_pop # if num of con > num of hyb but <= num of gps, gps most pop
	j con_most_pop

cmp_con_w_else4: # compare con with hyb and win
	ble $t7, $t8, cmp_hyb_w_win # if num of con <= num of hyb, compare hyb with win
	ble $t7, $t9, win_most_pop # if num of con > num of hyb but < num of win, win most pop
	j con_most_pop

cmp_con_w_hyb: # compare con with hyb
	ble $t7, $t8, hyb_most_pop # if num of con <= num of hyb, hyb most pop
	j con_most_pop

cmp_con_w_gps: # compare con with gps
	ble $t7, $s0, gps_most_pop # if num of con <= num of gps, gps most pop
	j con_most_pop

cmp_con_w_win: # compare con with win
	ble $t7, $t9, win_most_pop # if num of con <= num of win, win most pop
	j con_most_pop
	
cmp_hyb_w_else: # compare hyb with win and gps
	bne $t2, 1, cmp_hyb_w_gps # if t2 = 0, compare hyb with gps
	bne $t3, 1, cmp_hyb_w_win # if t3 = 0, compare hyb with win
	ble $t8, $t9, cmp_win_w_gps # if num of hyb <= num of win, compare win and gps
	ble $t8, $s0, gps_most_pop # if num of hyb > num of win but <= num of gps, gps most pop
	j hyb_most_pop

cmp_hyb_w_gps: # compare hyb with gps
	ble $t8, $s0, gps_most_pop # if num of hyb <= num of gps, gps most pop
	j hyb_most_pop

cmp_hyb_w_win: # compare hyb with win
	ble $t8, $t9, win_most_pop # if num of hyb <= num of win, win most pop
	j hyb_most_pop

cmp_win_w_gps: # compare win with gps
	ble $t9, $s0, gps_most_pop # if num of win <= num of gps, gps most pop
	j win_most_pop

con_most_pop:
	beq $t7, $0, error5
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	li $v0, 1 # v0 = 1 = convertible most pop
	jr $ra # jump back to most_popular_feature_main.asm

hyb_most_pop:
	beq $t8, $0, error5
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	li $v0, 2 # v0 = 2 = hybrid most pop
	jr $ra # jump back to most_popular_feature_main.asm

win_most_pop:
	beq $t9, $0, error5
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	li $v0, 4 # v0 = 4 = tinted windows most pop
	jr $ra # jump back to most_popular_feature_main.asm

gps_most_pop:
	beq $s0, $0, error5
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	li $v0, 8 # v0 = 8 = gps most pop
	jr $ra	# jump back to most_popular_feature_main.asm

error5:
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	li $v0, -1 # v0 = -1
	jr $ra # jump back to most_popular_feature_main.asm

### Optional function: not required for the assignment ###
transliterate:
	li $v0, -200
	li $v1, -200
	
	# a0 = char
	# a1 = addr of transliterate_str
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal index_of
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	# t4 = index
	li $t5, 10 # t5 = 10
	div $t4, $t5 # index divided by 10
	mfhi $t4 # t4 = index % 10
	jr $ra  

### Optional function: not required for the assignment ###
char_at:
	li $v0, -200
	li $v1, -200

	# a0 = address of vin/map/weights
	# a1 = index
	
	li $t3, 0 # counter
	find_char:
		beq $t3, $a1, found_char
		addi $a0, $a0, 1
		addi $t3, $t3, 1
		j find_char

found_char:
	lbu $t3, 0($a0) # t3 = char at desired index
	jr $ra 

### Optional function: not required for the assignment ###
index_of:
	li $v0, -200
	li $v1, -200
	
	# a0 = character
	# a1 = address of transliterate_str/weights
		
	li $t4, 0 # counter
	find_index:
		lbu $t5, 0($a1) # t5 = first char in a1
		beq $t5, $a0, found_index # if t5 = char, found index
		addi $a1, $a1, 1
		addi $t4, $t4, 1
		j find_index

found_index:
	jr $ra						

### Part VIII ###
compute_check_digit:
	li $v0, -200
	li $v1, -200
	
	# a0 = address of vin
	# a1 = address of map
	# a2 = address of weights
	# a3 = address of transliterate_Str
	
	li $t0, 0 # t0 = sum
	li $t1, 0 # t1 = counter
	li $t2, 17 # t2 = 17
	li $t6, 0 # index of char in transliterate_str % 10
	li $t7, 0 # index of char in transliterate_str % 10 * index of char in maps
	
	addi $sp, $sp, -12
	sw $s0, 8($sp)
	sw $s1, 4($sp)
	sw $ra, 0($sp)
	move $s0, $a0 # s0 = address of vin
 	move $s1, $a1 # s1 = address of map
	
	for_loop:
		beq $t1, $t2, sum_mod_11
		move $a0, $s0 # a0 = address of vin
		move $a1, $t1 # move counter value to a1
		jal char_at
		move $a0, $t3 # load char of vin at index into a0
		move $a1, $a3 # load transliterate_str into a1
		jal transliterate
		move $a0, $a2 # move addr of weights to a0
		move $a1, $t1 # move counter value to a1
		jal char_at
		move $t6, $t4 # t6 = index of char in transliterate_str % 10
		move $a0, $t3 # t3 = char at index
		move $a1, $s1
		jal index_of
		mul $t7, $t6, $t4
		add $t0, $t0, $t7 # sum = sum + (index of transliterate_str % 10) * index of char in map
		addi $t1, $t1, 1
		j for_loop

sum_mod_11:
	li $t8, 11
	div $t0, $t8 # sum divided by 11
	mfhi $t8 # t8 = sum % 11
	move $a0, $s1 # a0 = address of maps
	move $a1, $t8 # a1 = index
	jal char_at
	j check_digit

check_digit:
	lw $ra, 0($sp)
	lw $s1, 4($sp)
	lw $s0, 8($sp)
	addi $sp, $sp, 12
	move $v0, $t3 # v0 = check digit
	jr $ra # jump back to compute_check_digit_main.asm

#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################
