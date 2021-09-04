#include <stdio.h>
#include <stdlib.h>


char cadena[100];
char sopaLetra[29] = "h o l a\n\nr t y s\n\np u t i";

int main() {
    char sopa[9] = "sopaE.txt";
    char caracter;

    /*FILE *fp;
	fp = fopen ( sopa, "r" );
	if (fp==NULL) {
        fputs ("File error",stderr);
        exit (1);
    }*/
    printf("\nEl contenido del archivo de prueba es \n\n");
   /* while((caracter = ) != EOF)
    {
		printf("%c",caracter);
    }*/

    printf("%c", sopaLetra);

    printf("\n");

	solicitarPalabra();


  return 0;
}

void solicitarPalabra(){

	puts("Escriba una palabra:");
	gets(cadena);




}



