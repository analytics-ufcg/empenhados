library(dplyr)
library(tidyr)
library(readr)
library(tm)
options(scipen = 999)

nfe <- read.csv("notas-fiscais-refined.csv", stringsAsFactors = FALSE,  colClasses=c("Chave_de_acesso"="character"), encoding = "utf8")

notas <-  src_mysql('notas_fiscais', group='ministerio-publico', password=NULL, username = "empenhados")

query <- sql('
 SELECT DISTINCT lower(UTrib) UTrib FROM NCM
')

unidades <- tbl(notas, query) %>% 
  collect(n = Inf)

word.count <- function(data) {

  result <- data.frame(word = data) %>%
    group_by(word) %>%
    summarise(freq = n()) %>% 
    mutate(percent = freq / sum(freq)) %>%
    right_join(data.frame(word=data))
  
  return(result$percent)
}

word.clean <- function(descricao) {
  gsub('\\d|[[:punct:]]', ' ', descricao) %>%
    tolower() %>%
    iconv(to = "ASCII//TRANSLIT") %>% 
    removeWords(stopwords('portuguese')) %>%
    removeWords(unidades$UTrib) %>% 
    stripWhitespace() %>%
    trimws() %>%
    strsplit(" ") %>%
    return()
}

nfe.split <- nfe %>%
  select(
    Chave_de_acesso,
    Nr_item,
    NCM = NCM_prod,
    descricao = Descricao_do_Produto_ou_servicos) %>%
  mutate(
    descricao = word.clean(descricao)) %>%
  unnest(descricao)

metrica <- nfe.split %>%
  group_by(NCM) %>%
  mutate(percent = word.count(descricao)) %>%
  group_by(Chave_de_acesso,
            Nr_item) %>%
  distinct(descricao, .keep_all = TRUE) %>% 
  summarise(metrica = sum(percent, na.rm = TRUE))

nfe.result <- nfe %>%
  left_join(metrica, by = c("Chave_de_acesso",
                             "Nr_item")) %>% 
  replace_na(list(metrica = 0)) %>%
  rename(Metrica = metrica, NCM = NCM_prod) %>% 
  select(-Descricao_do_Produto_ou_servicos)

nfe.conf <- nfe.result %>%
  group_by(NCM) %>%
  filter(n_distinct(Metrica) > 2) %>%
  mutate(Confiavel = kmeans(Metrica, centers = c(min(Metrica), max(Metrica)))$cluster == 2) %>% 
  ungroup() %>% 
  select(Chave_de_acesso, Nr_item, Confiavel) 

nfe.final <- nfe.result %>% 
  left_join(nfe.conf, by = c("Chave_de_acesso", "Nr_item")) %>% 
  replace_na(list(Confiavel = TRUE)) %>% 
  select(-NCM)
  
nfe.csv <- read.csv("nota_fiscal.csv", stringsAsFactors = FALSE,  colClasses=c("Chave_de_acesso"="character"), encoding = "latin1")

nfe.bd <- nfe.csv %>% 
  select(-Unid_prod) %>% 
  inner_join(nfe.final, by = c("Chave_de_acesso", "Nr_item"))

write.csv(nfe.bd, "notas_fiscais.csv", fileEncoding = "latin1", row.names = FALSE)

