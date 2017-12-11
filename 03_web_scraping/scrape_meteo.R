## Reto 3
# Scraping de datos metereológicos

# Echa un vistazo a la siguiente página: 
# http://www.ogimet.com/cgi-bin/gsynres?ord=REV&decoded=yes&ndays=31&ano=2008&mes=1&day=31&hora=24&ind=08221

# Los parámetros a modificar a mano son los siguientes:
# ord [REV]: Parámetro que hace que se muestren datos resumidos o no. Me interesa quitarlo para mostrar el detalle de la fecha y la hora
# decoded [YES/NO]: La información presentada es detallada o resumida (detalla la hora, o presenta datos de 48h previas a la fecha)
# ndays: Número de días a pasado desde la fecha dada.
# ano: Año de la medición
# mes: Mes de la medición
# day: Día de la medición
# hora: Hora de la medición
# ind: Número identificativo de la estación meteorológica

#install.packages("XML")
#install.packages("lubridate")
library(lubridate)
library(XML)

# Mi df
tabla<-data.frame()

# Función que dado mes y año, obtiene un DF los datos horarios de las siguientes variables:
#   - Fecha y Hora
#   - Temperatura
#   - Dirección del viento
#   - Velocidad del viento
#
# Necesitaré:
#   - Deducir el último día del mes para fijarlo en los parámetros "day" y "ndays" de la llamada.
#   - Una opción sería incluirlos como parámetros por defecto, pero jugaré un poco con POSIXct.
#   - El resto de parámetros de la llamada, voy a dejarlos fijos dentro del ámbito de la función.
get_datos_horarios<-function(ano,mes){
  # Variables fijas que necesito a la hora de realizar la llamada:
  direccion<-"http://www.ogimet.com/cgi-bin/gsynres?ord=REV"
  decoded<-"yes"
  ind<-"08221"
  hora<-24
  
  # Variables que calculo en la función para hacer la llamda (ndays y day):
  fecha <- as.Date(paste(ano,"/",mes,"/01",sep=""),format="%Y/%m/%d")
  month(fecha) <- month(fecha)+1
  fecha <- as.Date(fecha,format="%Y/%m/%d")-1
  ndays<-format(fecha,"%d")
  day<-ndays
  
  #Debug:
  #print(paste("Para el mes y año: ",ano,mes,"\n La fecha resultante es: ",fecha,"\n Y por tanto el día y el número de días corresponden con: ",day,ndays,sep=""))
  
  # Monto la llamada con los parámetros ya calculados:
  direccion<-paste(direccion,"&decoded=",decoded,"&ndays=",ndays,"&ano=",ano,"&mes=",mes,"&day=",day,"&hora=",hora,"&ind=",ind,sep="")
  #Debug; 
  print (paste("La dirección generada es: ",direccion,sep=""))
  #direccion<-"http://www.ogimet.com/cgi-bin/gsynres?ord=REV&decoded=yes&ndays=31&ano=2008&mes=1&day=31&hora=24&ind=08221"
  tabla<-readHTMLTable(direccion,stringsAsFactors=FALSE)

  # De la información obtenida en la llamada, nos quedamos con la lectura horaria
  # y seleccionamos sólo las columnas de fecha, hora, temperatura, direccion y velocidad del viento.
  tabla <- tabla[[3]][c(1,2,3,7,8)]
  
  # Como la tabla trae un par de filas que no me interesan, las quito.
  tabla <- tabla[-1:-2,]
  
  # Aplico los nombres que quiero a las columnas 
  names(tabla) <- c("Fecha","Hora","T(C)","ddd","ffkmh")
  
  # Transformo los tipos de dato de las columnas según mis intereses:
  tabla$fecha_hora <- as.POSIXct(paste(tabla$Fecha, tabla$Hora), format="%d/%m/%Y %H:%M")
  tabla$`T(C)`<- as.numeric(tabla$`T(C)`)
  tabla$ffkmh <- as.numeric(tabla$ffkmh)
  
  # Reutilizo una vez más la tabla, para convertirla en data.frame con los nombres
  # y variables que quiero:
  tabla <- data.frame("Fecha"=tabla$fecha_hora,"Temp(C)"=tabla$`T(C)`,"Dir"=tabla$ddd,"Vel"=tabla$ffkmh)
 
  # Retorno del DF
  tabla
}   

# Iteramos sobre los meses del año que nos interesa, llamando a la función definida.

meses <- seq(as.Date("2008-01-01"), length=12, by="1 month")


for (i in meses){
  i<-as.Date(i, origin = "1970-01-01")
  print(paste("Recogiendo datos para: ",format(i,"%Y%m%d"),sep=""))
  tabla<-rbind(tabla,get_datos_horarios(format(i,"%Y"),format(i,"%m")))
}

# Comprobación para ver si hay duplicados:
print(paste("Número de duplicados en Tabla: ",sum(duplicated(tabla))))

# Otra solución para quitar duplicados sería quedarse sólo con las filas que no son duplicadas:
# tabla <- tabla[!duplicated(tabla),]

