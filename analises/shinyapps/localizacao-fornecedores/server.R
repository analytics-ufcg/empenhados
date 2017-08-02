#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(methods)
library(dplyr)
library(ggfortify)
library(rgdal)
library(maps)
library(ggmap)
library(leaflet)
library(stringr)
library(shiny)

ganhadores <- read.csv("../lib/fornecedores.csv", stringsAsFactors = FALSE, colClasses=c("cd_Credor"="character"))

utils <- src_mysql('utils', group='ministerio-publico', password=NULL)

cep_licitantes <- tbl(utils, 'empresa') %>%
  collect(n = Inf)

dados_cep <- cep_licitantes %>%
  mutate(longitude = as.numeric(longitude)) %>%
  mutate(latitude = as.numeric(latitude))

localizacao_licitantes_municipios <- ganhadores %>%
  left_join(dados_cep %>%
              select(cnpj, cep, latitude, longitude, estado, cidade), by = c('cd_Credor' = 'cnpj')) %>%
  filter(!is.na(cep), cep != "") %>%
  ungroup()

# localizacao_licitantes <- ganhadores %>%
#   group_by(cd_Credor, no_Credor) %>%
#   summarise(ganhou = sum(ganhou),
#             valor_total_emp = sum(valor_total_emp),
#             valor_mediana_emp = median(valor_mediana_emp),
#             valor_total_pag = sum(valor_total_pag, na.rm = TRUE),
#             num_municipios = n()) %>%
#   left_join(dados_cep %>%
#               select(cnpj, cep, latitude, longitude, estado, cidade), by = c('cd_Credor' = 'cnpj')) %>%
#   filter(!is.na(cep), cep != "")
# 
# ##### Não tenho certeza se isso ainda é necessário #####
# # Endereço incorreto retornado pela API de busca
# localizacao_licitantes <- localizacao_licitantes %>%
#   filter(!(cd_Credor %in% c("07150557000158", "07129849000109", "09149258000129", "10462503000132", "09296872000113", "11968320000156", "00387408000168", "07316478000174", "05031301000287", "35591957000134", "08195834000101", "08031919000154", "07513602000191"))) %>%
#   filter(!(!is.na(cep) & is.na(latitude)))


server <- function(input, output, session){
  
  mapa_paraiba <- readOGR("../dados/mapa_paraiba_ibge/Municipios.shp")
  
  # Atualizando nome de municípios que mudaram de nome nos últimos anos
  levels_mapa = levels(mapa_paraiba@data$Nome_Munic)
  levels_mapa[51] = "Tacima"
  levels_mapa[200] = "São Vicente do Seridó"
  levels_mapa[173] = "Joca Claudino"
  levels_mapa[156] = "Quixaba"
  levels(mapa_paraiba@data$Nome_Munic) = levels_mapa
  
  mapa_paraiba@data$Nome_Munic = as.character(mapa_paraiba@data$Nome_Munic)
  
  data_pb <- mapa_paraiba@data
  
  data_paraiba <- reactive({
    data_pb %>%
      left_join(
        (
          localizacao_licitantes_municipios  %>%
            filter(grepl(str_sub(input$busca, -14), cd_Credor)) %>%
            distinct(de_Municipio, .keep_all = TRUE)
        ), 
        by = c("Nome_Munic" = "de_Municipio"))%>%
      mutate(ganhou = ifelse(is.na(ganhou), 0, ganhou)) %>%
      mutate(valor_total_pag = ifelse(is.na(valor_total_pag), 0, valor_total_pag))
  })
  
  
  output$municipios <- renderLeaflet({
    mapa_paraiba@data <- data_paraiba()
    
    switch(input$modo_visualizacao,
           "Total de vitórias" = (
             leaflet(data = mapa_paraiba) %>%
               addProviderTiles(providers$Esri.WorldGrayCanvas) %>%
               addPolygons(opacity = 0.5,
                           weight = 1,
                           color = 'black',
                           fillColor = colorNumeric("Blues", mapa_paraiba@data$ganhou)(mapa_paraiba@data$ganhou),
                           label = paste(mapa_paraiba@data$Nome_Munic),
                           popup = paste("Município: ", str_to_upper(mapa_paraiba@data$Nome_Munic), "</br>",
                                         "Vitórias: ", mapa_paraiba@data$ganhou, "</br>",
                                         "Valor pago: R$ ", mapa_paraiba@data$valor_total_pag),
                           fillOpacity = 1) %>%
               addLegend(position = "bottomright", 
                         pal = colorNumeric("Blues", mapa_paraiba@data$ganhou), 
                         values = mapa_paraiba@data$ganhou,
                         title = "Vitórias",
                         opacity = 1, na.label = "0") %>%
               addMarkers(
                 data = (
                   localizacao_licitantes_municipios %>%
                     filter(grepl(str_sub(input$busca, -14), cd_Credor))
                 ),
                 label = ~str_to_upper(no_Credor), 
                 popup = ~paste(
                   "Nome:", str_to_upper(no_Credor), "</br>",
                   "CNPJ/CPF:", cd_Credor, "</br>",
                   "Cidade:", cidade, " - ", estado
                 )
               )
           ),
           
           "Valor recebido" = (
             leaflet(data = mapa_paraiba) %>%
               addProviderTiles(providers$Esri.WorldGrayCanvas) %>%
               addPolygons(opacity = 0.5,
                           weight = 1,
                           color = 'black',
                           fillColor = colorNumeric("Oranges", mapa_paraiba@data$valor_total_pag)(mapa_paraiba@data$valor_total_pag),
                           label = paste(mapa_paraiba@data$Nome_Munic),
                           popup = paste("Município: ", str_to_upper(mapa_paraiba@data$Nome_Munic), "</br>",
                                         "Vitórias: ", mapa_paraiba@data$ganhou, "</br>",
                                         "Valor pago: R$ ", mapa_paraiba@data$valor_total_pag),
                           fillOpacity = 1)%>%
               addLegend(position = "bottomright", 
                         pal = colorNumeric("Oranges", mapa_paraiba@data$valor_total_pag), 
                         values = mapa_paraiba@data$valor_total_pag,
                         title = "Valores recebidos",
                         opacity = 1, na.label = "0") %>%
               addMarkers(
                 data = (
                   localizacao_licitantes_municipios %>%
                     filter(grepl(str_sub(input$busca, -14), cd_Credor))
                 ),
                 label = ~str_to_upper(no_Credor), 
                 popup = ~paste(
                   "Nome:", str_to_upper(no_Credor), "</br>",
                   "CNPJ/CPF:", cd_Credor, "</br>",
                   "Cidade:", cidade, " - ", estado
                 )
               )
           ))
  })
}
