library(shiny)
library(DT)


# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("F1 Racing Data"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      h3("This data set comes from the ", a(href = "https://ergast.com/mrd/", "Ergast Developer API")),
      br(),
      h4("You can select the year of the racing results you would like to see below:"),
      selectInput("year", label = "Year", 
                  choices = c("Current", "All Available", "2023", "2022", "2021", "2020", "2019", "2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", "2009", "2008", "2007", "2006", "2005", "2004", "2003", "2002", "2001", "2000"),
                  selected = "Current"),
      br(),
      h4("Which category interests you?"),
      radioButtons("title", "Category", choices = list("Race Results" = "results", "Qualifying Results" = "qualifying", "Sprint Qualifying Results" = "sprint", "Standings")),
      uiOutput("resultsStandings"),
      br(),
      h4("You can find the", strong("sample mean"), " for a few variables below:"),
      selectInput("var", label = "Variables to Summarize", 
                  choices = c("Duration", "Amount", "Age"),
                  selected = "Age"),
      numericInput("round", "Select the number of digits for rounding", value = 2, min = 0, max = 5)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("barPlot"),
      br(),
      dataTableOutput("summary")
    )
  )
))
