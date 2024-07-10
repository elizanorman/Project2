# load required packages
library(shiny)
library(DT)
library(jsonlite)
library(tidyverse)
library(httr)
library(dplyr)
library(caret)
library(ggplot2)
library(ggExtra)


# Define UI for application
shinyUI(fluidPage(
  # Application title
  titlePanel("Fruit Nutrition Data"),
  # create first 'About' tab
  tabsetPanel(
    tabPanel("About",
      sidebarLayout(
        sidebarPanel(
          h3("This data set comes from the ", a(href = "https://www.fruityvice.com/", "Fruityvice API")),
          br(),
          h4("From the API:"),
          h5("With Fruityvice you can receive interesting data from any fruit of your choosing. On top of that you can add fruits by yourself as well! Added fruits will first have to be approved by an admin to avoid any errors in the data. The shown data is based on 100 grams of the listed fruit. The owner does not guarantee the available data is 100% flawless, however he will do his best to fix any wrong data.")
                 
        ),
        mainPanel(
          img(src = "cherry.png" )
        )
      )
    ),
  # create second tab
    tabPanel("Data Download",
      sidebarLayout(
        sidebarPanel(
          h4("What color fruit would you like to know about?"),
          selectInput("col", label = "Colors",
                  choices = c( "all fruits", "red", "blue", "green", "yellow", "pink", "orange", "purple"),
                  selected = "all fruits"),
          br(),
          radioButtons("radio", "Nutrition or Biology:",choices = c("Nutrition Facts", "Biological Classification")
            ),
    
          conditionalPanel(
            condition = "input.radio == 'Nutrition Facts'",
            checkboxGroupInput("varsNut", "Select variables:",choices = c("nutritions_calories", "nutritions_fat", "nutritions_sugar", "nutritions_carbohydrates", "nutritions_protein"), selected = c("nutritions_calories", "nutritions_fat", "nutritions_sugar", "nutritions_carbohydrates", "nutritions_protein"))
          ),
          conditionalPanel(
            condition = "input.radio == 'Biological Classification'",
            checkboxGroupInput("varsBio", "Select variables:",choices = c("family", "order", "genus"), selected = c("family", "order", "genus"))
          ),
          downloadButton("download", "Download Dataset")
        ),
        # Show the generated dataset
        mainPanel(
          dataTableOutput("summary")
        )
      )
    ),
    # create third tab
    tabPanel("Data Exploration",
      sidebarLayout(
        sidebarPanel(
          h4("Are you interested in Numeric or Categorical Summaries?"),
          radioButtons("numType", "",choices = c("Numeric", "Categorical")
          ),
               
          conditionalPanel(
            condition = "input.numType == 'Categorical'",
            radioButtons("varsCat", "Contingency tables for which variables:",choices = c("family vs order", "order vs genus", "genus vs family"), selected = c("family vs order"))
          ),
          conditionalPanel(
            condition = "input.numType == 'Categorical'",
            radioButtons("varsBar", "Select a variable for the bar plot:",choices = c("color", "family", "order", "genus"), selected = c("color"))
          ),
          conditionalPanel(
            condition = "input.numType == 'Numeric'",
            radioButtons("numPlots", "Select a variable for numeric summaries:",choices = c("nutritions_calories", "nutritions_fat", "nutritions_sugar", "nutritions_carbohydrates", "nutritions_protein"), selected = c("nutritions_calories"))
          ),
          conditionalPanel(
            condition = "input.numType == 'Numeric'",
            selectInput("scatterVar1", "Select the first numeric variable for plotting",choices = c("nutritions_calories", "nutritions_fat", "nutritions_sugar", "nutritions_carbohydrates", "nutritions_protein"), selected = "nutritions_calories")
          ),
          conditionalPanel(
            condition = "input.numType == 'Numeric'",
            selectInput("scatterVar2", "Select the second numeric variable for plotting",choices = c("nutritions_calories", "nutritions_fat", "nutritions_sugar", "nutritions_carbohydrates", "nutritions_protein"), selected = "nutritions_fat")
          )
        ),
        mainPanel(
          tableOutput("table"),
          plotOutput("barPlot"),
          plotOutput("line"),
          textOutput("text"),
          plotOutput("scatter"),
          plotOutput("box")
        )
      )
    )
  )
))
