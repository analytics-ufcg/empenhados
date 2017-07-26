load_licitantes_merenda <- function() {
  
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

  licitacoes <- empenhos %>%
    group_by(cd_UGestora, nu_Licitacao, tp_Licitacao) %>%
    summarise(total_empenhos = n())
  
  query <- sql('
    SELECT *
    FROM Participantes
  ')
  
  participantes <- tbl(sagres, query) %>%
    collect(n = Inf)
  
  query <- sql('
    SELECT nu_CPFCNPJ, no_Fornecedor
    FROM Fornecedores
  ')
  
  fornecedores <- tbl(sagres, query) %>%
    collect(n = Inf) %>%
    distinct(nu_CPFCNPJ, .keep_all = TRUE)
    
  get.municipio <- function(cd_UGestora) {
    result <- data.frame(
      cd_Municipio = str_sub(cd_UGestora, -3)) %>%
      left_join(municipios)
    return(result$de_Municipio)
  }
  
  licitacoes <- licitacoes %>%
    mutate(de_Municipio = get.municipio(cd_UGestora))
  
  participacoes <- participantes %>%
    merge(licitacoes, by=c('cd_UGestora', 'tp_Licitacao', 'nu_Licitacao'), all.x=T) %>%
    group_by(nu_CPFCNPJ) %>%
    summarise(
      participou = n(),
      municipios = n_distinct(de_Municipio))
  
  vitorias <- empenhos %>%
    mutate(de_Municipio = get.municipio(cd_UGestora)) %>%
    group_by(cd_Credor) %>%
    summarise(ganhou = n_distinct(cd_UGestora, nu_Licitacao, tp_Licitacao),
              municipios_vitorias = n_distinct(de_Municipio),
              valor_total_emp = sum(vl_Empenho),
              valor_mediana_emp = median(vl_Empenho),
              valor_total_pag = sum(total_pag, na.rm = TRUE)) %>%
    left_join(empenhos %>% group_by(cd_Credor, no_Credor) %>% distinct(cd_Credor), by = "cd_Credor")
  
  vitorias <- vitorias %>%
    distinct(cd_Credor, .keep_all = TRUE) %>%
    filter(cd_Credor != '00000000000000')
  
  licitantes <- participacoes %>%
    left_join(vitorias, by = c('nu_CPFCNPJ' = 'cd_Credor')) %>%
    select(-no_Credor)
  
  licitantes <- licitantes %>%
    mutate(ganhou = ifelse(is.na(ganhou), 0, ganhou), 
           valor_total_emp = ifelse(is.na(valor_total_emp), 0, valor_total_emp),
           valor_mediana_emp = ifelse(is.na(valor_mediana_emp), 0, valor_mediana_emp),
           valor_total_pag = ifelse(is.na(valor_total_pag), 0, valor_total_pag))
  
  licitantes <- licitantes %>%
    mutate(ganhou = ganhou/participou) %>%
    filter(
      is.finite(ganhou),
      nu_CPFCNPJ != '00000000000000')
  
  licitantes <- licitantes %>%
    left_join(fornecedores, by = c("nu_CPFCNPJ")) %>%
    filter(!is.na(no_Fornecedor)) %>%
    select(-municipios_vitorias)
  
  return(list(licitantes = licitantes, vitorias = vitorias))
}