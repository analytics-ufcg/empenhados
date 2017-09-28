library(dplyr)
library(methods)
library(shiny)
library(DBI)
library(RMySQL)
library(plotly)
library(tidyr)
library(stringr)
library(shinydashboard)
library(RColorBrewer)

ui <- dashboardPage(
  dashboardHeader(title = "Notas fiscais atípicas"),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    fluidRow(
        box(width = 12, status = "primary",
          selectizeInput(inputId = "busca", 
                      label = "Código NCM", 
                      choices = NULL,
                      multiple = FALSE,
                      options = list(maxOptions = 5, placeholder = 'Insira um código NCM ou descrição de produto')),
          selectInput(inputId = "select_unid",
                      label = "Unidade",
                      choices = c("KG"))
        )
    ),
    fluidRow(
        box(width = 12, status = "primary",              
          plotlyOutput("scatter")
        )
    ),
    fluidRow(
      box(width = 12, status = "primary", solidHeader = TRUE, title = "Notas Fiscais Ocultadas da Visualização",
          collapsible = TRUE, collapsed = TRUE,           
          dataTableOutput("table")
      )
    ),
    fluidRow(
      box(width = 12, status = "primary", solidHeader = TRUE, title = "Exportação de Dados",
          collapsible = TRUE, collapsed = TRUE, align = "center",
          p("Abaixo é possível realizar o download dos dados referentes ao NCM selecionado."),
          p("O campo confiável indica se um item foi considerado como pertencente ou não ao NCM indicado.
            Apenas itens considerados confiáveis foram exibidos na visualização acima"),
          downloadButton(outputId = "down_csv",
                         label = "Exportar CSV")
      )
    )
  )
)