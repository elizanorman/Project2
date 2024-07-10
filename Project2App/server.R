# load required packages
library(shiny)
library(tidyverse)
library(DT)
library(jsonlite)
library(tidyverse)
library(httr)
library(dplyr)
library(ggplot2)
library(ggExtra)


# Define server logic
shinyServer(function(input, output) {
  # access the API and convert content to tibble
  URL <- "https://fruityvice.com/api/fruit/all"
  outData <- GET(URL)$content |>
    rawToChar() |>
    fromJSON() |>
    as_tibble()
  # create a tibble row by row to assign colors to the fruits
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
    
  # create a reactive dataset to be used in the summary output
  data2 <- reactive({
    # merge the color column onto the dataset, and access the columns from nutritions
    outData <- outData |> left_join(color_mappings, by = c("name" = "fruit")) |>
      unnest_wider(col=nutritions, names_sep="_")
    # allow subsetting by fruit option (col) from the UI
    if(input$col == "all fruits"){
      # display user's choice of variables from the dataset
      if(input$radio == "Nutrition Facts"){
        outData2 <- select(outData, "name", "id", input$varsNut)
      }else{
        outData2 <- select(outData, "name", "id", input$varsBio)
      }
    }else{
      if(input$radio == "Nutrition Facts"){
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
  # output the reactive data2()
  output$summary <- DT::renderDataTable({
    data2()
  })
  # allow the user to download the reactive data2()
  output$download <- downloadHandler(
    filename = function() {
      "Fruit.csv"
    },
    content = function(file){
      write.csv(data2(), file, row.names = FALSE)
    }
  )
  # create a contingency table for categorical data, and only keep nonzero rows
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
  # create a bar plot for categorical data
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
  # create a line graph for numeric data
  output$line <- renderPlot({
    outData <- outData |> left_join(color_mappings, by = c("name" = "fruit")) |>
      unnest_wider(col=nutritions, names_sep="_")
    if(input$numType == "Categorical"){
      p <- ggplot(outData, aes(x = nutritions_sugar, y = nutritions_calories, color = color)) +
           geom_line() +
           labs(x = "Sugar", y = "Calories", color = "Fruit Color") +
           scale_color_manual(values = c(blue = "blue", green = "green", orange = "orange", pink = "pink", purple = "purple", red = "red", yellow = "yellow"))
      p
    }
  })
  # output numeric summaries (mean and median) for numeric data
  output$text <- renderText({
    outData <- outData |> left_join(color_mappings, by = c("name" = "fruit")) |>
      unnest_wider(col=nutritions, names_sep="_")
    if(input$numType == "Numeric"){
      paste("The mean of ", input$numPlots, "is ", round(mean(as.numeric(outData[[input$numPlots]])),2) , ", and the median of ", input$numPlots, "is ", round(median(as.numeric(outData[[input$numPlots]])),2))
    }
  })
  # output scatter plot, with additional density curves categorized by color on the margins, for numeric data
  output$scatter <- renderPlot({
    outData <- outData |> left_join(color_mappings, by = c("name" = "fruit")) |>
      unnest_wider(col=nutritions, names_sep="_")
    if(input$numType == "Numeric"){
      f <- ggplot(outData, aes(x = as.numeric(.data[[input$scatterVar1]]), y = as.numeric(.data[[input$scatterVar2]]), colour = as.factor(.data$color))) +
           geom_point()+
           labs(x = input$scatterVar1, y = input$scatterVar2, colour = "Color")
           ggMarginal(f, groupColour = TRUE, groupFill = TRUE)
    }
  })
  # output boxplot for calories by fruit color
  output$box <- renderPlot({
    outData <- outData |> left_join(color_mappings, by = c("name" = "fruit")) |>
      unnest_wider(col=nutritions, names_sep="_")
    if(input$numType == "Numeric"){
      b <- ggplot(outData, aes(x = color, y = nutritions_calories, fill = as.factor(color))) +
           geom_boxplot() +
           scale_fill_manual(values = c(blue = "blue", green = "green", orange = "orange", pink = "pink", purple = "purple", red = "red", yellow = "yellow")) +
           labs(x = "Color", y = "Calories", fill = "Color")
      b
    }
  })
})
