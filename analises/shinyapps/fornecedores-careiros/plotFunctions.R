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

fornecedor_ncm <- function(){
  
}

fornecedor_ncm_compradores <- function(){
  
}