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
      if(input$radio == "Nutrition Breakdown"){
        outData2 <- select(outData, "name", "id", input$varsNut)
      }else{
        outData2 <- select(outData, "name", "id", input$varsBio)
      }
        
    }else{
      if(input$radio == "Nutrition Breakdown"){
        outData2 <- outData |> 
          filter(input$col == outData$color) |>
          select("name", "id", input$varsNut)
    }else{
      outData2 <- outData |> 
        filter(input$col == outData$color) |>
        select("name", "id", input$varsBio)
    }
  }
  })
  output$summary <- DT::renderDataTable({
    data2()
})
  output$download <- downloadHandler(
    filename = function() {
      "Fruit.csv"
    },
    content = function(file){
      write.csv(data2(), file, row.names = FALSE)
    }
  )
  output$table <- renderTable({
    if(input$numType == "Categorical"){
    if(input$varsCat == "family vs order"){
      tab1 <- table(outData$family, outData$order)
      tab1_df <- as.data.frame(tab1)
      nonzero_df <- tab1_df[tab1_df$Freq != 0,]
      nonzero_df1 <- rename(nonzero_df, family=Var1, order=Var2)
      nonzero_df1
    }else if(input$varsCat == "order vs genus"){
      tab1 <- table(outData$order, outData$genus)
      tab1_df <- as.data.frame(tab1)
      nonzero_df <- tab1_df[tab1_df$Freq != 0,]
      nonzero_df1 <- rename(nonzero_df, family=Var1, order=Var2)
      nonzero_df1
    }else{
      tab1 <- table(outData$genus, outData$family)
      tab1_df <- as.data.frame(tab1)
      nonzero_df <- tab1_df[tab1_df$Freq != 0,]
      nonzero_df1 <- rename(nonzero_df, family=Var1, order=Var2)
      nonzero_df1
    }
    }
  })
  output$barPlot <- renderPlot({
    outData <- outData |> left_join(color_mappings, by = c("name" = "fruit")) |>
      unnest_wider(col=nutritions, names_sep="_")
    if(input$numType == "Categorical" && input$varsBar == "color"){
    g <- ggplot(outData, aes(x = color))  
     g + geom_bar(aes(fill = as.factor(color))) +
         scale_fill_manual(values = c(blue = "blue", green = "green", orange = "orange", pink = "pink", purple = "purple", red = "red", yellow = "yellow"))
    }else if(input$numType == "Categorical" && input$varsBar == "family"){
      g <- ggplot(outData, aes(x = family))  
      g + geom_bar(aes(fill = as.factor(family)))
    }else if(input$numType == "Categorical" && input$varsBar == "order"){
      g <- ggplot(outData, aes(x = order))  
      g + geom_bar(aes(fill = as.factor(order)))
    }else if(input$numType == "Categorical" && input$varsBar == "genus"){
      g <- ggplot(outData, aes(x = genus))  
      g + geom_bar(aes(fill = as.factor(genus)))
    }
  })
  
  output$text <- renderText({
    outData <- outData |> left_join(color_mappings, by = c("name" = "fruit")) |>
      unnest_wider(col=nutritions, names_sep="_")
    if(input$numType == "Numeric"){
      paste("The mean of ", input$numPlots, "is ", round(mean(as.numeric(outData[[input$numPlots]])),2) , ", and the median of ", input$numPlots, "is ", round(median(as.numeric(outData[[input$numPlots]])),2))
    }
  })
  
  
})
