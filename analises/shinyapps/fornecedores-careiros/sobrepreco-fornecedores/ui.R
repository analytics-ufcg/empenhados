library(shiny)
library(shinydashboard)
library(shinyBS)

library(dplyr)
library(plotly)
library(stringr)

ui <- dashboardPage(
  dashboardHeader(title = "Fornecedores que praticam sobrepreço",
                  titleWidth = 450, dropdownMenuOutput("messageMenu")),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    tags$script(HTML("function clickFunction(link){ 
                   Shiny.onInputChange('linkClicked',link);
                     }")),
    fluidRow(
      box(width = 6, status = "primary", solidHeader = TRUE,
          title = "Análise de Atipicidade",
          plotlyOutput("scatter1", height = 500)
      ),
      box(width = 6, status = "primary", solidHeader = TRUE, title = "Sumarização",
          plotlyOutput("scatter_atipicos", height = 250),
          plotlyOutput("scatter_boxplot", height = 250)
      ),
      box(width = 12, status = "primary", solidHeader = TRUE,
          plotlyOutput("scatter_vendas")
      )
    )
  )
)
