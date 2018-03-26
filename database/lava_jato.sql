DROP DATABASE IF EXISTS lava_jato;
CREATE DATABASE lava_jato;
USE lava_jato;

CREATE TABLE atuacao_fornecedores_compradores(
    CPF_CNPJ_emit VARCHAR(18),
    Nome_razao_social_emit VARCHAR(60),
    CPF_CNPJ_dest VARCHAR(18),
    Nome_razao_social_dest VARCHAR(60),
    Total_compras INT(11),

    PRIMARY KEY(CPF_CNPJ_emit, CPF_CNPJ_dest)
);

CREATE TABLE atuacao_fornecedores_ncm(
    CPF_CNPJ_emit VARCHAR(18),
    Razao_social VARCHAR(60),
    NCMs_atuacao INT(11),
    NCM_frequente_1 VARCHAR(8),
    Total_NCM_frequente_1 INT(11),
    NCM_frequente_2 VARCHAR(8),
    Total_NCM_frequente_2 INT(11),
    NCM_frequente_3 VARCHAR(8),
    Total_NCM_frequente_3 INT(11),
    NCM_atipicidade_maxima VARCHAR(8),
    NCM_atipicidade_maxima_desc VARCHAR(120),
    Presente_CEIS CHAR(3),

    PRIMARY KEY(CPF_CNPJ_emit)
);

CREATE TABLE preco_maximo_ncm_atipico(
    CPF_CNPJ_emit VARCHAR(18),
    Razao_social_emit VARCHAR(60),
    CPF_CNPJ_dest VARCHAR(18),
    Razao_social_dest VARCHAR(60),
    NCM_prod VARCHAR(8),
    Descricao_prod VARCHAR(120),
    Valor_venda_prod DECIMAL(12, 2),
    Preco_medio_NCM DECIMAL(12, 2),
    Chave_nota CHAR(44),
    Item_nota INT(3),

    PRIMARY KEY(CPF_CNPJ_emit, Chave_nota, Item_nota)
);
