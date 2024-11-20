# CS 2340 Term Project
# Author: Theo & Anthony
# Date: Wed Nov 20 2024
# Description: Multiplication matching game

.include	"SysCalls.asm"
.data
	# Data segment
	displayMatrix: .asciiz "04x3001204x4002005x405x50012002001x204x5002503x400080002001602x4"
	binaryMatrix: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	valueMatrix: .word 12,12,16,20,20,25,12,20,2,20,25,12,8,2,16,8
	RO_displayMatrix: .asciiz "04x3001204x4002005x405x50012002001x204x5002503x400080002001602x4"
	RO_binaryMatrix: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	RO_valueMatrix: .word 12,12,16,20,20,25,12,20,2,20,25,12,8,2,16,8
	rowPrompt: .asciiz "Enter the first cell number you would like to select (1-16) \n"
	colPrompt: .asciiz "Enter the second cell number you would like to select (1-16) \n"
	selectedText: .asciiz "You have selected Cells: "
	comma: .asciiz " and "
	newLine: .asciiz "\n"
	continueText: .asciiz "You have not found all matches so the game will continue\n"
	timeFormat: .asciiz "00:00"
	playAgainText: .asciiz "Would you like to play again? 0 = Play Again, 1 = Quit \n"
	yes: .asciiz "Y"
	no: .asciiz "N"
	answer: .space 100
	

.text
mainLoop:
	li $v0, 30 # System Time
	syscall
	move $s7, $a0 # Store starting time in $s7
	
	
	eventLoop:
		
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

	move $s0,$v0 # Save Cell #1 value to $s0

	li $v0, SysPrintString # Prompt for Cell #2 Number
	la $a0, colPrompt
	syscall
	
	li $v0, SysReadInt # Read in Cell #2 value
	syscall
	
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