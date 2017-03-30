data licitacao_sem_na;
set licitacao1;
if nu_Propostas = "NA" then nu_Propostas = ""; 
nu_Propostas = input(nu_Propostas, 4.0);	
run;

proc sgplot data = licitacao_sem_na;
where dt_Mes >= 1 & dt_Mes <= 12;
vbar nu_Propostas;
title "Número de propostas para as licitações";
xaxis label = "Número de propostas";
yaxis label = "Frequência";
run;
