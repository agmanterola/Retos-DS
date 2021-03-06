## Reto 2 Ejercicio 3

#Si listamos todos los n�meros naturales menores que 10 que son m�ltiplos de 3 o de 5, 
#nos sale 3, 5, 6 y 9. La suma de ellos da 23.

#Encuentra la suma de todos los m�ltiplos de 3 o de 5 menores que 1000.

#Para publicar el resultado, primero crea una carpeta llamada 01_intro_programacion. 
#Dentro de ella, mete tu soluci�n en un fichero ejecutable, es decir 03_multiplos.R o 
#03_multiplos.py, dependiendo del lenguaje que escojas.


#Hago una funci�n que dado un l�mite, calcule los m�ltiplos de 3 o 5 hasta ese l�mite:
calcula_multiplos<- function(limite){
  #Incializo la variable que se devolver� en caso de que quiera utilizarse fuera de la funci�n.
  resultado <- 0
  
  for (i in 1:limite) {
    # Se comprueba que el n�mero tratado es menor que el que nos pasan por par�metro y adem�s,
    # el n�mero tratado en la iteraci�n es divisible entre 3 o 5.
    if (i<limite && ((i %% 3 ==0)||(i %% 5 ==0))){
      #Print que se puede usar como debuggeo
      #print(paste(i, "es divisible entre 3 o 5"))
      resultado = resultado +i
    }#if
  }#for

  print(paste("La suma de todos los n�meros divisibles entre 3 o 5 hasta ",limite, "es: ",resultado))
  return(resultado)
}

#Con la funci�n preparada, llamamos a la misma con el valor 1000

#Comprobaci�n de que se obtiene lo mismo que en el enunciado
#resultado<- calcula_multiplos(10)

#Ejecuci�n del ejercicio
resultado<- calcula_multiplos(1000)
