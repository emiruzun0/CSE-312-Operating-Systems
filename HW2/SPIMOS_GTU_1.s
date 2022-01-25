.data 
	myArray: .space 400
	Sorted_Array:	.asciiz		"Sorted Array: ["
	Space:		.asciiz		", "
	Bracket:	.asciiz		"]"
.text
.globl main
	
main:
	
	
	
	addi $t0,$zero,99
	addi $t1,$zero,0
	addi $t2,$zero,4
	addi $t3,$zero,1
	
	j fillLoop
		

fillLoop:						#Fill the array from 99 to 0
	blt $t0,$t3,threadCreate
	sw $t0,myArray($t1)
	add $t1,$t1,$t2
	addi $t0,$t0,-1
	j fillLoop
	
	
threadCreate:
	#li $v0, 18			I didn't connect that.
	#syscall
	j threadJoin
	
threadJoin:				
	#li $v0, 19 		I didn't connect that
	#syscall
	li $a0,0			#Low 
	li $a1,24			#Middle
	li $a2, 49			#High
	jal mergeWith3Parameters
	li $a0,50			#Low 
	li $a1,	74		#Middle
	li $a2, 99			#High 
	jal mergeWith3Parameters
	li $a0,0			#Low 
	li $a1,	49		#Middle
	li $a2, 99			#High 
	jal mergeWith3Parameters

	
	
mergeWith3Parameters:
        addiu   $sp,$sp,-80
        sw      $fp,76($sp)
        sw      $19,72($sp)
        sw      $18,68($sp)
        sw      $17,64($sp)
        sw      $16,60($sp)
        move    $fp,$sp
        sw      $4,80($fp)
        sw      $5,84($fp)
        sw      $6,88($fp)
        move    $4,$sp
        move    $6,$4
        lw      $5,84($fp)
        lw      $4,80($fp)
        nop
        subu    $4,$5,$4
        addiu   $4,$4,1
        sw      $4,28($fp)
        lw      $5,88($fp)
        lw      $4,84($fp)
        nop
        subu    $4,$5,$4
        sw      $4,32($fp)
        lw      $4,28($fp)
        nop
        addiu   $4,$4,-1
        sw      $4,36($fp)
        move    $5,$4
        addiu   $5,$5,1
        move    $19,$5
        move    $18,$0
        srl     $5,$19,27
        sll     $12,$18,5
        or      $12,$5,$12
        sll     $13,$19,5
        move    $5,$4
        addiu   $5,$5,1
        move    $17,$5
        move    $16,$0
        srl     $5,$17,27
        sll     $10,$16,5
        or      $10,$5,$10
        sll     $11,$17,5
        addiu   $4,$4,1
        sll     $4,$4,2
        addiu   $4,$4,3
        addiu   $4,$4,7
        srl     $4,$4,3
        sll     $4,$4,3
        subu    $sp,$sp,$4
        move    $4,$sp
        addiu   $4,$4,3
        srl     $4,$4,2
        sll     $4,$4,2
        sw      $4,40($fp)
        lw      $4,32($fp)
        nop
        addiu   $4,$4,-1
        sw      $4,44($fp)
        move    $5,$4
        addiu   $5,$5,1
        move    $25,$5
        move    $24,$0
        srl     $5,$25,27
        sll     $8,$24,5
        or      $8,$5,$8
        sll     $9,$25,5
        move    $5,$4
        addiu   $5,$5,1
        move    $15,$5
        move    $14,$0
        srl     $5,$15,27
        sll     $2,$14,5
        or      $2,$5,$2
        sll     $3,$15,5
        move    $2,$4
        addiu   $2,$2,1
        sll     $2,$2,2
        addiu   $2,$2,3
        addiu   $2,$2,7
        srl     $2,$2,3
        sll     $2,$2,3
        subu    $sp,$sp,$2
        move    $2,$sp
        addiu   $2,$2,3
        srl     $2,$2,2
        sll     $2,$2,2
        sw      $2,48($fp)
        sw      $0,8($fp)
$L3:
        lw      $3,8($fp)
        lw      $2,28($fp)
        nop
        slt     $2,$3,$2
        beq     $2,$0,$L2
        nop

        lw      $3,80($fp)
        lw      $2,8($fp)
        nop
        addu    $3,$3,$2

        sll     $3,$3,2

        addu    $2,$3,$2

        lw      $4,40($fp)
        lw      $2,8($fp)
        nop
        sll     $2,$2,2
        addu    $2,$4,$2
        sw      $3,0($2)
        lw      $2,8($fp)
        nop
        addiu   $2,$2,1
        sw      $2,8($fp)
        b       $L3
        nop

$L2:
        sw      $0,12($fp)
$L5:
        lw      $3,12($fp)
        lw      $2,32($fp)
        nop
        slt     $2,$3,$2
        beq     $2,$0,$L4
        nop

        lw      $2,84($fp)
        nop
        addiu   $3,$2,1
        lw      $2,12($fp)
        nop
        addu    $3,$3,$2

        sll     $3,$3,2

        addu    $2,$3,$2

        lw      $4,48($fp)
        lw      $2,12($fp)
        nop
        sll     $2,$2,2
        addu    $2,$4,$2
        lw      $2,12($fp)
        nop
        addiu   $2,$2,1
        sw      $2,12($fp)
        b       $L5
        nop

$L4:
        sw      $0,16($fp)
        sw      $0,20($fp)
        lw      $2,80($fp)
        nop
        sw      $2,24($fp)
        j exit
$L9:
        lw      $3,16($fp)
        lw      $2,28($fp)
        nop
        slt     $2,$3,$2
        beq     $2,$0,$L6
        nop

        lw      $3,20($fp)
        lw      $2,32($fp)
        nop
        slt     $2,$3,$2
        beq     $2,$0,$L6
        nop

        lw      $3,40($fp)
        lw      $2,16($fp)
        nop
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)
        lw      $4,48($fp)
        lw      $2,20($fp)
        nop
        sll     $2,$2,2
        addu    $2,$4,$2
        lw      $2,0($2)
        nop
        slt     $2,$2,$3
        bne     $2,$0,$L7
        nop

        lw      $3,40($fp)
        lw      $2,16($fp)
        nop
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)

        lw      $4,24($fp)
        nop
        sll     $4,$4,2

        addu    $2,$4,$2
        sw      $3,0($2)
        lw      $2,16($fp)
        nop
        addiu   $2,$2,1
        sw      $2,16($fp)
        b       $L8
        nop

$L7:
        lw      $3,48($fp)
        lw      $2,20($fp)
        nop
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)

        lw      $4,24($fp)
        nop
        sll     $4,$4,2

        addu    $2,$4,$2
        sw      $3,0($2)
        lw      $2,20($fp)
        nop
        addiu   $2,$2,1
        sw      $2,20($fp)
$L8:
        lw      $2,24($fp)
        nop
        addiu   $2,$2,1
        sw      $2,24($fp)
        b       $L9
        nop

$L6:
        lw      $3,16($fp)
        lw      $2,28($fp)
        nop
        slt     $2,$3,$2
        beq     $2,$0,$L10
        nop

        lw      $3,40($fp)
        lw      $2,16($fp)
        nop
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)

        lw      $4,24($fp)
        nop
        sll     $4,$4,2

        addu    $2,$4,$2
        sw      $3,0($2)
        lw      $2,16($fp)
        nop
        addiu   $2,$2,1
        sw      $2,16($fp)
        lw      $2,24($fp)
        nop
        addiu   $2,$2,1
        sw      $2,24($fp)
        b       $L6
        nop

$L10:
        lw      $3,20($fp)
        lw      $2,32($fp)
        nop
        slt     $2,$3,$2
        beq     $2,$0,$L11
        nop

        lw      $3,48($fp)
        lw      $2,20($fp)
        nop
        sll     $2,$2,2
        addu    $2,$3,$2
        lw      $3,0($2)

        lw      $4,24($fp)
        nop
        sll     $4,$4,2

        addu    $2,$4,$2
        sw      $3,0($2)
        lw      $2,20($fp)
        nop
        addiu   $2,$2,1
        sw      $2,20($fp)
        lw      $2,24($fp)
        nop
        addiu   $2,$2,1
        sw      $2,24($fp)
        b       $L10
        nop

$L11:
        move    $sp,$6
        nop
        move    $sp,$fp
        lw      $fp,76($sp)
        lw      $19,72($sp)
        lw      $18,68($sp)
        lw      $17,64($sp)
        lw      $16,60($sp)
        addiu   $sp,$sp,80
        jr       $31
        nop

mergeWith2Parameters:
        addiu   $sp,$sp,-40
        sw      $31,36($sp)
        sw      $fp,32($sp)
        move    $fp,$sp
        sw      $4,40($fp)
        sw      $5,44($fp)
        lw      $3,44($fp)
        lw      $2,40($fp)
        nop
        subu    $2,$3,$2
        srl     $3,$2,31
        addu    $2,$3,$2
        sra     $2,$2,1
        move    $3,$2
        lw      $2,40($fp)
        nop
        addu    $2,$3,$2
        sw      $2,24($fp)
        lw      $3,40($fp)
        lw      $2,44($fp)
        nop
        slt     $2,$3,$2
        beq     $2,$0,$L14
        nop

        lw      $5,24($fp)
        lw      $4,40($fp)
        jal     mergeWith2Parameters
        nop

        lw      $2,24($fp)
        nop
        addiu   $2,$2,1
        lw      $5,44($fp)
        move    $4,$2
        jal     mergeWith2Parameters
        nop

        lw      $6,44($fp)
        lw      $5,24($fp)
        lw      $4,40($fp)
        jal     mergeWith3Parameters
        nop

$L14:
        nop
        move    $sp,$fp
        lw      $31,36($sp)
        lw      $fp,32($sp)
        addiu   $sp,$sp,40
        jr       $ra
        nop

mergeSort:
        addiu   $sp,$sp,-48
        sw      $31,44($sp)
        sw      $fp,40($sp)
        move    $fp,$sp
        sw      $4,48($fp)
        nop
        addiu   $4,$2,1
        sw      $2,24($fp)
        lw      $3,24($fp)
        nop
        move    $2,$3
        sll     $2,$2,2
        addu    $2,$2,$3
        sw      $2,28($fp)
        lw      $2,24($fp)
        nop
        addiu   $3,$2,1
        move    $2,$3
        sll     $2,$2,2
        addu    $2,$2,$3
        addiu   $2,$2,-1
        sw      $2,32($fp)
        lw      $3,32($fp)
        lw      $2,28($fp)
        nop
        subu    $2,$3,$2
        srl     $3,$2,31
        addu    $2,$3,$2
        sra     $2,$2,1
        move    $3,$2
        lw      $2,28($fp)
        nop
        addu    $2,$3,$2
        sw      $2,36($fp)
        lw      $3,28($fp)
        lw      $2,32($fp)
        nop
        slt     $2,$3,$2
        beq     $2,$0,$L16
        nop

        lw      $5,36($fp)
        lw      $4,28($fp)
        jal     mergeWith2Parameters
        nop

        lw      $2,36($fp)
        nop
        addiu   $2,$2,1
        lw      $5,32($fp)
        move    $4,$2
        jal     mergeWith2Parameters
        nop

        lw      $6,32($fp)
        lw      $5,36($fp)
        lw      $4,28($fp)
        jal     mergeWith3Parameters
        nop

$L16:
        nop
        move    $sp,$fp
        lw      $31,44($sp)
        lw      $fp,40($sp)
        addiu   $sp,$sp,48
        jr       $ra
        nop


	
$L19:
        lw      $2,24($fp)
        nop

        beq     $2,$0,$L18
        nop
        lw      $3,24($fp)
        nop
        sll     $3,$3,2
        addu    $2,$3,$2
        lw      $3,28($fp)
        nop
        sw      $3,0($2)
        lw      $2,24($fp)
        nop
        addiu   $2,$2,1
        sw      $2,24($fp)
        lw      $2,28($fp)
        nop
        addiu   $2,$2,-1
        sw      $2,28($fp)
        b       $L19
        nop

$L18:
        sw      $0,32($fp)
$L21:
        lw      $2,32($fp)
        nop
        beq     $2,$0,$L20
        nop

        addiu   $3,$fp,40
        lw      $2,32($fp)
        nop
        sll     $2,$2,2
        addu    $3,$3,$2
        move    $7,$0
        move    $5,$0
        move    $4,$3
        jal     threadCreate  #I didn't do that
        nop

        lw      $2,32($fp)
        nop
        addiu   $2,$2,1
        sw      $2,32($fp)
        b       $L21
        nop

$L20:
        sw      $0,36($fp)
$L23:
        lw      $2,36($fp)
        nop
        beq     $2,$0,$L22
        nop

        lw      $2,36($fp)
        nop
        sll     $2,$2,2
        addiu   $3,$fp,24
        addu    $2,$3,$2
        lw      $2,16($2)
        move    $5,$0
        move    $4,$2
        jal     threadJoin
        nop

        lw      $2,36($fp)
        nop
        addiu   $2,$2,1
        sw      $2,36($fp)
        b       $L23
        nop

$L22:
        li      $6,9                        # 0x9
        li      $5,4                        # 0x4
        move    $4,$0
        jal     mergeWith3Parameters
        nop

        li      $6,19                 # 0x13
        li      $5,14                 # 0xe
        li      $4,10                 # 0xa
        jal     mergeWith3Parameters
        nop

        li      $6,19                 # 0x13
        li      $5,9                        # 0x9
        move    $4,$0
        jal     mergeWith3Parameters
        nop

        move    $2,$0
        move    $sp,$fp
        lw      $31,60($sp)
        lw      $fp,56($sp)
        addiu   $sp,$sp,64
        jr       $ra
        nop

staticWith2Prm:
        addiu   $sp,$sp,-32
        sw      $31,28($sp)
        sw      $fp,24($sp)
        move    $fp,$sp
        sw      $4,32($fp)
        sw      $5,36($fp)
        lw      $3,32($fp)
        li      $2,1                        # 0x1
        bne     $3,$2,$L27
        nop

        lw      $3,36($fp)
        li      $2,65535                    # 0xffff
        bne     $3,$2,$L27
        nop

        nop
        jal     exit
        nop

$L27:
        nop
        move    $sp,$fp
        lw      $31,28($sp)
        lw      $fp,24($sp)
        addiu   $sp,$sp,32
        jr       $ra
        nop
	
	
exit: 	#Exit label
	li $v0,10
	syscall
