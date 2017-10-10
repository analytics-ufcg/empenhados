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

  updateSelectizeInput(session, 
                       "busca",
                       choices = ncm[["Descricao"]],
                       server = TRUE,
                       selected = "21011110 - CAFÉ SOLÚVEL DESCAFEINADO")
  
  ncm_input <- reactive({
    str_sub(input$busca, 1, 8)
  })
  
  dados_nfe <- reactive({
    ncm_input = ncm_input()
    
    template <- ('
    SELECT Valor_unit_prod, NCM_prod, Descricao_do_Produto_ou_servicos, Nome_razao_social_emit, 
                  CPF_CNPJ_emit, Nome_razao_social_dest, CPF_CNPJ_dest, Valor_total_da_nota, 
                  Data_de_emissao, Unid_prod, Metrica
    FROM nota_fiscal
    WHERE NCM_prod = "%s" AND Confiavel = "TRUE"
  ')
    
    query <- template %>%
      sprintf(ncm_input) %>%
      sql()
    
    nfe <- tbl(notas, query) %>%
      collect(n = Inf) 
  })
  
  observe({
    dados_nfe <- dados_nfe()
    updateSelectInput(session, "select_unid",
                      choices = dados_nfe[["Unid_prod"]]
    )
  })
  
  output$scatter <- renderPlotly({
    
    dados_nfe <- dados_nfe() %>%
      filter(Unid_prod == input$select_unid) %>%
      group_by(NCM_prod, Nome_razao_social_emit) %>%
      summarise(preco_medio = mean(Valor_unit_prod),
                observacoes = n(),
                max = max(Valor_unit_prod),
                min = min(Valor_unit_prod)) %>%
      mutate(tipo = ifelse(preco_medio > quantile(preco_medio, .75) + IQR(preco_medio) * 1.5, 
                           "Sobrepreço", "Preço típico")) %>%
      ungroup()
    
    tryCatch(
    dados_nfe %>%
      bind_rows(data.frame(
        NCM_prod = input$select_unid, 
        Nome_razao_social_emit = c(NA, NA),
        preco_medio = c(NA, NA),
        observacoes = c(NA, NA),
        max = c(NA, NA),
        min = c(NA, NA),
        tipo = c("Sobrepreço", "Preço típico")
      )) %>%
      plot_ly(x = ~Nome_razao_social_emit, y = ~preco_medio, type = "scatter", mode = "markers",
              color = ~tipo, colors = c("#0066CC", "#FF0000"),
              text = ~paste("Fornecedor:", Nome_razao_social_emit,
                            "<br> Preço Médio: ", round(preco_medio, 2),
                            "<br> Preço Máximo: ", round(max, 2),
                            "<br> Preço Mínimo: ", round(min, 2),
                            "<br> Número de vendas: ", observacoes),
              hoverinfo = "text") %>%
      layout(title = paste(input$busca, "-" ,input$select_unid),
            xaxis = list(title = "Fornecedores",  showticklabels = FALSE),
            yaxis = list(title = 'Preço médio')),
    
    error = function(e) { plot_ly() }
    )
  })
  
  tabela_careiros <- read.csv("../../dados/metrica_careiros.csv")
  
  output$careiros_geral <- renderDataTable(
    tabela_careiros %>%
      arrange(desc(Atipicidade_media)),
    options = list(scrollX = TRUE, pageLength = 10)
  )
  
  output$download_csv1 <- downloadHandler(
    filename = function(){
      paste("export-careiros.csv", sep = "")
    },
    content = function(file) {
      write.csv(tabela_careiros %>% mutate_all(funs(as.character(.))),
                file, row.names = F)
    },
    contentType = "text/csv"
  )
  
  tabela_careiros_comp <- read.csv("../../dados/metrica_careiros_comp.csv")
  
  output$careiros_geral_comp <- renderDataTable(
    tabela_careiros_comp %>%
      arrange(desc(Atipicidade_media)),
    options = list(scrollX = TRUE, pageLength = 10)
  )
  
  output$download_csv2 <- downloadHandler(
    filename = function(){
      paste("export-careiros-pareado.csv", sep = "")
    },
    content = function(file) {
      write.csv(tabela_careiros_comp %>% mutate_all(funs(as.character(.))),
                file, row.names = F)
    },
    contentType = "text/csv"
  )


}
