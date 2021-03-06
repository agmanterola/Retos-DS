## Reto 3
# Scraping de datos metereol�gicos

# Echa un vistazo a la siguiente p�gina: 
# http://www.ogimet.com/cgi-bin/gsynres?ord=REV&decoded=yes&ndays=31&ano=2008&mes=1&day=31&hora=24&ind=08221

# Los par�metros a modificar a mano son los siguientes:
# ord [REV]: Par�metro que hace que se muestren datos resumidos o no. Me interesa quitarlo para mostrar el detalle de la fecha y la hora
# decoded [YES/NO]: La informaci�n presentada es detallada o resumida (detalla la hora, o presenta datos de 48h previas a la fecha)
# ndays: N�mero de d�as a pasado desde la fecha dada.
# ano: A�o de la medici�n
# mes: Mes de la medici�n
# day: D�a de la medici�n
# hora: Hora de la medici�n
# ind: N�mero identificativo de la estaci�n meteorol�gica

#install.packages("XML")
#install.packages("lubridate")
library(lubridate)
library(XML)

# Mi df
tabla<-data.frame()

# Funci�n que dado mes y a�o, obtiene un DF los datos horarios de las siguientes variables:
#   - Fecha y Hora
#   - Temperatura
#   - Direcci�n del viento
#   - Velocidad del viento
#
# Necesitar�:
#   - Deducir el �ltimo d�a del mes para fijarlo en los par�metros "day" y "ndays" de la llamada.
#   - Una opci�n ser�a incluirlos como par�metros por defecto, pero jugar� un poco con POSIXct.
#   - El resto de par�metros de la llamada, voy a dejarlos fijos dentro del �mbito de la funci�n.
get_datos_horarios<-function(ano,mes){
  # Variables fijas que necesito a la hora de realizar la llamada:
  direccion<-"http://www.ogimet.com/cgi-bin/gsynres?ord=REV"
  decoded<-"yes"
  ind<-"08221"
  hora<-24
  
  # Variables que calculo en la funci�n para hacer la llamda (ndays y day):
  fecha <- as.Date(paste(ano,"/",mes,"/01",sep=""),format="%Y/%m/%d")
  month(fecha) <- month(fecha)+1
  fecha <- as.Date(fecha,format="%Y/%m/%d")-1
  ndays<-format(fecha,"%d")
  day<-ndays
  
  #Debug:
  #print(paste("Para el mes y a�o: ",ano,mes,"\n La fecha resultante es: ",fecha,"\n Y por tanto el d�a y el n�mero de d�as corresponden con: ",day,ndays,sep=""))
  
  # Monto la llamada con los par�metros ya calculados:
  direccion<-paste(direccion,"&decoded=",decoded,"&ndays=",ndays,"&ano=",ano,"&mes=",mes,"&day=",day,"&hora=",hora,"&ind=",ind,sep="")
  #Debug; 
  print (paste("La direcci�n generada es: ",direccion,sep=""))
  #direccion<-"http://www.ogimet.com/cgi-bin/gsynres?ord=REV&decoded=yes&ndays=31&ano=2008&mes=1&day=31&hora=24&ind=08221"
  tabla<-readHTMLTable(direccion,stringsAsFactors=FALSE)

  # De la informaci�n obtenida en la llamada, nos quedamos con la lectura horaria
  # y seleccionamos s�lo las columnas de fecha, hora, temperatura, direccion y velocidad del viento.
  tabla <- tabla[[3]][c(1,2,3,7,8)]
  
  # Como la tabla trae un par de filas que no me interesan, las quito.
  tabla <- tabla[-1:-2,]
  
  # Aplico los nombres que quiero a las columnas 
  names(tabla) <- c("Fecha","Hora","T(C)","ddd","ffkmh")
  
  # Transformo los tipos de dato de las columnas seg�n mis intereses:
  tabla$fecha_hora <- as.POSIXct(paste(tabla$Fecha, tabla$Hora), format="%d/%m/%Y %H:%M")
  tabla$`T(C)`<- as.numeric(tabla$`T(C)`)
  tabla$ffkmh <- as.numeric(tabla$ffkmh)
  
  # Reutilizo una vez m�s la tabla, para convertirla en data.frame con los nombres
  # y variables que quiero:
  tabla <- data.frame("Fecha"=tabla$fecha_hora,"Temp(C)"=tabla$`T(C)`,"Dir"=tabla$ddd,"Vel"=tabla$ffkmh)
 
  # Retorno del DF
  tabla
}   

# Iteramos sobre los meses del a�o que nos interesa, llamando a la funci�n definida.

meses <- seq(as.Date("2008-01-01"), length=12, by="1 month")


for (i in meses){
  i<-as.Date(i, origin = "1970-01-01")
  print(paste("Recogiendo datos para: ",format(i,"%Y%m%d"),sep=""))
  tabla<-rbind(tabla,get_datos_horarios(format(i,"%Y"),format(i,"%m")))
}

# Comprobaci�n para ver si hay duplicados:
print(paste("N�mero de duplicados en Tabla: ",sum(duplicated(tabla))))

# Otra soluci�n para quitar duplicados ser�a quedarse s�lo con las filas que no son duplicadas:
# tabla <- tabla[!duplicated(tabla),]

