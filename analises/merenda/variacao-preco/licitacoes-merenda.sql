use sagres;

drop table if exists classificacao_licitacao;

create table classificacao_licitacao(
    cd_UGestora int(11),
    nu_Licitacao char(9) 
        character set utf8 
        collate utf8_general_ci,
    tp_Licitacao smallint(6),
    dt_Ano smallint(6),
    pr_EmpenhosMerenda decimal(4,3),
    vl_EmpenhosMerenda decimal(19,4)
);


alter table classificacao_licitacao 
    add constraint pk_classificacao_licitacao primary key (cd_UGestora, nu_Licitacao, tp_Licitacao),
    add constraint fk_classificacao_licitacao foreign key (cd_UGestora, nu_Licitacao, tp_Licitacao)
        references licitacao (cd_UGestora, nu_Licitacao, tp_Licitacao);


create temporary table e as 
    select cd_ugestora, nu_licitacao, tp_licitacao, dt_Ano, sum(vl_empenho) as soma 
    from empenhos
    group by cd_ugestora, nu_licitacao, tp_licitacao;


create temporary table em as 
    select cd_ugestora, nu_licitacao, tp_licitacao, dt_Ano, sum(vl_empenho) as soma 
    from empenhos 
    where cd_funcao = 12 
        and (cd_subelemento = 02 or cd_SubFuncao = 306) 
    group by cd_ugestora, nu_licitacao, tp_licitacao;


create temporary table e1 as
    select e.cd_ugestora, e.nu_licitacao, e.tp_licitacao, e.dt_Ano, em.soma/e.soma as pr_EmpenhosMerenda, em.soma as soma
	from e, em
	where e.cd_ugestora = em.cd_ugestora and e.nu_licitacao = em.nu_licitacao and e.tp_licitacao = em.tp_licitacao;


insert into classificacao_licitacao (cd_UGestora, nu_Licitacao, tp_Licitacao, dt_Ano)
	select e.cd_ugestora, e.nu_licitacao, e.tp_licitacao, e.dt_Ano
	from e;

update classificacao_licitacao c
	left join e1 on (c.cd_ugestora = e1.cd_ugestora and c.nu_licitacao = e1.nu_licitacao and c.tp_licitacao = e1.tp_licitacao)
	set c.pr_EmpenhosMerenda = e1.pr_EmpenhosMerenda, vl_EmpenhosMerenda = e1.soma;

update classificacao_licitacao
    set pr_EmpenhosMerenda = 0
    where pr_EmpenhosMerenda is null;
    
	
