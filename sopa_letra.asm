.data 
.align 2
buffer: .space 20000 # dirección de las palabras que escribirá el usuario
.align 2
archivo: .space 1024	# dirección de la url del archivo ingresada por el user
.align 2
archivoLimpio: .space 1024 #Dirección del archivo ingresado por el user pero sin el \n
.align 2
archivoSalida:	.asciiz  "archivoSalida.txt"     	# Archivo de salida


.align 2
bufferSalida: .space 69 # 


#mensajes 
pedirPlabras: .asciiz "\n Ingrese separadas por coma y sin espacio (palabra1,palabra2,palabran,)\n las palabras:\n "
pedirArchivo: .asciiz "\n Ingrese ruta del archivo: \n"
mensajeAparicion1: .asciiz " aparece en el archivo "
mensajeAparicion2: .asciiz " veces.\n"

mensaje1: .asciiz "\n retorno aquí"


cons1:  .word 32	# Caracter de espacio
cons2:  .word 13	# Caracter: Carriage Return

spaces: .asciiz ""     #aquí se almacenan los caracteres leidos del archivo.
.text

# Subrutina: main (Inicio del Programa)
main:
	jal	mainMenu # rutina principal, jump and link
	j 	exit    
# Subrutina: menu principal
mainMenu:
	addi $sp, $sp, -4	#Copia de seguridad de la dirección de la función que llama, para devolvernos en dado caso
	sw $ra, 0($sp)
         
#solicitamos al usuario que ingrese la ruta del archivo
solicitarArchivo: 
	add $t1, $zero, $zero #guardaremos la dirección del buffer de entrada de la url del archivo
	add $t2, $zero, $zero #guardaremos la dirección donde almacenaremos el archivo sin \n (enter)
	add $t3, $zero, $zero #guardaremos la dirección de la url del archivo sucio
	add $t4, $zero, $zero #guardaremos la dirección de la url del archivo limpio
	add $t5, $zero, $zero #guardaremos la bandera \n (enter)
	add $t6, $zero, $zero #guardaremos el caracter leido de la url del archivo sucio
	
	li $v0, 4		# print string, $a0 = dirección de cadena terminada en nulo para imprimir
	la $a0,	pedirArchivo	#Mensaje de pedir archivo
	syscall

	li $v0, 8 		#leer string (para leer la url de la ruta del archivo)
        la $a0, archivo		#$a0 = dirección del búfer de entrada (la dirección de "buffer" apuntará a la url)
        li $a1, 1024		#Espacio maximo de cantidad de caracteres de la ruta del archivo
        syscall
        
        la $t1, archivo #cargamos indefinidamente en t1 la dirección de la url del archivo sucio
        la $t2, archivoLimpio #cargamos indefinidamente en t2 la dirección donde se alojará la url limpia
  	add $t3, $t1, $zero #hacemos una copia
  	add $t4, $t2, $zero #hacemos una copia
        addi $t5, $t5, 10  # para saber cuando hemos llegado al final de la cadena ingresada por el user
        
        #remover de la la url o ruta o nombre del archivo el enter \n                
limpiarArchivo:	
	lbu $t6, 0($t3)	# $t6, almacena el caracter leido de t3, es decir caracter de la url que limpiaremos
	beq $t6, $t5, validarArchivo # si (caracter == \n, entonces finalizamos la lectura y validaremos si es un archivo correcto
	sb $t6, 0($t4) #cpu->memoria, enviamos el caracter leído y diferente de \n a la dirección del archivoLimpio
	addi $t3, $t3, 1 #avanzamos al siguiente caracter de la url que estamos limpiando
	addi $t4, $t4, 1 #avanzamos a una posición disponible para guardar el siguiente caracter en archivoLimpio
	j limpiarArchivo #iteramos	
	
limpiarContenido:
	lbu $t2, 0($t1)	# $t2, almacena el caracter leido de t1, es decir caracter de la fila 
	beq $t2, $t5, reemplazarCaracter # si (caracter == \r, entonces debemos reemplazar el 13 por el 126
	beq $t2, $t6, reemplazarCaracter # si (caracter == \r, entonces debemos reemplazar el 13 por el 126
	beq $t2, $zero, exit # si (caracter == \r, entonces debemos reemplazar el 13 por el 126
	addi $t1, $t1, 1
	j limpiarContenido #iteramos	

reemplazarCaracter:
	sb $t7, 0($t1)
	addi $t1, $t1, 1
	j limpiarContenido
	
	
	
#validamos si la ruta del archivo es correcta			
validarArchivo:
        
	li $v0, 13		#abrir archivo, v0 contiene el descriptor del archivo
	la $a0, archivoLimpio	#a0 = dirección del búfer de entrada (url limpia del archivo que ingresó el usuario)
	li $a1, 0			#Modo lectura
	li $a2, 0
	syscall
	
	add $s0, $v0, $zero		#guardamos en s0 el descriptor
	slt $t1, $v0, $zero		#si (v0 < 0)? t1=1: t1=0;
	bne $t1, $zero, solicitarArchivo #Si no encuentra el archivo, vuelve a preguntar por archivo, si( t1 != 0) solicitarArchivo
	
	#El archivo existe! Copiar datos a memoria
	#Lectura del archvo
	li $v0, 14   		# lee datos desde el archivo
	add $a0, $s0, $zero	# descriptor del archivo a0 = s0
	la $a1, spaces		# dirección del buffer de entrada (hace referencia a la dirección de memoria donde inicia el contenido 
	li $a2, 20000		# cantidad masixma de caracteres que serán volcados del archivo a memoria
	syscall
	
	add $s2, $v0, $zero	# guardamos la cantidad de caracteres
	add $a0, $s0, $zero	# pasamos el descriptor 
	li $v0, 16		# cerrar archivo
	syscall			
	
	add $s0, $s2, $zero	#Numero de caracteres
	add $s1, $a1, $zero	#Base del buffer del contenido del archivo
	add $t1, $s1, $zero	#hacemos una copia para recorrer el buffer
	
	addi $t5, $zero, 13  # para saber cuando hemos llegado al final de la fila
	addi $t6, $zero, 10
	addi $t7, $zero, 126  # para saber cuando hemos llegado al final de la fila

	j limpiarContenido
	# cambiar \n\r por ~ 126

	
	
#contarCaracteres:
#	lbu $t2, 0($t1)		#$t2 = $s0[$t1]
#	beq $t2, $zero, inicializacion	#Si $t2 = '\0' terminar de contar
#	addi $t1, $t1, 1	#$t1 = $t1 + 1
#	addi $s0, $s0, 1	#$s0 = $s0 + 1, contador de caracteres
#	j contarCaracteres

        
        
        exit: 	li $v0, 10		# Constante para terminar el programa
	syscall
        
        
        
        
        
        
        
        
        
        
        
