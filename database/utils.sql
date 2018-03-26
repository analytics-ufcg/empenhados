DROP DATABASE IF EXISTS utils;
CREATE DATABASE utils;
USE utils;

CREATE TABLE municipio (
    cd_IBGE CHAR(6),
    cd_Municipio CHAR(3),
    de_Municipio VARCHAR(100),
    vl_Populacao INT(11),
    vl_IDHM DECIMAL(4,1),
    vl_IDHM_Renda DECIMAL(4,1),
    vl_IDHM_Longevidade DECIMAL(4,1),
    vl_IDHM_Educacao DECIMAL(4,1),
    vl_IDEB_Anos_Finais DECIMAL(2,1),
    vl_Aprendizado_Anos_Finais DECIMAL(3,2),
    pr_Fluxo_Anos_Finais DECIMAL(3,2),
    vl_IDEB_Anos_Iniciais DECIMAL(2,1),
    vl_Aprendizado_Anos_Iniciais DECIMAL(3,2),
    pr_Fluxo_Anos_Iniciais DECIMAL(3,2),
    vl_Docentes_Fundamental INT(10),
    vl_Docentes_Medio INT(10),
    vl_Docentes_Pre_Escolar INT(10),
    vl_Escolas_Fundamental INT(10),
    vl_Escolas_Medio INT(10),
    vl_Escolas_Pre_Escolar INT(10),
    vl_Matriculas_Fundamental INT(10),
    vl_Matriculas_Medio INT(10),
    vl_Matriculas_Pre_Escolar INT(10),

    PRIMARY KEY (cd_IBGE)
);

-- Deve ser copiado para o esquema 'empresas' em breve
CREATE TABLE empresa (
    cep CHAR(8),
    cnpj CHAR(14),
    altitude DECIMAL(6,2),
    bairro VARCHAR(100),
    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7),
    logradouro VARCHAR(150),
    cidade VARCHAR(100),
    ddd INT(2),
    ibge CHAR(7),
    estado CHAR(2),

    PRIMARY KEY (cep, cnpj)
);

CREATE TABLE indicadores_escolares (
    cd_IBGE CHAR(7),
    de_Municipio VARCHAR(100),
    dt_Ano INT(4),
    vl_Docentes_Total INT(4),
    vl_Docentes_Fundamental INT(4),
    vl_Docentes_Medio INT(4),
    vl_Docentes_Pre_Escolar INT(4),
    vl_Escolas_Total INT(3),
    vl_Escolas_Fundamental  INT(3),
    vl_Escolas_Medio INT(3),
    vl_Escolas_Pre_Escolar INT(3),
    vl_Matriculas_Total INT(5),
    vl_Matriculas_Fundamental INT(5),
    vl_Matriculas_Medio INT(5),
    vl_Matriculas_Pre_Escolar INT(5),

    PRIMARY KEY (cd_IBGE, dt_Ano)
);

-- Deve ser copiado para o esquema 'empresas' em breve
CREATE TABLE cnae (
    nu_CPFCNPJ CHAR(14),
    de_RazaoSocial VARCHAR(200),
    nu_CEP CHAR(8),
    cd_CNAEFiscal CHAR(7),
    de_Secao VARCHAR(80),
    de_Divisao VARCHAR(200),
    de_Grupo VARCHAR(200),
    de_Classe VARCHAR(200),
    de_Subclasse VARCHAR(200),

    PRIMARY KEY (nu_CPFCNPJ)
);
