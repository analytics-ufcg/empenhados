library(shiny)

source("../plotFunctions.R")

shinyServer <- function(input, output, session) {
  library(lubridate)
  library(readr)
  
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
  
  tabela_careiros <- read.csv("../../dados/fornecedores_ncms.csv", encoding = "latin1")
  
  # É necessário ter o csv com a tabela nfe
  #nfe_confiavel <- read_csv("../../dados/nfe_confiavel.csv", locale = locale(encoding = "latin1"))
  
  output$scatter1 <- renderPlotly({
    fornecedores_ncms(tabela_careiros)
  })
  
  output$scatter_boxplot <- renderPlotly({
    ## Exemplo de uso
    fornecedores_ncm(nfe_confiavel, 21011110, "UND")
  })
  
  

}
