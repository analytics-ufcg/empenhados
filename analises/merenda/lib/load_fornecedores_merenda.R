load_fornecedores_merenda <- function() {
  
  library(methods)
  library(dplyr)
  library(stringr)
  library(rsagrespb)
  
  sagres = src_mysql('SAGRES_MUNICIPAL', group='ministerio-publico-local', password=NULL)
  utils = src_mysql('utils', group='ministerio-publico-local', password=NULL)
  
  municipios = tbl(utils, 'municipio') %>%
    collect()
  
  empenhos <- get_empenhos_filtrados(sagres, cd_funcao = 12, cd_subfuncao = 306, cd_subelemento = "02") %>%
    collect(n = Inf)
  
  pagamentos <- get_pagamentos_filtrados(sagres, cd_funcao = 12, cd_subfuncao = 306, cd_subelemento = "02") %>%
    collect(n = Inf)
  
  pagamentos <- pagamentos %>%
    group_by(cd_UGestora, nu_Empenho, dt_Ano, cd_UnidOrcamentaria) %>%
    summarise(total_pag = sum(vl_Pagamento))
  
  empenhos <- empenhos %>%
    left_join(pagamentos, by = c("cd_UGestora", "nu_Empenho", "dt_Ano", "cd_UnidOrcamentaria"))
  
  get.municipio <- function(cd_UGestora) {
    result <- data.frame(
      cd_Municipio = str_sub(cd_UGestora, -3)) %>%
      left_join(municipios)
    return(result$de_Municipio)
  }
  
  vitorias <- empenhos %>%
    mutate(de_Municipio = get.municipio(cd_UGestora)) %>%
    group_by(cd_Credor, de_Municipio) %>%
    summarise(ganhou = n_distinct(cd_UGestora, nu_Licitacao, tp_Licitacao),
              valor_total_emp = sum(vl_Empenho),
              valor_mediana_emp = median(vl_Empenho),
              valor_total_pag = sum(total_pag, na.rm = TRUE)) %>%
    left_join(empenhos %>% group_by(cd_Credor, no_Credor) %>% distinct(cd_Credor), by = "cd_Credor")
  
  vitorias <- vitorias %>%
    distinct(cd_Credor, de_Municipio, .keep_all = TRUE) %>%
    filter(cd_Credor != '00000000000000')
  
  return(vitorias)
}