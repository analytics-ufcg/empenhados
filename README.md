# Blog Empenhados

Blog contendo as análises públicas resultantes da parceria entre o Laboratório Analytics (UFCG) e o
Ministério Público da Paraíba. 

As análises já realizadas podem ser encontradas no link: https://analytics-ufcg.github.io/empenhados/

## Detalhes técnicos

O blog foi gerado a partir de documentos RMarkdown utilizando a biblioteca `blogdown`, com temas da ferramenta [Hugo](https://gohugo.io).
Após a geração do mesmo, fez-se necessária a execução do script `render_unlock.py`, que altera o local onde são importados os scripts em javascript
que permitem a renderização correta de RMarkdown no blogdown e causam bloqueio de renderização quando carregados no início dos arquivos html.
