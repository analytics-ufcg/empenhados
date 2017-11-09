# -*- coding:utf-8 -*-

import urllib.request
import pymysql
import os, errno

def get_dados_cidade(idtema, codmun):
    local_filename, headers = urllib.request.urlretrieve('http://cidades.ibge.gov.br/xtras/csv.php?lang=&idtema=' + idtema + '&codmun=' + codmun)

    with open(local_filename, 'r', encoding='latin-1') as csv, open('idtema_'+idtema+'/'+codmun+'.csv', 'w', encoding='latin-1') as destination:
        for line in csv:
            line = str.replace(line, '&atilde;', 'ã')
            destination.write(line)


def get_dados_cidades(idtema):
    try:
        os.makedirs('idtema_'+idtema)
    except OSError as e:
        if e.errno != errno.EEXIST:
            raise

    utils = pymysql.connect(read_default_file="~/.my.cnf", database = "utils")
    cursor = utils.cursor()
    cursor.execute("SELECT cd_IBGE from municipio")
    results = cursor.fetchall()

    for row in results:
        get_dados_cidade(idtema, row[0])

    utils.close()


get_dados_cidades("156")
get_dados_cidades("117")
get_dados_cidades("2")
get_dados_cidades("22")
get_dados_cidades("21")
