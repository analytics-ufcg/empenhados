library(dplyr)

notas <-  src_mysql('notas_fiscais', group='ministerio-publico', password=NULL)

dados_careiros_all <- tbl(notas, 'nota_fiscal') %>%
  select(c(
    Valor_unit_prod, NCM_prod, CPF_CNPJ_dest,
    CPF_CNPJ_emit, Unid_prod, Confiavel)) %>%
  filter(Confiavel == 'TRUE') 

dados_careiros <- dados_careiros_all %>%
  group_by(NCM_prod, CPF_CNPJ_emit, Unid_prod) %>%
  summarise(Preco_medio = mean(Valor_unit_prod)) %>%
  ungroup() %>%
  collect()

dcg_nomes_emit <- tbl(notas, 'nota_fiscal') %>%
  select(CPF_CNPJ_emit, Nome_razao_social_emit) %>%
  collect() %>%
  distinct(CPF_CNPJ_emit, .keep_all = TRUE)

metrica_careiros <- dados_careiros %>%
  filter(!is.na(NCM_prod), NCM_prod != "NA") %>%
  group_by(NCM_prod, Unid_prod) %>%
  mutate(Atipico = (Preco_medio - quantile(Preco_medio, 0.75) + IQR(Preco_medio) * 1.5) / IQR(Preco_medio)) %>%
  ungroup() %>%
  filter(!is.nan(Atipico), !is.infinite(Atipico)) %>%
  group_by(CPF_CNPJ_emit) %>%
  summarise(NCMs_atuacao = n(),
            Atipicidade_media = mean(Atipico, na.rm = TRUE),
            Atipicidade_maxima = max(Atipico, na.rm = TRUE),
            Atipicidade_minima = min(Atipico, na.rm = TRUE)) %>%
  left_join(dcg_nomes_emit) %>%
  select(c(CNPJ = CPF_CNPJ_emit,
           Razao_Social = Nome_razao_social_emit,
           NCMs_atuacao, Atipicidade_media, Atipicidade_maxima, Atipicidade_minima
  ))

write.csv(metrica_careiros, "../dados/metrica_careiros.csv", 
          row.names = F, na = "",
          quote = TRUE, fileEncoding = "latin1")




dados_careiros_comp <- dados_careiros_all %>%
  group_by(NCM_prod, CPF_CNPJ_emit, CPF_CNPJ_dest, Unid_prod) %>%
  summarise(Preco_medio = mean(Valor_unit_prod)) %>%
  ungroup() %>%
  collect()  

dcg_nomes_dest <- tbl(notas, 'nota_fiscal') %>%
  select(CPF_CNPJ_dest, Nome_razao_social_dest) %>%
  collect() %>%
  distinct(CPF_CNPJ_dest, .keep_all = TRUE)

metrica_careiros_comp <- dados_careiros_comp %>%
  filter(!is.na(NCM_prod), NCM_prod != "NA") %>%
  group_by(NCM_prod, Unid_prod) %>%
  mutate(Atipico = (Preco_medio - quantile(Preco_medio, 0.75) + IQR(Preco_medio) * 1.5) / IQR(Preco_medio)) %>%
  ungroup() %>%
  filter(!is.nan(Atipico), !is.infinite(Atipico)) %>%
  group_by(CPF_CNPJ_emit, CPF_CNPJ_dest) %>%
  summarise(NCMs_atuacao = n(),
            Atipicidade_media = mean(Atipico, na.rm = TRUE),
            Atipicidade_maxima = max(Atipico, na.rm = TRUE),
            Atipicidade_minima = min(Atipico, na.rm = TRUE)) %>%
  left_join(dcg_nomes_emit) %>%
  left_join(dcg_nomes_dest) %>%
  select(c(CNPJ_Vendedor = CPF_CNPJ_emit,
           Razao_Social_Vendedor = Nome_razao_social_emit,
           CNPJ_Comprador = CPF_CNPJ_dest,
           Razao_Social_Comprador = Nome_razao_social_dest,
           NCMs_atuacao, Atipicidade_media, Atipicidade_maxima, Atipicidade_minima
  ))

write.csv(metrica_careiros_comp, "../dados/metrica_careiros_comp.csv", 
          row.names = F, na = "",
          quote = TRUE, fileEncoding = "latin1")
