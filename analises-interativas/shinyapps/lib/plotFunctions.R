# Ações:  Tipo de uso: consumo de informação > apresentação
#         Tipo de consulta: navegação
#         Tipo de busca: sumarização
#
# Alvo:   Distribuição
fornecedores_ncms <- function(dados, event){
  library(plotly)
  
  forn_mais_atipicos <- dados %>%
    distinct(CNPJ, Atipicidade_media, forn_selected) %>%
    arrange(desc(Atipicidade_media)) %>%
    head(75)
  
  if (is.null(event)) {
    grafico <- dados %>%
      semi_join(forn_mais_atipicos) %>%
      arrange(desc(Atipicidade_media)) %>%
      plot_ly(source = "A") %>%
      add_markers(x = ~reorder(CNPJ, -Atipicidade_media),
                  y = ~Atipicidade,
                  key = ~NCM_prod,
                  type = "scatter",
                  mode = "markers",
                  hoverinfo = "text",
                  text = ~paste("Fornecedor:", Razao_Social, "<br>",
                                "CNPJ:", CNPJ, "<br>",
                                "NCM:", NCM_prod, "<br>",
                                "Atipicidade média:", round(Atipicidade_media, 2), "<br>",
                                "Atipicidade no NCM:", round(Atipicidade, 2), "<br>")) %>%
      layout(title = "Fornecedores de Maior Atipicidade",
             xaxis = list(title = "Clique em um fornecedor", showticklabels = FALSE),
             yaxis = list(fixedrange = TRUE, rangemode = "nonnegative"))
  } else {
    grafico <- dados %>%
      semi_join(forn_mais_atipicos) %>%
      arrange(desc(Atipicidade_media)) %>%
      mutate(forn_selected = if_else(CNPJ == event$x & NCM_prod == event$key, "Selecionado", "Demais")) %>%
      plot_ly(source = "A") %>%
      add_markers(x = ~reorder(CNPJ, -Atipicidade_media),
                  y = ~Atipicidade,
                  key = ~NCM_prod,
                  color = ~forn_selected,
                  colors = c("#3498DB", "#FF0000"),
                  type = "scatter",
                  mode = "markers",
                  hoverinfo = "text",
                  showlegend = FALSE,
                  text = ~paste("Fornecedor:", Razao_Social, "<br>",
                                "CNPJ:", CNPJ, "<br>",
                                "NCM:", NCM_prod, "<br>",
                                "Atipicidade média:", round(Atipicidade_media, 2), "<br>",
                                "Atipicidade no NCM:", round(Atipicidade, 2), "<br>")) %>%
      layout(title = "Fornecedores de Maior Atipicidade",
             xaxis = list(title = "Clique em um fornecedor", showticklabels = FALSE),
             yaxis = list(fixedrange = TRUE, rangemode = "nonnegative"))
  }
  return(grafico)
}

fornecedores_ncm_facet <- function(dados, ncm) {
  library(plotly)
  
  descricao <- levels(as.factor(nfe$Descricao))
  
  dados <- dados %>%
    filter(NCM_prod == ncm) %>%
    group_by(CPF_CNPJ_emit, Unid_prod) %>%
    summarise(Nome_razao_social_emit = first(Nome_razao_social_emit), preco_medio = mean(Valor_unit_prod)) %>% 
    mutate(tipo = ifelse(preco_medio > quantile(preco_medio, .75) + IQR(preco_medio) * 1.5, 
                         "Sobrepreço", "Preço típico")) %>%
    ungroup()
  
  p1 <- dados %>% 
    filter(tipo == "Sobrepreço") %>% 
    plot_ly(source = "B") %>% 
    add_trace(x = ~preco_medio, y = ~Nome_razao_social_emit, key = ~CPF_CNPJ_emit, type= "scatter", mode = "markers", color = I('#FF0000'),
              text = ~paste("Fornecedor:", Nome_razao_social_emit,
                            "<br> Preço Médio: ", round(preco_medio, 2)),
              hoverinfo = "text",
              xaxis = ~paste0("x", Unid_prod))
  
  p2 <- dados %>% 
    plot_ly(source = "B") %>% 
    add_trace(x = ~preco_medio, type = "box", name = "Todos",
              key = ~CPF_CNPJ_emit,
              hoverinfo = "x",
              line = list(color = 'rgb(9,56,125)'),
              xaxis = ~paste0("x", Unid_prod)
    )
  
  grafico <- subplot(p1, p2, nrows = 2, shareX = TRUE, shareY = FALSE) %>% 
    layout(title = ~paste("Preço médio para vendas com NCM", ncm),
           yaxis = list(title = "Fornecedores atípicos",  showticklabels = FALSE),
           xaxis = list(title = paste(descricao, " <br>", "Unidade: ", unidade)), 
           margin = list(b = 80),
           showlegend = FALSE)
  
  return(grafico)
}

fornecedores_ncm <- function(dados, ncm, unidade){
  library(plotly)
  
  descricao <- levels(as.factor(dados$Descricao))
  
  dados <- dados %>%
    filter(NCM_prod == ncm, Unid_prod == unidade) %>% 
    
    group_by(CPF_CNPJ_emit, forn_selected) %>%
    summarise(Nome_razao_social_emit = first(Nome_razao_social_emit),
              preco_medio = mean(Valor_unit_prod)) %>% 
    ungroup() %>% 
    
    mutate(tipo = ifelse(preco_medio > quantile(preco_medio, .75) + IQR(preco_medio) * 1.5, 
                         "Sobrepreço", "Preço típico"))
  
  p1 <- dados %>% 
    filter(tipo == "Sobrepreço") %>% 
    plot_ly(source = "B") %>% 
    add_trace(x = ~preco_medio, y = ~Nome_razao_social_emit, key = ~CPF_CNPJ_emit, type= "scatter", mode = "markers", 
              color = ~forn_selected, colors = c("#FF0000", "#3498DB"),
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
    layout(title = ~paste("Preço médio para vendas com NCM", ncm),
           yaxis = list(title = "Fornecedores atípicos",  showticklabels = FALSE),
           xaxis = list(title = paste(descricao, " <br>", "Unidade: ", unidade)), 
           margin = list(b = 80))
  
  return(grafico)
  
}



# Ações:  Tipo de uso: consumo de informação > apresentação
#         Tipo de consulta: navegação
#         Tipo de busca: identificar
#
# Alvo:   Pontos extremos
fornecedor_ncm_compradores <- function(dados, cnpj_fornecedor, ncm, unidade){
  library(plotly)
  
  grafico <- dados %>%
    filter(CPF_CNPJ_emit == cnpj_fornecedor, NCM_prod == ncm) %>%
    plot_ly(source = "C") %>%
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

fornecedores_ncm_unidades <- function(dados, ncm){
  library(plotly)
  
  descricao <- levels(as.factor(dados$Descricao))
  
  dados <- dados %>%
    group_by(CPF_CNPJ_emit, forn_selected, Unid_prod) %>%
    summarise(Nome_razao_social_emit = first(Nome_razao_social_emit),
              preco_medio = mean(Valor_unit_prod)) %>% 
    ungroup() %>% 
    
    group_by(Unid_prod) %>% 
    mutate(tipo = ifelse(preco_medio > quantile(preco_medio, .75) + IQR(preco_medio) * 1.5, 
                           "Sobrepreço", "Preço típico")) %>% 
    mutate(tem_sobrepreco = ifelse(n_distinct(tipo) == 2, TRUE, FALSE)) %>% 
    ungroup()
  
  unidades <- dados %>% filter(tem_sobrepreco) %>% select(Unid_prod)
  unidades <- levels(as.factor(unidades$Unid_prod))
  
  list_scatter_sobrepreco <- map(unidades, function(x){
    
      p1 <- dados %>% 
        filter(Unid_prod == x, tipo == "Sobrepreço") %>% 
        mutate(color = ifelse(forn_selected == "Selecionado", "#FF0000", "#52B3D9")) %>% 
        
        plot_ly(source = "B") %>% 
        add_trace(x = ~preco_medio, y = ~CPF_CNPJ_emit, key = ~Unid_prod, type= "scatter", mode = "markers",
                  showlegend=FALSE,
                  marker = list(color = ~color),
                  text = ~paste("Fornecedor:", Nome_razao_social_emit,
                                "<br> Preço Médio: ", round(preco_medio, 2),
                                "<br> Unidade: ", x),
                  hoverinfo = "text") %>% 
        layout(yaxis = list(title = x, showticklabels = FALSE))
    
  })
  
  grafico_atipicos <- subplot(list_scatter_sobrepreco, nrows = length(unidades), shareX = TRUE, shareY = FALSE, titleY = TRUE) %>% 
    layout(title =  paste("Produto: ", descricao),
           titlefont=list(size = 14),
           xaxis = list(title = "Preço Médio para os fornecedores atípicos (R$)"),
           margin = list(t = 45))
  
  return(grafico_atipicos)
  
}

fornecedores_ncm_unidades_boxplot <- function(dados, ncm){
  library(plotly)
  
  descricao <- levels(as.factor(dados$Descricao))
  
  dados <- dados %>%
    group_by(CPF_CNPJ_emit, forn_selected, Unid_prod) %>%
    summarise(Nome_razao_social_emit = first(Nome_razao_social_emit),
              preco_medio = mean(Valor_unit_prod)) %>% 
    ungroup() %>% 
    
    group_by(Unid_prod) %>% 
    mutate(tipo = ifelse(preco_medio > quantile(preco_medio, .75) + IQR(preco_medio) * 1.5, 
                         "Sobrepreço", "Preço típico")) %>% 
    mutate(tem_sobrepreco = ifelse(n_distinct(tipo) == 2, TRUE, FALSE))
  
  unidades <- dados %>% filter(tem_sobrepreco) %>% select(Unid_prod)
  unidades <- levels(as.factor(unidades$Unid_prod))
  
  grafico <- dados %>%
    filter(Unid_prod %in% unidades) %>%
    
    plot_ly(source = "Z") %>%
    add_trace(x = ~preco_medio, color = ~Unid_prod, type = "box", name = " ", boxpoints = FALSE, 
              hoverinfo = "x") %>% 
    layout(title = "",
           xaxis = list(title = "Todos os fornecedores"),
           showlegend=FALSE,
           margin = list(t = 50))

  return(grafico)
  
}
