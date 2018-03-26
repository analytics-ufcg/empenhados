DROP DATABASE IF EXISTS rais;
CREATE DATABASE rais;
USE rais;

CREATE TABLE rais_2011 (

    Municipio CHAR(6),
    CNAE_95_Classe CHAR(5),
    Vinculo_Ativo_31_12 CHAR(1),
    Tipo_Vinculo CHAR(2),
    Motivo_Desligamento CHAR(2),
    Mes_Desligamento CHAR(2),
    Ind_Vinculo_Alvara CHAR(2),
    Tipo_Admissao CHAR(2),
    Tipo_Salario CHAR(2),
    CBO_94_Ocupacao CHAR(5),
    Escolaridade_apos_2005 CHAR(2),
    Sexo_Trabalhador CHAR(2),
    Nacionalidade CHAR(2),
    Raca_Cor CHAR(2),
    Ind_Portador_Defic CHAR(1),
    Tamanho_Estabelecimento CHAR(2),
    Natureza_Juridica CHAR(4),
    Ind_CEI_Vinculado CHAR(1),
    Tipo_Estab CHAR(2),
    Ind_Estab_Participa_PAT CHAR(1),
    Ind_Simples CHAR(1),
    Data_Admissao_Declarada CHAR(6),
    Vl_Remun_Media_Nom DECIMAL(15, 2),
    Vl_Remun_Media_SM DECIMAL(9, 2),
    Vl_Remun_Dezembro_Nom DECIMAL(15, 2),
    Vl_Remun_Dezembro_SM  DECIMAL(9, 2),
    Tempo_Emprego DECIMAL(6, 2),
    Qtd_Hora_Contr INT(2),
    Vl_Ultima_Remuneracao_Ano DECIMAL(9, 2),
    Vl_Salario_Contratual DECIMAL(10, 2),
    PIS CHAR(15),
    Numero_CTPS CHAR(8),
    CPF CHAR(11),
    CEI_Vinculado CHAR(12),
    CNPJ_CEI CHAR(14),
    CNPJ_Raiz CHAR(8),
    Nome_Trabalhador VARCHAR(80),
    CBO_Ocupacao_2002 CHAR(6),
    CNAE_2p0_Classe CHAR(5),
    CNAE_2p0_Subclasse CHAR(7),
    Tipo_Defic CHAR(2),
    Causa_Afastamento_1 CHAR(2),
    Dia_Ini_AF1 INT(2),
    Mes_Ini_AF1 INT(2),
    Dia_Fim_AF1 INT(2),
    Mes_Fim_AF1 INT(2),
    Causa_Afastamento_2 CHAR(2),
    Dia_Ini_AF2 INT(2),
    Mes_Ini_AF2 INT(2),
    Dia_Fim_AF2 INT(2),
    Mes_Fim_AF2 INT(2),
    Causa_Afastamento_3 CHAR(2),
    Dia_Ini_AF3 INT(2),
    Mes_Ini_AF3 INT(2),
    Dia_Fim_AF3 INT(2),
    Mes_Fim_AF3 INT(2),
    Qtd_Dias_Afastamento INT(3),

    PRIMARY KEY(CPF, CNPJ_CEI, Vinculo_Ativo_31_12)
);

CREATE TABLE rais_2012 (

    Municipio CHAR(6),
    CNAE_95_Classe CHAR(5),
    Vinculo_Ativo_31_12 CHAR(1),
    Tipo_Vinculo CHAR(2),
    Motivo_Desligamento CHAR(2),
    Mes_Desligamento CHAR(2),
    Ind_Vinculo_Alvara CHAR(2),
    Tipo_Admissao CHAR(2),
    Tipo_Salario CHAR(2),
    CBO_94_Ocupacao CHAR(5),
    Escolaridade_apos_2005 CHAR(2),
    Sexo_Trabalhador CHAR(2),
    Nacionalidade CHAR(2),
    Raca_Cor CHAR(2),
    Ind_Portador_Defic CHAR(1),
    Tamanho_Estabelecimento CHAR(2),
    Natureza_Juridica CHAR(4),
    Ind_CEI_Vinculado CHAR(1),
    Tipo_Estab CHAR(2),
    Ind_Estab_Participa_PAT CHAR(1),
    Ind_Simples CHAR(1),
    Data_Admissao_Declarada CHAR(6),
    Vl_Remun_Media_Nom DECIMAL(15, 2),
    Vl_Remun_Media_SM DECIMAL(9, 2),
    Vl_Remun_Dezembro_Nom DECIMAL(15, 2),
    Vl_Remun_Dezembro_SM  DECIMAL(9, 2),
    Tempo_Emprego DECIMAL(6, 2),
    Qtd_Hora_Contr INT(2),
    Vl_Ultima_Remuneracao_Ano DECIMAL(9, 2),
    Vl_Salario_Contratual DECIMAL(10, 2),
    PIS CHAR(15),
    Numero_CTPS CHAR(8),
    CPF CHAR(11),
    CEI_Vinculado CHAR(12),
    CNPJ_CEI CHAR(14),
    CNPJ_Raiz CHAR(8),
    Nome_Trabalhador VARCHAR(80),
    CBO_Ocupacao_2002 CHAR(6),
    CNAE_2p0_Classe CHAR(5),
    CNAE_2p0_Subclasse CHAR(7),
    Tipo_Defic CHAR(2),
    Causa_Afastamento_1 CHAR(2),
    Dia_Ini_AF1 INT(2),
    Mes_Ini_AF1 INT(2),
    Dia_Fim_AF1 INT(2),
    Mes_Fim_AF1 INT(2),
    Causa_Afastamento_2 CHAR(2),
    Dia_Ini_AF2 INT(2),
    Mes_Ini_AF2 INT(2),
    Dia_Fim_AF2 INT(2),
    Mes_Fim_AF2 INT(2),
    Causa_Afastamento_3 CHAR(2),
    Dia_Ini_AF3 INT(2),
    Mes_Ini_AF3 INT(2),
    Dia_Fim_AF3 INT(2),
    Mes_Fim_AF3 INT(2),
    Qtd_Dias_Afastamento INT(3),

    PRIMARY KEY(CPF, CNPJ_CEI, Vinculo_Ativo_31_12)
);

CREATE TABLE rais_2013 (

    Municipio CHAR(6),
    CNAE_95_Classe CHAR(5),
    Vinculo_Ativo_31_12 CHAR(1),
    Tipo_Vinculo CHAR(2),
    Motivo_Desligamento CHAR(2),
    Mes_Desligamento CHAR(2),
    Ind_Vinculo_Alvara CHAR(2),
    Tipo_Admissao CHAR(2),
    Tipo_Salario CHAR(2),
    CBO_94_Ocupacao CHAR(5),
    Escolaridade_apos_2005 CHAR(2),
    Sexo_Trabalhador CHAR(2),
    Nacionalidade CHAR(2),
    Raca_Cor CHAR(2),
    Ind_Portador_Defic CHAR(1),
    Tamanho_Estabelecimento CHAR(2),
    Natureza_Juridica CHAR(4),
    Ind_CEI_Vinculado CHAR(1),
    Tipo_Estab CHAR(2),
    Ind_Estab_Participa_PAT CHAR(1),
    Ind_Simples CHAR(1),
    Data_Admissao_Declarada CHAR(6),
    Vl_Remun_Media_Nom DECIMAL(15, 2),
    Vl_Remun_Media_SM DECIMAL(9, 2),
    Vl_Remun_Dezembro_Nom DECIMAL(15, 2),
    Vl_Remun_Dezembro_SM  DECIMAL(9, 2),
    Tempo_Emprego DECIMAL(6, 2),
    Qtd_Hora_Contr INT(2),
    Vl_Ultima_Remuneracao_Ano DECIMAL(9, 2),
    Vl_Salario_Contratual DECIMAL(10, 2),
    PIS CHAR(15),
    Numero_CTPS CHAR(8),
    CPF CHAR(11),
    CEI_Vinculado CHAR(12),
    CNPJ_CEI CHAR(14),
    CNPJ_Raiz CHAR(8),
    Nome_Trabalhador VARCHAR(80),
    CBO_Ocupacao_2002 CHAR(6),
    CNAE_2p0_Classe CHAR(5),
    CNAE_2p0_Subclasse CHAR(7),
    Tipo_Defic CHAR(2),
    Causa_Afastamento_1 CHAR(2),
    Dia_Ini_AF1 INT(2),
    Mes_Ini_AF1 INT(2),
    Dia_Fim_AF1 INT(2),
    Mes_Fim_AF1 INT(2),
    Causa_Afastamento_2 CHAR(2),
    Dia_Ini_AF2 INT(2),
    Mes_Ini_AF2 INT(2),
    Dia_Fim_AF2 INT(2),
    Mes_Fim_AF2 INT(2),
    Causa_Afastamento_3 CHAR(2),
    Dia_Ini_AF3 INT(2),
    Mes_Ini_AF3 INT(2),
    Dia_Fim_AF3 INT(2),
    Mes_Fim_AF3 INT(2),
    Qtd_Dias_Afastamento INT(3),
    Idade INT(3),

    PRIMARY KEY(CPF, CNPJ_CEI, Vinculo_Ativo_31_12)
);

CREATE TABLE rais_2014 (

    Municipio CHAR(6),
    CNAE_95_Classe CHAR(5),
    Vinculo_Ativo_31_12 CHAR(1),
    Tipo_Vinculo CHAR(2),
    Motivo_Desligamento CHAR(2),
    Mes_Desligamento CHAR(2),
    Ind_Vinculo_Alvara CHAR(2),
    Tipo_Admissao CHAR(2),
    Tipo_Salario CHAR(2),
    CBO_94_Ocupacao CHAR(5),
    Escolaridade_apos_2005 CHAR(2),
    Sexo_Trabalhador CHAR(2),
    Nacionalidade CHAR(2),
    Raca_Cor CHAR(2),
    Ind_Portador_Defic CHAR(1),
    Tamanho_Estabelecimento CHAR(2),
    Natureza_Juridica CHAR(4),
    Ind_CEI_Vinculado CHAR(1),
    Tipo_Estab CHAR(2),
    Ind_Estab_Participa_PAT CHAR(1),
    Ind_Simples CHAR(1),
    Data_Admissao_Declarada CHAR(6),
    Vl_Remun_Media_Nom DECIMAL(15, 2),
    Vl_Remun_Media_SM DECIMAL(9, 2),
    Vl_Remun_Dezembro_Nom DECIMAL(15, 2),
    Vl_Remun_Dezembro_SM  DECIMAL(9, 2),
    Tempo_Emprego DECIMAL(6, 2),
    Qtd_Hora_Contr INT(2),
    Vl_Ultima_Remuneracao_Ano DECIMAL(9, 2),
    Vl_Salario_Contratual DECIMAL(10, 2),
    PIS CHAR(15),
    Data_de_Nascimento CHAR(6),
    Numero_CTPS CHAR(8),
    CPF CHAR(11),
    CEI_Vinculado CHAR(12),
    CNPJ_CEI CHAR(14),
    CNPJ_Raiz CHAR(8),
    Nome_Trabalhador VARCHAR(80),
    CBO_Ocupacao_2002 CHAR(6),
    CNAE_2p0_Classe CHAR(5),
    CNAE_2p0_Subclasse CHAR(7),
    Tipo_Defic CHAR(2),
    Causa_Afastamento_1 CHAR(2),
    Dia_Ini_AF1 INT(2),
    Mes_Ini_AF1 INT(2),
    Dia_Fim_AF1 INT(2),
    Mes_Fim_AF1 INT(2),
    Causa_Afastamento_2 CHAR(2),
    Dia_Ini_AF2 INT(2),
    Mes_Ini_AF2 INT(2),
    Dia_Fim_AF2 INT(2),
    Mes_Fim_AF2 INT(2),
    Causa_Afastamento_3 CHAR(2),
    Dia_Ini_AF3 INT(2),
    Mes_Ini_AF3 INT(2),
    Dia_Fim_AF3 INT(2),
    Mes_Fim_AF3 INT(2),
    Qtd_Dias_Afastamento INT(3),
    Idade INT(3),
    Dia_de_Desligamento INT(2),

    PRIMARY KEY(CPF, CNPJ_CEI, Vinculo_Ativo_31_12)
);

CREATE TABLE rais_2015 (

    Municipio CHAR(6),
    CNAE_95_Classe CHAR(5),
    Vinculo_Ativo_31_12 CHAR(1),
    Tipo_Vinculo CHAR(2),
    Motivo_Desligamento CHAR(2),
    Mes_Desligamento CHAR(2),
    Ind_Vinculo_Alvara CHAR(2),
    Tipo_Admissao CHAR(2),
    Tipo_Salario CHAR(2),
    CBO_94_Ocupacao CHAR(5),
    Escolaridade_apos_2005 CHAR(2),
    Sexo_Trabalhador CHAR(2),
    Nacionalidade CHAR(2),
    Raca_Cor CHAR(2),
    Ind_Portador_Defic CHAR(1),
    Tamanho_Estabelecimento CHAR(2),
    Natureza_Juridica CHAR(4),
    Ind_CEI_Vinculado CHAR(1),
    Tipo_Estab CHAR(2),
    Ind_Estab_Participa_PAT CHAR(1),
    Ind_Simples CHAR(1),
    Data_Admissao_Declarada CHAR(6),
    Vl_Remun_Media_Nom DECIMAL(15, 2),
    Vl_Remun_Media_SM DECIMAL(9, 2),
    Vl_Remun_Dezembro_Nom DECIMAL(15, 2),
    Vl_Remun_Dezembro_SM  DECIMAL(9, 2),
    Tempo_Emprego DECIMAL(6, 2),
    Qtd_Hora_Contr INT(2),
    Vl_Ultima_Remuneracao_Ano DECIMAL(9, 2),
    Vl_Salario_Contratual DECIMAL(10, 2),
    PIS CHAR(15),
    Data_de_Nascimento CHAR(6),
    Numero_CTPS CHAR(8),
    CPF CHAR(11),
    CEI_Vinculado CHAR(12),
    CNPJ_CEI CHAR(14),
    CNPJ_Raiz CHAR(8),
    Nome_Trabalhador VARCHAR(80),
    CBO_Ocupacao_2002 CHAR(6),
    CNAE_2p0_Classe CHAR(5),
    CNAE_2p0_Subclasse CHAR(7),
    Tipo_Defic CHAR(2),
    Causa_Afastamento_1 CHAR(2),
    Dia_Ini_AF1 INT(2),
    Mes_Ini_AF1 INT(2),
    Dia_Fim_AF1 INT(2),
    Mes_Fim_AF1 INT(2),
    Causa_Afastamento_2 CHAR(2),
    Dia_Ini_AF2 INT(2),
    Mes_Ini_AF2 INT(2),
    Dia_Fim_AF2 INT(2),
    Mes_Fim_AF2 INT(2),
    Causa_Afastamento_3 CHAR(2),
    Dia_Ini_AF3 INT(2),
    Mes_Ini_AF3 INT(2),
    Dia_Fim_AF3 INT(2),
    Mes_Fim_AF3 INT(2),
    Qtd_Dias_Afastamento INT(3),
    Idade INT(3),
    Dia_de_Desligamento INT(2),
    IBGE_Subsetor CHAR(5),
    Ano_Chegada_Brasil INT(4),
    CEP_Estab CHAR(8),
    Mun_Trab CHAR(6),
    Razao_Social VARCHAR(80),
    Vl_Rem_Janeiro_CC DECIMAL(15, 2),
    Vl_Rem_Fevereiro_CC DECIMAL(15, 2),
    Vl_Rem_Marco_CC DECIMAL(15, 2),
    Vl_Rem_Abril_CC DECIMAL(15, 2),
    Vl_Rem_Maio_CC DECIMAL(15, 2),
    Vl_Rem_Junho_CC DECIMAL(15, 2),
    Vl_Rem_Julho_CC DECIMAL(15, 2),
    Vl_Rem_Agosto_CC DECIMAL(15, 2),
    Vl_Rem_Setembro_CC DECIMAL(15, 2),
    Vl_Rem_Outubro_CC DECIMAL(15, 2),
    Vl_Rem_Novembro_CC DECIMAL(15, 2),

    PRIMARY KEY(CPF, CNPJ_CEI, Vinculo_Ativo_31_12)
);