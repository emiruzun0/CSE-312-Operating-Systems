.data
message: .asciiz " ---Factors of Number---\n"
message1: .asciiz " Enter the integer for factors : "
message2: .asciiz " The factors : " 
message3: .asciiz " You can not enter negative number ! \n"
comma: .asciiz ","

.text 
.globl main
main:
	li $v0, 4					#Prints welcome program 
	la $a0, message
	syscall

	li $v0,4					#Prints Enter integers message
	la $a0,message1
	syscall
	
	li $v0,5					#Take integer input from the user
	syscall
	move $s0,$v0
	
	blt $s0,$0,errorLabel		#If the number is negative, then go to error label
	
	li $v0,4					#Prints The factors : message
	la $a0,message2
	syscall
	
	li $t0,1					#Load 1 to the t0 register. This is the iterator for my program
	
	printLoop:
		bgt $t0,$s0,exit
		div $s0,$t0
		mfhi $t1
		beq $t1,$0,printFactor
		checkNext:
		addi $t0,$t0,1
		j printLoop	
		
printFactor:		#Prints the factors of number
	li $v0, 1
	move $a0, $t0
	syscall
	
	li $v0, 4		#Prints comma
	la $a0, comma
	syscall
	
	j checkNext

errorLabel:			#Print the error mesage
	li $v0,4
	la $a0,message3
	syscall
	j exit
			
		
exit: 	#Exit label
	li $v0,10
	syscall
