# 05.R

# Ejercicio a realizar
# Preproceso: lo mismo que en el modelo anterior pero, además, vamos a arreglar la columna 
# DebtRatio y crear columnas relacionadas. Fíjate que, aunque debería tener un valor entre 0 y 1, 
# a veces tiene valores muy altos. Haz lo siguiente:
#
# * Crea la columna ZeroDebtRatio que tenga valor true si DebtRatio es igual a 0, false si no. 
#   De esta manera, nos guardamos si el valor original era cero antes de corregirlo, y no perdemos 
#   la importancia que pudiera tener.
#
# * Pon el valor de DebtRatio a cero si UnknownMonthlyIncome es true, para corregir los valores 
#   altos al desconocer los ingresos.
#
# * Vamos a probar otra idea relacionada, que es calcular la deuda que tiene la persona, 
#   con una ligera variación. Cuando los valores pueden estar en escalas diferentes, 
#   y solo nos importan las diferencias grandes (si tienen más o menos ceros, 
#   por así decirlo), podemos usar el logaritmo del valor. 
#   Crea una variable LogDebt que sea el logaritmo de la deuda (log(MonthlyIncome * DebtRatio)). 
#   Cuidado con los infinitos al usarlo los logaritmos: sustituye los que te hayan salido por 0.
#
# Modelo: entrena un random forest de 500 árboles

#Funciones
source("0.R")

# prepara el entorno con el fichero y librerías
dataset <-prepara_dataset()


# Estructura general del ejercicio:

# Fija la semilla
set.seed(1234)

#Elimina las variables innecesarias (X)
# Lo hace en el prepara_dataset()

#Preprocesa los datos y separa en entrenamiento (70%) y validación (30%): 
#  variable en cada modelo, ya que vamos a probar diferentes ideas
## Además, se incluyen las columnas extra para ZeroDebtRatio y LogDebt
dataset<- imputa_nulos(dataset, UKColumns=TRUE, DebtRatio=TRUE)

## Separación del dataset en 2 sets de entrenamiento y testeo (sesgado, como en el ejercicio 2):
lista<- prepara_train_test(dataset, 0.7,TRUE)

entrenamiento <- lista$entrenamiento
test <- lista$test

##Convertimos a factor la variable dependiente para utilizarla en el entrenamiento
entrenamiento$SeriousDlqin2yrs=as.factor(entrenamiento$SeriousDlqin2yrs)

#Entrena el modelo con el conjunto de entrenamiento (500 árboles)
modelo <- randomForest(SeriousDlqin2yrs ~ ., entrenamiento, ntree=500)

#Pinta la importancia de variables.
varImpPlot(modelo)

#Mide el AUC en el conjunto de validación. 
#   Déjalo apuntado con un comentario al final del script y comenta brevemente 
#   si ves mejora o no en el resultado y por qué crees que pasa.
test$pred <- predict(modelo, test)
# Medición de precisión:
#mean(test$pred == test$SeriousDlqin2yrs) --> 0.7910222
test$prediccion<-as.numeric(test$pred)
ROC <- roc(test$SeriousDlqin2yrs, test$prediccion)
plot(ROC, col = "blue")
auc(ROC)
# Area bajo la curva : 0.7801
# En este caso el área bajo disminuye un 0.0023 con respecto al anterior.
# Posible motivo: Mantener la deuda y la deuda sin escala en el mismo modelo puede hacer que le cueste
# interpretación? Ni idea.
