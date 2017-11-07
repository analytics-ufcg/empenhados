library(shiny)
library(shinydashboard)
library(shinyBS)

library(dplyr)
library(plotly)
library(stringr)

ui <- dashboardPage(
  dashboardHeader(title = "Fornecedores que praticam sobrepreço",
                  titleWidth = 450),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    fluidRow(
      box(width = 12, status = "primary", solidHeader = TRUE,
          title = "Análise de Atipicidade*",
          footer = "*Atipicidade: A atipicidade de um fornecedor 
                    para um NCM é calculada considerando a distância normalizada entre o preço 
                    médio praticado pelo fornecedor e o maior preço médio
                    que não é classificado como ponto extremo. As atipicidades mínimas, médias e máximas
                    utilizadas acima são sumarizações da atipicidade calculada nos NCM's em que 
                    o fornecedor atua.",
          plotlyOutput("fornecedores_ncms", height = 700),
          plotlyOutput("fornecedor_ncm_compradores", height = 700)
      )
    )
  )
)
