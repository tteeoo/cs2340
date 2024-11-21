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