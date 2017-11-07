# Ações:  Tipo de uso: consumo de informação > apresentação
#         Tipo de consulta: navegação
#         Tipo de busca: sumarização
#
# Alvo:   Distribuição
fornecedores_ncms <- function(dados){
  library(plotly)
  
  forn_mais_atipicos <- dados %>%
    distinct(CNPJ, Atipicidade_media) %>%
    arrange(desc(Atipicidade_media)) %>%
    head(100)
    
  
  grafico <- dados %>%
    semi_join(forn_mais_atipicos) %>%
    arrange(desc(Atipicidade_media)) %>%
    plot_ly(source = "A") %>%
    add_markers(x = ~reorder(CNPJ, -Atipicidade_media),
                y = ~Atipicidade,
                type = "scatter",
                mode = "markers",
                hoverinfo = "text",
                text = ~paste("Fornecedor:", Razao_Social, "<br>",
                              "CNPJ:", CNPJ, "<br>",
                              "NCM:", NCM_prod, "<br>",
                              "Atipicidade média:", round(Atipicidade_media, 2), "<br>",
                              "Atipicidade no NCM:", round(Atipicidade, 2), "<br>")) %>%
    layout(xaxis = list(title = "Fornecedor", showticklabels = FALSE),
           yaxis = list(fixedrange = TRUE, rangemode = "nonnegative"))
    
  return(grafico)
  
}



fornecedores_ncm <- function(dados, ncm, unidade){
  library(plotly)
  
  dados <- dados %>%
    filter(NCM_prod == ncm, Unid_prod == unidade) %>% 
    group_by(Nome_razao_social_emit) %>%
    summarise(preco_medio = mean(Valor_unit_prod)) %>% 
    mutate(tipo = ifelse(preco_medio > quantile(preco_medio, .75) + IQR(preco_medio) * 1.5, 
                         "Sobrepreço", "Preço típico")) %>%
    ungroup()
  
  p1 <- dados %>% 
    filter(tipo == "Sobrepreço") %>% 
    plot_ly(source = "B") %>% 
    add_trace(x = ~preco_medio, y = ~Nome_razao_social_emit, type= "scatter", mode = "markers", color = I('#FF0000'),
              text = ~paste("Fornecedor:", Nome_razao_social_emit,
                            "<br> Preço Médio: ", round(preco_medio, 2)),
              hoverinfo = "text")
  
  p2 <- dados %>% 
    plot_ly(source = "B") %>% 
    add_trace(x = ~preco_medio, type = "box", name = "Todos",
              hoverinfo = "x",
              line = list(color = 'rgb(9,56,125)')
    )
  
  grafico <- subplot(p1, p2, nrows = 2, shareX = TRUE, shareY = FALSE) %>% 
    layout(title = ~paste("Vendas com NCM", ncm),
           yaxis = list(title = "Fornecedores atípicos",  showticklabels = FALSE),
           xaxis = list(title = 'Preço médio'), 
           showlegend = FALSE)
  
  return(grafico)
  
}


# Ações:  Tipo de uso: consumo de informação > apresentação
#         Tipo de consulta: navegação
#         Tipo de busca: identificar
#
# Alvo:   Pontos extremos
fornecedor_ncm_compradores <- function(dados, cnpj_fornecedor, ncm, unidade){
  library(plotly)
  
  dados <- dados %>%
    filter(CPF_CNPJ_emit == cnpj_fornecedor, NCM_prod == ncm) %>%
    plot_ly() %>%
    add_trace(x = ~reorder(CPF_CNPJ_dest, -Preco_medio), y = ~Preco_medio,
              type = "scatter", mode = "markers",
              hoverinfo = "text",
              text = ~paste(
                "Comprador:", Nome_razao_social_dest, "<br>",
                "CNPJ:", CPF_CNPJ_dest, "<br>",
                "Unidade:", Unid_prod, "<br>",
                "Preço Médio: R$", round(Preco_medio, 2))) %>%
    layout(title = ~paste("Vendas com NCM", NCM_prod,
                          "efetuadas por", "<br>", Nome_razao_social_emit, "<br>",
                          "(", CPF_CNPJ_emit, ")"),
           xaxis = list(title = "Comprador", showTickLabels = FALSE),
           yaxis = list(title = "Preço Médio (R$)", range = c(0, ~max(Preco_medio) * 1.2)),
           margin = list(l = 50))
    
  return(grafico)
}