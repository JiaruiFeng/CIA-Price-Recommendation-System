library(shiny)
library(shinyjs)
library(shinyBS)
library(shinydashboard)
library(keras)
library(plotly)
library(text2vec)
library(stringr)
library(corpus)
library(fastDummies)
#library(png)
dashboardPage(
  title="Product Price Recommendation",
  skin="red",
  
  #HEAD###################
  dashboardHeader(title="Product Price Recommendation",titleWidth=300),
  #SiderBar################
  dashboardSidebar(
    sidebarMenu(
      menuItem("Find Price",tabName = "price",icon=icon("fas fa-bell"),selected=TRUE),
      menuItem("Workflow",tabName="workflow",icon=icon("fas fa-project-diagram")),
      menuItem("Model Evaluation", tabName = "modelEvaluation",icon=icon("far fa-chart-bar")),
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
          box(title="Provide information of Products",width=12,status = "info",collapsible = F,solidHeader = TRUE,
              fluidRow(
                tags$div(id="nameBar",
                         textInput(inputId="name",h4("Name of product"),placeholder = "Input name of your product",width="400px"),
                ) ,
                tipify(tags$div(id="brandBar",
                         uiOutput("brandName")
                         ),"If brand of your product don't list in there, please select 'others' optition")
              ),
              fluidRow(
                tipify(tags$div(id="conditionBar",
                         selectInput("condition", label=h4("Choose condition of your product"),
                                     choices =c("very well","well","normal","bad","very bad"),selected=1,width="200px")
                         ),"We have totally five different condition, you can select the condition which suitable to your
                             product."),
                tipify(tags$div(id="shippingBar",
                         checkboxInput("shipping", h4("Cover shipping fee"), TRUE,width="auto")
                         ),"If you will cover shipping fee, please mark the checkbox.")
              ),
              fluidRow(
                tags$div(id="cate1Bar",             
                         uiOutput("Category1")
                         ),
                tags$div(id="cate2Bar",
                         uiOutput("Category2")
                         ),
                tags$div(id="cate3Bar",
                         uiOutput("Category3")
                         )
              ),
              textAreaInput("description", label=h4("Give a brief description"), value = "", width = NULL, height = "100px",
                            cols = NULL, rows = NULL, placeholder = NULL, resize = NULL),
              bsButton("predict","Give me a price",size="large",style="info")
              )
        )
      ),
      tabItem(tabName = "workflow",
              fluidRow(
                box(title="Data Description and Preprocessing",width=12,status = "success",collapsible = T,solidHeader = TRUE,
                    tags$div(id="preprocessingBar",
                             imageOutput("preprocessing")   
                    )
                )
              ),
              fluidRow(
                box(title="Features Construction",width=12,status = "warning",collapsible = T,solidHeader = TRUE,
                    tags$h4(id="featuresConstructionText",
                           "We construct totally totally four kinds of feature to train our model. We named it as final, logical,
                      stem and combine respectively"
                    )
                )
              ),
              fluidRow(
                box(title="Final Feature",width=8,status="warning",collapsible = T,solidHeader = T,
                    tags$div(class="workflowPicture",
                             imageOutput("finalFeature")   
                    )),
                box(title="Logical Feature",width=4,status="warning",collapsible = T,solidHeader = T,
                  tags$div(class="workflowPicture",
                           imageOutput("logicalFeature")   
                  )
                )
              ),
              fluidRow(
                box(title="Stem Feature",width=6,status="warning",collapsible = T,solidHeader = T,
                    tags$div(class="workflowPicture",
                             imageOutput("stemFeature")   
                    )),
                box(title="combine Feature",width=6,status="warning",collapsible = T,solidHeader = T,
                    tags$div(class="workflowPicture",
                             imageOutput("combineFeature")   
                    )),
              ),
              fluidRow(
                box(title="Prediction Procedure",width = 12,status = "primary",collapsible = T,solidHeader = T,
                    tags$p("placeholder")
                    )
              )
      )
    )
  )
)
