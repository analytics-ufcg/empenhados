DROP DATABASE IF EXISTS lava_jato;
CREATE DATABASE lava_jato;
USE lava_jato;

CREATE TABLE atuacao_fornecedores_compradores(
    CPF_CNPJ_emit VARCHAR(14),
    Nome_razao_social_emit VARCHAR(60),
    CPF_CNPJ_dest VARCHAR(18),
    Nome_razao_social_dest VARCHAR(60),
    Total_compras INT(11),

    PRIMARY KEY(CPF_CNPJ_emit, CPF_CNPJ_dest)
);

CREATE TABLE atuacao_fornecedores_ncm(
    Ranking_atipicidade INT(11),
    CPF_CNPJ_emit VARCHAR(14),
    Razao_social VARCHAR(60),
    NCMs_atuacao INT(11),
    NCM_frequente_1 VARCHAR(120),
    Total_NCM_frequente_1 INT(11),
    NCM_frequente_2 VARCHAR(120),
    Total_NCM_frequente_2 INT(11),
    NCM_frequente_3 VARCHAR(120),
    Total_NCM_frequente_3 INT(11),
    NCM_atipicidade_maxima VARCHAR(8),
    NCM_atipicidade_maxima_desc VARCHAR(120),
    Presente_CEIS CHAR(3),

    PRIMARY KEY(CPF_CNPJ_emit)
);

CREATE TABLE preco_maximo_ncm_atipico(
    CPF_CNPJ_emit VARCHAR(14),
    Razao_social_emit VARCHAR(60),
    CPF_CNPJ_dest VARCHAR(14),
    Razao_social_dest VARCHAR(60),
    NCM_prod VARCHAR(120),
    Descricao_prod VARCHAR(120),
    Valor_venda_prod DECIMAL(12, 2),
    Preco_medio_NCM DECIMAL(12, 2),
    Chave_nota CHAR(44),
    Item_nota INT(3),

    PRIMARY KEY(CPF_CNPJ_emit, Chave_nota, Item_nota)
);

CREATE TABLE atipicidades_fornecedores(
    CPF_CNPJ_emit VARCHAR(14),
    NCM_prod VARCHAR(8),
    NCM_prod_desc VARCHAR(120),
    Atipicidade DECIMAL(14, 2),

    PRIMARY KEY(CPF_CNPJ_emit, NCM_prod)
);

CREATE TABLE faturamento_empresas(
	cd_UGestora CHAR(6),
	cd_Credor VARCHAR(14),
	dt_Ano INT(4),
	no_Credor VARCHAR(82),
	total_Empenhos DECIMAL(14, 2),
	total_Pago DECIMAL(14, 2),
	total_Estorno DECIMAL(13, 2),
	total_Vitorias INT(3),

	PRIMARY KEY(cd_UGestora, cd_Credor, dt_Ano)
);

CREATE TABLE metricas_2016(
	CNPJ VARCHAR(15),
	fornecedor VARCHAR(82),
	metrica_2 DECIMAL(4, 2),
	metrica_3 DECIMAL(8, 4),
	metrica_4 DECIMAL(4, 2),
	metrica_5 DECIMAL(10, 5),
	metrica_6 DECIMAL(10, 5),
	metrica_8 DECIMAL(6, 2),
	metrica_9 DECIMAL(10, 5),
	metrica_final DECIMAL(12, 8),
	ranking_metrica_2 INT(4),
	ranking_metrica_3 INT(5),
	ranking_metrica_4 INT(4),
	ranking_metrica_5 INT(6),
	ranking_metrica_6 INT(6),
	ranking_metrica_8 INT(5),
	ranking_metrica_9 INT(5),
	ranking_metrica_final INT(6),
	

	PRIMARY KEY(CNPJ)
);
