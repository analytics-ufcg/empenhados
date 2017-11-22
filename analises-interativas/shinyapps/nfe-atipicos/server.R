server <- function(input, output, session){
  library(lubridate)
  
  set.seed(123)
  options(warn = -1)
  
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
  
  updateSelectizeInput(session, "busca", choices = ncm[["Descricao"]], server = TRUE, selected = "10064000 - ARROZ QUEBRADO")
  
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
      filter(Unid_prod == input$select_unid, Confiavel == TRUE) %>%
      mutate(Data_de_emissao = ymd_hms(Data_de_emissao))
    
    tryCatch(
      dados_nfe %>%
        mutate(atipico = ifelse(t.test(Valor_unit_prod, alternative = 'less', conf.level = 0.99)$conf.int[2] < Valor_unit_prod, "Atípico", "Típico"),
               Metrica = round(Metrica, 3)) %>%
        #resolve a situação onde os níveis da variável 'atipico' não aparecem na legenda
        bind_rows(data.frame(
          Valor_unit_prod = c(Inf, Inf), 
          NCM_prod = input$select_unid, 
          Descricao_do_Produto_ou_servicos = c(NA, NA), 
          Nome_razao_social_emit = c(NA, NA), 
          Nome_razao_social_dest = c(NA, NA), 
          Valor_total_da_nota = c(NA, NA), 
          Data_de_emissao = ymd_hms("2016-01-01 00:00:00"),
          Unid_prod = c(NA, NA),
          Metrica = c(NA, NA),
          Confiavel = TRUE,
          atipico = c("Atípico", "Típico")
        )) %>%
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
        layout(title = input$busca,
               xaxis = list(title = "Mês" ),
               yaxis = list(title = 'Valor unitário em Reais'),
               color = list(drop = FALSE),
               margin = list(t = 30, b = 50)),
      
      error = function(e) { plot_ly() }
    )
    
  })
  
  output$table <- renderDataTable(arrange(dados_nfe() %>% 
                                            filter(Unid_prod == input$select_unid, Confiavel == FALSE) %>% 
                                            select(-c(Unid_prod, NCM_prod)), 
                                          desc(Metrica)),
                                  options = list(scrollX = TRUE, pageLength = 10))
  
  output$down_csv <- downloadHandler(
    filename = function(){
      paste("exportnfe-", ncm_input(), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(dados_nfe() %>% mutate_all(funs(as.character(.))),
                file, row.names = F)
    },
    contentType = "text/csv"
  )

}
