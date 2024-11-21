# CS 2340 Term Project
# Author: Theo & Anthony
# Date: Wed Nov 20 2024
# Description: Multiplication matching game

.include	"SysCalls.asm"
.data
	# Data segment
	displayMatrix: .space 512 # This will be randomly generated from the bank
	binaryMatrix: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	valueMatrix: .space 512 # This will be randomly generated from the bank
	BANK_displayMatrix: .asciiz "04x3001204x4002005x405x50012002001x204x5002503x400080002001602x4"
	BANK_binaryMatrix: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	BANK_valueMatrix: .word 12,12,16,20,20,25,12,20,2,20,25,12,8,2,16,8
	rowPrompt: .asciiz "Enter the first cell number you would like to select (1-16) \n"
	colPrompt: .asciiz "Enter the second cell number you would like to select (1-16) \n"
	selectedText: .asciiz "You have selected Cells: "
	comma: .asciiz " and "
	newLine: .asciiz "\n"
	continueText: .asciiz "You have not found all matches so the game will continue\n"
	timeFormat: .asciiz "00:00 Elapsed"
	playAgainText: .asciiz "Would you like to play again? 0 = Play Again, 1 = Quit \n"
	yes: .asciiz "Y"
	no: .asciiz "N"
	answer: .space 100
	clearScreen: .asciiz "\n\n\n\n\n\n\n\n\n\n\n\n"
	

.text
.globl mainLoop
mainLoop:
	li $v0, 30 # System Time
	syscall
	move $s7, $a0 # Store starting time in $s7
	jal randomize
	eventLoop:
		jal renderBoard # Display the game board
		jal parseInput # Take user inputs and processes them
		jal showTime # Displays elapsed time
		jal checkWin # Checks if user has won
	beqz $v0, eventLoop
	
jal playAgain
beqz $v0, mainLoop

li $v0, SysExit	# syscall: exit 
syscall

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

renderBoard:
	li $t0, 0 # Counter for the loop
	li $t1, 16 # Limit of the loop
	cellLoop:
		la $t2, displayMatrix # Grap the start of the display matrix
		sll $t3, $t0, 2 # Counter * 4 = offset of cell
		add $t2, $t2, $t3 # Label + offset = cell in memory
		
		li $t5, 0 # Counter for the loop
		li $t6, 4 # Limit of the loop
		charLoop:
			add $t7, $t2, $t5 # Byte = cell + counter
			lb $a0, 0($t7) # Load char to print
			li $v0, SysPrintChar # Syscall for printing a character
			syscall
			addi $t5, $t5, 1 # Incremement counter
		blt $t5, $t6, charLoop
			
		addi $t0, $t0, 1 # Incremement counter
		 
		# Printing a newline after every fourth cell
		li $t2, 4
		div $t0, $t2 # Divide counter by 4
		mfhi $t3 # Move the remainder to $t3
		bnez $t3, skipNewline # Skip newline printing if divisble by 4
		
		li $v0, SysPrintString # Syscall for printing a string
		la $a0, newLine # Load address of the message
		syscall
		
		skipNewline:
	blt $t0, $t1, cellLoop
jr $ra

checkWin:
	# Returns:	
	# 0 = Continue Game
	# 1 = Finish Game
	la $t0, binaryMatrix
	addi $t1, $zero, 0 # Finish flag, 0 = 0 Not found yet
	addi $v0, $zero, 1
		
	addi $sp, $sp, -4
	sw $ra, 0($sp)
		
	checkWinLoop:
		lw $t2, 0($t0) # Value of cell
		
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		
		beq $t2, 0, updateCheckWin # If cell value = 0 then end loop
		
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		addi $t0, $t0, 4 # Update index
	beqz $t1,checkWinLoop
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4	
jr $ra 

updateCheckWin:
	li $v0, SysPrintString # Showing selected values
	la $a0, continueText
	syscall
	
	addi $t1, $t1, 1
	addi $v0, $zero, 0
jr $ra

showTime:
	li $v0, 30 # System Time
	syscall
	move $t0, $a0 # Store current time in $t0
	
	sub $a0, $t0, $s7
	
	
	li $t0, 1000     # Divisor for ms to seconds
    	div $a0, $t0     # Divide milliseconds by 1000
    	mflo $t1         # $t1 now contains total seconds
    
    	# Get minutes
    	li $t0, 60       # Divisor for seconds to minutes
    	div $t1, $t0     # Divide total seconds by 60
    	mflo $t2         # $t2 = minutes
    	mfhi $t3         # $t3 = remaining seconds
    	
    	# Convert first minute digit
    	li $t0, 10       # Divisor for tens place
    	div $t2, $t0     # Divide minutes by 10
    	mflo $t4         # $t4 = tens digit
    	mfhi $t5         # $t5 = ones digit
   	 
    	# Store minutes digits with validation
    	la $t0, timeFormat  # Load address of output buffer
    	
    	# Tens digit of minutes
    	li $t6, 0x30        # ASCII '0'
    	add $t4, $t4, $t6   # Convert to ASCII
    	sb $t4, 0($t0)      # Store tens digit
    
   	 # Ones digit of minutes
   	add $t5, $t5, $t6   # Convert to ASCII
    	sb $t5, 1($t0)      # Store ones digit
    	
    	# Convert seconds
    	li $t0, 10          # Divisor for tens place
    	div $t3, $t0        # Divide seconds by 10
    	mflo $t4            # $t4 = tens digit
    	mfhi $t5            # $t5 = ones digit
    
    	# Store seconds digits with validation
    	la $t0, timeFormat # Load address of output buffer
    
    	# Tens digit of seconds
    	add $t4, $t4, $t6   # Convert to ASCII
    	sb $t4, 3($t0)      # Store tens digit
    
    	# Ones digit of seconds
    	add $t5, $t5, $t6   # Convert to ASCII
    	sb $t5, 4($t0)      # Store ones digit
    
    	# Print the formatted time
    	li $v0, 4           # Print string syscall
    	la $a0, timeFormat # Load address of time string
    	syscall
	
	
	li $v0, SysPrintString # Printing new line
	la $a0, newLine 
	syscall
	
jr $ra

playAgain:
# Return 1 for quit
# Return 0 for keep playing
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	playAgainLoop:
		li $v0, SysPrintString
		la $a0, playAgainText
		syscall
		
		li $v0, SysReadInt
		syscall
		
		
		
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		
		beq $a0, 1, noPath
		beq $a0, 0, yesPath
		
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
	bgt $v0, 1, playAgainLoop

	lw $ra, 0($sp)
	addi $sp, $sp, 4
jr $ra

yesPath:
	addi $v0, $zero, 0
jr $ra

noPath:
	addi $v0, $zero, 1
jr $ra

randomize:
	
	
	la $t3, BANK_displayMatrix
	la $t4, BANK_valueMatrix
	move $t1, $t3
	move $t2, $t4
	
	li $t0, 0 # Array index
	shuffleBank:
		li $v0, SysRandIntRange
		li $a1, 16
		syscall
		
		mul $a0,$a0,4
		
		add $t3, $t3, $a0 # Increment bank addresses
		add $t4, $t4, $a0
		
		lw $t5, 0($t1) # Load from current spot
		lw $t6, 0($t3) # Load from random spot
		
		sw $t6, 0($t1) # Put random in current
		sw $t5, 0($t3) # Put current in random spot
		
		lw $t5, 0($t2) # Load from current spot
		lw $t6, 0($t4) # Load from random spot
		
		sw $t6, 0($t2) # Put random in current
		sw $t5, 0($t4) # Put current in random spot
		
		
		
		sub $t3, $t3, $a0 # Reset bank addresses
		sub $t4, $t4, $a0
		
		addi $t1, $t1, 4 # Increment
		addi $t2, $t2, 4
		
		addi $t0, $t0, 1
	blt $t0,16,shuffleBank
	
	
	
	la $t1, displayMatrix # Load address of display matrix
	la $t2, valueMatrix # Load address of value matrix
	li $t0, 0 # Array index
	copyLoop:
		
		# Copy shuffled content to real matricies
		lw $t5, 0($t3)
		sw $t5, 0($t1)
		 lw $t5, 0($t4)
		sw $t5, 0($t2)
		
		
		addi $t1, $t1, 4
		addi $t2, $t2, 4
		addi $t3, $t3, 4
		addi $t4, $t4, 4
		addi $t0, $t0, 1
	blt $t0,16,copyLoop
	
	
jr $ra