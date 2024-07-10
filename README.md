# Project2

The purpose of this app is to explore the characteristics of 49 different fruits. The app will allow the user to filter, subset, and download data about the fruits' nutrition facts as well as their biological classifications. The Data Exploration tab allows the user to plot different combinations of categorical and numeric variables.

install.packages(c("shiny", "DT", "jsonlite", "tidyverse", "httr", "dplyr", "caret", "ggplot2", "ggExtra"))

shiny::runGitHub(repo = "Project2", username = "elizanorman", subdir = "Project2App", ref = "main")
