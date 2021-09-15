/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package generadorsopaletra;

import java.io.FileWriter;
import java.io.PrintWriter;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author juang
 */
public class GeneradorSopaLetra {
    
    private static final Random ALEATORIO = new Random();


    /**
     * @param args the command line arguments
     */
   public static void main(String[] args) {

        final int fila = 100;
        final int columna = 100;
        int caracteerEntero;
        char caracterAleatorio;
        StringBuilder filaCaracteres = new StringBuilder();

        for (int i = 0; i < fila; i++) {

            for (int j = 0; j < columna; j++) {
                do {
                    caracteerEntero = (ALEATORIO.nextInt(122 - 97 + 1) + 97); //genera enteros entre 65 y 91, es decir genera letras MAYUSCULAS de la A  a la Z
                    /*
                    para generar letras de la "a" a la "z" minusculas use:  (ALEATORIO.nextInt(122 - 97 + 1) + 97);
                    */

                } while (!(caracteerEntero >= 65 && caracteerEntero <= 90)&&!(caracteerEntero >= 97 && caracteerEntero <= 122));
                caracterAleatorio = (char) caracteerEntero;
                if ((j + 1) == columna) {
                    if ((i + 1) == fila) {
                        filaCaracteres.append(caracterAleatorio);
                    } else {
                        filaCaracteres.append(caracterAleatorio).append("\r\n");

                    }

                } else {
                    filaCaracteres.append(caracterAleatorio).append(" ");

                }

            }

        }
        System.out.println(filaCaracteres);

        try(FileWriter fichero= new FileWriter("C:\\Config\\MIPSasm\\archivos\\sopaJava.txt"); // CAMBIA ESTA RUTA
            PrintWriter pw = new PrintWriter(fichero) ) {
             
            pw.print(filaCaracteres);

        } catch (Exception e) {
            Logger.getGlobal().log(Level.SEVERE, "Hubo en error escribiendo en el archivo", e);
        } 

    }

    
}
