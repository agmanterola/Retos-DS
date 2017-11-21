## Reto 2 Ejercicio 4

# En Inglaterra, existen monedas de penique y de libra (que son 100 peniques). 
# Las monedas disponibles son: 1p, 2p, 5p, 10p, 20p, 50p, £1 (100p) y £2 (200p). 
# Podemos sumar £2 de la siguiente forma: 1×£1 + 1×50p + 2×20p + 1×5p + 1×2p + 3×1p.

# ¿De cuántas formas distintas podemos sumar £2, usando cualquier cantidad de monedas?

# Algortimo por fuerza bruta.
# Tras más de 2h de ejecución, he obtenido el resultado de 73682.


# cantidad2 <- 200
# monedas2 <- c(1, 2, 5, 10, 20, 50, 100, 200)
# cantidades2 <- rep(cantidad2, times=length(monedas2))
# pesos2 <- cantidades2 / monedas2
# 
# combinaciones2<-0
# 
# for (a in 0:pesos2[1]){
#   for (b in 0:pesos2[2]){
#     for (c in 0:pesos2[3]){
#       for (d in 0:pesos2[4]){
#          for (e in 0:pesos2[5]){
#            for (f in 0:pesos2[6]){
#              for (g in 0:pesos2[7]){
#                for (h in 0:pesos2[8]){
#                    valor_a<-a*monedas2[1]
#                    valor_b<-b*monedas2[2]
#                    valor_c<-c*monedas2[3]
#                    valor_d<-d*monedas2[4]
#                    valor_e<-e*monedas2[5]
#                    valor_f<-f*monedas2[6]
#                    valor_g<-g*monedas2[7]
#                    valor_h<-h*monedas2[8]
#                    
#                    if (sum(valor_a,valor_b,valor_c,valor_d,valor_e,valor_f,valor_g,valor_h)==cantidad2){
#                      #print(paste("Sum de a,b,c,d es",a,b,c,d))
#                      #print(paste(a,b,c,d))
#                      combinaciones2 <- combinaciones2 +1     
#                     }#if
#                   }#for de moneda de 2
#                 }#for de moneda de 1
#                } #for de moneda de 0.50
#              }#for de moneda de 0.20
#            }#for de moneda de 0.10
#          }#for de moneda de 0.05
#        }#for de moneda de 0.02
#      }#for de moneda de 0.01

# Solución eficiente cedida por la tutora
# Adaptado de http://www.mathblog.dk/project-euler-31-combinations-english-currency-denominations/

# Variables iniciales
objetivo <- 200
monedas  <- c(1, 2, 5, 10, 20, 50, 100, 200)

# Definimos el array de formas (alternativas para conseguir una cantidad)
maneras   <- rep(0, 201)
maneras[1] <- 1

# Se recorren los arrays de monedas y soluciones.
for (i in 1:length(monedas)) {
  for (j in (monedas[i] + 1):(objetivo + 1)) {
    maneras[j] = maneras[j] + maneras[j - monedas[i]]
  }
}

# La solución está en la última posición del array
maneras[length(maneras)]
