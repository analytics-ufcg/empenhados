library(dplyr)
library(tidyr)

## Tratando dados do IDEB

ideb_iniciais <- read.csv("ideb-por-municipios-inicial.csv", stringsAsFactors = FALSE, encoding = "ASCII")

ideb_iniciais <- ideb_iniciais %>%
  filter(UF == "PB") %>%
  select(Ano, UF, Município, Ideb, Aprendizado, Fluxo) %>%
  rename("IDEB_AnosIniciais" = Ideb,
         "aprendizado_AnosIniciais" = Aprendizado,
         "fluxo_AnosIniciais" = Fluxo)

ideb_finais <- read.csv("ideb-por-municipios-final.csv", stringsAsFactors = FALSE)

ideb_finais <- ideb_finais %>%
  filter(UF == "PB") %>%
  select(Ano, UF, Município, Ideb, Aprendizado, Fluxo) %>%
  rename("IDEB_Anosfinais" = Ideb,
         "aprendizado_AnosFinais" = Aprendizado,
         "fluxo_AnosFinais" = Fluxo)

ideb_paraiba <- ideb_finais %>%
  left_join(ideb_iniciais, by = c("Município" = "Município")) %>%
  select(-c(Ano.y, UF.y)) %>%
  rename("Ano" = Ano.x,
         "UF" = UF.x)

rm(ideb_iniciais)
rm(ideb_finais)

ideb_paraiba$Município[108] <- "MAE D'AGUA"
ideb_paraiba$Município[130] <- "OLHO D'AGUA"
ideb_paraiba$Município[178] <- "SAO DOMINGOS"
ideb_paraiba$Município[212] <- "TACIMA"

## Tratando dados do IDH

idh_municipios <- read.csv("idh-municipios-PB.csv", stringsAsFactors = FALSE, sep = ";", encoding = "latin1")

idh_municipios <- idh_municipios %>%
  filter(Espacialidade == "Município") %>%
  separate(Lugar, c('Cidade', 'UF'), -6) %>%
  rename("cd_IBGE" = COD.IBGE) %>%
  rename("IDHM" = IDHM..2010.) %>%
  rename("IDHM_Renda" = IDHM.Renda..2010.) %>%
  rename("IDHM_Longevidade" = IDHM.Longevidade..2010.) %>%
  rename("IDHM_Educacao" = IDHM.Educação..2010.) %>%
  mutate(IDHM = gsub("\\,", ".", IDHM)) %>%
  mutate(IDHM_Renda = gsub("\\,", ".", IDHM_Renda)) %>%
  mutate(IDHM_Longevidade = gsub("\\,", ".", IDHM_Longevidade)) %>%
  mutate(IDHM_Educacao = gsub("\\,", ".", IDHM_Educacao)) %>%
  select(-c(UF, Espacialidade))

## Tabela final

utils = src_mysql('utils', username = "empenhados", group='ministerio-publico', password=NULL)

municipios = tbl(utils, 'municipio') %>%
  select(cd_IBGE, cd_Municipio, de_Municipio, vl_Populacao) %>% # A tabela atual presente no banco de dados já contém dados de IDH e IDEB
  collect()

municipios <- municipios %>% 
  mutate(copy_de_Municipio = de_Municipio) %>%
  mutate_each(funs(toupper), copy_de_Municipio) %>%
  mutate(copy_de_Municipio = iconv(copy_de_Municipio, to='ASCII//TRANSLIT'))

Encoding(municipios$de_Municipio) <- "UTF-8"
Encoding(idh_municipios$Cidade) <- "UTF-8"
Encoding(ideb_paraiba$Município) <- "UTF-8"

municipios <- municipios %>%
  left_join(idh_municipios, by = c("de_Municipio" = "Cidade")) %>%  
  left_join(ideb_paraiba, by = c("copy_de_Municipio" = "Município")) %>%
  select(-c(copy_de_Municipio, UF, Ano))
