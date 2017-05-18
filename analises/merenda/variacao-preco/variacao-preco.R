library(dplyr)

dados_nota <- read.table('analises/merenda/dados/notas_fiscais/dados_nf.txt', 
                         sep = '|', header = TRUE, dec = ",",
                         quote = "", fill = TRUE, encoding = 'latin1', 
                         strip.white=T, stringsAsFactors = FALSE, na.strings = c(""),
                         colClasses = c("Chave_de_acesso" = "character", "Cod_EAN" = "character"))

variaveis_numericas <- c(
  "Valor_total_da_nota", "Valor_fatura", "Base_de_Calculo_do_ICMS", "Valor_do_ICMS",
  "Base_de_calculo_do_ICMS_substituicao", "Valor_do_ICMS_substituicao", "Valor_total_dos_produtos",
  "Valor_do_frete", "Valor_do_seguro", "Valor_desconto", "Valor_outras_despesas_acessorias", "Valor_do_IPI",
  "Valor_total_ICMS_UF_dest", "Valor_total_ICMS_UF_remet", "Valor_BC_ICMS_UF_dest", "Aliquota_interna_UF_dest",
  "Aliquota_interestadual_UF_env", "Valor_ICMS_FCP_UF_dest", "Valor_ICMS_partilha_UF_dest",
  "Valor_ICMS_partilha_UF_remet", "Quant_prod", "Valor_unit_prod", "Valor_total_prod", "Valor_desconto_item" ,
  "BC_ICMS_prod", "Valor_ICMS_prod", "Aliq_ICMS_prod", "BC_ICMS_ST_prod", "Valor_ICMS_ST_prod",
  "Aliq_ICMS_ST_prod", "Valor_IPI_prod", "Aliq_IPI_prod", "Valor_PMC_prod"
)

dados_nota <- dados_nota %>%
  rename(Valor_total_da_nota = Valor_total_da._nota) %>%
  mutate_at(variaveis_numericas, funs(gsub('\\.', '', .))) %>%
  mutate_at(variaveis_numericas, funs(gsub(',', '\\.', .))) %>%
  mutate_at(variaveis_numericas, funs(as.numeric(.)))

str(dados_nota)

write.csv(dados_nota, file = "dados_nf.csv", na = "", col.names = TRUE, 
          row.names = FALSE, fileEncoding = 'latin1')
