library(shiny)

shinyServer <- function(input, output, session) {
  
  notas <-  src_mysql('notas_fiscais', group='ministerio-publico', password=NULL)
  
  query <- sql('
   SELECT DISTINCT NCM_prod FROM nota_fiscal
  ')
  
  ncm_cod <- tbl(notas, query) %>%
    collect(n = Inf)
  
  # ncm <- read.csv("../../utils/dados/NCMatualizada13072017.csv",
  #                 sep=";",
  #                 stringsAsFactors = F,
  #                 colClasses = c(NCM = "character")) %>%
  #   semi_join(ncm_cod, by = c("NCM" = "NCM_prod"))
  # 
  # updateSelectizeInput(session, "busca",
  #                      choices = ncm[["Descricao"]],
  #                      server = TRUE)

}
