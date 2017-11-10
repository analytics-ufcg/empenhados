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
  
  dados_fornecedores_ncms <- read_csv("../../dados/fornecedores_ncms.csv",
                                      locale = locale(encoding = "latin1"))
  
  # É necessário ter o csv com a tabela nfe
  #nfe_confiavel <- read_csv("../../dados/nfe_confiavel.csv", locale = locale(encoding = "latin1"))
  
  output$scatter1 <- renderPlotly({
    fornecedores_ncms(dados_fornecedores_ncms)
  })
  

  output$scatter_boxplot <- renderPlotly({
    event.data <- event_data("plotly_click", source = "A")
    
    event.data <<- event.data
    
    if(is.null(event.data) == T) return(NULL)
    
    forn_selec <- dados_fornecedores_ncms %>%
      filter(CNPJ == event.data$x, round(Atipicidade, 3) == round(event.data$y, 3))
    
    forn_selec <<- forn_selec
    
    notas <-  src_mysql('notas_fiscais', group='ministerio-publico', password=NULL)
    
    template <- ('
    SELECT Valor_unit_prod, NCM_prod, Descricao_do_Produto_ou_servicos, Nome_razao_social_emit, 
                  CPF_CNPJ_emit, Nome_razao_social_dest, CPF_CNPJ_dest, Valor_total_da_nota, 
                  Data_de_emissao, Unid_prod, Metrica
    FROM nota_fiscal
    WHERE NCM_prod = "%s" AND Confiavel = "TRUE"
  ')
    
    query <- template %>%
      sprintf(forn_selec$NCM_prod) %>%
      sql()
    
    nfe <- tbl(notas, query) %>%
      collect(n = Inf) 
    
    nfe <<- nfe
    
    unidade <- nfe %>%
      group_by(Unid_prod) %>%
      summarise(n = n())
    
    unid_max <- unidade %>%
      filter(n == max(n))

    fornecedores_ncm(nfe, forn_selec$NCM_prod, unid_max$Unid_prod)

  })
  
  output$scatter_vendas <- renderPlotly({
    event.data_vendas <- event_data("plotly_click", source = "B")
    
    event.data_vendas <<- event.data_vendas
    
    if(is.null(event.data_vendas) == T) return(NULL)
    
    nfe_vendas <- nfe %>% 
      filter(CPF_CNPJ_emit == event.data_vendas$key) %>% 
      group_by(CPF_CNPJ_emit, CPF_CNPJ_dest, Unid_prod) %>% 
      summarise(Nome_razao_social_emit = first(Nome_razao_social_emit),
                Nome_razao_social_dest = first(Nome_razao_social_dest),
                NCM_prod = first(NCM_prod),
                Preco_medio = mean(Valor_unit_prod))

    fornecedor_ncm_compradores(nfe_vendas, event.data_vendas$key, levels(as.factor(nfe$NCM_prod)), unid_max$Unid_prod)
  })
  
  output$tabela <- renderDataTable({
    
    event.data2 <- event_data("plotly_click", source = "B")
    
    if(is.null(event.data2) == T) return(NULL)
    
    nfe %>%
      filter(Nome_razao_social_emit == event.data2$y)
    
  })
  
  output$messageMenu <- renderMenu({
    notification = notificationItem(text = "O que é atipicidade?",
                           icon("info"),
                           status = "success",
                           href="#")
    notification$children[[1]]=a(href="#","onclick"=paste0("clickFunction('","notify","'); return false;"),notification$children[[1]]$children)
    
    dropdownMenu(type = "messages", icon = icon("info"), headerText = "Atipicidade", badgeStatus = "success",
                   notification
                 )
  })
  
  observeEvent(input$linkClicked == "atipica",{
    showNotification("A atipicidade de um fornecedor para um NCM é calculada considerando a distância normalizada entre o preço 
                    médio praticado pelo fornecedor e o maior preço médio
                    que não é classificado como ponto extremo. As atipicidades mínimas, médias e máximas
                    utilizadas acima são sumarizações da atipicidade calculada nos NCM's em que 
                    o fornecedor atua.", duration = NULL)
    
  })

}
