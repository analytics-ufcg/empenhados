server <- function(input, output, session){
  
  ncm_input <- reactive({
    str_sub(input$busca, 1, 8)
  })
  
  dados_nfe <- reactive({
    ncm_input = ncm_input()
    
    template <- ('
    SELECT Valor_unit_prod, NCM_prod, Descricao_do_Produto_ou_servicos, Nome_razao_social_emit, Nome_razao_social_dest, 
                  Valor_total_da_nota, Unid_prod
    FROM nota_fiscal_melhor
    WHERE NCM_prod = %s
  ')
    
    query <- template %>%
      sprintf(ncm_input) %>%
      sql()
    
    tbl(src_mysql('notas_fiscais', group='ministerio-publico', password=NULL), query) %>%
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
      filter(Unid_prod == input$select_unid)
    
    quantile = quantile(dados_nfe$Valor_unit_prod, probs = c(0.9))
    
    dados_nfe %>%
      mutate(dummy = seq(nrow(dados_nfe))) %>% 
      mutate(atipico = ifelse(Valor_unit_prod > quantile, "Atípico", "Típico")) %>% 
      plot_ly(x = ~dummy, y = ~Valor_unit_prod, type = "scatter", mode = "markers", color = ~atipico,
              text = ~paste('Descrição: ', Descricao_do_Produto_ou_servicos,
                            '<br>Emitente: ', Nome_razao_social_emit,
                            '<br>Destino: ', Nome_razao_social_dest,
                            '<br>Valor Unitário: R$', Valor_unit_prod,
                            '<br>Valor total da Nota: R$', Valor_total_da_nota
              ),
              hoverinfo = 'text')  %>%
      layout(xaxis = list(title = input$busca, showticklabels = FALSE),
             yaxis = list(title = 'Valor unitário em Reais'))
  })
  
  output$table <- renderDataTable(dados_nfe() %>% filter(Unid_prod == input$select_unid) %>% select(-c(Unid_prod, NCM_prod)),
                                  options = list(scrollX = TRUE, pageLength = 10))

}