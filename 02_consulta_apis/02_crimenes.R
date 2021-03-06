## Reto 2 Ejercicio 2

# Con la documentaci�n de las dos APIs que vas a utilizar:
  
#  Nominatim
#  La polic�a de UK

# Haz lo siguiente:
  
# Pregunta a la API de Nominatim de a d�nde (calle, ciudad, ...) 
#  pertenecen estas coordenadas: 51.4965946,-0.1436476
# Pregunta a la API de la polic�a de UK por cr�menes cometidos cerca de esa localizaci�n 
#  en Abril de 2017.

# A partir de la respuesta, haz un conteo de los cr�menes que ha habido por cada categor�a

# Como ya se ha instalado la librer�a httr en el ejercicio anterior, 
# no incluyo la sentencia en �ste.
library(httr)

# Seg�n leo en nominatin, la forma de obtener info a partir de unas coordenadas es:
# http://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=-34.44076&lon=-58.70521
# Esto me devuelve un JSONv2, que es en ppio, f�cil de tratar (XML llevar�a m�s paquetes)

# Creo la URL
direccion <- "http://nominatim.openstreetmap.org/reverse?format=jsonv2"
latitud <- "&lat=51.4965946"
longitud <- "&lon=-0.1436476"

# Defino la URL uniendo los par�metros y quitando espacios entre ellos
url_lugar <- paste(direccion,latitud,longitud,sep="")
url_lugar

# Consulto por el lugar de las coordenadas
peticion_lugar <- GET(url_lugar)
info_lugar <- content(peticion_lugar)

# Imprimo cosas sobre el lugar obtenido
lugar <- info_lugar$address
#print(paste("La direcci�n del lugar es Calle ",lugar$road," n� ",lugar$house_number,
#" de la ciudad de ",lugar$city," C.P.:",lugar$postcode,", ",lugar$state, sep=""))


# Compruebo informaci�n de cr�menes por la zona:
#direccion <- "https://data.police.uk/api/crimes-street/all-crime?"
direccion <- "https://data.police.uk/api/crimes-at-location?"
fecha_crimen <-"date=2017-04"

# Consulto el lugar por coordenada y fecha
peticion_crimen<- GET(direccion, query = list(dat = "2017-04", lat = 51.4965946, lng = -0.1436476))
contenido <- content(peticion_crimen)

# Selecciono las categor�as de cr�menes de la zona
categorias <- lapply(contenido, `[[`,1)

# Aislo cada tipo de crimen
tipo_crimen <- unique(categorias)

# Imprimo el n�mero de cr�emenes por tipo de crimen
for (tipo in tipo_crimen){
  numero <- sum(categorias==tipo)
  print(paste("El numero de crimenes de tipo: ",tipo," asciende a: ",numero))
}