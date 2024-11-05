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

.text
	
	
	li $v0, SysExit	# syscall: exit 
	syscall
