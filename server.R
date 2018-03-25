library(shiny)
library(ggplot2)
library(caret)
library(randomForest)
library(knitr)
library(datasets)
library(dplyr)
library(rpart)
#knit2html('Readme.rmd','Readme.md')
# knit2html('Readme.rmd','Readme.md')

#
# Defines the Random Forest model and predictor for 'mpg' in the 'mtcars' dataset.
#
source(file = "modelBuilding_Source.R")

#
# Setting up Shiny Server
#
shinyServer(
  
  function(input, output, session) {
    
    output$table <- renderDataTable({
     
      mtcars2<- mtcars
        data <- transmute(mtcars2, Car = rownames(mtcars2), Cylinder= input$cyl,Transmission=input$am,
                         Displacement = input$disp, Horsepower = hp, Weight =input$wt)
      
        data
    })
    
    
    
    
    
    # To show new lines in the browser
    decoratedDataStructure <- paste0(dataStructure, collapse = "<br/>")
    output$dataStructure <- renderText({decoratedDataStructure})
    
    # Builds "reactively" the prediction.
    predictMpg <- reactive({
      
      carToPredict <- data.frame(
        cyl = input$cyl, 
        disp = input$disp, 
        hp = input$hp, 
        drat = input$drat, 
        wt = input$wt, 
        qsec = input$qsec, 
        vs = as.numeric(input$vs), 
        am = as.numeric(input$am), 
        gear = input$gear, 
        carb = input$carb)
      
      randomForestPredictor(ModelBuilder(), carToPredict)
      
    })
    
    output$prediction <- renderTable({
      predictMpg()
    })
    
    
    
  }
  
)
