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

.include 	"renderBoard.asm"
.include 	"parseInput.asm"
.include	"showTIme.asm"
.include	"checkWin.asm"
.include	"randomize.asm"