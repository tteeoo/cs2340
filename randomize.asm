.data
	BANK_displayMatrix: .asciiz " 4x3  12 4x4  20 5x4 5x5  12  20 1x2 4x5  25 3x4   8   2  16 2x4"
	BANK_binaryMatrix: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	BANK_valueMatrix: .word 12,12,16,20,20,25,12,20,2,20,25,12,8,2,16,8

.text
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
