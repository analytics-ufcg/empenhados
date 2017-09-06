library(dplyr)
library(readr)

notas <-  src_mysql('notas_fiscais', group='ministerio-publico', password=NULL)

nfe <- tbl(src_mysql('notas_fiscais', group='ministerio-publico', password=NULL), 'nota_fiscal_melhor') %>%
  #select(Chave_de_acesso, Nr_item, Descricao_do_Produto_ou_servicos, NCM_prod, Unid_prod) %>%
  collect(n = Inf)

write.csv(nfe, "nfe_small.csv", row.names = FALSE)

nfe_csv <- read.csv("nfe_small.csv", encoding = "utf8")



