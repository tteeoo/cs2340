.data
	rowPrompt: .asciiz "Enter the first cell number you would like to select (1-16) \n"
	colPrompt: .asciiz "Enter the second cell number you would like to select (1-16) \n"
	selectedText: .asciiz "You have selected Cells: "
	comma: .asciiz " and "
.text
parseInput:
	li $v0, SysPrintString # Prompt for Cell #1 Number
	la $a0, rowPrompt
	syscall

	li $v0, SysReadInt # Read in Cell #1 Number
	syscall
	

	blt $v0, 1, parseInput # Input validation
	bgt $v0, 16, parseInput

	move $t0, $v0 # Save Cell #1 value to $t0
	# Calculate matrix offset with (Cell# - 1) * 4
	subi $t2, $t0, 1
	sll $t2, $t2, 2
	# Flip the card up by setting its place in the binary matrix to 1
	li $t4, 1
	sw $t4, binaryMatrix($t2)
	# Print the board, but need to save $ra and $t0,2 on the stack,
	#	because this is a nested function call
	subu $sp, $sp, 12 # Allocate space on the stack
	sw $ra, 0($sp) # Save $ra
	sw $t0, 4($sp) # Save $t0
	sw $t2, 8($sp) # Save $t2
	jal renderBoard # Print
	lw $ra, 0($sp) # Restore $ra
	lw $t0, 4($sp) # Restore $t0
	lw $t2, 8($sp) # Restore $t2
	addu $sp, $sp, 12 # Deallocate space

	li $v0, SysPrintString # Prompt for Cell #2 Number
	la $a0, colPrompt
	syscall
	
	li $v0, SysReadInt # Read in Cell #2 value
	syscall
	
	blt $v0, 1, parseInput # Input validation
	bgt $v0, 16, parseInput
	
	move $t1, $v0 # Save Cell #2 value to $t1
	# Calculate matrix offset with (Cell# - 1) * 4
	subi $t3, $t1, 1
	sll $t3, $t3, 2
	# Flip the card up by setting its place in the binary matrix to 1
	li $t4, 1
	sw $t4, binaryMatrix($t3)
	# Print the board, but need to save $ra and $t0,1,2,3 on the stack,
	#	because this is a nested function call
	subu $sp, $sp, 20 # Allocate space on the stack
	sw $ra, 0($sp) # Save $ra
	sw $t0, 4($sp) # Save $t0
	sw $t1, 8($sp) # Save $t1
	sw $t2, 12($sp) # Save $t2
	sw $t3, 16($sp) # Save $t3
	jal renderBoard # Print
	lw $ra, 0($sp) # Restore $ra
	lw $t0, 4($sp) # Restore $t0
	lw $t1, 8($sp) # Restore $t1
	lw $t2, 12($sp) # Restore $t2
	lw $t3, 16($sp) # Restore $t3
	addu $sp, $sp, 20 # Deallocate space
	
	li $v0, SysPrintString # Showing selected values
	la $a0, selectedText
	syscall
			
	li $v0, SysPrintInt
	move $a0, $t0
	syscall
			
	li $v0, SysPrintString # Showing selected values
	la $a0, comma
	syscall
			
	li $v0, SysPrintInt
	move $a0, $t1
	syscall
			
	li $v0, SysPrintString # Printing new line
	la $a0, newLine 
	syscall
	
	# Move return values (selected cell offsets) into the v registers
	move $v0, $t2
	move $v1, $t3

jr $ra
