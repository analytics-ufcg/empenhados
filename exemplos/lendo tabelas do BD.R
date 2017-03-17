library(dplyr)
library(stringr)

sagres <- src_mysql('sagres', group='ministerio-publico', password=NULL)

query <- sql('
  SELECT *
  FROM licitacao
  WHERE de_Obs REGEXP "merenda"
')

licitacoes <- tbl(sagres, query) %>%
  compute(name = 'lm') %>%
  collect()

query <- sql('
  SELECT *
  FROM contratos
  WHERE (cd_UGestora, nu_Licitacao, tp_Licitacao) IN
    (SELECT cd_UGestora, nu_Licitacao, tp_Licitacao FROM lm)
')

contratos <- tbl(sagres, query) %>%
  collect()

query <- sql('
  SELECT *
  FROM participantes
  WHERE (cd_UGestora, nu_Licitacao, tp_Licitacao) IN
    (SELECT cd_UGestora, nu_Licitacao, tp_Licitacao FROM lm)
')

participantes <- tbl(sagres, query) %>%
  compute(name = 'pm') %>%
  collect()

query <- sql('
  SELECT *
  FROM fornecedores
  WHERE (cd_UGestora, nu_CPFCNPJ) IN
    (SELECT cd_UGestora, nu_CPFCNPJ FROM pm)
')

fornecedores <- tbl(sagres, query) %>%
  collect()

#---------------------------------------------------------------------------

utils <- src_mysql('utils', group='ministerio-publico', password=NULL)

municipios <- tbl(utils, 'municipio') %>%
  collect()

get.municipio <- function(cd_UGestora) {
  result <- data.frame(cd_Municipio = str_sub(cd_UGestora, -3)) %>%
    merge(municipios)

  return(result$de_Municipio)
}