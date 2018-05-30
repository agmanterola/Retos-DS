# 04.R

# Ejercicio a realizar
# Preproceso: Preproceso: lo mismo que en el modelo anterior pero, además, 
# crea dos nuevas columnas con valor true/false indicando si esa fila tiene NumberOfDependents 
# y MonthlyIncome nulos respectivamente (llámalas UnknownNumberOfDependents y UnknownMonthlyIncome). 
# Si estas nuevas columnas cobran importancia en el modelo, querrá decir que probablemente 
# sea un indicativo de impago (p.e. en caso de que la gente elija dar o no el dato y, 
# si tienen premeditación en no pagar, prefieran omitirlo).
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
##Preprocesado:
dataset<- imputa_nulos(dataset, UKColumns=TRUE)

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
#mean(test$pred == test$SeriousDlqin2yrs) --> 0.7940444
test$prediccion<-as.numeric(test$pred)
ROC <- roc(test$SeriousDlqin2yrs, test$prediccion)
plot(ROC, col = "blue")
auc(ROC)
# Area bajo la curva : 0.7824
# En este caso el área bajo la curva mejora levemente, sube 0.0023 con respecto al anterior.
# Posible motivo: Las variables introducidas aportan cierto valor al modelo a la hora de predicir.
# Podrían asumirse comportamientos como en los que las personas no quieren hacer ver el número
# de personas a su cargo, o su ingreso mensual por miedo a no poder pagarlo y por tanto, por miedo
# a que en previsión de no poder pagarlo, no se les concediese el crédito.
# No obstante, no sé si la diferencia es tal como respaldar esta idea con la mejora del modelo.
