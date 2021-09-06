.data 


.text
main: #amain 
	addi $t0, $zero, 200
	
	jal mainMenu
	
	lw $ra, 0($sp) # restaurar ra
	addi $sp, $sp, 4
	
	li $v0, 10
	syscall
	
sumar: #sumar

	addi $sp, $sp, -4	#Copia de seguridad de la direcci�n de la funci�n que llama, para devolvernos en dado caso
	sw $ra, 0($sp)
	
	add $t1, $t0, $a0
	
	addi $v0, $t1, 0
	
	jr $ra
		
mainMenu: #mainmenu

	addi $sp, $sp, -4	#Copia de seguridad de la direcci�n de la funci�n que llama, para devolvernos en dado caso
	sw $ra, 0($sp)

	
	jal sumar
	
	lw $ra, 0($sp) # restaurar ra
	addi $sp, $sp, 4
	
	add $t2, $zero, $v0
	 	
 	li $v0, 1
 	addi $a0, $t2, 0
 	syscall
 	
 	jr $ra
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	