library(shiny)
library(shinydashboard)

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
                                        placeholder = 'Insira um código NCM ou descrição de produto'))
      )
    ),
    
    fluidRow(
      box(width = 12, status = "primary", solidHeader = TRUE,
          title = "Fornecedores que vendem com sobrepreço no NCM"
          #Add visualização (decidir entre gráfico ou tabela)
      )
    ),
    
    fluidRow(
      box(width = 12, status = "primary",
          collapsible = TRUE, collapsed = TRUE, solidHeader = TRUE,
          title = "Fornecedores que vendem com sobrepreço no geral"
          #Add visualização (decidir entre gráfico ou tabela)
      )
    ),
    
    fluidRow(
      box(width = 12, status = "primary", solidHeader = TRUE,
          collapsible = TRUE, collapsed = TRUE,
          title = "Exportar dados", align = "center",
          downloadButton(outputId = "download_csv",
                         label = "Exportar CSV")
      )
    )
  )
)