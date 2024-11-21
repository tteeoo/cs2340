# CS 2340 Term Project
# Author: Theo & Anthony
# Date: Wed Nov 20 2024
# Description: Multiplication matching game

.include	"SysCalls.asm"
.data
	# Data segment
	displayMatrix: .space 64 # This will be randomly generated from the bank
	binaryMatrix: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	valueMatrix: .space 64 # This will be randomly generated from the bank

	newLine: .asciiz "\n"
  cell: .asciiz "  ? "

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
		
		# Move the output of parseInput (selected cells) into the arguments for setMatrix
		move $a0, $v0
		move $a1, $v1
		
		jal setMatrix # Check for value of selected cells and set matrices accordingly
		jal showTime # Displays elapsed time
		jal checkWin # Checks if user has won
	beqz $v0, eventLoop
	
jal playAgain
beqz $v0, mainLoop

li $v0, SysExit	# syscall: exit 
syscall

.include 	"renderBoard.asm"
.include 	"parseInput.asm"
.include 	"setMatrix.asm"
.include	"showTIme.asm"
.include	"checkWin.asm"
.include	"randomize.asm"
