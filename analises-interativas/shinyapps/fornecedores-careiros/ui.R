library(shiny)
library(shinydashboard)
library(shinyBS)

library(dplyr)
library(plotly)
library(stringr)
library(DT)
library(purrr)

ui <- dashboardPage(

  dashboardHeader(title = "Fornecedores que praticam sobrepreço",
                  titleWidth = 450, dropdownMenuOutput("messageMenu")),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    tags$head(tags$link(rel="shortcut icon", href="tce-cropped.png")),
    tags$head(
      HTML(
        "<script>
          var socket_timeout_interval
          var n = 0
          $(document).on('shiny:connected', function(event) {
            socket_timeout_interval = setInterval(function(){
            Shiny.onInputChange('count', n++)
            }, 15000)
          });
          $(document).on('shiny:disconnected', function(event) {
            clearInterval(socket_timeout_interval)
          });
        </script>"
      )
    ),

    fluidRow(
      box(width = 6, status = "primary", solidHeader = TRUE,
          title = span("Atipicidade dos fornecedores",
                       downloadButton("download1", label = "", class = NULL),
                       actionButton("message_atipicidade", "", icon = icon("question"))),
          plotlyOutput("scatter1", height = 500)
      ),

      box(width = 6, status = "primary", solidHeader = TRUE,
          title = span("Atuação de fornecedores no produto selecionado",
                       downloadButton("download2", label = "", class = NULL),
                       actionButton("message_atuacao", "", icon = icon("question"))),
          plotlyOutput("scatter_atipicos", height = 250),
	        plotlyOutput("scatter_boxplot", height = 250)
      ),

      box(width = 10, status = "primary", solidHeader = TRUE,
          title = span("Relação de Vendas",
                       downloadButton("download3", label = "", class = NULL)),
          div(dataTableOutput("tabela"))
      ),

      fixedRow(width = 2,
               box(width = 2, status = "danger",textOutput("text"))
      )
    )
  )
)
