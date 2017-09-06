library(dplyr)
library(tidyr)
library(readr)
library(tm)
options(scipen = 999)

nfe <- read_csv("notas-fiscais-refined.csv")

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
    stripWhitespace() %>%
    trimws() %>%
    strsplit(" ") %>%
    return()
}

nfe <- nfe %>%
  mutate(id = seq(nrow(nfe)))

nfe.split <- nfe %>%
  select(
    id,
    NCM = NCM_prod,
    descricao = Descricao_do_Produto_ou_servicos) %>%
  mutate(
    descricao = word.clean(descricao)) %>%
  unnest(descricao)

metrica <- nfe.split %>%
  group_by(NCM) %>%
  mutate(percent = word.count(descricao)) %>%
  group_by(id) %>%
  distinct(descricao, .keep_all = TRUE) %>% 
  summarise(metrica = sum(percent, na.rm = TRUE))

nfe.result <- nfe %>%
  left_join(metrica, by = "id") %>% 
  replace_na(list(metrica = 0)) %>%
  rename(Metrica = metrica) %>% 
  select(-c(id, NCM_prod, Descricao_do_Produto_ou_servicos, Unid_prod))



