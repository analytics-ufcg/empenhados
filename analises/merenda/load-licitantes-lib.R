load_licitantes <- function(){
  sagres = src_mysql('sagres', group='ministerio-publico', password=NULL)
  utils = src_mysql('utils', group='ministerio-publico', password=NULL)
  
  municipios = tbl(utils, 'municipio') %>%
    collect()
  
  municipios$de_Municipio[199] = 'Sao Vicente do Serido'
  
  query <- sql('
               SELECT *
               FROM licitacao
               WHERE de_Obs REGEXP "merenda" AND 
               dt_Ano >= 2011 AND dt_Ano <= 2015
               ')
  
  licitacoes_fornecedor <- tbl(sagres, query) %>%
    compute(name = 'lm') %>%
    collect()
  
  query <- sql('
               SELECT c.*
               FROM contratos c
               INNER JOIN lm
               USING (cd_UGestora, nu_Licitacao, tp_Licitacao)
               ')
  
  contratos <- tbl(sagres, query) %>%
    collect()
  
  
  query <- sql('
               SELECT p.*
               FROM participantes p
               INNER JOIN lm
               USING (cd_UGestora, nu_Licitacao, tp_Licitacao)
               ')
  
  participantes <- tbl(sagres, query) %>%
    compute(name = 'pm') %>%
    collect()
  
  query <- sql('
               SELECT DISTINCT f.*
               FROM fornecedores f
               INNER JOIN pm
               USING (cd_UGestora, nu_CPFCNPJ)
               ')
  
  fornecedores <- tbl(sagres, query) %>%
    collect()
  
  # Adicionando o nome dos municípios nos dados de fornecedores
  fornecedores$cd_Municipio <- substr(as.character(fornecedores$cd_UGestora), 4, 6)
  fornecedores <- merge(fornecedores, municipios, by = 'cd_Municipio')
  
  fornecedores$Nome_Munic <- fornecedores$de_Municipio.y
  fornecedores$de_Municipio.y <- NULL
  
  # Adicionando o nome dos municipios nos dados de licitacoes_fornecedor
  licitacoes_fornecedor$cd_Municipio <- substr(as.character(licitacoes_fornecedor$cd_UGestora), 4, 6)
  licitacoes_fornecedor <- merge(licitacoes_fornecedor, municipios, by = 'cd_Municipio')
  
  licitacoes_fornecedor$Nome_Munic <- licitacoes_fornecedor$de_Muninipio.y
  licitacoes_fornecedor$de_Municipio.y <- NULL
  
  #paraiba = licitacoes_merenda %>% inner_join(mapa_paraiba@data, c('de_Municipio' = 'Nome_Munic'))
  #cd_UGestora, nu_Licitacao, tp_Licitacao)
  participantes <- participantes %>%
    inner_join(licitacoes_fornecedor %>%
                 select(cd_UGestora, nu_Licitacao, tp_Licitacao, vl_Licitacao), 
               c('cd_UGestora' = 'cd_UGestora', 'nu_Licitacao' = 'nu_Licitacao', 'tp_Licitacao' = 'tp_Licitacao')) 
  
  participacoes <- participantes %>%
    group_by(nu_CPFCNPJ) %>%
    summarise(participou = n(),
              valor_participou_total = sum(vl_Licitacao),
              valor_participou_medio = mean(vl_Licitacao))
  
  vitorias <- contratos %>%
    group_by(nu_CPFCNPJ) %>%
    summarise(
      ganhou = n(),
      valor = sum(vl_TotalContrato),
      valor_medio = mean(vl_TotalContrato))
  
  licitantes <- fornecedores %>%
    distinct(nu_CPFCNPJ) %>%
    merge(participacoes, all=T) %>%
    merge(vitorias, all=T) %>%
    filter(nu_CPFCNPJ != '00000000000000')
  
  licitantes[is.na(licitantes)] <- 0
  
  licitantes <- licitantes %>%
    mutate(perdeu = participou-ganhou)
  
  return(licitantes)
  
}