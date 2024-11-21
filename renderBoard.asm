renderBoard:
	# Enter cellLoop to print each cell
	li $t0, 0 # Counter for the loop
	li $t1, 16 # Limit of the loop
	cellLoop:
		la $t2, displayMatrix # Grap the start of the display matrix
		sll $t3, $t0, 2 # Counter * 4 = offset of cell
		
		# Skip if the cell is not flipped (0 in binary matrix)
		lw $t8, binaryMatrix($t3)
		beqz $t8, unflipped
		
		# Enter charLoop to print a flipped cell, iterating each character in displayMatrix
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
		
		b flipped # Above we have printed a flipped cell, so skip unflipped print logic
		unflipped:
			li $v0, SysPrintString # Print "  ? "
			la $a0, cell
			syscall
		flipped:
		
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
