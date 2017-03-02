library(dplyr)

# Instancia conexão com o BD usando as configurações em ~/.my.cnf
sagres <- src_mysql('sagres', group='ministerio-publico', password=NULL)

# Lista as tabelas existentes
src_tbls(sagres)

# Inicia uma operação sobre uma tabela
licitacao <- tbl(sagres, 'licitacao')

# Recupera algumas linhas
head(licitacao)

# Descreve as colunas e seus valores
glimpse(licitacao)

# Prepara uma query em cima dos dados, mas não a executa
query <- licitacao %>%
  filter(dt_Ano >= 2016) %>%
  select(cd_UGestora, vl_Licitacao)

# Imprime o código SQL que foi preparado, caso necessário
explain(query)

# Efetivamente executa a query
result <- collect(query)
