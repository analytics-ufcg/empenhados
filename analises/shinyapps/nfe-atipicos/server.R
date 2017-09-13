server <- function(input, output, session){
  set.seed(123)
  #options(warn = -1)
  
  ncm_input <- reactive({
    str_sub(input$busca, 1, 8)
  })
  
  dados_nfe <- reactive({
    ncm_input = ncm_input()
    
    template <- ('
    SELECT Valor_unit_prod, NCM_prod, Descricao_do_Produto_ou_servicos, Nome_razao_social_emit, Nome_razao_social_dest, 
                  Valor_total_da_nota, Data_de_emissao, Unid_prod, Metrica, Confiavel
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
      filter(Unid_prod == input$select_unid, Confiavel == TRUE)

    quantile = quantile(dados_nfe$Valor_unit_prod, probs = c(0.9))

    if (nrow(dados_nfe) != 0) {
      dados_nfe %>%
        mutate(atipico = ifelse(Valor_unit_prod > quantile, "Atípico", "Típico"),
               Metrica = round(Metrica, 3)) %>%
        plot_ly(x = ~Data_de_emissao, y = ~Valor_unit_prod, type = "scatter", mode = "markers", color = ~atipico, colors = "Set1",
                text = ~paste('Descrição: ', Descricao_do_Produto_ou_servicos,
                              '<br>Emitente: ', Nome_razao_social_emit,
                              '<br>Destino: ', Nome_razao_social_dest,
                              '<br>Valor Unitário: R$', Valor_unit_prod,
                              '<br>Valor total da Nota: R$', Valor_total_da_nota,
                              '<br>Data de Emissão: ', Data_de_emissao,
                              '<br>Similaridade com o NCM: ', Metrica
                ),
                hoverinfo = 'text')  %>%
        layout(xaxis = list(title = input$busca, showticklabels = FALSE),
               yaxis = list(title = 'Valor unitário em Reais'))

    } else{
      return (NULL)
    }
    
  })
  
  output$table <- renderDataTable(arrange(dados_nfe() %>% 
                                            filter(Unid_prod == input$select_unid, Confiavel == FALSE) %>% 
                                            select(-c(Unid_prod, NCM_prod)), 
                                          desc(Metrica)),
                                  options = list(scrollX = TRUE, pageLength = 10))

}
