# 0.R

# Script de R que contendrá funciones comunes al resto de scripts.
library(dplyr)

## Funciones
# Función para la preparación inicial del entorno
prepara_dataset <- function(){
  library(dplyr)
  library(randomForest)
  library(caret)
  library(pROC)
  
  setwd("C:/Trabajo/DataScience/DataScience_Bluetab/Retos/12_credito")
  fichero <- "./dat/credit.csv"
  if(!file.exists(fichero)){
    download.file("https://raw.githubusercontent.com/koldLight/bluetab-data-science-2017/master/retos/dat/credit.csv", "./dat/credit.csv", method="libcurl")
  }
  
  dataset<- read.csv("./dat/credit.csv",header=TRUE,stringsAsFactors = FALSE)
  
  dataset <- dataset[,-1]
  
  dataset

}

# Función para el cálculo de la moda de una columna
obtener_moda <- function(v)
{
  v<-as.data.frame(v)
  moda <- v %>% mutate(conteo=1) %>% 
    group_by(v) %>% 
    summarize(cuenta = sum(conteo)) %>% 
    arrange(desc(cuenta)) %>% 
    select(v) %>% 
    head(1)
  
  as.numeric(moda)
}

# Función para la imputación de nulos en las columnas:
# MonthlyIncome y NumberOfDependents
imputa_nulos <- function(dataset, UKColumns=FALSE, DebtRatio=FALSE){
  ##Preprocesado: Control previo de nulos en columnas antes de imputarlas
  if(UKColumns){
    dataset <- dataset %>%
      mutate(UnknownNumberOfDependents=as.integer(is.na(NumberOfDependents)),
             UnknownMonthlyIncome=as.integer(is.na(MonthlyIncome)))
  }#if
  
  ## Sustitución de NA por 0 para MonthlyIncome
  nulos<- which(is.na(dataset$MonthlyIncome))
  dataset[nulos,names(dataset)=="MonthlyIncome"] = 0
  
  ## Obtención de la moda para la columna NumberOfDependents
  aux <- dataset[which( !is.na(dataset$NumberOfDependents)),names(dataset) == "NumberOfDependents"]
  moda_dependents <- obtener_moda(aux)
  ## Sustitución de NA por moda
  nulos<- which(is.na(dataset$NumberOfDependents))
  dataset[nulos,names(dataset)=="NumberOfDependents"] = moda_dependents
  
  # Ya que el nuevo cálculo de las columnas de DebtRatio dependen de Unknown Columns, controlo
  # ambas para que DebRatio no se calcule si no se han generado las UKColumns.
  if(UKColumns & DebtRatio){
    # Creación de columna ZeroDebtRatio
    dataset <- dataset %>%
      mutate(ZeroDebtRatio = (DebtRatio == 0))
    # Imputar 0 en DebtRatio
    dataset[dataset$UnknownMonthlyIncome == 1, "DebtRatio"] = 0
    
    # Calcular la deuda por persona con el logaritmo
    dataset <- dataset %>%
      mutate(LogDebt=log(MonthlyIncome * DebtRatio))
    # Control de infinitos
    dataset[is.infinite(dataset$LogDebt),"LogDebt"]=0
  }# if
  
  #Limpieza:
  nulos <- NULL
  aux <- NULL
  
  #Devolución:
  dataset
  
}

## Función para la división de un dataset en sets de entrenamiento y test
## La cantidad de filas se especifica por el parámetro 'pct' (valores 0 < pct < 1)
## que destina el número de filas del dataset*pct al set de entrenamiento.
## Adicionalmente se puede especificar el parámetro balanceo (por defecto a Falso)
## que decide si el set de entrenamiento y el de test, tendrán el mismo número de casos
## para cada valor de la clase.

prepara_train_test <- function(dataset, pct, balanceo=FALSE){
  indices <- sample(nrow(dataset))
  limite <- round(nrow(dataset)*pct)
  entrenamiento <- dataset[indices[1:limite],]
  test <- dataset[indices[(limite+1):nrow(dataset)],]
  
  # Con entrenamiento y test preparados, comprobamos el balanceo
  if(balanceo){
    #Obtenemos el número de filas por clase
    t <- table(entrenamiento$SeriousDlqin2yrs)
    # Buscamos reducir las filas al número mínimo de filas de las 2 posibles clases.
    if(t[1]>t[2]){
      #Escogemos filas con la clase mayoritaria, se pone el tope de filas de la clase minoritaria.
      e1<-head(entrenamiento[entrenamiento$SeriousDlqin2yrs==names(t[1]),],t[2])
      #Escogemos por otro lado las filas de la clase minoritaria
      e2<-entrenamiento[names(t[2])==entrenamiento$SeriousDlqin2yrs,]
      #Se unen los dos sets en uno.
      entrenamiento <- rbind(e1,e2)
      #Limpieza
      e1<-NULL
      e2<-NULL
    }else if (t[1]<t[2]){
      #Escogemos filas con la clase mayoritaria, se pone el tope de filas de la clase minoritaria.
      e1<-head(entrenamiento[entrenamiento$SeriousDlqin2yrs==names(t[2]),],t[1])
      #Escogemos por otro lado las filas de la clase minoritaria
      e2<-entrenamiento[names(t[1])==entrenamiento$SeriousDlqin2yrs,]
      #Se unen los dos sets en uno.
      entrenamiento <- rbind(e1,e2)
      #Limpieza
      e1<-NULL
      e2<-NULL
    }
  }#if(balanceo)
  
  #Balanceo o no listamos entrenamiento y test para su devolución
  resultado <- list(entrenamiento,test)
  names(resultado) <- c("entrenamiento","test")
  resultado
}#prepara_train_test
