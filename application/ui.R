library(shiny)
library(shinyjs)
library(shinyBS)
library(shinydashboard)
library(plotly)
dashboardPage(
  title="Product Price Recommendation",
  skin="red",
  
  #HEAD###################
  dashboardHeader(title="Product Price Recommendation",titleWidth=300),
  #SiderBar################
  dashboardSidebar(
    sidebarMenu(
      menuItem("Find Price",tabName = "price",icon=icon("fas fa-bell"),selected=TRUE),
      menuIten("Workflow",tabName="workflow",icon=icon("fas fa-network-wired")),
      menuItem("Model Evaluation", tabName = "modelEvaluation",icon=icon("fas fa-analytics")),
      menuItem("About",tabName="about",icon=icon("fas fa-bell"))
    ),
    width=300
  ),
  
  #dashboard body######
  dashboardBody(
    #load css file
    tags$head(
      tags$link(
        rel = "stylesheet", 
        type = "text/css",
        href = "page.css"),
        tags$style("font-size:18px")
    ),
    #load shinyJs
    useShinyjs(),
    tabItems(
      tabItem(tabName = "price",
        fluidRow(
          
        )
      )
    )
  )
)