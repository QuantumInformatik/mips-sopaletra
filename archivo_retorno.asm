.data 
.align 2
archivo: .space 1024	# dirección de la url del archivo ingresada por el user

.align 2
DERECHA: .asciiz "La palabra está hacia la derecha"


.align 2
bufferSalida: .space 69 # 

#mensajes 
pedirPlabras: .asciiz "\n Ingrese la palabra a buscar en la sopa de letras:\n "


mensaje1: .asciiz "\n retorno aquí"


cons1:  .word 32	# Caracter de espacio
cons2:  .word 13	# Caracter: Carriage Return

spaces: .asciiz ""     #aquí se almacenan los caracteres leidos del archivo.

.text
main: #amain
	addi $t0, $zero, 200
	
	jal mainMenu
	
	lw $ra, 0($sp) # restaurar ra
	addi $sp, $sp, 4
	
	li $v0, 10
	syscall
	
sumar: #sumar

	addi $sp, $sp, -4	#Copia de seguridad de la dirección de la función que llama, para devolvernos en dado caso
	sw $ra, 0($sp)
	
	add $t1, $t0, $a0
	
	addi $v0, $t1, 0
	
	jr $ra
		
mainMenu: #mainmenu

	addi $sp, $sp, -4	#Copia de seguridad de la dirección de la función que llama, para devolvernos en dado caso
	sw $ra, 0($sp)

	
	jal sumar
	
	lw $ra, 0($sp) # restaurar ra
	addi $sp, $sp, 4
	
	add $t2, $zero, $v0
	 	
 	li $v0, 1
 	addi $a0, $t2, 0
 	syscall
 	
 	jr $ra
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	