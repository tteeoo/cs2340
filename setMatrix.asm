setMatrix:
	# Load values from the equivalence matrix to see if the cells are the same
	lw $t2, valueMatrix($a0)
	lw $t3, valueMatrix($a1)
	
	# Keep the binary matrix unchanged (cells set visible from parseInput) if the values are the same
	beq $t2, $t3, match
	
	# Flip the cards back over if they don't match
	sw $zero, binaryMatrix($a0)
	sw $zero, binaryMatrix($a1)
	
	match:
jr $ra