# Ações:  Tipo de uso: consumo de informação > apresentação
#         Tipo de consulta: navegação
#         Tipo de busca: sumarização
#
# Alvo:   Distribuição
fornecedores_ncm <- function(dados){
  library(plotly)
  
  grafico <- dados %>%
    head(100) %>%
    plot_ly() %>%
    add_markers(x = ~CNPJ, y = ~Atipicidade, type = "scatter", mode = "markers")
    
  return(grafico)
  
}

fornecedor_ncm <- function(dados, titulo = ""){
  p1 <- dados %>% 
    filter(tipo == "Sobrepreço") %>% 
    plot_ly() %>% 
    add_trace(x = ~preco_medio, y = ~Nome_razao_social_emit, type= "scatter", mode = "markers", color = I('#FF0000'),
              text = ~paste("Fornecedor:", Nome_razao_social_emit,
                            "<br> Preço Médio: ", round(preco_medio, 2)),
              hoverinfo = "text")
  
  p2 <- dados %>% 
    plot_ly() %>% 
    add_trace(x = ~preco_medio, type = "box", name = "Todos",
              hoverinfo = "x",
              line = list(color = 'rgb(9,56,125)')
    )
  
  grafico <- subplot(p1, p2, nrows = 2, shareX = TRUE, shareY = FALSE) %>% 
    layout(title = titulo,
           yaxis = list(title = "Fornecedores atípicos",  showticklabels = FALSE),
           xaxis = list(title = 'Preço médio'), 
           showlegend = FALSE)
  
  return(grafico)
  
}

fornecedor_ncm_compradores <- function(){
  
}