# CS 2340 Term Project
# Author: Theo & Anthony
# Date: Wed Nov 20 2024
# Description: Multiplication matching game

.include	"SysCalls.asm"
.data
	# Data segment
	displayMatrix: .asciiz "04x3001204x4002005x405x50012002001x204x5002503x400080002001602x4"
	binaryMatrix: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	valueMatrix: .word 12,12,16,20,20,25,12,20,2,20,25,12,8,2,16,8
	RO_displayMatrix: .asciiz "04x3001204x4002005x405x50012002001x204x5002503x400080002001602x4"
	RO_binaryMatrix: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	RO_valueMatrix: .word 12,12,16,20,20,25,12,20,2,20,25,12,8,2,16,8
	rowPrompt: .asciiz "Enter the row number you would like to select\n"
	colPrompt: .asciiz "Enter the column number you would like to select\n"
	selectedText: .asciiz "You have selected: "
	comma: .asciiz ","
	newLine: .ascizz "\n"
	

.text
mainLoop:
	li $v0, 30 # System Time
	syscall
	move $s7, $a0 # Store starting time in $s7
	
	
	eventLoop:
	
		jal parseInput
		
		
	
		parseInput:
			li $v0, SysPrintString # Prompt for Row value
			la $a0, rowPrompt
			syscall
		
			li $v0, SysReadInt # Read in row value
			syscall
		
			move $s0,$v0 # Save Row value to $s0
		
			li $v0, SysPrintString # Prompt for Col value
			la $a0, colPrompt
			syscall
			
			li $v0, SysReadInt # Read in Col value
			syscall
			
			move $s1,$v0 # Save Col value to $s0
			
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
		# This will eventually check if the binaryMatrix is all 1s.
		# 0 = Continue Game
		# 1 = Finish Game
			checkWinLoop:
				la $t0, binaryMatrix
				
		
			li $v0, 0
		jr $ra 

	jal checkWin
	beqz $v0, eventLoop
#Prompt User if they wanna quit
beqz $v0, mainLoop

li $v0, SysExit	# syscall: exit 
syscall
	


		
