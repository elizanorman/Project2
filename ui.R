library(shiny)
library(DT)
library(jsonlite)
library(tidyverse)
library(httr)
library(dplyr)

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
                  choices = c("Current", "2023", "2022", "2021", "2020", "2019", "2018", "2017", "2016", "2015", "2014", "2013", "2012", "2011", "2010", "2009", "2008", "2007", "2006", "2005", "2004", "2003", "2002", "2001", "2000"),
                  selected = "Current"),
      br(),
      radioButtons("title", "Category", choices = list("Race Results" = "results", "Drivers" = "drivers", "Qualifying Results" = "qualifying", "Standings")),
      conditionalPanel(condition = "input.title == 'Standings'",
                       selectInput("constDriver", label = "Constructor or Driver Standings", choices = c("Constructor", "Driver"))),
    br(),
    # conditionalPanel(condition = "input.title == 'Standings' && input.constDriver == 'Driver'",
    #                  checkboxGroupInput("vars", label = "Variables", choices = list("Points" = "data$StandingsLists$DriverStandings[[1]]$points", "Wins" = "data$StandingsLists$DriverStandings[[1]]$wins"), selected = list("Points" = "points", "Wins" = "wins"))),

    conditionalPanel(condition = "input.title == 'Standings' && input.constDriver == 'Constructor'",
                     checkboxGroupInput("vars", label = "Variables", choices = list("Constructor ID" = "constructorId", "URL" = "url", "Name" = "name", "Nationality" = "nationality"), selected = list("Constructor ID" = "constructorId", "URL" = "url", "Name" = "name", "Nationality" = "nationality")))),
    
    # conditionalPanel(condition = "input.title == 'results'",
    #                  checkboxGroupInput("vars", label = "Variables", choices = list("Number" = "number", "Position" = "position", "Grid" = "grid", "Laps" = "laps", "Status" = "status"), selected = list("Number" = "number", "Position" = "position", "Grid" = "grid", "Laps" = "laps", "Status" = "status"))),
    # 
    # conditionalPanel(condition = "input.title == 'drivers'",
    #                  checkboxGroupInput("vars", label = "Variables", choices = list("Driver ID" = "driverId", "Permanent Number" = "permanentNumber", "Code" = "code", "URL"= "url", "First Name" = "givenName", "Last Name" = "familyName", "Birthday" = "dateOfBirth", "Nationality" = "nationality"), selected = list("Points" = "points", "Wins" = "wins", "Driver ID" = "driverId", "Permanent Number" = "permanentNumber", "Code" = "code", "URL"= "url", "First Name" = "givenName", "Last Name" = "familyName", "Birthday" = "dateOfBirth", "Nationality" = "nationality"))),
    # 
    # conditionalPanel(condition = "input.title == 'qualifying'",
    #                  checkboxGroupInput("vars", label = "Variables", choices = list("Number" = "number", "Position" = "position", "Q1" = "Q1", "Q2" = "Q2", "Q3" = "Q3"), selected = list("Number" = "number", "Position" = "position", "Q1" = "Q1", "Q2" = "Q2", "Q3" = "Q3")))),
  
    
    
    # Show a plot of the generated distribution
    mainPanel(
      dataTableOutput("summary")
    )
)))
