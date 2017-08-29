# Carrega os dados escolares de todas as cidades da Paraíba
load_dados_escolares <- function() {
  
  library(dplyr)
  library(tidyr)
  library(stringr)
  
  #Caminho relativo deve considerar que a origem é o diretório do arquivo que carrega a função
  file_names <- Sys.glob("../../utils/dados/dados_escolares/*/*.csv")
  
  warning(file_names[1])
  
  dados <- data.frame()
  
  for (file_name in file_names) {
    
    dados_escolares <- read.csv(file_name, header=FALSE, fileEncoding="latin1", 
                                sep = ";", dec = ",", stringsAsFactors = FALSE, na.strings = c("Não informado", "Não existente"))
    
    path_chunks <- str_split(file_name, "/")[[1]]
    
    dados_escolares <- dados_escolares %>%
      select(c(V1, V2)) %>%
      mutate(cidade = dados_escolares$V1 [1]) %>%
      mutate(cidade = as.factor(cidade)) %>%
      mutate(ano = as.integer(path_chunks[4])) %>%
      filter(grepl('municipal', dados_escolares$V1, ignore.case = T)) 
    
    dados_escolares <- dados_escolares %>%
      filter(!grepl('superior', dados_escolares$V1, ignore.case = T)) %>%
      mutate(V2 = str_replace_all(V2, '\\.', '')) %>%
      mutate(V2 = as.integer(V2)) %>%
      spread(V1, V2)
    
    codcid <- str_sub(path_chunks[5], end = 6)
    
    dados_escolares <- dados_escolares %>%
      mutate(codcidade = codcid)
    
    colnames(dados_escolares) <- 
      c("de_Municipio","dt_Ano", "vl_Docentes_Fundamental", "vl_Docentes_Medio", "vl_Docentes_Pre_Escolar", 
        "vl_Escolas_Fundamental", "vl_Escolas_Medio", "vl_Escolas_Pre_Escolar", 
        "vl_Matriculas_Fundamental", "vl_Matriculas_Medio", "vl_Matriculas_Pre_Escolar", "cd_IBGE")
    
    dados <- rbind(dados, dados_escolares)
  }
  
  dados <- dados %>%
     mutate(vl_Docentes_Total = vl_Docentes_Fundamental + vl_Docentes_Medio + vl_Docentes_Pre_Escolar) %>%
     mutate(vl_Escolas_Total = vl_Escolas_Fundamental + vl_Escolas_Medio + vl_Escolas_Pre_Escolar) %>%
     mutate(vl_Matriculas_Total = vl_Matriculas_Fundamental + vl_Matriculas_Medio + vl_Matriculas_Pre_Escolar)
  
  dados <- dados[c("cd_IBGE", "de_Municipio", "dt_Ano", 
                   "vl_Docentes_Total", "vl_Docentes_Fundamental", "vl_Docentes_Medio", "vl_Docentes_Pre_Escolar",
                   "vl_Escolas_Total", "vl_Escolas_Fundamental", "vl_Escolas_Medio", "vl_Escolas_Pre_Escolar",
                   "vl_Matriculas_Total", "vl_Matriculas_Fundamental", "vl_Matriculas_Medio", "vl_Matriculas_Pre_Escolar")]
  
  return(dados)
}

