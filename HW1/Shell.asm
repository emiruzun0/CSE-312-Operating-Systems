.data
MenuMessage: .asciiz "MENU \n1 - Show Primes \n2 - Factorize\n3 - BubbleSort\n4 - Exit\n"
EnterMessage: .asciiz "Enter number : " 
ErrorMessage: .asciiz "You've entered wrong choice !\n"
ExitMessage: .asciiz "Exited."
isPrime: .asciiz "ShowPrimes.asm"
Factorizes: .asciiz "Factorize.asm"
BubbleSort: .asciiz "BubbleSort.asm"



.text 
.globl main
main:
        addiu   $sp,$sp,-24
        sw      $fp,20($sp)
        move    $fp,$sp
        sw      $0,8($fp)
        b       $L2
        nop


$L9:
        lw      $2,8($fp)
        li      $3,1                        #case 1 
        beq     $2,$3,$L6
        nop

		li $3,2								#case 2
		beq     $2,$3,$L7
		
		li $3,3								#case 3 
		beq     $2,$3,$L8
        
        

		lw $2,8($fp)
		li $t0,1
		li $t1,4
        blt $2, $t0, error 				#Check if the choice is less than 1 or greater than 4, then goes to the error mesage
		bgt $2, $t1, error
        nop

        b       $L3
        nop

$L5:
        li      $3,3                        # 0x3
        beq     $2,$3,$L2
        nop

        li      $3,4                        # 0x4
        beq     $2,$3,$L2
        nop

$L3:
        nop



$L2:									#While loop
		la $a0, MenuMessage
		li $v0, 4
		syscall

		la $a0, EnterMessage
		li $v0, 4
		syscall
		
		li $v0, 5				#Take the input
		syscall 
		sw $v0,8($fp)
				
        lw      $3,8($fp)
        li      $2,4                        # 0x4
        bne     $3,$2,$L9
        nop

        j exit
        
error:				#Print error message
	la $a0, ErrorMessage
	li $v0, 4
	syscall
	j $L2
        
exit:				#Exit label
	la $a0, ExitMessage
	li $v0, 4
	syscall
	li $v0,10
	syscall
	

$L6:						#ShowPrimes.asm filename is added to a0 and called syscall
		la $a0, isPrime
		li $v0, 18
		syscall
		j $L2
		
$L7:						#Factorizes.asm filename is added to a0 and called syscall
		la $a0, Factorizes
		li $v0, 18
		syscall
		j $L2
		
$L8:						#BubbleSort.asm filename is added to a0 and called syscall
		la $a0, BubbleSort
		li $v0, 18
		syscall
		j $L2
		

