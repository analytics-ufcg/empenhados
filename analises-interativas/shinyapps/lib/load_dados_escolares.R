# Carrega os dados escolares de todas as cidades da Paraíba
load_dados_escolares <- function() {
  
  library(dplyr)
  library(tidyr)
  library(stringr)
  
  #Pasta de origem dos arquivos csv deve ser modificada aqui
  file_names <- Sys.glob("../dados/dados_escolares_2015/*.csv")
  
  dados <- data.frame()
  
  for (file_name in file_names) {
    
    dados_escolares <- read.csv(file_name, header=FALSE, fileEncoding="latin1", 
                                sep = ";", dec = ",", stringsAsFactors = FALSE)
    
    dados_escolares = dados_escolares %>%
      select(c(V1, V2)) %>%
      mutate(cidade = dados_escolares$V1 [1]) %>%
      mutate(cidade = as.factor(cidade)) %>%
      mutate(ano = 2015) %>%
      filter(grepl('municipal', dados_escolares$V1, ignore.case = T)) %>%
      mutate(V2 = str_replace_all(V2, '\\.', '')) %>%
      mutate(V2 = as.integer(V2)) %>%
      spread(V1, V2)
    
    codcid = str_replace(file_name, 'dados_escolares_2015/', '')
    codcid = str_sub(codcid, end = 7)
    dados_escolares = dados_escolares %>%
      mutate(codcidade = as.integer(codcid))
    
    dados <- rbind(dados, dados_escolares)
  }
  
  colnames(dados) <- c("cidade","ano", "docfund", "docmedio", "docpre", "escfund", 
                      "escmedio", "escpre", "matrifund", "matrimedio", "matripre", "codcidade")
  
  dados <- dados %>%
     mutate(doctotal = docfund + docmedio + docpre) %>%
     mutate(esctotal = escfund + escmedio + escpre) %>%
     mutate(matritotal = matrifund + matrimedio + matripre)
  
  dados = dados[c("cidade","codcidade", "ano", 
                  "docfund", "docmedio", "docpre", "doctotal",
                  "escfund", "escmedio", "escpre", "esctotal", 
                  "matrifund", "matrimedio", "matripre", "matritotal")]
  
  return(dados)
}

