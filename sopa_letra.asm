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
        
        
        
        
        exit: 	li $v0, 10		# Constante para terminar el programa
	syscall
        
        
        
        
        
        
        
        
        
        
        