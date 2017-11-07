library(shiny)
library(readr)

source("../plotFunctions.R")

shinyServer <- function(input, output, session) {
  library(lubridate)
  
  notas <-  src_mysql('notas_fiscais', group='ministerio-publico', password=NULL)
  
  query <- sql('
   SELECT DISTINCT NCM_prod FROM nota_fiscal
  ')
  
  ncm_cod <- tbl(notas, query) %>%
    collect(n = Inf)
  
  ncm <- read.csv("../../../utils/dados/NCMatualizada13072017.csv",
                  sep=";",
                  stringsAsFactors = F,
                  colClasses = c(NCM = "character")) %>%
    semi_join(ncm_cod, by = c("NCM" = "NCM_prod"))
  
  # output$download_csv2 <- downloadHandler(
  #   filename = function(){
  #     paste("export-careiros-pareado.csv", sep = "")
  #   },
  #   content = function(file) {
  #     write.csv(tabela_careiros_comp %>% mutate_all(funs(as.character(.))),
  #               file, row.names = F)
  #   },
  #   contentType = "text/csv"
  # )
  
  dados_fornecedores_ncms <- read_csv("../../dados/fornecedores_ncms.csv",
                                      locale = locale(encoding = "latin1"))
  
  output$fornecedores_ncms <- renderPlotly({
    fornecedores_ncms(dados_fornecedores_ncms)
  })
  
  dados_fornecedor_ncm_compradores <- read_csv("../../dados/fornecedor_ncm_compradores.csv",
                                               locale = locale(encoding = "latin1"))
  
  output$fornecedor_ncm_compradores <- renderPlotly({
    data <- event_data("plotly_click", source = "forn_ncms")
    vars <- c(data[["x"]], data[["y"]])
    
    fornecedor_ncm_compradores(dados_fornecedor_ncm_compradores,
                               vars[1], "10000000", "UND")
  })
  
  

}
