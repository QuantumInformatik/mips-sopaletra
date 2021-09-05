.data 
.align 2
bufferPalabra: .space 100 				# direcci�n de las palabras que escribir� el usuario
.align 2
archivo: .space 1024					# direcci�n de la url del archivo ingresada por el user
.align 2
archivoLimpio: .space 1024 				# Direcci�n del archivo ingresado por el user pero sin el \n
.align 2
DERECHA: .asciiz "La palabra est� hacia la derecha"
.align 2
IZQUIERDA: .asciiz "La palabra est� hacia la izquierda"
.align 2
ARRIBA: .asciiz "La palabra est� hacia la arriba"
.align 2
ABAJO	: .asciiz "La palabra est� hacia la abajo"

.align 2
dondeEstan	: .asciiz "La palabra inicia en "
fila	: .asciiz "\n fila: "
columna	: .asciiz "\n columna: "


.align 2
bufferSalida: .space 69 # 


#mensajes 
pedirPlabras: .asciiz "\n Ingrese la palabra a buscar en la sopa de letras:\n "
pedirArchivo: .asciiz "\n Ingrese ruta del archivo: \n"
mensajeAparicion1: .asciiz " aparece en el archivo "
mensajeAparicion2: .asciiz " veces.\n"

mensaje1: .asciiz "\n retorno aqu�"


cons1:  .word 32						# Caracter de espacio
cons2:  .word 13						# Caracter: Carriage Return

spaces: .asciiz ""     #aqu� se almacenan los caracteres leidos del archivo.
.text

main: 									# Subrutina: main (Inicio del Programa)

	jal	mainMenu 						# rutina principal, jump and link 
	j 	exit    

mainMenu: 								# Subrutina: menu principal
	addi $sp, $sp, -4					# Copia de seguridad de la direcci�n de la funci�n que llama, para devolvernos en dado caso
	sw $ra, 0($sp)

         
solicitarArchivo: 						# solicitamos al usuario que ingrese la ruta del archivo

	add $t1, $zero, $zero 				# guardaremos la direcci�n del buffer de entrada de la url del archivo
	add $t2, $zero, $zero 				# guardaremos la direcci�n donde almacenaremos el archivo sin \n (enter)
	add $t3, $zero, $zero 				# guardaremos la direcci�n de la url del archivo sucio
	add $t4, $zero, $zero 				# guardaremos la direcci�n de la url del archivo limpio
	add $t5, $zero, $zero 				# guardaremos la bandera \n (enter)
	add $t6, $zero, $zero 				# guardaremos el caracter leido de la url del archivo sucio
	
	li $v0, 4							# print string, $a0 = direcci�n de cadena terminada en nulo para imprimir
	la $a0,	pedirArchivo				# Mensaje de pedir archivo
	syscall

	li $v0, 8 							# leer string (para leer la url de la ruta del archivo)
    la $a0, archivo						# $a0 = direcci�n del b�fer de entrada (la direcci�n de "buffer" apuntar� a la url)
    li $a1, 1024						# Espacio maximo de cantidad de caracteres de la ruta del archivo
    syscall
        
    la $t1, archivo 					# cargamos indefinidamente en t1 la direcci�n de la url del archivo sucio
    la $t2, archivoLimpio 				# cargamos indefinidamente en t2 la direcci�n donde se alojar� la url limpia
  	add $t3, $t1, $zero 				# hacemos una copia
  	add $t4, $t2, $zero 				# hacemos una copia
	addi $t5, $t5, 10  					# para saber cuando hemos llegado al final de la cadena ingresada por el user
        
                     
limpiarArchivo:	 						# remover de la la url o ruta o nombre del archivo el enter \n  	
	lbu $t6, 0($t3)						# $t6, almacena el caracter leido de t3, es decir caracter de la url que limpiaremos
	beq $t6, $t5, validarArchivo 		# si (caracter == \n, entonces finalizamos la lectura y validaremos si es un archivo correcto
	sb $t6, 0($t4) 						# cpu->memoria, enviamos el caracter le�do y diferente de \n a la direcci�n del archivoLimpio
	addi $t3, $t3, 1 					# avanzamos al siguiente caracter de la url que estamos limpiando
	addi $t4, $t4, 1 					# avanzamos a una posici�n disponible para guardar el siguiente caracter en archivoLimpio
	j limpiarArchivo					# iteramos	
		
	
validarArchivo:							# validamos si la ruta del archivo es correcta			

	add $t3, $zero, $zero				# reiniciamos, antes aqui estaba la copia del archivo sucio
	add $t4, $zero, $zero				# reiniciamos, antes aqui estaba la copia del archivo limpio
	add $s4, $t2, $zero					# guardamos la direccion del archivo de la sopa de letras INMUTABLE
	add $t2, $zero, $zero				# reseteando variable

        
	li $v0, 13							# abrir archivo, v0 contiene el descriptor del archivo
	la $a0, archivoLimpio				# a0 = direcci�n del b�fer de entrada (url limpia del archivo que ingres� el usuario)
	li $a1, 0							# Modo lectura
	li $a2, 0
	syscall
	
	add $s0, $v0, $zero					# guardamos en s0 el descriptor
	slt $t1, $v0, $zero					# si (v0 < 0)? t1=1: t1=0;
	bne $t1, $zero, solicitarArchivo 	# Si no encuentra el archivo, vuelve a preguntar por archivo, si( t1 != 0) solicitarArchivo
	
										# El archivo existe! Copiar datos a memoria
										# Lectura del archvo
	li $v0, 14   						# lee datos desde el archivo
	add $a0, $s0, $zero					# descriptor del archivo a0 = s0
	la $a1, spaces						# direcci�n del buffer de entrada (hace referencia a la direcci�n de memoria donde inicia el contenido 
	li $a2, 20000						# cantidad masixma de caracteres que ser�n volcados del archivo a memoria
	syscall
	
	add $s5, $v0, $zero					# guardamos la cantidad de caracteres INMUTABLE
	add $a0, $s0, $zero					# pasamos el descriptor 
	li $v0, 16							# cerrar archivo
	syscall			
	
	add $s2, $a1, $zero					# Base del buffer del contenido del archivo INMUTABLE
	add $t0, $s2, $zero					# hacemos una copia del contenido para recorrer el buffer
	
	addi $t5, $zero, 13  					# para saber cuando hemos llegado al final de la fila
	
	# addi $sp, $sp, -8					# pedimos 8 bytes para realizar una copia de seguridad
	# sw $s4, 0($sp)					# guardamos en la pila la dirección de la url del archivo limpio
	# sw $s5, 4($sp)					# guardamos en la pila la dirección de la cantidad de caracteres

	



solicitarPalabras:	
													
	add $t1, $zero, $zero				# Iniciando temporales en 0 para volver a leer palabras en caso de incumplir
	
	li $v0, 4							# print string, $a0 = direcci�n de cadena terminada en nulo para imprimir
	la $a0,	pedirPlabras				# Mensaje para pedir las palabras
	syscall								# para que se ejecute el llamado al sistema

	li $v0, 8 							# read string,  
    la $a0, bufferPalabra				# $a0 = direcci�n del b�fer de entrada (la direcci�n de "buffer" apuntar� a las palabras)
    li $a1, 100							# $a1 = n�mero m�ximo de caracteres para leer
    syscall
       
    la $t1, bufferPalabra				# guardamos la direcci�n la direcci�n de memoria en el cpu, en el registro $t1	
    add $s3, $t1, $zero					# hacemos copia de la direcci�n en memoria de la palabra que bsucaremos INMUTABLE
	
	lbu $t4, 0($t1)  					# cargamos la letra de la palabra a buscar
	addi $s0, $zero, 1					# filas
	addi $s1, $zero, 1					# columna

bucleFila:
	   
	lbu $t3, 0($t0)						# $t3, almacena el caracter leido de t0, es decir caracter de la fila de la sopa de letras
	#beq $t3, 13, cambiarFila 			# si (caracter == \r, entonces debemos pasar a la fila de abajo	
	beq $t3, 10, cambiarFila 			# si (caracter == \n, entonces debemos pasar a la fila de abajo	
	beq $t3, $zero, exit 				# si (caracter == \0, entonces debemos finalizar
	beq $t3, $t4, calcularIndiceMovimiento
	addi $t0, $t0, 1
	addi $s1, $s1, 1				# aumentar columna
	j bucleFila 						# iteramos	    
        
cambiarFila:
 	addi $t0, $t0, 1				#aumentamos a la "otra fila", se asume que esta despues del enter
 	addi $s0, $s0, 1					#  aumenta fila
 	addi $s1, $zero, 1					#  reinciia columna
 	j bucleFila
        
calcularIndiceMovimiento: 				# se asume que es un valor constante
 	addi $t6, $zero, 9 					# desplazamiento vertical
 	addi $t7, $zero, 2 					# desplazameinto horizontal
 	
 	add $t2, $zero, $t0					# guardar dirección de descubrimiento
 
movernos:
 	
 	jal movernosDerecha
 	bne $s6, $zero,  finalizar
 	jal movernosIzquierda
 	bne $s6, $zero,  finalizar
 	j bucleFila
 	#jal movernosArriba
 	#jal movernosAbajo

finalizar: 								# esta rutina puede hacer cualquier cosa, ejemplo, puede solicitar nuevmante palabras.
 	j solicitarPalabras	
 	
movernosDerecha:
	addi $sp, $sp, -4 					# Reserva 2 palabras en pila (8 bytes)			
	sw $ra, 0($sp) 						# guarda ra 
	
	add $t0, $t0, $t7					# aumentamos indice para avanzar en las letras de la sopaletra
 	lbu $t8, 0($t0)						# caracter siguiente de la sopaletra
 	addi $t1, $t1, 1						# aumentamos indece para avanzar en el caracter de la palabra a buscar
 	lbu $t9, 0($t1)						# caracter siguiente de la palabra a buscar
 	
 	
 	jal comprobarFinal
 	lw $ra, 0($sp) 						# restaurar ra
	addi $sp, $sp, 4
 
 	
 	bne $s6, $zero, detallePalabra  	# hemos encontrado toda la palabra por la derecha
 	beq $t8, $t9, movernosDerecha
 	
	add $a0, $t2, $zero					# argumento de la funcion para saber desde donde reiniciar
	j reiniciarIndices 
 			
reiniciarIndices:
 	add $t0, $a0, $zero					# reseteamos indice a la posicion de descubrimiento
 	add $t1, $s3, $zero					# reseteamos indice a la posición del primer caracter de la palabra buscada

 	jr $ra

movernosIzquierda: 
 	addi $sp, $sp, -4 					# Reserva 2 palabras en pila (8 bytes)			
	sw $ra, 0($sp) 						# guarda ra 
	
	sub $t0, $t0, $t7					# aumentamos indice para avanzar en las letras de la sopaletra
 	lbu $t8, 0($t0)						# caracter siguiente de la sopaletra
 	addi  $t1, $t1, 1					# aumentamos indece para avanzar en el caracter de la palabra a buscar
 	lbu $t9, 0($t1)						# caracter siguiente de la palabra a buscar
 	
 	jal comprobarFinal					# si ya hemos recorrido toda la palabra
 	lw $ra, 0($sp) 						# restaurar ra
	addi $sp, $sp, 4
 
 	bne $s6, $zero, detallePalabra  	# hemos encontrado toda la palabra por la derecha
 	beq $t8, $t9, movernosIzquierda

	add $a0, $t2, $zero					# argumento de la funcion para saber desde donde reiniciar
 	j reiniciarIndices
 
movernosArriba:
 	addi $sp, $sp, -4 					# Reserva 2 palabras en pila (8 bytes)			
	sw $ra, 0($sp) 						# guarda ra 

	addi $t0, $t0, 1					# aumentamos indice para avanzar en las letras de la sopaletra
 	lbu $t8, 0($t0)						# caracter siguiente de la sopaletra
 	add  $t1, $t1, $t6					# aumentamos indece para avanzar en el caracter de la palabra a buscar
 	lbu $t9, 0($t1)						# caracter siguiente de la palabra a buscar
 	
 	jal comprobarFinal
 	lw $ra, 0($sp) 						# restaurar ra
	addi $sp, $sp, 4
 	
 	bne $s6, $zero, detallePalabra  	# hemos encontrado toda la palabra por la derecha 	
 	beq $t8, $t9, movernosArriba

	add $a0, $t2, $zero					# argumento de la funcion para saber desde donde reiniciar
 	j reiniciarIndices
 
comprobarFinal:

	bne $t9, 10, noFinalPalabraBuscada	# si t9 != 10, entonces no hemos llegado al final de la palabra buscada					
	addi $s6, $zero, 1					# flag para saber si hemos hallado la palabra, 1=hallada, 0= no hallada					
	jr $ra								# retornar
	
detallePalabra:
 	li $v0, 4
 	la $a0, dondeEstan
 	syscall
 	
 	li $v0, 4
 	la $a0, fila
 	syscall
 	
 	li $v0, 1
 	la $a0, ($s0)
 	syscall
 	
 	li $v0, 4
 	la $a0, columna
 	syscall
 	
 	li $v0, 1
 	la $a0, ($s1)
 	syscall

 	add $a0, $s2, $zero					# argumento de la funcion para saber desde donde reiniciar
 	j reiniciarIndices

     
noFinalPalabraBuscada:
	addi $s6, $zero, 0					# hacemos esto 0 dado que no hemos llegado al final
	jr $ra
                      
exit: 	li $v0, 10						# Constante para terminar el programa
	syscall
        
        
        
        
        
        
        
        
        
        
        
