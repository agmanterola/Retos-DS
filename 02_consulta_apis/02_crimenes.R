## Reto 2 Ejercicio 2

# Con la documentación de las dos APIs que vas a utilizar:
  
#  Nominatim
#  La policía de UK

# Haz lo siguiente:
  
# Pregunta a la API de Nominatim de a dónde (calle, ciudad, ...) 
#  pertenecen estas coordenadas: 51.4965946,-0.1436476
# Pregunta a la API de la policía de UK por crímenes cometidos cerca de esa localización 
#  en Abril de 2017.

# A partir de la respuesta, haz un conteo de los crímenes que ha habido por cada categoría

# Como ya se ha instalado la librería httr en el ejercicio anterior, 
# no incluyo la sentencia en éste.
library(httr)

# Según leo en nominatin, la forma de obtener info a partir de unas coordenadas es:
# http://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=-34.44076&lon=-58.70521
# Esto me devuelve un JSONv2, que es en ppio, fácil de tratar (XML llevaría más paquetes)

# Creo la URL
direccion <- "http://nominatim.openstreetmap.org/reverse?format=jsonv2"
latitud <- "&lat=-34.44076"
longitud <- "&lon=-58.70521"
latitud <- "&lat=52.643950"
longitud <- "&lon=-1.143042"
# Defino la URL uniendo los parámetros y quitando espacios entre ellos
url_lugar <- paste(direccion,latitud,longitud,sep="")
url_lugar

# Consulto por el lugar de las coordenadas
peticion_lugar <- GET(url_lugar)
info_lugar <- content(peticion_lugar)

# Imprimo cosas sobre el lugar obtenido
lugar <- info_lugar$address
print(paste("La dirección del lugar es Calle ",lugar$road," nº ",lugar$house_number,
            " de la ciudad de ",lugar$city," C.P.:",lugar$postcode,", ",lugar$state, sep=""))

# Compruebo información de crímenes por la zona:
direccion <- "https://data.police.uk/api/crimes-street/all-crime?"
fecha_crimen <-"&date=2017-04"

# Con los datos que tengo, preparo la consulta para los crímenes
url_crimen <- paste(direccion,"lat=",info_lugar$lat,"&lng=",info_lugar$lon,fecha_crimen, sep="")

# Consulto el lugar por coordenada y fecha
peticion_crimen <- GET(url_crimen)
contenido <- content(peticion_crimen)

# Selecciono las categorías de crímenes de la zona
categorias <- lapply(contenido, `[[`,1)

# Aislo cada tipo de crimen
tipo_crimen <- unique(categorias)

# Imprimo el número de críemenes por tipo de crimen
for (tipo in tipo_crimen){
  numero <- sum(categorias==tipo)
  print(paste("El numero de crimenes de tipo: ",tipo," asciende a: ",numero))
}