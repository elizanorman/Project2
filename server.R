library(shiny)
library(caret)
library(tidyverse)
library(DT)
data("GermanCredit")


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$summary <- DT::renderDataTable({
    var <- input$var
    round <- input$round
# if "Standings" selected on UI, give options "Driver" = driverStandings and "Constructor" = constructorStandings
    tab <- GermanCredit %>% 
      select("Class", "InstallmentRatePercentage", var) %>%
      group_by(Class, InstallmentRatePercentage) %>%
      summarize(mean = round(mean(get(var)), round))
    tab
  })
  
  output$barPlot <- renderPlot({
    
    g <- ggplot(GermanCredit, aes(x = Class))  
    
    if(input$plot == "bar"){
      g + geom_bar()
    } else if(input$plot == "sideUmemploy"){ 
      g + geom_bar(aes(fill = as.factor(EmploymentDuration.Unemployed)), position = "dodge") + 
        scale_fill_discrete(name = "Unemployment status", labels = c("Employed", "Unemployed"))
    } else if(input$plot == "sideForeign"){
      g + geom_bar(aes(fill = as.factor(ForeignWorker)), position = "dodge") + 
        scale_fill_discrete(name = "Status", labels = c("German", "Foreign"))
    }
  })
  
})
