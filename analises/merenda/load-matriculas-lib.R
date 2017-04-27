get.data.matriculas <- function(path) {
  
  data <- data.frame()
  
  for (fileName in path) {
    data_matriculas <- read.csv(fileName, header=FALSE, fileEncoding="latin1", sep = ";", stringsAsFactors = FALSE, dec = ",")
    
    data_matriculas = data_matriculas %>%
      select(c(V1, V2)) %>%
      mutate(cidade = data_matriculas$V1 [1]) %>%
      mutate(ano = 2015) %>%
      filter(grepl('municipal', data_matriculas$V1, ignore.case = T)) %>%
      spread(V1, V2)
    
    data <- rbind(data, data_matriculas)
  }
  return(data)
}
# Os dados(223 arquivos .csv baixados do site do IBGE) das matriculas de cada municipio devem estar na pasta "dados_matriculas" 
# para que a tabela seja gerada.

fileNames <- Sys.glob("dados_matriculas/*.csv")
dados = get.data.matriculas(fileNames)

colnames(dados) <- c("cidade","ano", "doc.fund", "doc.medio", "doc.pre", "esc.fund", 
                     "esc.medio", "esc.pre", "matri.fund", "matri.medio", "matri.pre")