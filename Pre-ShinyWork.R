library(jsonlite)
library(tidyverse)
library(httr)

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


URL <- "https://fruityvice.com/api/fruit/all"
outData <- GET(URL)$content |>
  rawToChar() |>
  fromJSON() |>
  as_tibble()

