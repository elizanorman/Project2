library(shiny)
library(tidyverse)
library(DT)
library(jsonlite)
library(tidyverse)
library(httr)
library(dplyr)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  getF1 <- function(title = "results", year = "current"){
    URL <- paste("https://ergast.com/api/f1/", 
                   year,
                   "/",
                   title,
                   ".json?limit=1000",
                   sep = "")
    outData <- GET(URL)$content |>
      rawToChar() |>
      fromJSON() |>
      as_tibble()
    tableOfInterest <- tail(outData$MRData, n=1)
    listOfInterest <- tableOfInterest[[1]]
    return(finalTibble = as_tibble(listOfInterest))
  }
  
  data2 <- reactive({
    if(input$title != "Standings"){
      data <- getF1(title = input$title, year = input$year)
      if(input$title == "results"){
        data2 <-unnest_wider(data$Races$Results[[1]], col = c(Driver, Constructor, FastestLap, Time), names_sep = "_")
      }else if(input$title == "qualifying"){
        data2 <- unnest_wider(data$Races$QualifyingResults[[1]], col = c(Driver, Constructor), names_sep = "_")
      } else{
        data2 <- data$Drivers
      }
    } else{
      if(input$constDriver == "Constructor"){
        data <- getF1(title = "constructorStandings", year = input$year)
        data2 <- as.data.frame(data$StandingsLists$ConstructorStandings[[1]]$Constructor)
        data2 <- data2 |> select(all_of(input$vars))
      } else if(input$constDriver == "Driver"){
        data <- getF1(title = "driverStandings", year = input$year)
        data2 <- as.data.frame(list(points = data$StandingsLists$DriverStandings[[1]]$points, wins = data$StandingsLists$DriverStandings[[1]]$wins, data$StandingsLists$DriverStandings[[1]]$Driver))
      }
    }
    return(data2)
  })
  output$summary <- DT::renderDataTable({
    data2()
})
  output$download <- downloadHandler(
    filename = function() {
      "F1_Racing.csv"
    },
    content = function(file){
      write.csv(data2(), file, row.names = FALSE)
    }
  )
})
