# 03.R

# Ejercicio a realizar
# Preproceso: lo mismo que en el modelo anterior
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
dataset<- imputa_nulos(dataset)

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
#mean(test$pred == test$SeriousDlqin2yrs) --> 0.7843556
test$prediccion<-as.numeric(test$pred)
ROC <- roc(test$SeriousDlqin2yrs, test$prediccion)
plot(ROC, col = "blue")
auc(ROC)
# Area bajo la curva : 0.7801
# En este caso el área bajo la curva no mejora, cae un 0.0008 con respecto al anterior (deleznable).
# Posible motivo: Los árboles de random Forest no se podan. Al aumentar el número de árboles,
# quizás se esté sobreajustando el modelo al set de entrenamiento y no produzca una mejora
# respecto al número de 100 árboles inicial.
