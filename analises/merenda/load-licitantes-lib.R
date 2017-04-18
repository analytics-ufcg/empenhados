library(plyr)
library(dplyr)
library(stringr)

load_licitantes <- function() {
  sagres = src_mysql('sagres', group='ministerio-publico', password=NULL)
  utils = src_mysql('utils', group='ministerio-publico', password=NULL)

  municipios = tbl(utils, 'municipio') %>%
    collect()

  query <- sql('
    SELECT *
    FROM licitacao
    WHERE de_Obs REGEXP "merenda"
    AND dt_Ano BETWEEN 2011 AND 2015
  ')

  licitacoes <- tbl(sagres, query) %>%
    compute(name = 'lm') %>%
    collect()

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

  get.municipio <- function(cd_UGestora) {
    result <- data.frame(
      cd_Municipio = str_sub(cd_UGestora, -3)) %>%
      join(municipios)
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

  licitantes <- licitantes %>%
    mutate(ganhou = ganhou/participou) %>%
    filter(
      nu_CPFCNPJ != '00000000000000',
      is.finite(ganhou))

  return(licitantes)
}
