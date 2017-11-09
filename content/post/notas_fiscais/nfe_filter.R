library(dplyr)
library(readr)

notas <-  src_mysql('notas_fiscais', group='ministerio-publico', password=NULL)

nfe_bd <- tbl(src_mysql('notas_fiscais', group='ministerio-publico', password=NULL), 'nota_fiscal') %>%
  #select(Chave_de_acesso, Nr_item, Descricao_do_Produto_ou_servicos, NCM_prod, Unid_prod) %>%
  collect(n = Inf)

write_csv(nfe_bd, "nfe_small.csv")

nfe_csv <- read.csv("nfe_small.csv", stringsAsFactors = FALSE,  colClasses=c("Chave_de_acesso"="character"))



