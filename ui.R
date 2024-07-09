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
      checkboxGroupInput("vars", "Select variables:",
                         choices = c("nutritions_calories", "nutritions_fat", "nutritions_sugar", "nutritions_carbohydrates", "nutritions_protein"), selected = c("nutritions_calories", "nutritions_fat", "nutritions_sugar", "nutritions_carbohydrates", "nutritions_protein"))
    ),
    conditionalPanel(
      condition = "input.radio == 'Biological Classification'",
      checkboxGroupInput("vars", "Select variables:",
                         choices = c("family", "order", "genus"), selected = c("family", "order", "genus"))
    ),
     downloadButton("download", "Download Dataset")),
    
    # Show a plot of the generated distribution
    mainPanel(
      dataTableOutput("summary")
    ))),
  tabPanel("Exploration", "")
)))
