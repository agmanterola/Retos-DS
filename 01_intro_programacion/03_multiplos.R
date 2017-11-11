## Reto 2 Ejercicio 3

#Si listamos todos los números naturales menores que 10 que son múltiplos de 3 o de 5, 
#nos sale 3, 5, 6 y 9. La suma de ellos da 23.

#Encuentra la suma de todos los múltiplos de 3 o de 5 menores que 1000.

#Para publicar el resultado, primero crea una carpeta llamada 01_intro_programacion. 
#Dentro de ella, mete tu solución en un fichero ejecutable, es decir 03_multiplos.R o 
#03_multiplos.py, dependiendo del lenguaje que escojas.


#Hago una función que dado un límite, calcule los múltiplos de 3 o 5 hasta ese límite:
calcula_multiplos<- function(limite){
  #Incializo la variable que se devolverá en caso de que quiera utilizarse fuera de la función.
  resultado <- 0
  
  for (i in 1:limite) {
    # Se comprueba que el número tratado es menor que el que nos pasan por parámetro y además,
    # el número tratado en la iteración es divisible entre 3 o 5.
    if (i<limite && ((i %% 3 ==0)||(i %% 5 ==0))){
      #Print que se puede usar como debuggeo
      #print(paste(i, "es divisible entre 3 o 5"))
      resultado = resultado +i
    }#if
  }#for

  print(paste("La suma de todos los números divisibles entre 3 o 5 hasta ",limite, "es: ",resultado))
  return(resultado)
}

#Con la función preparada, llamamos a la misma con el valor 1000

#Comprobación de que se obtiene lo mismo que en el enunciado
#resultado<- calcula_multiplos(10)

#Ejecución del ejercicio
resultado<- calcula_multiplos(1000)
