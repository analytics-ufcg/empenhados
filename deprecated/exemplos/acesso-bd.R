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

# Prepara queries em cima dos dados, mas não as executa
q1 <- licitacao %>%
  filter(dt_Ano >= 2016) %>%
  select(cd_UGestora, vl_Licitacao)

q2 <- sql('
  SELECT c.*
  FROM contratos c
  INNER JOIN tmp
  USING (cd_UGestora)
  WHERE dt_Ano >= 2016
')

# Imprime o código SQL que foi preparado, caso necessário
explain(q1)

# Cria uma tabela temporária a partir da query
q1 <- compute(q1, name = 'tmp')

# Efetivamente executa as queries
r1 <- collect(q1)
r2 <- tbl(sagres, q2) %>% collect()
