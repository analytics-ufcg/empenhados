library(dplyr)
library(leaflet)
library(shiny)

source('../lib/load_fornecedores_merenda.R')

ganhadores <- load_fornecedores_merenda() %>%
  ungroup()

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

ui <- shinyUI(
  fluidPage(
    wellPanel(
      fluidRow(
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
      leafletOutput("municipios")
    )
  )
)
