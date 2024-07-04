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
