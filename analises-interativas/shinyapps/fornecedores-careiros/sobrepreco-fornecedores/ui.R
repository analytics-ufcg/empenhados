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

    fluidRow(
      box(width = 6, status = "primary", solidHeader = TRUE,
          title = span("Atipicidade",
                       downloadButton("download1", label = "", class = NULL)),
          plotlyOutput("scatter1", height = 500)
      ),
      
      box(width = 6, status = "primary", solidHeader = TRUE, 
          title = span("Sumarização",
                       downloadButton("download2", label = "", class = NULL)),
          plotlyOutput("scatter_atipicos", height = 250),
	        plotlyOutput("scatter_boxplot", height = 250)
      ),
      
      box(width = 10, status = "primary", solidHeader = TRUE,
          title = span("Relação de Vendas",
                       downloadButton("download3", label = "", class = NULL)),
          div(dataTableOutput("tabela"))
      ),
      
      fixedRow(width = 2,
               box(width = 2, status = "danger",textOutput("text")),
               box(title = "O que é Atipicidade?",
                    width = 2, status = "primary", solidHeader = TRUE, p("A", strong('atipicidade'), "de um fornecedor para um NCM é calculada considerando a distância normalizada entre o preço 
                    médio praticado pelo fornecedor e o maior preço médio
                    que não é classificado como ponto extremo. As atipicidades mínimas, médias e máximas
                    utilizadas acima são sumarizações da atipicidade calculada nos NCM's em que 
                    o fornecedor atua."), collapsible = TRUE, collapsed = TRUE)
      )
    )
  )
)
