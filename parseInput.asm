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

	move $s0,$v0 # Save Cell #1 value to $s0

	li $v0, SysPrintString # Prompt for Cell #2 Number
	la $a0, colPrompt
	syscall
	
	li $v0, SysReadInt # Read in Cell #2 value
	syscall
	
	blt $v0, 1, parseInput # Input validation
	bgt $v0, 16, parseInput
	
	move $s1,$v0 # Save Cell #2 value to $s1
	
	li $v0, SysPrintString # Showing selected values
	la $a0, selectedText
	syscall
			
	li $v0, SysPrintInt
	move $a0, $s0
	syscall
			
	li $v0, SysPrintString # Showing selected values
	la $a0, comma
	syscall
			
	li $v0, SysPrintInt
	move $a0, $s1
	syscall
			
	li $v0, SysPrintString # Printing new line
	la $a0, newLine 
	syscall
	
jr $ra
