library(jsonlite)
library(tidyverse)
library(httr)
# f1_data <- "https://ergast.com/api/f1/circuits.json"
# APIresponse <- GET(f1_data)
# httr::status_code(APIresponse)
# 
# parsed <- fromJSON(rawToChar(APIresponse$content))
# finalTibble <- as_tibble(parsed)
# raceInfo <- finalTibble$MRData$RaceTable$Races

getF1 <- function(title, year = ""){
  if(year != "" & title == ""){
    URL <- paste("https://ergast.com/api/f1/", 
                 year, 
                 ".json",
                 sep = "")
    outData <- GET(URL)$content |>
      rawToChar() |>
      fromJSON() |>
      as_tibble()
    tableOfInterest <- tail(outData$MRData, n=1)
    listOfInterest <- tableOfInterest[[1]]
    return(finalTibble = as_tibble(listOfInterest))
  }else if(year != "" & title != ""){
    URL <- paste("https://ergast.com/api/f1/", 
                 year,
                 "/",
                 title,
                 ".json",
                 sep = "")
    outData <- GET(URL)$content |>
      rawToChar() |>
      fromJSON() |>
      as_tibble()
    tableOfInterest <- tail(outData$MRData, n=1)
    listOfInterest <- tableOfInterest[[1]]
    return(finalTibble = as_tibble(listOfInterest))
  }else if(year == "" & title != ""){
    URL <- paste("https://ergast.com/api/f1/", 
                 title,
                 ".json",
                 sep = "")
    outData <- GET(URL)$content |>
      rawToChar() |>
      fromJSON() |>
      as_tibble()
    tableOfInterest <- tail(outData$MRData, n=1)
    listOfInterest <- tableOfInterest[[1]]
    return(finalTibble = as_tibble(listOfInterest))
  }
}
final <- getF1(title = "driverStandings")

secondTry <- getF1(title = "circuits", year = "2010")

third <- getF1(title = "results", year = 2008)


# idea based on practice 1:
# "Select a year"
# 1) select year from choices ( selectInput() ) with one option being "All Available"
# "What category interests you?"
# 2) buttons like plot type ( radioButtons() )
#   - options: _results, lap times, standings ?
# depending on this choice:
# "Which variables?"
# 3) radioButtons() again ?

#   numerical variables: give mean per driver and/or location
#   - ggforce()
#   - scatter plot ?

#   categorical: (standings ?) give contingency table
#   - bar plot
#   - box and whisker for numerical at levels of cat

g <- ggplot(third, aes(x = Class))
  if(input$plot == "bar"){
    g + geom_bar()
  } else if(input$plot == "sideUmemploy"){ 
    g + geom_bar(aes(fill = as.factor(EmploymentDuration.Unemployed)), position = "dodge") + 
      scale_fill_discrete(name = "Unemployment status", labels = c("Employed", "Unemployed"))
  } else if(input$plot == "sideForeign"){
    g + geom_bar(aes(fill = as.factor(ForeignWorker)), position = "dodge") + 
      scale_fill_discrete(name = "Status", labels = c("German", "Foreign"))
  }