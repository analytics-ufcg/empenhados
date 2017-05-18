DROP TABLE IF EXISTS classificacao_licitacao;

CREATE TABLE classificacao_licitacao(
    cd_UGestora INT(11),
    nu_Licitacao CHAR(9) 
        CHARACTER SET utf8 
        COLLATE utf8_general_ci,
    tp_Licitacao SMALLINT(6),
    pr_EmpenhosMerenda DECIMAL(4,3)
);

ALTER TABLE classificacao_licitacao 
    ADD CONSTRAINT pk_classificacao_licitacao PRIMARY KEY (cd_UGestora, nu_Licitacao, tp_Licitacao),
    ADD CONSTRAINT fk_classificacao_licitacao FOREIGN KEY (cd_UGestora, nu_Licitacao, tp_Licitacao)
        REFERENCES licitacao (cd_UGestora, nu_Licitacao, tp_Licitacao);

create temporary table em as 
    select cd_ugestora, nu_licitacao, tp_licitacao, sum(vl_empenho) as soma 
    from empenhos 
    where cd_funcao = 12 
        and (cd_subelemento = 02 or cd_SubFuncao = 306) 
    group by cd_ugestora, nu_licitacao, tp_licitacao;

create temporary table e as 
    select cd_ugestora, nu_licitacao, tp_licitacao, sum(vl_empenho) as soma 
    from empenhos
    group by cd_ugestora, nu_licitacao, tp_licitacao;


INSERT INTO classificacao_licitacao
    SELECT e.cd_UGestora, e.nu_Licitacao, e.tp_Licitacao, 
