server <- function(input, output, session){
  
  ncm_input <- reactive({
    str_sub(input$busca, 1, 8)
  })
  
  dados_nfe <- reactive({
    ncm_input = ncm_input()
    
    tbl(src_mysql('notas_fiscais', group='ministerio-publico', password=NULL), 'nota_fiscal') %>%
      filter(ncm_input == NCM_prod) %>%
      select(Valor_unit_prod, NCM_prod, Descricao_do_Produto_ou_servicos, Nome_razao_social_emit, Nome_razao_social_dest, Valor_total_da_nota, Unid_prod) %>%
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
    
    mediana_total = median(dados_nfe$Valor_unit_prod)
    
    dados_nfe %>%
      plot_ly(x = ~Valor_total_da_nota, y = ~Valor_unit_prod, type = "scatter", mode = "markers", 
              text = ~paste('Descrição: ', Descricao_do_Produto_ou_servicos,
                            '<br>Emitente: ', Nome_razao_social_emit,
                            '<br>Destino: ', Nome_razao_social_dest,
                            '<br>Valor Unitário: R$', Valor_unit_prod,
                            '<br>Valor total da Nota: R$', Valor_total_da_nota
              ),
              hoverinfo = 'text', name = 'Valor Unitário') %>%
      layout(xaxis = list(type = 'log', title = 'Valor total em Reais (log)'),
             yaxis = list(title = 'Valor unitário em Reais'))
  })
  
  
  output$table <- renderDataTable(dados_nfe() %>% filter(Unid_prod == input$select_unid) %>% select(-c(Unid_prod, NCM_prod)),
                                  options = list(scrollX = TRUE, pageLength = 10))

}