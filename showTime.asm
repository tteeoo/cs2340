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