library(shiny)

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

  updateSelectizeInput(session, "busca",
                       choices = ncm[["Descricao"]],
                       server = TRUE,
                       selected = "10064000 - ARROZ QUEBRADO")
  
  ncm_input <- reactive({
    str_sub(input$busca, 1, 8)
  })
  
  dados_nfe <- reactive({
    ncm_input = ncm_input()
    
    template <- ('
    SELECT Valor_unit_prod, NCM_prod, Descricao_do_Produto_ou_servicos, Nome_razao_social_emit, 
                  CPF_CNPJ_emit, Nome_razao_social_dest, CPF_CNPJ_dest, Valor_total_da_nota, 
                  Data_de_emissao, Unid_prod, Metrica, Confiavel
    FROM nota_fiscal
    WHERE NCM_prod = "%s"
  ')
    
    query <- template %>%
      sprintf(ncm_input) %>%
      sql()
    
    nfe <- tbl(src_mysql('notas_fiscais', group='ministerio-publico', password=NULL), query) %>%
      collect(n = Inf) %>% 
      mutate(Confiavel = ifelse(Confiavel == "TRUE", TRUE, FALSE))
    
  })  
  
  observe({
    dados_nfe <- dados_nfe()
    updateSelectInput(session, "select_unid",
                      choices = dados_nfe[["Unid_prod"]]
    )
  })
  
  output$scatter <- renderPlotly({
    
    dados_nfe <- dados_nfe() %>%
      filter(Unid_prod == input$select_unid, Confiavel == TRUE) %>%
      group_by(NCM_prod, Nome_razao_social_emit) %>%
      summarise(preco_medio = mean(Valor_unit_prod))
    
    dados_nfe %>%
      plot_ly(x = ~Nome_razao_social_emit, y = ~preco_medio, type = "scatter", mode = "markers",
              text = ~paste("Fornecedor:", Nome_razao_social_emit,
                            "<br> Preço Médio: ", round(preco_medio, 2)),
              hoverinfo = "text") %>%
      layout(title = paste(input$busca, "-" ,input$select_unid),
            xaxis = list(title = "Fornecedores",  showticklabels = FALSE),
            yaxis = list(title = 'Preço médio'))
  })
  


}
