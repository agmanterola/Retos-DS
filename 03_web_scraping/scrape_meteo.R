## Reto 3
# Scraping de datos metereológicos

# Echa un vistazo a la siguiente página: 
# http://www.ogimet.com/cgi-bin/gsynres?ord=REV&decoded=yes&ndays=31&ano=2008&mes=1&day=31&hora=24&ind=08221

# Los parámetros a modificar a mano son los siguientes:
# decoded [YES/NO]: La información presentada es detallada o resumida (detalla la hora, o presenta datos de 48h previas a la fecha)
# ndays: Número de días a pasado desde la fecha dada.
# ano: Año de la medición
# mes: Mes de la medición
# day: Día de la medición
# hora: Hora de la medición
# ind: Número identificativo de la estación meteorológica

#install.packages("XML")
library(XML)

# Consulto el lugar por coordenada y fecha
direccion<-"http://www.ogimet.com/cgi-bin/gsynres?ord=REV"
decoded<-"YES"
ndays<-31
ano<-2008
mes<-1
day<-31
hora<-24
ind<-"08221"
direccion<-paste(direccion,"&decoded=",decoded,"&ndays=",ndays,"&ano=",ano,"&mes=",mes,"&day=",day,"&hora=",hora,"&ind=",ind,sep="")
print (paste("La dirección generada es: ",direccion,sep=""))

tabla<-readHTMLTable(direccion)

# Pruebas con tiempo:
fecha <- paste("2008","01","01",sep="")
fecha2 <- as.Date(fecha,format="%Y%m%d")
str2 <- "2012-3-12 14:23:08

