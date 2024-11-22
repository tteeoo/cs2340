.data
	continueText: .asciiz "You have not found all matches so the game will continue\n.."
	playAgainText: .asciiz "You Win!\nWould you like to play again? 0 = Play Again, 1 = Quit\n"
	unmatched: .asciiz " unmatched cards\n"
	answer: .space 100	
.text
checkWin:
	# Returns:	
	# 0 = Continue Game
	# 1 = Finish Game
	la $t0, binaryMatrix
	addi $t1, $zero, 0 # Finish flag, 0 = 0 Not found yet
	addi $v0, $zero, 1
		
	addi $sp, $sp, -4
	sw $ra, 0($sp)
		
	li $t5, 0
	li $t1, 0
	checkWinLoop:
		lw $t2, 0($t0) # Value of cell
		
		addi $sp, $sp, -4
		sw $ra, 0($sp)
		
		beq $t2, 0, incrementCounter # If cell value = 0 then end loop
		comeBack:
		
		lw $ra, 0($sp)
		addi $sp, $sp, 4
		
		addi $t0, $t0, 4 # Update index
		addi $t1, $t1 1
	blt $t1, 16, checkWinLoop
	
	
	bgt $t5, 0, updateCheckWin
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4	
jr $ra 

updateCheckWin:
	li $v0, SysPrintInt # Showing selected values
	move $a0, $t5
	syscall

	li $v0, SysPrintString # Showing selected values
	la $a0, unmatched
	syscall
	
	addi $v0, $zero, 0
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

incrementCounter:
	addi $t5, $t5, 1
j comeBack
