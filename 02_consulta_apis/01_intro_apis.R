## Reto 2 Ejercicio 1

#Instala la librería correspondiente en tu entorno. En R, tendrás que usar install.packages y en Python, pip o conda.

#Consulta la documentación y haz la siguiente petición:
  
#  URL: http://www.cartociudad.es/services/api/geocoder/reverseGeocode
#Verbo: GET
#Parámetros: lat=36.9003409 y lon=-3.4244838

#De la respuesta, imprime:
  
#El cuerpo
#El código HTTP de estado
#Las cabeceras

# Instalación de la librería (1 vez)
#install.packages("httr")

#Carga de la librería para ser usada en la sesión
library(httr)

#Monto la URL con los parámetros indicados
direccion <- "http://www.cartociudad.es/services/api/geocoder/reverseGeocode"
longitud <- "lon=-3.4244838"
latitud <- "lat=36.9003409" 
#Importante indicar el separador = "" para que no meta espacios entre los parámetros
url<-paste(direccion,"?",longitud,"&",latitud, sep="")
#url

#Realizo la petición
peticion <- GET(url)

#Imprimir el cuerpo
cuerpo <- content(peticion)
cuerpo

#Imprimir el código HTTP de estado
estado <- http_status(peticion)
estado

#Imprimir las cabeceras
cabeceras <- headers(peticion)
cabeceras