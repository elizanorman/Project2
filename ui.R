library(shiny)
library(DT)
library(jsonlite)
library(tidyverse)
library(httr)
library(dplyr)
library(caret)


# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Fruit Nutrition Data"),
  tabsetPanel(
    tabPanel("About",""),
  # Sidebar with a slider input for number of bins
  tabPanel("Data Download",
  sidebarLayout(
    sidebarPanel(
      h3("This data set comes from the ", a(href = "https://ergast.com/mrd/", "Ergast Developer API")),
      br(),
      h4("What color fruit would you like to know about?"),
      selectInput("col", label = "Colors",
                  choices = c( "all fruits", "red", "blue", "green", "yellow", "pink", "orange", "purple"),
                  selected = "all fruits"),
      br(),
    radioButtons("radio", "Nutrition or Biology:",
                 choices = c("Nutrition Breakdown", "Biological Classification")),
    
    conditionalPanel(
      condition = "input.radio == 'Nutrition Breakdown'",
      checkboxGroupInput("varsNut", "Select variables:",
                         choices = c("nutritions_calories", "nutritions_fat", "nutritions_sugar", "nutritions_carbohydrates", "nutritions_protein"), selected = c("nutritions_calories", "nutritions_fat", "nutritions_sugar", "nutritions_carbohydrates", "nutritions_protein"))
    ),
    conditionalPanel(
      condition = "input.radio == 'Biological Classification'",
      checkboxGroupInput("varsBio", "Select variables:",
                         choices = c("family", "order", "genus"), selected = c("family", "order", "genus"))
    ),
     downloadButton("download", "Download Dataset")),
    
    # Show a plot of the generated distribution
    mainPanel(
      dataTableOutput("summary")
    ))),
  tabPanel("Exploration",
           sidebarLayout(
             sidebarPanel(
               h4("Are you interested in Numeric or Categorical Summaries?"),
               radioButtons("numType", "",
                            choices = c("Numeric", "Categorical")),
               
               conditionalPanel(
                 condition = "input.numType == 'Categorical'",
                 radioButtons("varsCat", "Contingency tables for which variables:",
                                    choices = c("family vs order", "order vs genus", "genus vs family"), selected = c("family vs order"))),
               conditionalPanel(
                 condition = "input.numType == 'Categorical'",
                 radioButtons("varsBar", "Bar Plots for which variables:",
                              choices = c("color", "family", "order", "genus"), selected = c("color"))),
               conditionalPanel(
                 condition = "input.numType == 'Numeric'",
                 radioButtons("numPlots", "Which variable would you like to see numeric summaries for?",
                                    choices = c("nutritions_calories", "nutritions_fat", "nutritions_sugar", "nutritions_carbohydrates", "nutritions_protein"), selected = c("nutritions_calories"))
               ),
               conditionalPanel(
                 condition = "input.numType == 'Numeric'",
                 checkboxGroupInput("scatter", "Which variables",
                              choices = c("nutritions_calories", "nutritions_fat", "nutritions_sugar", "nutritions_carbohydrates", "nutritions_protein"), selected = c("nutritions_calories"))
                
               )),
            
           mainPanel(
             tableOutput("table"),
             plotOutput("barPlot"),
             textOutput("text")
           ))
))))
