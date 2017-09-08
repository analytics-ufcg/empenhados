library(dplyr)
library(tidyr)
library(readr)
library(tm)
options(scipen = 999)

nfe <- read.csv("notas-fiscais-refined.csv", stringsAsFactors = FALSE,  colClasses=c("Chave_de_acesso"="character"), encoding = "utf8")

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
  rename(Metrica = metrica) %>% 
  select(-c(NCM_prod, Descricao_do_Produto_ou_servicos))

