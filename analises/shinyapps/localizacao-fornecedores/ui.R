source('../lib/load_fornecedores_merenda.R')

ganhadores <- load_fornecedores_merenda() %>%
  ungroup()

cep_licitantes <- tbl(utils, 'empresa') %>%
  collect(n = Inf)

dados_cep <- read.csv("dados_cep.csv", stringsAsFactors = FALSE, header = TRUE, na.strings = '')

labels <- localizacao_licitantes_municipios %>%
  distinct(cd_Credor, .keep_all = TRUE) %>%
  arrange(no_Credor)

localizacao_licitantes_municipios <- ganhadores %>%
  left_join(cep_licitantes, by = c('cd_Credor' = 'nu_CPFCNPJ')) %>%
  filter(!is.na(nu_CEP)) %>%
  ungroup()

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