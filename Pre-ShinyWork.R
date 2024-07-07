library(jsonlite)
library(tidyverse)
library(httr)

getF1 <- function(title, year = ""){
  
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

}
final <- getF1(title = "driverStandings", year = 2004)
final2 <- getF1(title = "constructorStandings", year = 2004) |>
          unnest_wider(final2$StandingsLists$ConstructorStandings[[1]], col = c(position, points, wins))

final3 <- getF1(title = "results", year = 2004)
final4 <- getF1(title = "qualifying", year = 2004)
final5 <- getF1(title = "sprint", year = 2002)

final6 <- getF1(title = "drivers", year = 2002)

# secondTry <- getF1(title = "circuits", year = "2010")
# 
# third <- getF1(title = "results", year = 2008)


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


URL <- "http://ergast.com/api/f1/constructors/mclaren/circuits/monza/drivers"
outData <- GET(URL)$content |>
  rawToChar() |>
  fromJSON() |>
  as_tibble()

