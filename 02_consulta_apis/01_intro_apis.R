## Reto 2 Ejercicio 1

#Instala la librer�a correspondiente en tu entorno. En R, tendr�s que usar install.packages y en Python, pip o conda.

#Consulta la documentaci�n y haz la siguiente petici�n:
  
#  URL: http://www.cartociudad.es/services/api/geocoder/reverseGeocode
#Verbo: GET
#Par�metros: lat=36.9003409 y lon=-3.4244838

#De la respuesta, imprime:
  
#El cuerpo
#El c�digo HTTP de estado
#Las cabeceras

# Instalaci�n de la librer�a (1 vez)
#install.packages("httr")

#Carga de la librer�a para ser usada en la sesi�n
library(httr)

#Monto la URL con los par�metros indicados
direccion <- "http://www.cartociudad.es/services/api/geocoder/reverseGeocode"
longitud <- "lon=-3.4244838"
latitud <- "lat=36.9003409" 
#Importante indicar el separador = "" para que no meta espacios entre los par�metros
url<-paste(direccion,"?",longitud,"&",latitud, sep="")
#url

#Realizo la petici�n
peticion <- GET(url)

#Imprimir el cuerpo
cuerpo <- content(peticion)
cuerpo

#Imprimir el c�digo HTTP de estado
estado <- http_status(peticion)
estado

#Imprimir las cabeceras
cabeceras <- headers(peticion)
cabeceras