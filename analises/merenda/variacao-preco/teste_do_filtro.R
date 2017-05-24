library(dplyr)

sagres = src_mysql('sagres', group='ministerio-publico', password=NULL)

licitacoes_total = tbl(sagres, 'licitacao') %>%
  filter(dt_Ano >= 2010) %>%
  collect(n = Inf)

classificacao_licitacao = tbl(sagres, 'classificacao_licitacao') %>%
  collect(n = Inf)

licitacoes_total <- left_join(licitacoes_total, classificacao_licitacao, by = c("cd_UGestora", "nu_Licitacao", "tp_Licitacao"))

lics_desc <- subset(licitacoes_total, select = c("cd_UGestora", "nu_Licitacao", "tp_Licitacao", "de_Obs", "pr_EmpenhosMerenda"))

amostra_geral <- lics_desc[sample(nrow(lics_desc), 1000),]

amostra_lics_merenda <- subset(lics_desc, pr_EmpenhosMerenda > 0)
amostra_lics_merenda <- amostra_lics_merenda[sample(nrow(amostra_lics_merenda), 1000),]

