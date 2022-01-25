.data
message1: .asciiz " Prime"
newline: .asciiz "\n"

.text 
.globl main
main:
	li $s0,0
	li $s1,1000
	jal firstPrint  #I print 0,1,2 numbers out of the loop

	primeLoop:			#It goes to check Prime label and return this label after the print current number's situation
		bgt $s0,$s1,exit
		li $t0,2
		jal checkPrime
		addi $s0,$s0,1
		j primeLoop
	
	

checkPrime:				#Check the number is prime or not 
	beq $s0,$t0,printPrime		#If the loop ends, then that means the number is prime
	div $s0,$t0
	mfhi $t1				#Move the division remainder to the $t1 register
	beq $t1,$0,printNotPrime	#If the remainder is equal to 0, that means the number is not prime 
	addi $t0,$t0,1			#Add 1 to the iterator
	j checkPrime

printNotPrime:			#If the number is not prime, just prints the number and put a new line character
	li $v0,1		
	move $a0,$s0
	syscall		
	li $v0,4
	la $a0,newline		#Print the new line
	syscall
	jr $ra		
									
	
printPrime:			#If the number is prime, then prints the number and put string that is prime 
	li $v0,1		
	move $a0,$s0
	syscall	
	li $v0,4
	la $a0,message1
	syscall
	li $v0,4
	la $a0,newline		#Print the new line
	syscall	
	jr $ra
	
firstPrint:		#The first 3 number is obvious. So I print these numbers without loop for optimization. Otherwise, every turn it checks these numbers
	li $v0,1			#Print 0 
	move $a0,$s0
	syscall
	addi $s0,$s0,1
	li $v0,4
	la $a0,newline
	syscall
	li $v0,1			#Print 1 
	move $a0,$s0
	syscall	
	li $v0,4
	la $a0,newline
	syscall
	addi $s0,$s0,1
	li $v0,1			#Print 2 
	move $a0,$s0
	syscall
	li $v0,4
	la $a0,message1
	syscall
	li $v0,4
	la $a0,newline
	syscall
	addi $s0,$s0,1
	jr $ra

	
exit:			#Exit label
	li $v0,10
	syscall
