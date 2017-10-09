library(shiny)
library(shinydashboard)

library(dplyr)
library(plotly)
library(stringr)

ui <- dashboardPage(
  dashboardHeader(title = "Fornecedores que praticam sobrepreço", titleWidth = 450),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    fluidRow(
      box(width = 12, status = "primary",
          selectizeInput(inputId = "busca", 
                         label = "Código NCM", 
                         choices = NULL,
                         multiple = FALSE,
                         options = list(maxOptions = 5,
                                        placeholder = 'Insira um código NCM ou descrição de produto')),
          selectInput(inputId = "select_unid",
                      label = "Unidade",
                      choices = c("KG")),
          box(width = 12, status = "primary", solidHeader = TRUE,
              title = "Fornecedores que vendem com sobrepreço no NCM",
              plotlyOutput("scatter")
          )
      )
    ),
    
    fluidRow(
      box(width = 12, status = "primary",
          collapsible = TRUE, solidHeader = TRUE,
          title = "Fornecedores que vendem com sobrepreço no geral",
          dataTableOutput("careiros_geral"),
          tags$div(align = "right",
          downloadButton(outputId = "download_csv1",
                         label = "Exportar Dados"))
      )
    ),
    
    fluidRow(
      box(width = 12, status = "primary",
          collapsible = TRUE, solidHeader = TRUE,
          title = "Pares de fornecedores e compradores onde ocorre sobrepreço",
          dataTableOutput("careiros_geral_comp"),
          tags$div(align = "right",
                   downloadButton(outputId = "download_csv2",
                                  label = "Exportar Dados"))
      )
    )
  )
)