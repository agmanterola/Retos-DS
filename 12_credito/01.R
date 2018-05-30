# 01.R

# Ejercicio a realizar
# Preproceso: imputa los nulos de NumberOfDependents con la moda de su columna y MonthlyIncome con un cero.
# Modelo: entrena un random forest de 100 árboles

source("0.R")

# summary(dataset)

# Estructura general del ejercicio:

# Fija la semilla
set.seed(1234)
# Lee los datos del CSV
dataset<-prepara_dataset()

#Elimina las variables innecesarias (X)
# Lo hace en el prepara_dataset()

#Preprocesa los datos y separa en entrenamiento (70%) y validación (30%): 
# El preprocesado se realiza en la función imputa_nulos
dataset<-imputa_nulos(dataset)
  
 ## Creacion de los dataset de entrenamiento y test (sin sesgar) 
#indices <- sample(nrow(dataset))
#limite <- round(nrow(dataset)*0.7)
#entrenamiento <- dataset[indices[1:limite],]
#test <- dataset[indices[(limite+1):nrow(dataset)],]
lista<- prepara_train_test(dataset, 0.7)
entrenamiento <- lista$entrenamiento
test <- lista$test


#Esto no funciona, revisar el capítulo de Machine Learning Toolbox de datacamp, ENTERO.
#modelo <- train(
#  SeriousDlqin2yrs ~ ., entrenamiento,
#  metric = "ROC",
#  method = "ranger",
#  ntrees=100
#)
# Se queja de que la variable dependiente no es de tipo factor:
entrenamiento$SeriousDlqin2yrs=as.factor(entrenamiento$SeriousDlqin2yrs)

#Entrena el modelo con el conjunto de entrenamiento (100 árboles)
modelo <- randomForest(SeriousDlqin2yrs ~ ., entrenamiento, ntree=100)

#Pinta la importancia de variables.
varImpPlot(modelo)

#Mide el AUC en el conjunto de validación. 
#   Déjalo apuntado con un comentario al final del script y comenta brevemente 
#   si ves mejora o no en el resultado y por qué crees que pasa.
test$pred <- predict(modelo, test)
# Medición de precisión:
#mean(test$pred == test$SeriousDlqin2yrs) --> 0.9361778
test$prediccion<-as.numeric(test$pred)
ROC <- roc(test$SeriousDlqin2yrs, test$prediccion)
plot(ROC, col = "blue")
auc(ROC)
# Area bajo la curva : 0.5844
# Si bien la precisión parece buena al principio, el área bajo la curva
# no trae un valor muy espectacular.
# Este ejercicio supodrán el punto de partida o baseline para compararlo con el resto de ejercicios.


