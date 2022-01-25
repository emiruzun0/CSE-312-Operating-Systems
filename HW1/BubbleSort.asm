.data
myArray: .space 400
ArrSizeMessage: .asciiz " Please enter the length of the list : " 
message2: .asciiz " The length of the list can not be negative or zero ! "
message3: .asciiz " Enter the value : "
message4: .asciiz " After bubble sorting, the last list is :  " 
comma: .asciiz ","

	

.text 
.globl main

main:
	jal printArrSizeMsg			#Print message
	jal readArrSize				#Read array size
	la $s0,myArray		#Put the array adress into the t0 register 
	ble $t0,$0,errorLabel 
	
	li $t1,0		#Put 0 to the t1 register
	move $t2,$t0	#This is the size value. I copy to the t2 register
	li $t3,0		#Put 0 to the t3 register. It increases 4 by 4 for the address
	j loopForReadNumbers		#Take numbers loop. I take this loop in my organization course

loopForReadNumbers:
	beq $t1, $t2, bubbleSort		#If the numbers were taken, then go to the sort label

	la $a0, message3		#Prints message "enter value : "
	li $v0, 4
	syscall

	li $v0, 5				#Take numbers
	syscall 
	sw $v0, myArray($t3)	#Store the value in array

	addi $t3, $t3, 4
	addi $t1, $t1, 1
	j loopForReadNumbers

		

printArrSizeMsg: 
	li $v0, 4		#Print array size message
	la $a0, ArrSizeMessage
	syscall
	jr $ra
	
	
readArrSize:
	li $v0,5			#Take the length input from the user
	syscall
	move $t0,$v0
	jr $ra


bubbleSort:
	li $t1,0				#For the first iterator.  
	addi $t2,$t0,-1 		#It goes to until size-1. So I decrease the size by 1
	
	firstInnerLoop:			
		beq $t1,$t2,printArr 	#If the t1's value equals to t2's value, then go to the printArr label
		li $t3,0				#This is my second interator value. I load 0 in every loop
		sub $t4,$t2,$t1			
		secondInnerLoop:
			beq $t3,$t4,endSecondLoop	#If the loop is done for second iterator. time, then go endSecondLop
			sll $s1,$t3,2				#Multiplies by 4
			add $s1,$s1,$s0				#Added the value to the array address
			lw $s2,0($s1)				#Load the value in this index
			addi $t5,$t3,1
			sll $s3,$t5,2
			add $s3,$s3,$s0
			lw $s4,0($s3)				#Load the value in this index
			
			bgt $s2,$s4,swap			#If the first value is greater than second one, then swap these
			continue:
			addi $t3,$t3,1				#Increase second iterator
			j secondInnerLoop	
			
		endSecondLoop:
			addi $t1,$t1,1				#Increase first iterator
			j firstInnerLoop	
		
	
swap:					#Swaps the value and then again go to the continue label.
	sw $s4,0($s1)
	sw $s2,0($s3)
	j continue
	
printArr:
	li $v0, 4
	la $a0, message4
	syscall	
	
	li $t2,0				#Iterator for print
	move $t1,$t0
	li $t0,0				#Increases 4 by 4 for the address
		
	printLoop:
	beq $t2,$t1,exit		#If condition is not true, then go exit label
    li $v0,1
    lw $a0,myArray($t0)
    syscall
    jal PrintComma
    add $t0,$t0,4
    addi $t2,$t2,1
    j printLoop
    
PrintComma:				#Print space character
	li $v0,4
	la $a0,comma
	syscall
	jr $ra
	
	
errorLabel:		#Print the error message
	li $v0,4
	la $a0,message2
	syscall
	j exit
	
exit: 	#Exit label
	li $v0,10
	syscall
