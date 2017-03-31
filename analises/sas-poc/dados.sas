 /**********************************************************************
 *   PRODUCT:   SAS
 *   VERSION:   9.3
 *   CREATOR:   External File Interface
 *   DATE:      24MAR17
 *   DESC:      Generated SAS Datastep Code
 *   TEMPLATE SOURCE:  (None Specified.)
 ***********************************************************************/
    data WORK.licitacoes    ;
    %let _EFIERR_ = 0; /* set the ERROR detection macro variable */
    infile 'C:\Users\analyticstp1\Downloads\f_SAS\f_SAS\licitacoes_merenda.csv' delimiter = ',' MISSOVER DSD lrecl=32767 firstobs=2 ;
       informat VAR1 $4. ;
       informat cd_UGestora best32. ;
       informat dt_Ano best32. ;
       informat nu_Licitacao $11. ;
       informat tp_Licitacao best32. ;
       informat dt_Homologacao $21. ;
       informat nu_Propostas best32. ;
       informat vl_Licitacao best32. ;
       informat tp_Objeto best32. ;
       informat de_Obs $122. ;
       informat dt_MesAno $8. ;
       informat registroCGE $2. ;
       informat tp_regimeExecucao $2. ;
       format VAR1 $4. ;
       format cd_UGestora best12. ;
       format dt_Ano best12. ;
       format nu_Licitacao $11. ;
       format tp_Licitacao best12. ;
       format dt_Homologacao $21. ;
       format nu_Propostas best12. ;
       format vl_Licitacao best12. ;
       format tp_Objeto best12. ;
       format de_Obs $122. ;
       format dt_MesAno $8. ;
       format registroCGE $2. ;
       format tp_regimeExecucao $2. ;
    input
                VAR1 $
                cd_UGestora
                dt_Ano
                nu_Licitacao $
                tp_Licitacao
                dt_Homologacao $
                nu_Propostas
                vl_Licitacao
                tp_Objeto
                de_Obs $
                dt_MesAno $
                registroCGE $
                tp_regimeExecucao $
    ;
    if _ERROR_ then call symputx('_EFIERR_',1);  /* set ERROR detection macro variable */
    run;

proc print data=licitacoes;
run;
data contratos;
run;
data licitacoes_merenda;
run;
data fornecedores;
run; 


proc print data=licitacoes_merenda;
where dt_MesAno = '122010';
run;



proc print data=licitacoes;
run;
data mes;


proc sgplot data=licitacoes;
vbar dt_Mes / group = dt_Ano;
run;
quit;


proc sgplot data=licitacoes(
where=(dt_Mes < 13 & dt_Ano ^= 6 & dt_Ano ^= 2010 & dt_Mes ^= 0));
vbar dt_Mes;
title 'Em que mês ocorreram mais licitações de merenda?';
YAXIS LABEL = 'Número de licitações';
run;
quit;

proc sgplot data=licitacoes(
where=(dt_Mes ^= 13 & dt_Ano ^= 6 & dt_Ano ^= 2010 & dt_Mes ^= 0));
vbar dt_Mes / group = dt_Ano;
title 'Em que mês ocorreram mais licitações de merenda? (Classificado por ano)';
YAXIS LABEL = 'Número de licitações';
run;
quit;

proc sgplot data=licitacoes(
where=(dt_Mes ^= 13 & dt_Ano ^= 6 & dt_Ano ^= 2010));
vbar dt_Ano / group = dt_Mes;
title 'Em que ano ocorreram mais licitações de merenda?';
YAXIS LABEL = 'Número de licitações';
run;
quit;



