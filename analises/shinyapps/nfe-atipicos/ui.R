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

notas <-  src_mysql('notas_fiscais', group='ministerio-publico', password=NULL)

query <- sql('
 SELECT DISTINCT NCM_prod FROM nota_fiscal
')

ncm_cod <- tbl(notas, query) %>%
  collect(n = Inf)

ncm <- read.csv("../../utils/dados/NCMatualizada13072017.csv",
                sep=";",
                stringsAsFactors = F,
                colClasses = c(NCM = "character")) %>%
  semi_join(ncm_cod, by = c("NCM" = "NCM_prod"))

ui <- dashboardPage(
  dashboardHeader(title = "Notas fiscais atípicas"),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    fluidRow(
        box(width = 12, status = "primary",
          selectInput(inputId = "busca", 
                      label = "Código NCM", 
                      choices = (ncm[["Descricao"]]),
                      selected = "10064000 - ARROZ QUEBRADO"),
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