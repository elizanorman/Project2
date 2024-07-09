library(shiny)
library(tidyverse)
library(DT)
library(jsonlite)
library(tidyverse)
library(httr)
library(dplyr)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    URL <- "https://fruityvice.com/api/fruit/all"
    outData <- GET(URL)$content |>
      rawToChar() |>
      fromJSON() |>
      as_tibble()
    color_mappings <- tribble(
      ~fruit, ~color,
      "Strawberry", "red",
      "Tomato", "red",
      "Lingonberry", "red",
      "Lychee", "red",
      "Raspberry", "red",
      "Apple", "red",
      "Pomegranate", "red",
      "Cranberry", "red",
      "Cherry", "red",
      "Durian", "green",
      "Pear", "green",
      "Kiwi", "green",
      "GreenApple", "green",
      "Melon", "green",
      "Lime", "green",
      "Feijoa", "green",
      "Avocado", "green",
      "Annona", "green",
      "Banana", "yellow",
      "Pineapple", "yellow",
      "Gooseberry", "yellow",
      "Lemon", "yellow",
      "Mango", "yellow",
      "Kiwifruit", "yellow",
      "Jackfruit", "yellow",
      "Hazelnut", "yellow",
      "Blueberry", "blue",
      "Ceylon Gooseberry", "blue",
      "Fig", "pink",
      "Watermelon", "pink",
      "Guava", "pink",
      "Pitahaya", "pink",
      "Dragonfruit", "pink",
      "Pomelo", "pink",
      "Persimmon", "orange",
      "Orange", "orange",
      "Apricot", "orange",
      "Tangerine", "orange",
      "Peach", "orange",
      "Horned Melon", "orange",
      "Pumpkin", "orange",
      "Japanese Persimmon", "orange",
      "Papaya", "orange",
      "Blackberry", "purple",
      "Passionfruit", "purple",
      "Plum", "purple",
      "Grape", "purple",
      "Morus", "purple",
      "Mangosteen", "purple"
    )
    

  data2 <- reactive({
    outData <- outData |> left_join(color_mappings, by = c("name" = "fruit")) |>
      unnest_wider(col=nutritions, names_sep="_")
    if(input$col == "all fruits"){
      outData2 <- select(outData, "name", "id", input$vars)
    }else{
    outData2 <- outData |> 
      filter(input$col == outData$color) |>
      select("name", "id", input$vars)
    }
  })
  output$summary <- DT::renderDataTable({
    data2()
})
  output$download <- downloadHandler(
    filename = function() {
      "Art.csv"
    },
    content = function(file){
      write.csv(data2(), file, row.names = FALSE)
    }
  )
})
