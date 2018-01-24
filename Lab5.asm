.data
array: .space 480
namePrompt: .asciiz "Enter Name: "
agePrompt: .asciiz "Enter Age: "
salaryPrompt: .asciiz "Enter Salary: "
swapPrompt1: .asciiz "Enter Swap Index (1): "
swapPrompt2: .asciiz "Enter Swap Index (2): "
result1: .asciiz "Name: "
result2: .asciiz "Age, Salary: "
separate:  .asciiz ", $"
newLine:  .asciiz "\n"
swapError:  .asciiz "\nError: Invalid Swap Index. Ending program.."
buffer1: .space 40
buffer2: .space 40

.text
main:
	jal reset
	jal read
	jal reset
	jal print
	jal swap
	jal reset
	jal print
	li $v0, 10
	syscall

read:
	li $v0, 4
	la $a0, newLine
	syscall
	la $a0, namePrompt
	li $v0, 4
	syscall
	la $a0, ($t1)
	li $a1, 40
	li $v0, 8
	syscall

	la $a0, agePrompt
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	sw $v0, 40($t1)

	la $a0, salaryPrompt
	li $v0, 4
	syscall
	li $v0, 5
	syscall
	sw $v0, 44($t1)
	
	addi $t0, $t0, -1
	addi $t1, $t1, 48
	bgtz $t0, read
	jr $ra
	
print:
	li $v0, 4
	la $a0, newLine
	syscall
	
	li $v0, 4
	la $a0, result1
	syscall
	la $a0, ($t1)
	li $v0, 4
	syscall
	
	li $v0, 4
	la $a0, result2
	syscall
	la $a0, ($t1)
	lw $t2, 40($a0)
	li $v0, 1
	move $a0, $t2
	syscall
	li $v0, 4
	la $a0, separate
	syscall
	
	la $a0, ($t1)
	li $v0, 1
	lw $t2, 44($a0)
	move $a0, $t2
	syscall
	
	li $v0, 4
	la $a0, newLine
	syscall
	
	addi $t0, $t0, -1
	addi $t1, $t1, 48
	bgtz $t0, print
	jr $ra
	
swap:
	li $v0, 4
	la $a0, newLine
	syscall
	li $v0, 4
	la $a0, swapPrompt1
	syscall
	li $v0, 5
	syscall
	la $t2, ($v0)
	li $v0, 4
	la $a0, swapPrompt2
	syscall
	li $v0, 5
	syscall
	la $t3, ($v0)
	
	bltz $t2, skip
	bltz $t3, skip
	bgt $t2, 9, skip
	bgt $t3, 9, skip
	beq $t2, $t3, skip	
	mul $t2, $t2, 48
	mul $t3, $t3, 48
	
	li $a0, 40
	la $t1, array
	add $t1, $t1, $t2
	la $s0, buffer1
	
	loadName1:
	bltz $a0, cont1
	lb $a1, ($t1)
	sb $a1, ($s0)
	addi $t1, $t1, 1
	addi $s0, $s0, 1
	addi $a0, $a0, -1
	b loadName1
	
	cont1:
	la $t1, array
	add $t1, $t1, $t2
	lw $s1, 40($t1)
	lw $s2, 44($t1)
	
	li $a0, 40
	la $t1, array
	add $t1, $t1, $t3
	la $s0, buffer2
	
	loadName2:
	bltz $a0, cont2
	lb $a1, ($t1)
	sb $a1, ($s0)
	addi $t1, $t1, 1
	addi $s0, $s0, 1
	addi $a0, $a0, -1
	b loadName2
	
	cont2:
	la $t1, array
	add $t1, $t1, $t3
	lw $t5, 40($t1)
	lw $t6, 44($t1)
	
	li $a0, 40
	la $t1, array
	add $t1, $t1, $t3
	la $s0, buffer1
	
	swapName1:
	bltz $a0, cont3
	lb $a1, ($s0)
	sb $a1, ($t1)
	addi $t1, $t1, 1
	addi $s0, $s0, 1
	addi $a0, $a0, -1
	b swapName1
	
	cont3:
	li $a0, 40
	la $t1, array
	add $t1, $t1, $t2
	la $s0, buffer2
	
	swapName2:
	bltz $a0, cont4
	lb $a1, ($s0)
	sb $a1, ($t1)
	addi $t1, $t1, 1
	addi $s0, $s0, 1
	addi $a0, $a0, -1
	b swapName2
	
	cont4:
	la $t1, array
	add $t1, $t1, $t2
	sw $t5, 40($t1)
	sw $t6, 44($t1)
	
	la $t1, array
	add $t1, $t1, $t3
	sw $s1, 40($t1)
	sw $s2, 44($t1)
	jr $ra
	
	skip:
	li $v0, 4
	la $a0, swapError
	syscall
	jr $ra
	
reset:
	li $t0, 10
	la $t1, array
	jr $ra
