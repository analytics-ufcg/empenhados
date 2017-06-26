load_licitantes_merenda <- function() {
  
  library(methods)
  library(dplyr)
  library(stringr)
  library(rsagrespb)
  
  sagres = src_mysql('SAGRES_MUNICIPAL', group='ministerio-publico', password=NULL)
  utils = src_mysql('utils', group='ministerio-publico', password=NULL)

  municipios = tbl(utils, 'municipio') %>%
    collect()

  empenhos <- get_empenhos_filtrados(sagres, cd_funcao = 12, cd_subfuncao = 306, cd_subelemento = 02) %>%
    collect(n = Inf)
  
  licitacoes <- empenhos %>%
    group_by(cd_UGestora, nu_Licitacao, tp_Licitacao) %>%
    summarise(total_empenhos = n())
  
  query <- sql('
    SELECT *
    FROM Participantes
  ')
  
  participantes <- tbl(sagres, query) %>%
    collect(n = Inf)
  
  licitacoes <- licitacoes %>%
    mutate(de_Municipio = get.municipio(cd_UGestora))
  
  participacoes <- participantes %>%
    merge(licitacoes, by=c('cd_UGestora', 'tp_Licitacao', 'nu_Licitacao'), all.x=T) %>%
    group_by(nu_CPFCNPJ) %>%
    summarise(
      participou = n(),
      municipios = n_distinct(de_Municipio))
  
  vitorias <- empenhos %>%
    group_by(cd_Credor) %>%
    summarise(ganhou = n_distinct(cd_UGestora, nu_Licitacao, tp_Licitacao),
              valor_total_emp = sum(vl_Empenho),
              mediana_total_emp = median(vl_Empenho))
  
  vitorias <- vitorias %>%
    left_join(empenhos %>% select(cd_Credor, no_Credor), by = "cd_Credor")%>%
    distinct(cd_Credor, .keep_all = TRUE)
    
  ### O código abaixo ainda não foi alterado considerando a nova base de dados ###
    
  query <- sql('
    SELECT c.*
    FROM contratos c
    INNER JOIN lm
    USING (cd_UGestora, nu_Licitacao, tp_Licitacao)
  ')

  contratos <- tbl(sagres, query) %>%
    compute(name = 'cm') %>%
    collect()

  query <- sql('
    SELECT DISTINCT a.*
    FROM aditivos a
    INNER JOIN cm
    USING (cd_UGestora, nu_Contrato)
  ')

  aditivos <- tbl(sagres, query) %>%
    collect()

  query <- sql('
    SELECT p.*
    FROM Participantes p
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
      total = sum(vl_Licitacao),
      mediana = median(vl_Licitacao),
      municipios = n_distinct(de_Municipio))

  vitorias <- contratos %>%
    group_by(nu_CPFCNPJ) %>%
    summarise(
      ganhou = n(),
      total_ganho = sum(vl_TotalContrato))

  aditivacoes <- contratos %>%
    select(cd_UGestora, nu_Contrato, nu_CPFCNPJ) %>%
    merge(aditivos) %>%
    group_by(nu_CPFCNPJ) %>%
    summarise(
      aditivos = n())

  licitantes <- fornecedores %>%
    distinct(nu_CPFCNPJ) %>%
    merge(participacoes, all=T) %>%
    merge(vitorias, all=T) %>%
    merge(aditivacoes, all=T)

  licitantes[is.na(licitantes)] <- 0
  
  nomefornecedores <- fornecedores %>%
    select(c(nu_CPFCNPJ, no_Fornecedor)) %>%
    distinct(nu_CPFCNPJ, .keep_all = TRUE)
  
  licitantes <- licitantes %>%
    left_join(nomefornecedores, by = c("nu_CPFCNPJ" = "nu_CPFCNPJ"))

  licitantes <- licitantes %>%
    mutate(
      aditivos = ifelse(is.nan(aditivos/ganhou), 0, aditivos/ganhou),
      ganhou = ganhou/participou) %>%
    filter(
      is.finite(ganhou),
      nu_CPFCNPJ != '00000000000000')

  return(licitantes)
}