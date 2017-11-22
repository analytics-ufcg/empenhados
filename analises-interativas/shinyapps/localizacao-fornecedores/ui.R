library(dplyr)
library(leaflet)
library(shiny)
library(shinydashboard)

ganhadores <- ganhadores <- read.csv("../../../utils/dados/fornecedores.csv", stringsAsFactors = FALSE, colClasses=c("cd_Credor"="character"))

utils <- src_mysql('utils', group='ministerio-publico', password=NULL)

dados_cep <- tbl(utils, "empresa") %>%
  collect() %>%
  mutate(longitude = as.numeric(longitude)) %>%
  mutate(latitude = as.numeric(latitude))

localizacao_licitantes_municipios <- ganhadores %>%
  left_join(dados_cep %>%
              select(cnpj, cep, latitude, longitude, estado, cidade), by = c('cd_Credor' = 'cnpj')) %>%
  filter(!is.na(cep), cep != "") %>%
  ungroup()

labels <- localizacao_licitantes_municipios %>%
  distinct(cd_Credor, .keep_all = TRUE) %>%
  arrange(no_Credor)

ui <- dashboardPage(
  dashboardHeader(title = "Localização"),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    fluidRow(
      box(width = 12, status = "primary",
          selectInput(inputId = "busca", 
                      label = "Busque um fornecedor",
                      choices = (paste(labels[["no_Credor"]], " - ",labels[["cd_Credor"]]))
          ),
          radioButtons(inputId = "modo_visualizacao",
                       label = "Verificar",
                       choices = c("Total de vitórias", "Valor recebido"),
                       selected = "Total de vitórias",
                       inline = TRUE
          )
      )
    ),
    fluidRow(
      box(width = 12, status = "primary",              
          leafletOutput("municipios")
      )
    )
  )
)
