# load the required packages
library(shiny)
require(shinydashboard)
library(tidyverse)


#Dashboard header carrying the title of the dashboard
header <- dashboardHeader(title = "Avocados Sales")  

#Sidebar content of the dashboard
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Dataset", icon = icon("send",lib='glyphicon'), 
             href = "https://www.kaggle.com/neuromusic/avocado-prices")
  )
)

 
fluidRow(column(4, verbatimTextOutput("value")))

frow1 <- fluidRow(
  valueBoxOutput("value1")
  ,valueBoxOutput("value2")
  ,valueBoxOutput("value3")
)

frow2 <- fluidRow(
  box(
    title = "U.S. Avocado Sales (2015 - 2018)"
    ,status = "success"
    ,solidHeader = TRUE 
    ,collapsible = TRUE 
    ,plotOutput("barline"), height=480, width=12
  ),
  #  box(
  #   title = "Revenue per Type"
  #   ,status = "primary"
  #   ,solidHeader = TRUE 
  #   ,collapsible = TRUE 
  #   ,plotOutput("revenuebyType", height = "300px")
  # ),
  box(
    title = "Volume by Type"
    ,status = "primary"
    ,solidHeader = TRUE 
    ,collapsible = TRUE 
    ,plotOutput("perbyType", height = "300px")
  )
  
  ,box(
    title = "Total per Type"
    ,status = "primary"
    ,solidHeader = TRUE 
    ,collapsible = TRUE 
    ,plotOutput("totalbyType", height = "300px")
  ) 
)


# combine the two fluid rows to make the body
body <- dashboardBody(frow1, frow2)

#completing the ui part with dashboardPage
ui <- dashboardPage(title = 'My first Shiny Dashboard', header, sidebar, body, skin='green')
