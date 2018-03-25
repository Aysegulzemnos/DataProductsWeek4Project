#install.packages('shinyBS')
#install.packages('rpart')

library(caret)
library(randomForest)
library(shinyBS)

#
# Setting up for Random Forest predictor.
#

# Initializing data. 'mtcars' dataset is used. 
data("mtcars")

# To show structure in UI
dataStructure <- capture.output(str(mtcars))



# Defining custom training controls with cross validation.
# we used Repeated k-fold Cross Validation,

# in order to regenerate the model when the user change parameters in the UI.
# The goal of this model is to predict 'mpg' (miles per gallon) using the rest
# of the variables.
# 
#I will use 10-fold cross validation with 3 repeats.

set.seed(2018)

train_control <- trainControl(method="repeatedcv", number=10, repeats=3)


# Building Random Forest model function. 
# in order to regenerate the model when the user change parameters in the UI.
# The goal of this model is to predict 'mpg' (miles per gallon) using the rest
# of the variables.

ModelBuilder<- function() {
  
  return(
    train(
      mpg ~ ., 
      data = mtcars,
      method = "rf",
      trControl = train_control
    )
  )
  
}

# Predictor function.  It will be invoked 'reactively'.
randomForestPredictor <- function(model, parameters) {
  
  prediction <- predict(
    model,
    newdata = parameters
  )
  
  return(prediction)
  
}

