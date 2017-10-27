# Ações:  Tipo de uso: consumo de informação > apresentação
#         Tipo de consulta: navegação
#         Tipo de busca: sumarização
#
# Alvo:   Distribuição
fornecedores_ncm <- function(dados){
  library(plotly)
  
  grafico <- dados %>%
    arrange(desc(Atipicidade_media)) %>%
    head(200) %>%
    plot_ly() %>%
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
           yaxis = list(fixedrange = TRUE))
    
  return(grafico)
  
}

fornecedor_ncm <- function(){
  
}

fornecedor_ncm_compradores <- function(){
  
}