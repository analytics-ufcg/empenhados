library(dplyr)
library(tidyr)
library(readr)
library(stringr)

fornecedor_ncm_compradores <- read_csv("../../analises-interativas/shinyapps/dados/fornecedor_ncm_compradores.csv", 
                                       locale=locale(encoding="latin1"), col_types = "c??????") %>%
  mutate(NCM_prod = ifelse(nchar(NCM_prod) == 8, NCM_prod, str_c("0",NCM_prod)))

fornecedores_ncms <- read_csv("../../analises-interativas/shinyapps/dados/fornecedores_ncms.csv", 
                              locale=locale(encoding="latin1"), col_types = "??c???") %>%
  mutate(NCM_prod = ifelse(nchar(NCM_prod) == 8, NCM_prod, str_c("0",NCM_prod)))

metrica_careiros <- read_csv("../../analises-interativas/shinyapps/dados/metrica_careiros.csv", 
                             locale=locale(encoding="latin1"))

metrica_careiros_comp <- read_csv("../../analises-interativas/shinyapps/dados/metrica_careiros_comp.csv", 
                                  locale=locale(encoding="latin1"))

ceis <- read.csv("../../utils/dados/20180312_CEIS.csv", sep = ";", encoding = "latin1", 
                 colClasses = c(CPF.ou.CNPJ.do.Sancionado = "character")) %>%
  select(CNPJ = CPF.ou.CNPJ.do.Sancionado, 
         Sancao_CEIS = Tipo.Sanção,
         Fundamentacao_CEIS = Fundamentação.Legal)

notas <-  src_mysql('notas_fiscais', 
                    group='ministerio-publico',
                    user="empenhados", 
                    password=NULL)

ncm <- tbl(notas, "ncm") %>%
  collect(n = Inf) %>%
  mutate(NCM = ifelse(nchar(NCM) == 8, NCM, str_c("0",NCM)))

# Dados de CNPJ - Nome 
cnpj_nome <- tbl(notas, "nota_fiscal") %>% 
  distinct(CPF_CNPJ_emit, CPF_CNPJ_dest, Nome_razao_social_emit, Nome_razao_social_dest) %>% 
  collect(n = Inf) %>% 
  
  group_by(CPF_CNPJ_emit, CPF_CNPJ_dest) %>% 
  summarise(Nome_razao_social_emit = first(Nome_razao_social_emit), 
            Nome_razao_social_dest = first(Nome_razao_social_dest)) %>% 
  ungroup()

#Orgãos que mais compram nos fornecedores
set.seed(123)
compras_fornecedor_comprador <- tbl(notas, "nota_fiscal") %>%
  group_by(CPF_CNPJ_emit, CPF_CNPJ_dest) %>%
  summarise(
    Total_Compras = n_distinct(Chave_de_acesso)) %>%
  collect(n = Inf) %>%
  ungroup() %>%
  
  sample_n(nrow(.)) %>% 
  group_by(CPF_CNPJ_emit) %>% 
  top_n(3, Total_Compras) %>%
  ungroup() %>% 
  
  arrange(CPF_CNPJ_emit, desc(Total_Compras)) %>% 
  group_by(CPF_CNPJ_emit) %>% 
  slice(1:3) %>% 
  ungroup() %>% 
  
  left_join(cnpj_nome) %>% 
  select(CPF_CNPJ_emit, Nome_razao_social_emit, CPF_CNPJ_dest, Nome_razao_social_dest, Total_Compras)

#NCMs onde os fornecedores mais atuam
set.seed(123)
compras_fornecedor_ncm <- tbl(notas, "nota_fiscal") %>%
  group_by(CPF_CNPJ_emit, NCM_prod) %>%
  
  summarise(Total_NCM = n()) %>%
  collect(n = Inf) %>%
  ungroup() %>% 
  
  sample_n(nrow(.)) %>% 
  group_by(CPF_CNPJ_emit) %>% 
  top_n(3, Total_NCM) %>%
  ungroup() %>% 
  
  arrange(CPF_CNPJ_emit, desc(Total_NCM)) %>%
  group_by(CPF_CNPJ_emit) %>% 
  slice(1:3) %>% 
  ungroup()

#NCMs de maior atipicidade para os fornecedores
set.seed(123)
ncm_maior_atipicidade <- fornecedores_ncms %>%
  
  sample_n(nrow(.)) %>% 
  group_by(CNPJ) %>%
  top_n(1, Atipicidade) %>%
  select(CNPJ, NCM_Atipicidade_Maxima = NCM_prod) %>%
  ungroup() %>%
  
  group_by(CNPJ) %>% 
  slice(1) %>% 
  ungroup() %>% 
  
  left_join(
    ncm %>%
      select(NCM_Atipicidade_Maxima = NCM, 
             NCM_Atipicidade_Maxima_Desc = Descricao)
  )

dados_fornecedores <- fornecedores_ncms %>%
  distinct(CNPJ, Razao_Social, Atipicidade_media)

dados_fornecedores <- dados_fornecedores %>%
  left_join(
    fornecedores_ncms %>%
    group_by(CNPJ) %>%
    summarise(Atipicidade_total = sum(Atipicidade))
  )

dados_fornecedores <- dados_fornecedores %>%
  left_join(
    fornecedores_ncms %>%
      group_by(CNPJ) %>%
      summarise(Atipicidade_maxima = max(Atipicidade))
  )

dados_fornecedores <- dados_fornecedores %>%
  left_join(
    metrica_careiros %>%
      select(CNPJ, NCMs_atuacao)
  )

dados_fornecedores <- dados_fornecedores %>%
  mutate(CNPJ_temp = str_replace_all(CNPJ, "[-/.]", "")) %>%
  mutate(Presente_CEIS = ifelse(CNPJ_temp %in% ceis$CNPJ, 1, 0)) %>%
  mutate(Presente_CEIS = factor(Presente_CEIS, levels = c(0,1), labels = c("Não", "Sim")))

dados_fornecedores <- dados_fornecedores %>%
  left_join(ceis, by = c("CNPJ_temp" = "CNPJ")) %>%
  select(-CNPJ_temp)
# 
# dados_fornecedores <- dados_fornecedores %>%
#   left_join(
#     fornecedores_ncms %>%
#       group_by(CNPJ) %>%
#       top_n(1, Atipicidade) %>%
#       select(CNPJ, NCM_Atipicidade_Maxima = NCM_prod)
#   )
# 
# dados_fornecedores <- dados_fornecedores %>%
#   left_join(
#     ncm %>%
#       select(NCM_Atipicidade_Maxima = NCM, 
#              NCM_Atipicidade_Maxima_Desc = Descricao)
#   )
